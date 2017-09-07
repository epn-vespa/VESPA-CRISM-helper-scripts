This folder contains a test table for the embedded mixin in GAVO DaCHS version 1.0 (same as epntap2.rd-2.xml).
To create your own q.rd please use the q.rd creator found at:
http://epn1.epn-vespa.jacobs-university.de:8080/qrdcreator2/

The input data file should be in csv format. 

It is possible to enter python expressions into the q.rd creator (using VAR option), 
but it is much easier to preprocess your data table with python and simply map data columns to fields (using MAP option).
If you have a complex table with unusual data types you may still have to change a few things in the q.rd, but the edits should be minor. 
Most of the time q.rd creator should produce a valid q.rd.
