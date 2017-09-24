# TITAN EPN-TAP v2 service

Configuration files for TITAN in EPN-TAP v2 prototype service, can be used as templates and adapted. 

## Content

- `q.rd`: service RD
- `data/some.txt`: text file containing a sample of file from titan service
- `res/get_metadata.py`: python script used by the `customGrammar` section of the RD

## Description

The RD imports titan ascii files into the service schema, and sets up views 
automatically, it also create thumbnail.
in this case the files and thumbnails are stored in a serparate server to be delivered
