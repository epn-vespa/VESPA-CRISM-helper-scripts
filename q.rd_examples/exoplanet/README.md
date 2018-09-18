# exoplanet EPN-TAP v2 service with mixin

Configuration files for exoplanets service, can be used as templates and adapted.
This example uses a distant database to retrieve all the data, it recreates the entire collection using command gavo imp q


   - q.rd define all the fields (optional and non standard), fills the constant values, and runs the get_metadata.py file

   - get_metadata.py is a python file that read the distant database. You may change the parameter for your own case. Read the database using select, fill a dictionary with the field





