For testing save this folder to /var/gavo/inputs/epn_vespa_crism


A test dataset is now online at
http://epn1.epn-vespa.jacobs-university.de/__system__/tap/run/tap
as TAP service epn_vespa_crism.epn_core


Note:
When writing resource descriptor it may be necessary to validate data for imports 
(eg. making sure that strings can be converted to floats, otherwise it will crash)
This can be acieved by doing something similar to
                <make table="epn_core">
                        <rowmaker idmaps="*">
                                <map key="granule_uid" source="name" />
                                <var key="value" source="Minimum_latitude" />
                                <var key="c1_min">float(@value) if (@value).replace('.','',1).replace('-','',1).isdigit() else "-9999"</var>
                                <var key="myAccessFormat">str("yourAccessFormat")</var>
                                <var key="mySpatialFrameType">str("yourSpatialFrameType")</var>
                                <apply procDef="//epntap2#populate" name="fillepn">
                                        <bind name="target_name">"Mars"</bind>
                                        <bind name="access_format">@myAccessFormat</bind>
                                        <bind name="spatial_frame_type">@mySpatialFrameType</bind>
                                        <bind name="instrument_host_name">'phobos'</bind>
                                        <bind name="granule_gid">'MYgranule_gid'</bind>
                                        <bind name="obs_id">'MYobs_uid'</bind>
                                        <bind name="c1_min">@c1_min</bind>
                                </apply>
                        </rowmaker>
which would output -9999 into field c1_min on rows with corrupted data, running 
SELECT * FROM myschema.epn_core WHERE c1_min=-9999
in TOPCAT will pick out these rows.


Note: VO resource type meta for EPN-TAP should always be catalog.
