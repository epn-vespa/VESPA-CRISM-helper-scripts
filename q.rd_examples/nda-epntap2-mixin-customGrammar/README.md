# NDA Resource descriptor with EPNTAP2 Mixin and customGrammar

This Ressource Descrption example is using the latest EPNTAP2.rd mixin 
(provided in [src](src)), and a customGrammar to fill out the epncore table.

## Installation

This example requires the beta version of DaCHS, an up-to-date EPN-TAP v2 mixin 
and a python CDF library. 

### Beta version of DaCHS

Stop the current DaCHS instance if running:
```
sudo gavo serve stop
```
Select the "beta" version of DaCHS repository. In `/etc/apt/sources.list`, edit
the GAVO DaCHS Debian repository configuration to:
```
deb http://vo.ari.uni-heidelberg.de/debian beta main
```
Load the last version of DaCHS:
```
sudo apt-get upgrade
sudo apt-get update
```
Start DaCHS again:
```
sudo gavo serve start
```

### Install the last version of the EPN-TAP v2 mixin 

Then copy the [epntap2.rd](src/epntap2.rd) mixin file into 
`/usr/share/pyshared/gavo/resources/inputs/__system__/` as `root user.

### Install CDF library

This installation has two steps: installing the CDF C library from NASA-GSFC, 
and installing the PyCDF python module wrapper for the C library.

#### Installing the CDF Library
The CDF C library is distributed and maintained by NASA/GSFC at 
[https://cdf.gsfc.nasa.gov](https://cdf.gsfc.nasa.gov). This web site includes 
documentation on the CDF format and the CDF C library. The lastest CDF C library
distribution can be download from 
https://spdf.sci.gsfc.nasa.gov/pub/software/cdf/dist. Select the linux section
and the `cdf36_3-dist-all.tar.gz` file (replace `cdf36_3` by the current CDF 
library version). Follow instructions after download.

#### Installing the PyCDF module
The PyCDF module is a Python wrapper on the CDF C library. It is currently 
distributed as part of the [SpacePy](https://pythonhosted.org/SpacePy/) module.
You will have to follow the [manual install 
steps](https://pythonhosted.org/SpacePy/install_linux.html). 

Ask for [help](mailto:support.vespa@obspm.fr) if it does not work. 

## Setting up the service

Copy the [nda](nda) directory in `/var/gavo/inputs` as `dachsroot` user.

Run the [get_data.batch](nda/bin/get_data.batch) file to populate your data 
directories. This test service requires about 1.5 GB of free disk space.  
```
cd /var/gavo/inputs/nda
source bin/get_data.batch
```

Once the data directories are populated, import the dataset into DaCHS as 
`dachsroot` user:
```
cd /var/gavo/inputs/nda
gavo import -m q.rd
```
Restart your DaCHS server and play:
```
sudo gavo serve restart
```



