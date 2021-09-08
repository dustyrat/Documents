#!/bin/bash

## Requirements:
## - kubectl: https://kubernetes.io/docs/tasks/tools/
## - yq: https://github.com/mikefarah/yq

get-secrets(){
    echo "Deployment: $1 ($2)";

    kubectl get deploy $1 -o yaml --context $2 | yq e -M ".spec.template.spec.containers[].env[].valueFrom.secretKeyRef.name" - | sort | uniq | while read secret; do
        get-secret.sh $secret $2;
    done;

    kubectl get deploy $1 -o yaml --context $2 | yq e -M ".spec.template.spec.volumes[].secret.secretName" - | while read secret; do
        get-secret.sh $secret $2;
    done;
}

get-secrets $1 $2
