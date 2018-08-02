# exoplanet EPN-TAP v2 service with mixin

Configuration files for planets v2 service, can be used as templates and adapted.
This example use a distant database to retreive all the data, it recreate the entire collection using command gavo imp q


   - q.rd define all the field optional and non standard, it fill the constant values.  and run the get_metadata.py file

   - get_metadata.py is a python file that read the distant database. You may change the parameter for your own case. Read the database using select, fill a dictionary with the field





