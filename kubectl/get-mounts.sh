#!/bin/bash

## Requirements:
## - kubectl: https://kubernetes.io/docs/tasks/tools/
## - jq: https://stedolan.github.io/jq

get-mounts(){
    deployment=$1
    context=$2

    kubectl get deploy $deployment --context $context -o jsonpath="{range .spec.template.spec.volumes[*]}{@}{'\n'}{end}" | while read volume; do
        kubectl get deploy $deployment --context $context -o jsonpath="{range .spec.template.spec.containers[*]}{range .volumeMounts[?(@.name=='$(echo $volume | jq -r ".name")')]}{@}{'\n'}{end}{end}" | while read mount; do
            subPath=$(echo $mount | jq -r .subPath)
            mountPath=$(echo $mount | jq -r .mountPath | sed "s/\/root/./")

            if $(echo $volume | jq '.secret != null'); then
                name=$(echo $volume | jq -r .secret.secretName)
                get-secret.sh $name $context;
                echo "secret: ./$context/$name/data/$subPath -> $mountPath"
                cp ./$context/secret/$name/data/$subPath ./$mountPath
            fi

            if $(echo $volume | jq '.configMap != null'); then
                name=$(echo $volume | jq -r .configMap.name)
                get-configmap.sh $name $context;
                echo "configmap: ./$context/$name/data/$subPath -> $mountPath"
                cp ./$context/configmap/$name/data/$subPath ./$mountPath
            fi
        done;
    done;
}

get-mounts $1 $2