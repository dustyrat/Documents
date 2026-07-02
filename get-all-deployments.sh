#!/bin/bash

## Requirements:
## - kubectl: https://kubernetes.io/docs/tasks/tools/

get-all-deployments() {
    environment=$1
    yq '.contexts[].name' ~/.kube/config | sort | while read context; do
        if [[ $context == *"$environment"* ]]; then
	        list-deployments $context;
        fi
    done;
}

list-deployments(){
    context=$1
    echo "------------------------------";
    echo "Context: $context";
	kubectl get deploy --context $context -o wide;
    echo "------------------------------";
}

get-all-deployments $1
