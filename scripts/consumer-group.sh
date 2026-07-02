#!/bin/bash

## Requirements:
## - kafkactl: https://github.com/deviceinsight/kafkactl
## - jq: https://stedolan.github.io/jq

consumer-groups() {
    group=$1
    context=$2
    consumer-group $group $context;
}

consumer-group(){
    group=$1
    context=$2
    echo "------------------------------";
    echo "Group: $group";
    printf "\n******************************\n";
    lag=$(kafkactl describe consumer-group $group --print-topics=true --print-members=false --context $context -o json | jq -rcj 'select(.Topics) | .Topics |= sort_by(.Name) | .Topics[] | .Name + "," + (.totalLag | tostring) + "\\n"');
    printf "TOPIC,LAG\n$lag" | column -t -s ,;
    printf "\n******************************\n";
    kafkactl describe consumer-group $group --print-topics=true --print-members=false --context $context;
    echo "------------------------------";
}

consumer-groups $1 $2
