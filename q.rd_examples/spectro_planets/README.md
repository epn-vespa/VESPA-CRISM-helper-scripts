# spectro_planets, EPN-TAP v2 service

Configuration files for Telescopic planetary spectra service, can be used as templates and adapted 


spectro_planet.csv

   -  csv file containing description of all data files (because this contains a limited number of spectra, and because parameters have to be retrieved from the original papers, this is prepared manually under a French version of Xcel, then converted to actual csv)

q.rd

   - q.rd file (resource descriptor) for DaCHS. Uses csv grammar and epntap2.rd mixin
	 Will import the metadata and the data from the csv file. 

	 Use as:  (sudo) gavo imp q.rd

	 Caution: may have to add/remove binding vs map of access_format depending on versions of DaCHS and epntap2.rd mixin on your machine (still unclear)

Other IDL routines convert the original spectra to VOtable and produce eps thumbnails (then converted to png)
