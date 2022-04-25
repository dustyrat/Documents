#!/bin/bash

## Requirements:
## - kubectl: https://kubernetes.io/docs/tasks/tools/
## - yq: https://github.com/mikefarah/yq
## - jq: https://stedolan.github.io/jq

get-configmap(){
    configmap=$1
    context=$2

    echo "ConfigMap: $configmap ($context)"
    directory="$context/configmap/$configmap"
    mkdir -p "$directory/data";
    kubectl get configmap $configmap -o yaml --context $context > "$directory/configmap.yaml";
    yq e -M -o json ".data" "$directory/configmap.yaml" | jq -r 'keys | .[]' | while read key; do
        value="$(yq e -M -o json ".data" "$directory/configmap.yaml" | jq -r ".\"$key\"")"
        echo "$value" > "$directory/data/$key";
        dos2unix "$directory/data/$key";
    done;
}

get-configmap $1 $2
