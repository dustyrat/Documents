#!/bin/bash

## Requirements:
## - kubectl: https://kubernetes.io/docs/tasks/tools/
## - jq: https://stedolan.github.io/jq

get-env(){
    deployment=$1
    context=$2

    get-secrets.sh $deployment $context;

    echo
    echo "Environment Variables:"
    kubectl get deploy $deployment --context $context -o jsonpath="{range .spec.template.spec.containers[*]}{range .env[*]}{@}{'\n'}{end}{end}" | while read secret; do
        secretName=$(echo $secret | jq -r .valueFrom.secretKeyRef.name)
        file=$(echo $secret | jq -r .valueFrom.secretKeyRef.key)
        var=$(echo $secret | jq -r .name)
        echo "export $var=\"$(cat $context/$secretName/data/$file)\""
    done;

    kubectl get deploy $deployment --context $context -o jsonpath="{range .spec.template.spec.containers[*]}{range .envFrom[*]}{.secretRef.name}{'\n'}{end}{end}" | while read secret; do
        ls -1 $context/$secret/data | while read file; do
            echo "export $file=\"$(cat $context/$secret/data/$file)\""
        done;
    done;
}

get-env $1 $2
