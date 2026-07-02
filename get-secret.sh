#!/bin/bash

## Requirements:
## - kubectl: https://kubernetes.io/docs/tasks/tools/
## - yq: https://github.com/mikefarah/yq
## - jq: https://stedolan.github.io/jq

get-secret() {
    secret=$1
    context=$2

    echo "Secret: $secret ($context)"
    directory="$context/secret/$secret"
    mkdir -p "$directory/data"
    kubectl get secret $secret -o yaml --context $context >"$directory/secret.yaml"
    yq e -M -o json ".data" "$directory/secret.yaml" | jq -r 'keys | .[]' | while read key; do
        value="$(yq e -M -o json ".data" "$directory/secret.yaml" | jq -r ".\"$key\"")"
        echo "$value" | base64 -D >"$directory/data/$key"
        dos2unix "$directory/data/$key"
    done
}

get-secret $1 $2
