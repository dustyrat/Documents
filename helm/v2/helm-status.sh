#!/bin/bash

## Requirements:
## - helm: https://v2.helm.sh/docs/using_helm/#installing-helm

helm-status() {
    helm list --kube-context $1 --col-width 30 -dr -m 10
    echo ""
    helm list --kube-context $1 --col-width 30 -dr -m 10 --pending
    echo ""
    helm list --kube-context $1 --col-width 30 -dr -m 10 --failed
    echo ""
    helm list --kube-context $1 --col-width 30 -dr -m 10 --deleted
    echo ""
}

helm-status $1
