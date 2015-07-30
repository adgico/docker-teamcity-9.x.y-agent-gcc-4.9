#!/bin/bash

function check_name
{
	if [[ $1 == --name=* ]] ; then
		NAME=`sed -e "s/^\-\-name\=//" <<< $1`
		return 0
	fi

	if [[ $1 == -n=* ]] ; then
		NAME=`sed -e "s/^\-n\=//" <<< $1`
		return 0
	fi

	return 1 # not found
}

function check_server_url
{
	if [[ $1 == --server-url=* ]] ; then
		SERVER_URL=`sed -e "s/^\-\-server\-url\=//" <<< $1`
		return 0
	fi

	if [[ $1 == -su=* ]] ; then
		SERVER_URL=`sed -e "s/^\-su\=//" <<< $1`
		return 0
	fi

	return 1 # not found
}

function check_agent_name
{
	if [[ $1 == --agent-name=* ]] ; then
		AGENT=`sed -e "s/^\-\-agent\-name\=//" <<< $1`
		return 0
	fi

	if [[ $1 == -an=* ]] ; then
		AGENT=`sed -e "s/^\-an\=//" <<< $1`
		return 0
	fi

	return 1 # not found
}

function check_agent_port
{
	if [[ $1 == --agent-port=* ]] ; then
		AGENT_PORT=`sed -e "s/^\-\-agent\-port\=//" <<< $1`
		return 0
	fi

	if [[ $1 == -ap=* ]] ; then
		AGENT_PORT=`sed -e "s/^\-ap\=//" <<< $1`
		return 0
	fi

	return 1 # not found
}

function check_agent_url
{
	if [[ $1 == --agent-url=* ]] ; then
		AGENT_URL=`sed -e "s/^\-\-agent\-url\=//" <<< $1`
		return 0
	fi

	if [[ $1 == -au=* ]] ; then
		AGENT_URL=`sed -e "s/^\-au\=//" <<< $1`
		return 0
	fi

	return 1 # not found
}

function output_usage
{
	echo
	echo "Usage: create_teamcity_agent.sh <options>"
	echo
	echo "Options:"
	echo "--name, -n         Sets the container name"
	echo "--server-url, -su  Specifies the URL of the TeamCity server"
	echo "                   (e.g. www.example.com:8080)"
	echo "--agent-name, -an  Specifies the name of the agent"
	echo "--agent-port, -ap  Specifies the port that the TeamCity server"
	echo "                   will use to communicate with the build agent"
	echo "--agent-url, -au   Specifies the URL of the agent (without the port)"
	echo
}

function unknown_parameter
{
	echo
	echo "Unknown parameter \"$1\""
	output_usage
	exit 1;
}

for PARAMETER in $* ; do
	check_name "$PARAMETER" ||
	check_server_url "$PARAMETER" ||
	check_agent_name "$PARAMETER" ||
	check_agent_port "$PARAMETER" ||
	check_agent_url "$PARAMETER" ||
	unknown_parameter "$PARAMETER"
done

if [ "$NAME" == "" ] ; then
	echo No name specified
	output_usage
	exit 1
fi

ENV=
if [ "$SERVER_URL" != "" ] ; then
	ENV="$ENV -e SERVER_URL=$SERVER_URL"
fi

if [ "$AGENT" != "" ] ; then
	ENV="$ENV -e AGENT=$AGENT"
fi

PORT_MAPPING=9090:9090
if [ "$AGENT_PORT" != "" ] ; then
	PORT_MAPPING=$AGENT_PORT:$AGENT_PORT
	ENV="$ENV -e OWN_PORT=$AGENT_PORT"
fi

if [ "$AGENT_URL" != "" ] ; then
	ENV="$ENV -e OWN_URL=$AGENT_URL"
fi

docker run --name=$NAME -p $PORT_MAPPING -d $ENV adgico/teamcity-9.1-agent-gcc-4.9

