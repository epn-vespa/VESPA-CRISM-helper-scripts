# iks EPN-TAP v2 service

Configuration files for IKS v2 service, can be used as templates and adapted.
See this page for a tutorial: https://voparis-confluence.obspm.fr/display/VES/Setting+up+an+EPN-TAP+service



dbiks.pro

   -  IDL routine to read PDS data files and write SQL routine building the datatable

iks_db.sql

   - Output of dbiks.pro

iks_views_v2.sql

   - SQL script to build the views

iks_v2_q.rd

   - q.rd file for DaCHS

catiksfiles.pro

   - IDL routine to convert PDS3/ascii files to VOTable
   
IKS_spectral_channel.xml

   - VOTable containing a basic defintion of the service, for ingestion through TOPCAT

vopdc_obspm-lesia-iks-epn.xml

   - Declaration of service in the registry (TB Adapted, currently v1)


