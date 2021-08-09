#!/bin/bash

## Requirements:
## - helm: https://helm.sh/docs/intro/install/

helm-status(){
    helm list --kube-context $1 -dr -m 15 --time-format 2006-01-02T15:04:05Z07:00; echo "";
    helm list --kube-context $1 -dr -m 15 --time-format 2006-01-02T15:04:05Z07:00 --pending; echo "";
    helm list --kube-context $1 -dr -m 15 --time-format 2006-01-02T15:04:05Z07:00 --failed; echo "";
    helm list --kube-context $1 -dr -m 15 --time-format 2006-01-02T15:04:05Z07:00 --superseded; echo "";
    helm list --kube-context $1 -dr -m 15 --time-format 2006-01-02T15:04:05Z07:00 --uninstalled; echo "";
    helm list --kube-context $1 -dr -m 15 --time-format 2006-01-02T15:04:05Z07:00 --uninstalling; echo "";
}

helm-status $1
