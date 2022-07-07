#!/bin/bash

## Requirements:
## - kubectl: https://kubernetes.io/docs/tasks/tools/

get-configmaps() {
    deployment=$1
    context=$2

    echo "Deployment: $deployment ($context)"
    kubectl get deploy $deployment --context $context -o jsonpath="\
{range .spec.template.spec.containers[*]}{range .env[*]}{.valueFrom.configMapRef.name}{'\n'}{end}{end}\
{range .spec.template.spec.containers[*]}{range .envFrom[*]}{.configMapRef.name}{'\n'}{end}{end}\
{range .spec.template.spec.volumes[*]}{.configMap.name}{'\n'}{end}" | sort | uniq | xargs -n1 | while read configmap; do
        get-configmap.sh $configmap $context
    done
}

get-configmaps $1 $2
