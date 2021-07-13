#!/bin/bash

## Requirements:
## - kubectl: https://kubernetes.io/docs/tasks/tools/
## - yq: https://github.com/mikefarah/yq

get-secrets(){
    kubectl get deploy $1 -o yaml --context $2 | yq e -M ".spec.template.spec.volumes[].secret.secretName" - | while read secret; do
        get-secret.sh $secret $2;
    done;
}

get-secrets $1 $2
