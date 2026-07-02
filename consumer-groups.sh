#!/bin/bash

## Requirements:
## - kafkactl: https://github.com/deviceinsight/kafkactl

consumer-groups() {
    context=$1
	kafkactl get consumer-groups --context $context -o json | jq -rc ".Name" | sort | while read group; do
		consumer-group.sh $group $context;
	done;
}

consumer-groups $1
