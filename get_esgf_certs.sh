#!/bin/bash

get_certificates() {
    ESG_HOME=$HOME/.esg
    ESG_CERT_DIR=$ESG_HOME/certificates
    [[ -d $ESG_HOME ]] || mkdir -p $ESG_HOME
    # don't if this was already done today
    [[ "$(find $ESG_CERT_DIR -type d -mtime -1 2>/dev/null)" ]] && return 0
    echo -n "Retrieving Federation Certificates..." >&2

    if ! wget -O $ESG_HOME/esg-truststore.ts --no-check-certificate https://github.com/ESGF/esgf-dist/raw/master/installer/certs/esg-truststore.ts; then
        echo "Could not fetch esg-truststore";
        return 1
    fi
    
    if ! wget --no-check-certificate https://raw.githubusercontent.com/ESGF/esgf-dist/master/installer/certs/esg_trusted_certificates.tar -O - -q | tar x -C $ESG_HOME; then
        #certificates tarred into esg_trusted_certificates. (if it breaks, let the user know why
        wget --no-check-certificate https://raw.githubusercontent.com/ESGF/esgf-dist/master/installer/certs/esg_trusted_certificates.tar
        echo "Could't update certs!" >&2
        return 1
    else
        #if here everythng went fine. Replace old cert with this ones    
        [[ -d $ESG_CERT_DIR ]] && rm -r $ESG_CERT_DIR || mkdir -p $(dirname $ESG_CERT_DIR)
        mv $ESG_HOME/esg_trusted_certificates $ESG_CERT_DIR
        touch $ESG_CERT_DIR
        echo "done!" >&2
    fi

}
get_certificates
