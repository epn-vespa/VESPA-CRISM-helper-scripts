# mineral spectroscopy EPN-TAP v2 service

Configuration files for spectro service, can be used as templates and adapted 
(formerly spectro service, to be renamed PDS_speclib)


spectrodb_ex.csv

   -  csv file containing description of all data files (in this case: a sample of 2 files only; prepared under IDL)

q.rd

   - q.rd file (resource descriptor) for DaCHS. Uses csv grammar and epntap2.rd mixin
	 Will import the metadata and the data from the csv file. 

	 Use as:  (sudo) gavo imp q.rd

	 Caution: may have to add/remove binding vs map of access_format depending on versions of DaCHS and epntap2.rd on your machine (currently unclear)
