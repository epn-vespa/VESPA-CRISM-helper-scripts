# spectro EPN-TAP v2 service

Configuration files for spectro service, can be used as templates and adapted.



spectrodb_ex.csv

   -  csv file containing description of all data files (in this case: a sample of 2 files only; prepared under IDL)

spectro_q.rd

   - q.rd file (resource descriptor) for DaCHS. Uses csv grammar and epntap2.rd mixin
	 Will import the metadata and the data. 
	 use as:  sudo gavo imp q.rd

