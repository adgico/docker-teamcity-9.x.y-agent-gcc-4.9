#!/bin/bash

docker rmi adgico/teamcity-9.1-agent-gcc-4.9
docker build -t adgico/teamcity-9.1-agent-gcc-4.9 .
