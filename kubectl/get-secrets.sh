#!/bin/bash

## Requirements:
## - kubectl: https://kubernetes.io/docs/tasks/tools/

get-secrets(){
    deployment=$1
    context=$2

    echo "Deployment: $deployment ($context)";
    kubectl get deploy $deployment --context $context -o jsonpath="\
{range .spec.template.spec.containers[*]}{range .env[*]}{.valueFrom.secretKeyRef.name}{'\n'}{end}{end}\
{range .spec.template.spec.containers[*]}{range .envFrom[*]}{.secretRef.name}{'\n'}{end}{end}\
{range .spec.template.spec.volumes[*]}{.secret.secretName}{'\n'}{end}\
{range .spec.tls[*]}{.secretName}{'\n'}{end}\
    " | sort | uniq | xargs -n1 | while read secret; do
        get-secret.sh $secret $context;
    done;
}

get-secrets $1 $2
