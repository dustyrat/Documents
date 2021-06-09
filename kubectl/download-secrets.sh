#!/bin/bash

## Requirements:
## - kubectl: https://kubernetes.io/docs/tasks/tools/
## - yq: https://github.com/mikefarah/yq

download-secrets(){
    kubectl get deploy $1 -o yaml --context $2 | yq e -M ".spec.template.spec.volumes[].secret.secretName" - | while read secret; do
        download-secret.sh $secret $2;
    done;
}

download-secrets $1 $2
