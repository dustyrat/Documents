#!/bin/bash

## Requirements:
## - kubectl: https://kubernetes.io/docs/tasks/tools/
## - yq: https://github.com/mikefarah/yq
## - jq: https://stedolan.github.io/jq

pull-configs() {
    yq '.contexts[].name' ~/.kube/config | sort | while read context; do
        if [ -d "$context" ]; then
            rm -rf "$context";
        fi

        echo "------------------------------";
        echo "Context: $context"
        kubectl get deployments --context $context -o json | jq ".items[] | .metadata.name" -r | while read deployment; do
            get-configmaps.sh $deployment $context
            get-secrets.sh $deployment $context
        done;
        echo "------------------------------";

        find . -type f -path "./$context/*.json" | while read file; do
            tmp=$(mktemp)
            jq . $file > "$tmp" && mv "$tmp" $file
        done;
    done;
}

pull-configs
