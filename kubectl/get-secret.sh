#!/bin/bash

## Requirements:
## - kubectl: https://kubernetes.io/docs/tasks/tools/
## - yq: https://github.com/mikefarah/yq

get-secret(){
    secret=$1
    context=$2

    echo "Secret: $secret ($context)"
    directory="$context/$secret"
    mkdir -p $directory;
    cd $directory;
    kubectl get secret $secret -o yaml --context $context > secret.yaml;
    mkdir -p data;
    yq e -M ".data" secret.yaml | while read d; do
        eval $(echo $d | awk -F': ' '{ print "key="$1, "value="$2 }');
        echo $value | base64 -D > "data/$key";
        dos2unix "data/$key";
    done;
}

get-secret $1 $2
