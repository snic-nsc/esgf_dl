# What this is:

- This repo contains container recipes in an attempt to make it easier for users to download data from ESGF, irrespective of what operating system they use. This has been tested and known to work on Linux, Windows 10, and Mac OS.
- Singularity has been tested on Linux and Windows 10, and Docker on all platforms.
- The singularity container can be used on a machine without needing to be root or root-equivalent.
- Depending on which container you choose, you need to have Singularity or Docker installed on your host machine. it's out of the scope of this document to explain installation instructions, but the following urls have been found to be useful:
    - url 1 (fixme)
    - url 2 (fixme)

## Singularity installation

- The singularity build recipe is found in the file `Singularity`, in the `singularity` directory.
- To build:
```
git clone https://github.com/snic-nsc/esgf_dl.git
cd esgf_dl && git checkout 'v1.01'
cd singularity && sudo singularity build esgf_dl.simg Singularity
```
- You could also download a prebuilt container image from [https://esg-dn2.nsc.liu.se/virtualtestbed/esgf_dl.simg](https://esg-dn2.nsc.liu.se/virtualtestbed/esgf_dl.simg); its `sha256` checksum is `184cd4f7ad6ae959e31b40e5e0e4e11f75d955b5420dce88c1622a1d3a3c2e3d`.

## Docker installation

- The docker build recipe is found in the file `Dockerfile`, in the `docker` directory.
- To build:
```
git clone https://github.com/snic-nsc/esgf_dl.git
cd esgf_dl && git checkout 'v1.01'
cd docker && sudo docker build -t esgf-wget-env .
```
- The prebuilt container is also available on dockerhub; you can simply pull it down by:
```
docker pull pchengi/esgf-wget-env
```

## Downloading ESGF data

- You can download ESGF data using your authentication cookies (recommended), or by using myproxy certificates (not required, and perhaps will be deprecated in the future).

## Downloading ESGF data using authentication cookies (recommended method)
- If using Singularity, simply enter the singularity shell, and execute the wget script with the `-H' flag, and follow the prompts
```
singularity shell esgf_dl.simg
bash wget-xxx.sh -H
```
- If using Docker, simply run the docker container, mounting your home directory onto the container, and execute the wget script with the `-H' flag, and follow the prompts.
```
sudo docker run --rm -it -v $HOME:/opt/esgf_dl/mnt pchengi/esgf-wget-env bash
# The above command mounts your home directory under /opt/esgf_dl/mnt, and you start in /opt/esgf_dl. 
# It is recommended that you create a new directory for downloading the files, under /opt/esgf_dl/mnt, copy the wget script there, and execute it.
# Remember that the docker container runs as root; don't forget to do a chown -R <userid>:<groupid> <download dir> using the userid and groupid of the user who owns the home directory on the host machine.
bash wget-xxx.sh -H
```

## Downloading ESGF data using myproxy certificate

- The option to download ESGF data using X509 certificates may be deprecated in the future.
- If using Singularity,
```
singularity shell esgf_dl.simg
bash wget-xxx.sh
```

- If using Docker,
```
sudo docker run --rm -it -v $HOME:/opt/esgf_dl/mnt pchengi/esgf-wget-env bash
Change to directory containing the wget script, and execute
bash wget-xxx.sh
```

## Expert option: manually fetch myproxy certificate

- This is only for advanced users; if your needs have not been met above, or if you wish to test services, you can manually run myproxy-logon using the python client.
- To do this, you'll need to know your myproxy host, and the username. If your openid is `https://esg-dn1.nsc.liu.se/esgf-idp/openid/testuser`, your myproxy host is `esg-dn1.nsc.liu.se` and your username is `testuser`.
- Note that the above statement may not always apply; some sites such as CEDA use external identity providers, and this method of deducing myproxy host and username will not work. If you know the actual endpoint and identity, use those instead.
- If using singularity, 
```
singularity shell esgf_dl.simg
rm -rf $HOME/.esg
bash /opt/esgf_dl/get_esgf_certs.sh
myproxyclient logon -b -T -s <myproxy host name> -l <username> -o ~/.esg/credentials.pem -C ~/.esg/certificates
```
- If using Docker, 
```
sudo docker run --rm -it -v $HOME:/opt/esgf_dl/mnt pchengi/esgf-wget-env bash
rm -rf $HOME/.esg
bash /opt/esgf_dl/get_esgf_certs.sh
myproxyclient logon -b -T -s <myproxy host name> -l <username> -o ~/.esg/credentials.pem -C ~/.esg/certificates
```
