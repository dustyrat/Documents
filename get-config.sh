#!/bin/bash

## Requirements:
## - kubectl: https://kubernetes.io/docs/tasks/tools/
## - jq: https://stedolan.github.io/jq

get-config() {
    deployment=$1
    context=$2

    get-configmaps.sh $deployment $context
    get-secrets.sh $deployment $context

	find . -type f -path "./$context/*.json" | while read file; do
		tmp=$(mktemp)
		jq . $file > "$tmp" && mv "$tmp" $file
	done;

    echo
    echo "Config: $deployment ($context)"

    get-env.sh $deployment $context
    envfile="./$context/env/$deployment/.env"
    if test -f "$envfile"; then
        echo "$envfile => .env"
        cp $envfile .env
    fi

    spec=$(kubectl get deploy $deployment --context $context -o json | jq -cr ".spec.template.spec | { volumeMounts: .containers[].volumeMounts, volumes: .volumes } | tostring")
    echo $spec | jq -cr ".volumeMounts[]" | while read mount; do
        name=$(echo $mount | jq -cr ".name");
        subPath=$(echo $mount | jq -cr ".subPath");
        mountPath=$(echo $mount | jq -cr ".mountPath");
        volume=$(echo $spec | jq -cr ".volumes[] | select(.name==\"$name\")")
        type=$(echo $volume | jq -cr ". | keys | .[] | select(. != \"name\")")

        if [ "$type" = "secret" ]; then
            name=$(echo $volume | jq -cr ".$type.secretName")
            directory="./$context/secret/$name/data"
        elif [ "$type" = "configMap" ]; then
            name=$(echo $volume | jq -cr ".$type.name")
            directory="./$context/configmap/$name/data"
        fi
        echo "$directory/$subPath => .$mountPath"
       
        mkdir -p $(dirname ".$mountPath")
        cp -R "$directory/$subPath" ".$mountPath"
    done
    rm -rf $context
}

get-config $1 $2