# BDIP(v2) EPN-TAP v2 service

Configuration files for BDIP v2 prototype service, can be used as templates and 
adapted. It uses a connection to an external PgSQL database from the resource
descriptor (RD) itself.

## Content

- `q.rd`: service RD
- `data/bdip_tables.txt`: text file containing the list of tables to read in the remote database
- `res/get_metadata.py`: python script used by the `customGrammar` section of the RD

## Description

The RD imports the remote tables into the service schema, and sets up views 
automatically.

