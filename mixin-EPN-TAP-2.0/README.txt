New row definitions were taken from this table: https://voparis-confluence.obspm.fr/display/VES/EPN-TAP+V2.0+parameters

epntap2.rd.xml must be renamed to epntap2.rd
and then placed into this directory on the server:
/usr/lib/python2.7/dist-packages/gavo/resources/inputs/__system__/
then, it is necessary to run
gavo serve reload
to update __system__ rd's prior to running
gavo --debug imp q.rd
