# What this is

- This container is an attempt to make it easier for users to download data from ESGF, irrespective of what operating system they use. This has been tested and known to work on Linux, Windows 10, and Mac OS.
- This recipe requires that you have installed Singularity on your operating system; it's out of the scope of this document to explain installation instructions, but the following urls have been found to be useful:
    - url 1 (fixme)
    - url 2 (fixme)

## Singularity installation

- The singularity build recipe is found in the file `Singularity`.
- To build:
```
git clone https://github.com/snic-nsc/esgf_dl.git
cd esgf_dl && sudo singularity build esgf_dl.simg Singularity
```
- You could also download a prebuilt container image from [https://esg-dn2.nsc.liu.se/virtualtestbed/esgf_dl.simg](https://esg-dn2.nsc.liu.se/virtualtestbed/esgf_dl.simg)

## Downloading ESGF data

- You can download ESGF data using your authentication cookies (recommended), or by using myproxy certificates (not required, and perhaps will be deprecated in the future).

## Downloading ESGF data using authentication cookies (recommended method)
- Simply enter the singularity shell, and execute the wget script with the `-H' flag, and follow the prompts
```
singularity shell esgf_dl.simg
bash wget-xxx.sh -H
```

## Downloading ESGF data using myproxy certificate

- The option to download ESGF data using X509 certificates may be deprecated in the future.
- To do this, you'll need to know your myproxy host, and the username. If your openid is `https://esg-dn1.nsc.liu.se/esgf-idp/openid/testuser`, your myproxy host is `esg-dn1.nsc.liu.se` and your username is `testuser`.
```
singularity shell esgf_dl.simg
rm -rf $HOME/.esg
bash /opt/esgf_dl/get_esgf_certs.sh
myproxyclient logon -b -T -s <myproxy host name> -l <username> -o ~/.esg/credentials.pem -C ~/.esg/certificates
```
