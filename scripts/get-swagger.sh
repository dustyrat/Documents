#!/bin/bash

## Requirements:
## - kubectl: https://kubernetes.io/docs/tasks/tools/

get-swagger(){
    context=$1
	kubectl get ingress --context $context -o json | jq -rc ".items[] | { name: .metadata.name, host: .spec.tls[0].hosts[0] }" | while read ingress; do
	name=$(echo $ingress | jq -r '.name');
	host=$(echo $ingress | jq -r '.host');
	echo "Ingress: $name"
	echo "Host: $host"
	uri="https://$host"
	status_code=$(curl -s -o /dev/null -w "%{http_code}" "$uri/swagger/")
	if [ "$status_code" -eq 200 ]; then
		echo "Swagger: $uri/swagger/"
		get-spec $name "$uri/swagger/swagger.yaml" || get-spec $name "$uri/api/docs/openapi.yaml";
	fi
    echo "------------------------------";
  done;
}

get-spec(){
    _name=$1
    _uri=$2
	_status_code=$(curl -s -o "$_name.yaml" -w "%{http_code}" "$_uri")
	if [ "$_status_code" -eq 200 ]; then
		echo "Spec: $_uri"
		return 0
	fi
	return 1
}

get-swagger $1