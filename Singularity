Bootstrap: docker
From: debian

%post
    apt-get update && apt-get install -y git wget make libssl-dev python2.7 python-dev build-essential python-pip openjdk-8-jre
    pip install MyProxyClient
    git clone https://github.com/snic-nsc/esgf_dl.git
    cd esgf_dl && git checkout 'v1.0'
    mkdir -p /opt/esgf_dl && cp get_esgf_certs.sh /opt/esgf_dl
