this file (epntap2.rd) should probably be placed into 
/usr/share/pyshared/gavo/resources/inputs/__system__/

there is no need to keep epntap2.rd and epntap.rd separate, 
since only <mixinDef id="table"> and <procDef type="apply" id="populate">
need to be changed, and one RD file can have multiple definitions of these
however it may be more convinient to do so at the development stage 
to make it easier to edit.

I don't understand why does epntap.rd have a column "accref"
<column name="accref" original="//products#products.accref"/>
This exposes my input data table. Is that really necessary? 
