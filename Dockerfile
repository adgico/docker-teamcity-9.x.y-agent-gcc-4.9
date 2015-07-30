FROM       adgico/teamcity-9.1-agent
MAINTAINER Byran Wills-Heath <byran@adgico.co.uk>

RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update

RUN apt-get install -y build-essential

RUN apt-get install -y g++-4.9

