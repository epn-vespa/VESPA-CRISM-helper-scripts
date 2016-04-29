# VVEx EPN-TAP v2 service

Configuration files for Virtis Venus-Express v2 service, can be used as templates and adapted.


dbvex2.pro
- IDL routine to gather info and build a first data table: parse the extended index of the PSA archive, extract relevant info, format it conveniently. Then write a SQL routine (vex_db2.sql) ingesting the metadata. Each line describes both the data and geometry granules.
    

vex_views2.sql

   - SQL script to build the epn.core view from the datatable.  

vex_v2_q.rd

   - q.rd file for DaCHS




