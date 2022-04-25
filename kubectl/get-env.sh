#!/bin/bash

## Requirements:
## - kubectl: https://kubernetes.io/docs/tasks/tools/
## - jq: https://stedolan.github.io/jq

get-env(){
    deployment=$1
    context=$2

    get-configmaps.sh $deployment $context;
    get-secrets.sh $deployment $context;

    echo
    echo "Environment Variables:"
    kubectl get deploy $deployment --context $context -o jsonpath="{range .spec.template.spec.containers[*]}{range .env[*]}{@}{'\n'}{end}{end}" | while read env; do
        var=$(echo $env | jq -r .name)
        if $(echo $volume | jq '.valueFrom.secretKeyRef != null'); then
            name=$(echo $env | jq -r .valueFrom.secretKeyRef.name)
            file=$(echo $env | jq -r .valueFrom.secretKeyRef.key)
            echo "export $var=\"$(cat $context/secret/$name/data/$file)\""
        fi

        if $(echo $volume | jq '.valueFrom.configMapRef != null'); then
            name=$(echo $env | jq -r .valueFrom.configMapRef.name)
            file=$(echo $env | jq -r .valueFrom.configMapRef.key)
            echo "export $var=\"$(cat $context/configmap/$name/data/$file)\""
        fi
    done;

    kubectl get deploy $deployment --context $context -o jsonpath="{range .spec.template.spec.containers[*]}{range .envFrom[*]}{@}{'\n'}{end}{end}" | while read env; do
        echo $env
        if $(echo $env | jq '.secretRef != null'); then
            name=$(echo $env | jq -r .secretRef.name)
            ls -1 $context/secret/$name/data | while read file; do
                echo "export $file=\"$(cat $context/secret/$name/data/$file)\""
            done;
        fi

        if $(echo $env | jq '.configMapRef != null'); then
            name=$(echo $env | jq -r .configMapRef.name)
            ls -1 $context/configmap/$name/data | while read file; do
                echo "export $file=\"$(cat $context/configmap/$name/data/$file)\""
            done;
        fi
    done;
}

get-env $1 $2
