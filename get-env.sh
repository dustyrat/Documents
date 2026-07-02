#!/bin/bash

## Requirements:
## - kubectl: https://kubernetes.io/docs/tasks/tools/
## - jq: https://stedolan.github.io/jq

get-env() {
    deployment=$1
    context=$2

    echo
    echo "Environment Variables: $deployment ($context)"

    dir="./$context/env/$deployment"
    output="$dir/.env"
    if test -f "$output"; then
        truncate -s 0 $output
    else
        mkdir -p "${output%/*}" && touch "$output"
    fi

    kubectl get deploy $deployment --context $context -o jsonpath="{range .spec.template.spec.containers[*]}{range .env[*]}{@}{'\n'}{end}{end}" | while read env; do
        var=$(echo $env | jq -r .name)
        if $(echo $volume | jq '.valueFrom.secretKeyRef != null'); then
            name=$(echo $env | jq -r .valueFrom.secretKeyRef.name)
            key=$(echo $env | jq -r .valueFrom.secretKeyRef.key)
            filename="$context/secret/$name/data/$key"
            echo "$var=\"$(cat $filename)\"" >> $output
        fi

        if $(echo $volume | jq '.valueFrom.configMapRef != null'); then
            name=$(echo $env | jq -r .valueFrom.configMapRef.name)
            key=$(echo $env | jq -r .valueFrom.configMapRef.key)
            filename="$context/configmap/$name/data/$key"
            echo "$var=\"$(cat $filename)\"" >> $output
        fi
    done

    kubectl get deploy $deployment --context $context -o jsonpath="{range .spec.template.spec.containers[*]}{range .envFrom[*]}{@}{'\n'}{end}{end}" | while read env; do
        if $(echo $env | jq '.secretRef != null'); then
            name=$(echo $env | jq -r .secretRef.name)
            ls -1 $context/secret/$name/data | while read key; do
                filename="$context/secret/$name/data/$key"
                echo "$key=\"$(cat $filename)\"" >> $output
            done
        fi

        if $(echo $env | jq '.configMapRef != null'); then
            name=$(echo $env | jq -r .configMapRef.name)
            ls -1 $context/configmap/$name/data | while read key; do
                filename="$context/configmap/$name/data/$key"
                echo "$key=\"$(cat $filename)\"" >> $output
            done
        fi
    done

    if [ ! -s "$output" ]; then
        rm -rf "$output"
    fi

    if [ -z "$( ls -A $dir )" ]; then
        rm -rf "$dir"
    fi
}

get-env $1 $2
