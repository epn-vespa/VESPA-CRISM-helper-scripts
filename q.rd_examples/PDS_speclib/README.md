# mineral spectroscopy EPN-TAP v2 service

Configuration files for spectro service, can be used as templates and adapted 
(formerly spectro service, renamed PDS_speclib)


spectrodb_ex2.csv

   - a csv file containing the description of all data files (in this example: a sample for 2 spectra only). The table is prepared under IDL and this is particularly messy, but this is not relevant here - the IDL routine is therefore not included.

q.rd

   - q.rd file (resource descriptor) for DaCHS. Uses csv grammar and epntap2.rd mixin
	 Will import the metadata and the data from the csv file. 
	 In the q.rd file, you have to change the name of the csv file in use. 

	 Use as:  (sudo) gavo imp q.rd

	 Caution: may have to add/remove binding vs map of access_format depending on versions of DaCHS and epntap2.rd on your machine (currently unclear, but the baseline is to use the mixin included in your version of DaCHS)
