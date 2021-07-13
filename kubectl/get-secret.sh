#!/bin/bash

## Requirements:
## - kubectl: https://kubernetes.io/docs/tasks/tools/
## - yq: https://github.com/mikefarah/yq

get-secret(){
    echo "Secret: $1 ($2)"
    mkdir -p $1;
    cd $1;
    kubectl get secret $1 -o yaml --context $2 > secret.yaml;
    mkdir -p data;
    yq e -M ".data" secret.yaml | while read d; do
        eval $(echo $d | awk -F': ' '{ print "key="$1, "value="$2 }');
        echo $value | base64 -d > "data/$key";
    done;
    cd ../;
}

get-secret $1 $2
