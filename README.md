# What this is:

- This repo contains container recipes in an attempt to make it easier for users to download data from ESGF, across operating systems.
- The Singularity container has been tested and found to work on Linux, and the Docker container has been tested and found to work on Linux, Windows 10, and MacOS.
## Which one to use
- If you are running MacOS or Windows, your choice has to be Docker.
- The Singularity container can be used on a machine without needing to be root or root-equivalent user.
- The Singularity shell environment defaults to the same userid/groupid as that of the user running the container, so no need to worry about file-permissions.
- The Docker container runs as user 'root'; any files downloaded within the container, even onto the manually mounted home directory, will be owned by 'root'. You have to manually use `chown` to change ownership; you don't need to do this on a Mac.
- Singularity is supported on all major linux platforms and can be run natively, but installation on Mac or Windows requires vagrant/vm deployment, costing the advantage of auto-mounting.
- Depending on which container you choose, you need to have Singularity or Docker installed on your host machine. it's out of the scope of this document to explain installation instructions, but the following urls have been found to be useful:
    - [Singularity Installation on Linux](https://singularity.lbl.gov/install-linux)
    - [Docker Installation on Windows](https://docs.docker.com/docker-for-windows/install/)
    - [Docker Installation on Mac](https://docs.docker.com/docker-for-mac/install/)
    - For Docker installation on Linux distros, check documentation for your distribution, as it is often repackaged for your distribution.

## Singularity installation

- The Singularity build recipe is found in the file `Singularity`, in the `singularity` directory.
- To build:
```
git clone https://github.com/snic-nsc/esgf_dl.git
cd esgf_dl && git checkout 'v1.02'
cd singularity && sudo singularity build esgf_dl.simg Singularity
```
- You could also download a prebuilt container image from [https://esg-dn2.nsc.liu.se/virtualtestbed/esgf_dl.simg](https://esg-dn2.nsc.liu.se/virtualtestbed/esgf_dl.simg); its `sha256` checksum is `321137f6ddc4f8854d5e5770d79f8c1bdbafac4001666f73a2531e50f589de6c`.

## Docker installation

- The Docker build recipe is found in the file `Dockerfile`, in the `docker` directory.
- To build:
```
git clone https://github.com/snic-nsc/esgf_dl.git
cd esgf_dl && git checkout 'v1.02'
cd docker && sudo docker build -t esgf-wget-env .
```
- The prebuilt container is also available on Dockerhub; you can simply pull it down by:
```
sudo docker pull pchengi/esgf-wget-env
```

## Downloading ESGF data

- You can download ESGF data using your authentication cookies (recommended), or by using myproxy certificates (not required, and perhaps will be deprecated in the future).

## Downloading ESGF data using authentication cookies (recommended method)
- If using Singularity, simply enter the singularity shell, and execute the wget script with the `-H' flag, and follow the prompts
```
singularity shell esgf_dl.simg
cd <directory containing wget script>
bash wget-xxx.sh -H
```
- If using Docker, simply run the Docker container, mounting your home directory onto the container, and execute the wget script with the `-H' flag, and follow the prompts.
```
sudo docker run --rm -it -v $HOME:/opt/esgf_dl/mnt pchengi/esgf-wget-env:v1.02 bash
cd <directory containing wget script>
(note that your home directory would be mounted under /opt/esgf_dl/mnt on the container)
bash wget-xxx.sh -H
```
The `docker run` command above mounts your home directory under /opt/esgf_dl/mnt, and you start in /opt/esgf_dl. 
It is recommended that you create a new directory for downloading the files, under /opt/esgf_dl/mnt, copy the wget script there, and execute it.
Remember that the Docker container runs as root; don't forget to do a chown -R <userid>:<groupid> <download dir> using the userid and groupid of the user who owns the home directory on the host machine. You don't need to do this however on a Mac.

## Downloading ESGF data using myproxy certificate

- The option to download ESGF data using X509 certificates may be deprecated in the future.
- If using Singularity,
```
singularity shell esgf_dl.simg
cd <directory containing wget script>
bash wget-xxx.sh
```

- If using Docker,
```
sudo docker run --rm -it -v $HOME:/opt/esgf_dl/mnt pchengi/esgf-wget-env:v1.02 bash
cd <directory containing wget script>
(note that your home directory would be mounted under /opt/esgf_dl/mnt on the container)
bash wget-xxx.sh
```

## Expert option: manually fetch myproxy certificate

- This is only for advanced users; if your needs have not been met above, or if you wish to test services, you can manually run myproxy-logon using the python client.
- To do this, you'll need to know your myproxy host, and the username. If your openid is `https://esg-dn1.nsc.liu.se/esgf-idp/openid/testuser`, your myproxy host is `esg-dn1.nsc.liu.se` and your username is `testuser`.
- Note that the above statement may not always apply; some sites such as CEDA use external identity providers, and this method of deducing myproxy host and username will not work. If you know the actual endpoint and identity, use those instead.
- If using Singularity, 
```
singularity shell esgf_dl.simg
rm -rf $HOME/.esg
bash /opt/esgf_dl/get_esgf_certs.sh
myproxyclient logon -b -T -s <myproxy host name> -l <username> -o ~/.esg/credentials.pem -C ~/.esg/certificates
```
- If using Docker, 
```
sudo docker run --rm -it -v $HOME:/opt/esgf_dl/mnt pchengi/esgf-wget-env:v1.02 bash
rm -rf $HOME/.esg
bash /opt/esgf_dl/get_esgf_certs.sh
myproxyclient logon -b -T -s <myproxy host name> -l <username> -o ~/.esg/credentials.pem -C ~/.esg/certificates
```
