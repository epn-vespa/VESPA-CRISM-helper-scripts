# Hisaki/EXCEED service at Tohoku University (Sendai, Japan)
section for SQL script tables

## Versions
- [v1](v1) contains an old version of the service, using an SQL script to write into the database. The [hisaki.sql](v1/hisaki.sql) uses spoly function to create polygos for use in `s_region` field of product table

- [v2](v2) is now using the `epntap2` mixin and a `customGrammar` to load the metadata into the database.

