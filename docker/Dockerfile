FROM debian

RUN apt-get update && apt-get install -y git wget make libssl-dev python2.7 python-dev build-essential python-pip openjdk-8-jre-headless
RUN pip install MyProxyClient
WORKDIR /opt
RUN git clone https://github.com/snic-nsc/esgf_dl.git
WORKDIR /opt/esgf_dl
ENTRYPOINT /bin/bash
