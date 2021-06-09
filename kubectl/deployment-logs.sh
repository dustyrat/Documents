#!/bin/bash

## Requirements:
## - kubectl: https://kubernetes.io/docs/tasks/tools/
## - yq: https://github.com/mikefarah/yq

deployment-logs(){
    echo "$1 ($2)"
    kubectl logs -l $(kubectl get deploy $1 -o yaml --context $2 | yq e -M ".spec.selector.matchLabels" - | sed 's/: /=/') -f --all-containers --ignore-errors --max-log-requests 50 --context $2
}

deployment-logs $1 $2
