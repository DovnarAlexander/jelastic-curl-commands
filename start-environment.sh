#!/bin/bash

JELASTIC_URL=${JELASTIC_URL:-$1}
JELASTIC_SESSION=${JELASTIC_SESSION:-$2}
JELASTIC_ENVIRONMENT=${JELASTIC_ENVIRONMENT:-$3}

jelastic=$(curl -XPOST "https://$JELASTIC_URL/1.0/environment/control/rest/startenv" --data "envName=$JELASTIC_ENVIRONMENT&session=$JELASTIC_SESSION")
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
