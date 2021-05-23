#!/bin/bash

JELASTIC_URL=${JELASTIC_URL:-$1}
JELASTIC_SESSION=${JELASTIC_SESSION:-$2}
JELASTIC_ENVIRONMENT=${JELASTIC_ENVIRONMENT:-$3}
JELASTIC_NODE_ID=${JELASTIC_NODE_ID:-$4}
DOCKER_IMAGE_TAG=${DOCKER_IMAGE_TAG:-$5}

jelastic=$(curl -XPOST "https://$JELASTIC_URL/1.0/environment/control/rest/redeploycontainerbyid" --data "envName=$JELASTIC_ENVIRONMENT&session=$JELASTIC_SESSION&nodeId=$JELASTIC_NODE_ID&tag=$DOCKER_IMAGE_TAG")
echo $jelastic
result=$(echo $jelastic | jq .result)

if [ -n $GITHUB_RUN_NUMBER ]
then
    echo "::set-output name=result::$result"
fi

if [ "$result" != "0" ]
then
    echo "Result is $result" && exit 1
fi
