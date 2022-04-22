#!/bin/bash

## Requirements:
## - kubectl: https://kubernetes.io/docs/tasks/tools/
## - jq: https://stedolan.github.io/jq

get-mounts(){
    deployment=$1
    context=$2

    get-secrets.sh $deployment $context;

    kubectl get deploy $deployment --context $context -o jsonpath="{range .spec.template.spec.volumes[*]}{@}{'\n'}{end}" | while read volume; do
    mount=$(kubectl get deploy $deployment --context $context -o jsonpath="{range .spec.template.spec.containers[*]}{range .volumeMounts[?(@.name=='$(echo $volume | jq -r ".name")')]}{@}{'\n'}{end}{end}")
    secretName=$(echo $volume | jq -r .secret.secretName)
    subPath=$(echo $mount | jq -r .subPath)
    mountPath=$(echo $mount | jq -r .mountPath)
    echo "$context/$secretName/data/$subPath -> $mountPath"
    cp ./$context/$secretName/data/$subPath ./$mountPath
done;
}

get-mounts $1 $2
