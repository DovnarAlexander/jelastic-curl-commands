#!/bin/bash

JELASTIC_URL=${JELASTIC_URL:-$1}
JELASTIC_USERNAME=${JELASTIC_USERNAME:-$2}
JELASTIC_PASSWORD=${JELASTIC_PASSWORD:-$3}

jelastic=$(curl -XPOST "https://$JELASTIC_URL/1.0/users/authentication/rest/signin" --data "password=$JELASTIC_PASSWORD&login=$JELASTIC_USERNAME")
echo $jelastic
result=$(echo $jelastic | jq .result)

if [ "$result" != "0" ]
then
    echo "Result is $result" && exit 1
fi

session=$(echo $jelastic | jq .session | tr -d '"')
if [ -z $session ]
then
    echo $session && exit 1
fi

if [ -n $GITHUB_RUN_NUMBER ]
then
    echo "::set-output name=session::$session"
else
    echo $esssion
fi
