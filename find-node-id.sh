#!/bin/bash

JELASTIC_URL=${JELASTIC_URL:-$1}
JELASTIC_SESSION=${JELASTIC_SESSION:-$2}
JELASTIC_ENVIRONMENT=${JELASTIC_ENVIRONMENT:-$3}
DOCKER_IMAGE=${DOCKER_IMAGE:-$4}

jelastic=$(curl "https://$JELASTIC_URL/1.0/environment/control/rest/getenvinfo" --data "envName=$JELASTIC_ENVIRONMENT&session=$JELASTIC_SESSION")
echo $jelastic
result=$(echo $jelastic | jq .result)

if [ "$result" != "0" ]
then
    echo "Result is $result" && exit 1
fi

nodeId=$(echo $jelastic | jq " .nodes | .[] | select(.customitem.dockerName==\"$DOCKER_IMAGE\") | .id")
if [ -z "$nodeId" ]
then
    echo $nodeId && exit 1
fi

if [ -n $GITHUB_RUN_NUMBER ]
then
    echo "::set-output name=nodeId::$nodeId"
else
    echo "NodeId is $nodeId"
fi
