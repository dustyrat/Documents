#!/bin/bash

get-volumeMnts(){
    echo "Volume Mounts: $1 ($2)"

    spec=$(kubectl get deploy $1 -o yaml --context $2 | yq e -jM '.spec.template.spec' - | jq -c .)
    volumes=$(echo $spec | jq -c '.volumes')
    mounts=$(echo $spec | jq -c '.containers[].volumeMounts')

    echo $volumes | jq -c '.[]' | while read volume; do
        secret=$(echo $volume | jq -r '.secret.secretName')
        name=$(echo $volume | jq -r ".name")
        mount=$(echo $mounts | jq -c "map(select(.name == \"$name\"))[]")
        subPath=$(echo $mount | jq -r ".subPath")
        mountPath=$(echo $mount | jq -r ".mountPath" | sed 's/\/root\///')

        get-secret.sh $secret $2;

        echo "Volume: $volume"
        echo "Mount: $mount"
        echo "$secret/data/$subPath -> $mountPath"
        cp $secret/data/$subPath $mountPath
    done;
}

get-volumeMnts $1 $2