# Resource Descriptor file Examples

This directory lists a series of example services configurations 
to be used by data providers to train on building their own 
Resource Descriptor files (`q.rd`) and scripts.

## List of available examples

* [Generic service](generic): A generic `q.rd` file based on the Vega/IKS service at Obs. Paris _(outdated: to be updated with the `epntap2` mixin)_
* [HISAKI service](hisaki): This test service is based on a sample of the Japanese Hisaki data; it is configured with an external script that fills in the database, and is proposing an `s_region` implementation _(outdated: to be updated with the `epntap2` mixin)_
* [IKSv2 service](iks_v2): This is an upgraded version of the [Generic](generic) service example. It is using IDL to write the SQL scripts that will fill the database and to convert PDS3/ascii files into VOTable _(outdated: to be updated with the `epntap2` mixin)_
* [Illu67p](illu67p): This example service has been developed by the CDPP team in Toulouse. It used the new epntap2 mixin feature and a customGrammar to fill the database through DaCHS during the `import` step.
* [IRTF Orton](irtf_orton): This service is using a simple `q.rd` file, and an external Python script to fill the database. This is based on ground based IR observations of Jupiter, in support of Juno. _(outdated: to be updated with the `epntap2` mixin)_
* [Kronos](kronos): This service is a (way too!) complex example of connexion to external database (using PgSQL Foreign Data Wrappers), based on the Cassini/RPWS/HFR database at Obs. Paris, in Meudon. _(outdated: to be updated with the `epntap2` mixin)_
* [myPoly](mypolyb): This a test service that implements `s_region` with the `sPoly` type from PgSphere.
* [ObsNancay NDA-old](nancay_dam): This is an old version of the Nancay Decameter Array service. _(outdated: to be updated with the `epntap2` mixin)_
* [ObsNancay NDA-new](nda-epntap2-mixin-customGrammar): This the new version of the previous example. This example proposes a complete tutorial for setting up similar services (using daily CDF files). It contains the `epntap2` mixin and uses a customGrammar.
* [Planets](planets): A generic service, with the solar system planet main parameters. _(outdated: to be updated with the `epntap2` mixin)_
* [PDS_speclib](PDS_speclib): For PDS spectral library service. Uses the `epntap2` mixin and csv Grammar.
* [spectro_planets](spectro_planets): For Telescopic Planetary Spectra collection. Uses the `epntap2` mixin and csv Grammar.
* [VVEx](vvex): An example service for VIRTIS-VEx data using IDL to build the ingestion SQL script.  _(outdated: to be updated with the `epntap2` mixin)_
* [BDIP_v2](bdip_v2): This service prototype illustrates the connection to a remote database in the resource descriptor.

## More info

More tutorials and informations on how to set up a service are available from:

* the [VESPA discussion and documentation wiki](https://voparis-confluence.obspm.fr/display/VES/Implementing+a+VESPA+service)
* the [GAVO/DaCHS documentation web site](http://docs.g-vo.org/DaCHS/)


