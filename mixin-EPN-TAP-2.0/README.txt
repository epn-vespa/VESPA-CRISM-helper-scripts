##The latest version is epntap2.rd-2.xml

New row definitions were taken from this table: https://voparis-confluence.obspm.fr/display/VES/EPN-TAP+V2.0+parameters

epntap2.rd.xml must be renamed to epntap2.rd
and then placed into this directory on the server:
/usr/share/pyshared/gavo/resources/inputs/__system__/epntap2.rd
then there should be created a symbolic link in
/usr/lib/python2.7/dist-packages/gavo/resources/inputs/__system__/
to do so run 
ln -s /usr/share/pyshared/gavo/resources/inputs/__system__/epntap2.rd /usr/lib/python2.7/dist-packages/gavo/resources/inputs/__system__/epntap2.rd

then, it is necessary to run
gavo serve reload
gavo serve restart

to update __system__ rd's prior to running
gavo --debug imp q.rd
