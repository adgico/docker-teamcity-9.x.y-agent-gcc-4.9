#!/bin/bash

docker rmi adgico/teamcity-9.x.y-agent-gcc-4.9
docker build -t adgico/teamcity-9.x.y-agent-gcc-4.9 .
