# IRTF_Orton Resource descriptor with EPNTAP2 Mixin, procDef, fitsGrammar

This Ressource Description example is using the latest EPNTAP2.rd mixin 
(as provided in current beta version of DaCHS), procedures defined by `procDef`,
and the `fitsProdGrammar` to load the FITS file header.

## Installation

This example requires the beta version of DaCHS, an up-to-date EPN-TAP v2 mixin 
and the `zeep` python module. 

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
sudo apt-get update
sudo apt-get upgrade
```
Start DaCHS again:
```
sudo gavo serve start
```

### Install Zeep Python Module

This service example is connecting to an external ephemeris webservice 
[IMCCE/Miriade](http://vo.imcce.fr/webservices/miriade/). This webservice is 
using SOAP, so we need to install a SOAP client module for Python. We propose 
to use the [Zeep](http://docs.python-zeep.org/en/master/). 

The Zeep module installation shall be done under `root` priviledge:
```
sudo pip install zeep
```


## Setting up the service

Copy the [irtf_orton](v2/irtf_orton) directory in `/var/gavo/inputs` as `dachsroot` user.

Run the [get_data.batch](v2/irtf_orton/bin/get_data.batch) file to populate your data 
directory. This test service requires about 25 MB of free disk space.  
```
cd /var/gavo/inputs/irtf_orton
source bin/get_data.batch
```

Once the data directories are populated, import the dataset into DaCHS as 
`dachsroot` user:
```
cd /var/gavo/inputs/irtf_orton
gavo import q.rd
```
Restart your DaCHS server and play:
```
sudo gavo serve restart
```

### Versions of service

Two versions of the service are available:
* [v1](v1): First version, using an EPNcore view and an external script to fill the database
* [v2](v2): Current version, using mixin, procDef and fitsProdGrammar capabilites, with no external script anymore. 


