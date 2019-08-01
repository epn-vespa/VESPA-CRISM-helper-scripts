<resource schema="planetserver_crism">
        <meta name="subject">CRISM</meta>
        <meta name="title">PlanetServer CRISM-derived subset</meta>
        <meta name="description"><![CDATA[
The data provided by PlanetServer are higher-order products derived from a
subset of the complete CRISM* dataset. For the original CRISM dataset
(Murchie, S. et al., 2007), please visit PDS Geosciences node,
https://pds-geosciences.wustl.edu/missions/mro/crism.htm .

This service provides metadata information and access-URLs to the
PlanetServer data access OGC/OWS endpoints as well as hyperlinks to access
the interactive interface provided by the service.
The data provided by PlanetServer was atmospherically calibrated and
geo-referenced as described in Figueira, R.M. et al., 2018.
For the interactive interface, go to http://access.planetserver.eu .

- Murchie, S. et al., 2007, https://doi.org/10.1029/2006JE002682
- Figueira, R.M. et al., 2018, https://doi.org/10.1016/j.pss.2017.09.007

*: Compact Reconnaissance Imaging Spectrometer for Mars (CRISM) on Mars
Reconnaissance Orbiter (MRO), http://crism.jhuapl.edu/
        ]]></meta>
        <meta name="creationDate">2019-08-01T06:00:00</meta>

        <meta name="creator.name">Mikhail Minin</meta>
        <meta name="contact.name">Carlos Brandt</meta>
        <meta name="contact.email">c.brandt@jacobs-university.de</meta>
        <meta name="instrument">CRISM/MRO</meta>

        <meta name="subjects">Mars, spectroscopy, infrared, remote sensing</meta>

        <meta name="facility"></meta>

        <meta name="source">planetserver.eu</meta>
        <meta name="contentLevel">Research</meta>
        <meta name="type">Catalog</meta>  <!-- or Archive, Survey -->

        <meta name="doi">10.21938/F66d1S0a7hE4ZZPDCXyocA</meta>

        <table id="epn_core">
                <mixin spatial_frame_type="body">//epntap2#table-2_0</mixin>
<!--                <mixin>//obscore#publish</mixin>-->
                <meta name="description">
                PlanetServer2/CRISM data: http://access.planetserver.eu/
                </meta>
                <stc>
		     Polygon UNKNOWNFrame [s_region]
                </stc>
                <index columns="s_region" method='GIST'/>

		<column name="access_url" type="text" ucd="meta.ref.url;meta.file" verbLevel="1" description="URL of the data file." />
		<column name="access_format" type="text" description="File format type" ucd="meta.code.mime" verbLevel="1"/>
		<column name="access_estsize" type="integer" unit="kbyte" description="Estimate file size in kbyte" ucd="phys.size;meta.file" verbLevel="1"/>

                <column name="thumbnail_url" type="text" ucd="meta.ref.url;meta.file" description="URL of an image preview" />

<column name="bib_reference" type="text" ucd="meta.bib.bibcode" verbLevel="1" description="doi bibcode" />

<!--optional-->
<column name="solar_longitude_min" type="double precision" unit="deg" verbLevel="1" description="Min Solar longitude Ls (location on orbit / season)" ucd="pos.posAng;pos.heliocentric;stat.min" />
<column name="solar_longitude_max" type="double precision" unit="deg" verbLevel="1" description="Max Solar longitude Ls (location on orbit / season)" ucd="pos.posAng;pos.heliocentric;stat.max" />

<!--non-standard-->
                <column name="sensor_id" type="text" ucd="meta.note;meta.main" tablehead="sensor id" verbLevel="1" description="non standard" />
                <column name="image_width" type="integer" description="image width" ucd="meta.note;meta.main" tablehead="image width" verbLevel="1" unit="pix" />
                <column name="image_height" type="integer" ucd="meta.note;meta.main" tablehead="image height" verbLevel="1" description="image height" unit="pix" />

                <column name="external_link" type="text" ucd="meta.ref.url" tablehead="external_link" verbLevel="1" description="Link to a web application to extract data for CASSIS" />

                <publish sets="ivo_managed,local" />
<!--                <publish />-->

<!--                <column name="BD1300counts" type="integer" description="pixel counts for product BD1300 > 0.01" ucd="meta.note;meta.main" tablehead="BD1300 counts" verbLevel="1" unit="pix" /> -->
<column name="spatial_coordinate_description" type="text" tablehead="Spatial_coordinate_description" description="ID of specific coordinate system and version." ucd="meta.code.class;pos.frame" verbLevel="1" />

                <column name="wavelengths" type="text" description="List of wavelengths for each band" ucd="meta.note;meta.main;em.wl" tablehead="wavelengths" verbLevel="10" unit="nm" />

        </table>

        <data id="import">
                <sources>data/data.csv</sources>
		<csvGrammar>
			<rowfilter procDef="//products#define">
				<bind name="table">"\schema.epn_core"</bind>
			</rowfilter>
		</csvGrammar>
                <make table="epn_core">
			<rowmaker idmaps="*">
				<var key="c1min" source="Westernmost_longitude" />
				<var key="c1max" source="Easternmost_longitude" />
				<var key="c2min" source="Minimum_latitude" />
				<var key="c2max" source="Maximum_latitude" />
				<var key="granule_uid" source="footprint" />

				<var key="s_region">
                                                    'Polygon ICRS '+' '.join([str(item) for sublist in zip([float(x) for x in \
                                                    (@granule_uid.split(' ')[1:-2:2]+[@granule_uid.split(' ')[1]])],[float(x) for x in \
                                                    (@granule_uid.split(' ')[2:-2:2]+[@granule_uid.split(' ')[2]])]) for item in sublist])</var>


				<var key="spatial_frame_type">"body"</var>
				<var key="processing_level">3</var>

				<var key="granule_uid" source="name" />
				<var key="granule_gid">(@granule_uid)[0:3]</var>
				<var key="obs_id">(@granule_uid)[3:11]</var>
                                <var key="dataproduct_type">"sc"</var>
				<var key="sensor_id">(@granule_uid)[20:21]</var>

<!--				   <var key="access_url">('http://access.planetserver.eu:8080/rasdaman/ows?&amp;SERVICE=WCS&amp;VERSION=2.0.1&amp;REQUEST=GetCoverage&amp;COVERAGEID=') + (@granule_uid).lower() + ('&amp;FORMAT=image/tiff')</var>-->
				<var key="access_url">('http://access.planetserver.eu/rasdaman/ows?&amp;SERVICE=WCS&amp;VERSION=2.0.1&amp;REQUEST=GetCoverage&amp;COVERAGEID=') + (@granule_uid).lower() + ('&amp;FORMAT=image/tiff')</var>
				<var key="target_name">"Mars"</var>
				<var key="target_class">"planet"</var>

				<var key="access_format">"application/x-geotiff"</var>

				<var key="spectral_resolution_min"  source="dimE" /> <!-- i needed a floating point variable, so took advantage of this column -->
				<var key="image_width">int(@spectral_resolution_min)</var>

				<var key="spectral_resolution_min" source="dimN" />
				<var key="image_height">int(@spectral_resolution_min)</var>


				<var key="access_estsize">[0.432*@image_width*@image_height,1.764*@image_width*@image_height][@sensor_id=='L']</var>

                                <var key="spectral_resolution_min">[ 2150714947773.1868, 290151792525.3139][@sensor_id=='L']</var>
                                <var key="spectral_resolution_max">[18041696022271.645, 2990145149266.6045][@sensor_id=='L']</var>

                                <var key="spectral_range_min">[283894373106060.6, 76151305120910.39][@sensor_id=='L']</var>
                                <var key="spectral_range_max">[822250296215030.1,299403233796065.1][@sensor_id=='L']</var>

                                <var key="spectral_sampling_step_min">[ 1771888268945.3125, 126910768664.07812][@sensor_id=='L']</var>
                                <var key="spectral_sampling_step_max">[14510950936840.75,  1945816521669.0625][@sensor_id=='L']</var>


				<var key="instrument_name">"CRISM"</var>
				<var key="instrument_host_name">"MRO"</var>

<!--                               <var key="thumbnail_url">('http://access.planetserver.eu:8080/rasdaman/ows?service=WCS&amp;version=2.0.1&amp;request=ProcessCoverages&amp;query=for%20data%20in%20%28%20') + (@granule_uid).lower() + "%20%29%20return%20" + ('encode(%20%7B%20%0Ared%3A%20(int)((int)(255%20%2F%20(max(%20data.band_38)%20-%20min(data.band_38)))%20*%20(data.band_38%20-%20min(data.band_38)))%3B%20%0Agreen%3A%20(int)((int)(255%20%2F%20(max(%20data.band_27)%20-%20min(data.band_27)))%20*%20(data.band_27%20-%20min(data.band_27)))%3B%20%0Ablue%3A%20(int)((int)(255%20%2F%20(max(%20data.band_13)%20-%20min(data.band_13)))%20*%20(data.band_13%20-%20min(data.band_13)))%20%3B%20%0Aalpha%3A%20(int)((data.band_100%20%3E%200)%20*%20255)%7D%2C%20%22png%22%2C%20%22nodata%3D65535%22)','encode(%20{%20red:%20(int)((int)(255%20/%20(max(%20data.band_233)%20-%20min(data.band_233)))%20*%20(data.band_233%20-%20min(data.band_233)));%20green:%20(int)((int)(255%20/%20(max(%20data.band_78)%20-%20min(data.band_78)))%20*%20(data.band_78%20-%20min(data.band_78)));%20blue:%20(int)((int)(255%20/%20(max(%20data.band_13)%20-%20min(data.band_13)))%20*%20(data.band_13%20-%20min(data.band_13)))%20;%20alpha:%20(int)((data.band_100%20%3E%200)%20*%20255)},%20%22png%22,%20%22nodata=65535%22)')[@sensor_id=="L"]</var>-->
                                <var key="thumbnail_url">('http://access.planetserver.eu/rasdaman/ows?service=WCS&amp;version=2.0.1&amp;request=ProcessCoverages&amp;query=for%20data%20in%20%28%20') + (@granule_uid).lower() + "%20%29%20return%20" + ('encode(%20%7B%20%0Ared%3A%20(int)((int)(255%20%2F%20(max(%20data.band_38)%20-%20min(data.band_38)))%20*%20(data.band_38%20-%20min(data.band_38)))%3B%20%0Agreen%3A%20(int)((int)(255%20%2F%20(max(%20data.band_27)%20-%20min(data.band_27)))%20*%20(data.band_27%20-%20min(data.band_27)))%3B%20%0Ablue%3A%20(int)((int)(255%20%2F%20(max(%20data.band_13)%20-%20min(data.band_13)))%20*%20(data.band_13%20-%20min(data.band_13)))%20%3B%20%0Aalpha%3A%20(int)((data.band_100%20%3E%200)%20*%20255)%7D%2C%20%22png%22%2C%20%22nodata%3D65535%22)','encode(%20{%20red:%20(int)((int)(255%20/%20(max(%20data.band_233)%20-%20min(data.band_233)))%20*%20(data.band_233%20-%20min(data.band_233)));%20green:%20(int)((int)(255%20/%20(max(%20data.band_78)%20-%20min(data.band_78)))%20*%20(data.band_78%20-%20min(data.band_78)));%20blue:%20(int)((int)(255%20/%20(max(%20data.band_13)%20-%20min(data.band_13)))%20*%20(data.band_13%20-%20min(data.band_13)))%20;%20alpha:%20(int)((data.band_100%20%3E%200)%20*%20255)},%20%22png%22,%20%22nodata=65535%22)')[@sensor_id=="L"]</var>

<!--				   <var key="subgranule_url">('http://epn1.epn-vespa.jacobs-university.de:8080/subGranule/index.html?cov=') + (@granule_uid).lower() + ('&amp;c1_min=') + str(@c1min) + ('&amp;c1_max=') + str(@c1max) + ('&amp;c2_min=') + str(@c2min) + ('&amp;c2_max=') + str(@c2max) + ('&amp;E_px=') + str(@image_width) + ('&amp;N_px=') + str(@image_height)  + ('&amp;sensor_id=') + (@sensor_id).lower()</var>-->
<!--                                <var key="external_link">('http://aux1.epn-vespa.jacobs-university.de/subGranule2/index.html?callback=') + (@granule_uid).lower()</var>-->
                                <var key="external_link">('http://aux1.epn-vespa.jacobs-university.de/subGranule3/index.html?callback=') + (@granule_uid).lower()</var>


<var key="service_title">"CRISM"</var>
<var key="creation_date">"2016-1-1"</var>
<var key="modification_date">"2018-2-8"</var>
<var key="release_date">"2016-1-1"</var>
<var key="measurement_type">"phys.luminosity;phys.angArea;em.wl"</var>

<var key="bib_reference">"10.1029/2006JE002682"</var>

<var key="incidence_max" source="Incidence_angle" />
<var key="incidence_min" source="Incidence_angle" />

<var key="phase_max" source="Phase_angle" />
<var key="phase_min" source="Phase_angle" />

<var key="c1_resol_min">(@c1max-@c1min)/@image_width</var>
<var key="c1_resol_max">@c1_resol_min</var>

<var key="c2_resol_min">(@c2max-@c2min)/@image_height</var>
<var key="c2_resol_max">@c2_resol_min</var>

<var key="time_min" source="UTC_start_time" />
<var key="time_max" source="UTC_stop_time" />

<var key="emergence_min" source="Emission_angle" />
<var key="emergence_max" source="Emission_angle" />


<var key="solar_longitude_min" source="Solar_longitude" />
<var key="solar_longitude_max" source="Solar_longitude" />

<!--				<var key="BD1300counts" source="BD1300counts" /> -->
<var key="spatial_coordinate_description" source="projection" />

<var key="wavelengths">["352.313;358.771;365.229;371.687;378.145;384.603;391.061;397.519;403.977;410.435;416.893;423.351;429.809;436.267;442.725;449.183;455.641;462.099;468.557;475.015;481.473;487.931;494.389;500.847;507.305;513.763;520.221;526.679;533.137;539.595;546.053;552.511;558.969;565.427;571.885;578.3430000000001;584.801;591.259;597.717;604.175;610.633;617.091;623.549;630.007;636.465;642.923;649.381;655.839;662.297;668.755;675.213;681.671;688.129;694.587;701.045;707.503;713.961;720.419;726.877;733.335;739.793;746.251;752.709;759.167;765.625;772.083;778.541;784.999;791.457;797.915;804.373;810.831;817.289;823.747;830.205;836.663;843.121;849.579;856.037;862.495;868.953;875.411;881.869;888.327;894.785;901.243;907.701;914.159;920.617;927.075;933.533;939.991;946.449;952.907;959.365;965.823;972.281;978.739;985.197;991.655;998.113;1004.571;1011.029;1017.487;1023.945;1030.403;1036.861","1.00135;1.0079;1.01445;1.021;1.02755;1.0341;1.04065;1.0472;1.05375;1.0603;1.06685;1.07341;1.07996;1.08651;1.09307;1.09962;1.10617;1.11273;1.11928;1.12584;1.13239;1.13895;1.14551;1.15206;1.15862;1.16518;1.17173;1.17829;1.18485;1.19141;1.19797;1.20453;1.21109;1.21765;1.22421;1.23077;1.23733;1.24389;1.25045;1.25701;1.26357;1.27014;1.2767;1.28326;1.28983;1.29639;1.30295;1.30952;1.31608;1.32265;1.32921;1.33578;1.34234;1.34891;1.35548;1.36205;1.36861;1.37518;1.38175;1.38832;1.39489;1.40145;1.40802;1.41459;1.42116;1.42773;1.43431;1.44088;1.44745;1.45402;1.46059;1.46716;1.47374;1.48031;1.48688;1.49346;1.50003;1.50661;1.51318;1.51976;1.52633;1.53291;1.53948;1.54606;1.55264;1.55921;1.56579;1.57237;1.57895;1.58552;1.5921;1.59868;1.60526;1.61184;1.61842;1.625;1.63158;1.63816;1.64474;1.65133;1.65791;1.66449;1.67107;1.67766;1.68424;1.69082;1.69741;1.70399;1.71058;1.71716;1.72375;1.73033;1.73692;1.74351;1.75009;1.75668;1.76327;1.76985;1.77644;1.78303;1.78962;1.79621;1.8028;1.80939;1.81598;1.82257;1.82916;1.83575;1.84234;1.84893;1.85552;1.86212;1.86871;1.8753;1.8819;1.88849;1.89508;1.90168;1.90827;1.91487;1.92146;1.92806;1.93465;1.94125;1.94785;1.95444;1.96104;1.96764;1.97424;1.98084;1.98743;1.99403;2.00063;2.00723;2.01383;2.02043;2.02703;2.03363;2.04024;2.04684;2.05344;2.06004;2.06664;2.07325;2.07985;2.08645;2.09306;2.09966;2.10627;2.11287;2.11948;2.12608;2.13269;2.1393;2.1459;2.15251;2.15912;2.16572;2.17233;2.17894;2.18555;2.19216;2.19877;2.20538;2.21199;2.2186;2.22521;2.23182;2.23843;2.24504;2.25165;2.25827;2.26488;2.27149;2.2781;2.28472;2.29133;2.29795;2.30456;2.31118;2.31779;2.32441;2.33102;2.33764;2.34426;2.35087;2.35749;2.36411;2.37072;2.37734;2.38396;2.39058;2.3972;2.40382;2.41044;2.41706;2.42368;2.4303;2.43692;2.44354;2.45017;2.45679;2.46341;2.47003;2.47666;2.48328;2.4899;2.49653;2.50312;2.50972;2.51632;2.52292;2.52951;2.53611;2.54271;2.54931;2.55591;2.56251;2.56911;2.57571;2.58231;2.58891;2.59551;2.60212;2.60872;2.61532;2.62192;2.62853;2.63513;2.64174;2.64834;2.65495;2.66155;2.66816;2.67476;2.68137;2.68798;2.69458;2.70119;2.76068;2.76729;2.7739;2.78052;2.78713;2.79374;2.80035;2.80697;2.81358;2.8202;2.82681;2.83343;2.84004;2.84666;2.85328;2.85989;2.86651;2.87313;2.87975;2.88636;2.89298;2.8996;2.90622;2.91284;2.91946;2.92608;2.9327;2.93932;2.94595;2.95257;2.95919;2.96581;2.97244;2.97906;2.98568;2.99231;2.99893;3.00556;3.01218;3.01881;3.02544;3.03206;3.03869;3.04532;3.05195;3.05857;3.0652;3.07183;3.07846;3.08509;3.09172;3.09835;3.10498;3.11161;3.11825;3.12488;3.13151;3.13814;3.14478;3.15141;3.15804;3.16468;3.17131;3.17795;3.18458;3.19122;3.19785;3.20449;3.21113;3.21776;3.2244;3.23104;3.23768;3.24432;3.25096;3.2576;3.26424;3.27088;3.27752;3.28416;3.2908;3.29744;3.30408;3.31073;3.31737;3.32401;3.33066;3.3373;3.34395;3.35059;3.35724;3.36388;3.37053;3.37717;3.38382;3.39047;3.39712;3.40376;3.41041;3.41706;3.42371;3.43036;3.43701;3.44366;3.45031;3.45696;3.46361;3.47026;3.47692;3.48357;3.49022;3.49687;3.50353;3.51018;3.51684;3.52349;3.53015;3.5368;3.54346;3.55011;3.55677;3.56343;3.57008;3.57674;3.5834;3.59006;3.59672;3.60338;3.61004;3.6167;3.62336;3.63002;3.63668;3.64334;3.65;3.65667;3.66333;3.66999;3.67665;3.68332;3.68998;3.69665;3.70331;3.70998;3.71664;3.72331;3.72998;3.73664;3.74331;3.74998;3.75665;3.76331;3.76998;3.77665;3.78332;3.78999;3.79666;3.80333;3.81;3.81667;3.82335;3.83002;3.83669;3.84336;3.85004;3.85671;3.86339;3.87006;3.87673;3.88341;3.89008;3.89676;3.90344;3.91011;3.91679;3.92347;3.93015;3.93682;4"][@sensor_id=='L']</var>

				<apply procDef="//epntap2#populate-2_0" name="fillepn">
     <bind name="processing_level">@processing_level</bind>
					<bind name="target_name">@target_name</bind>
					<bind name="target_class">@target_class</bind>
					<bind name="instrument_host_name">@instrument_host_name</bind>
					<bind name="instrument_name">@instrument_name</bind>
					<bind name="granule_uid">@granule_uid</bind>
					<bind name="granule_gid">@granule_gid</bind>
					<bind name="obs_id">@obs_id</bind>
<!--					<bind name="spatial_frame_type">"body"</bind>
					<bind name="access_format">@access_format</bind>-->

					<bind name="c1min">@c1min</bind>
					<bind name="c1max">@c1max</bind>
					<bind name="c2min">@c2min</bind>
					<bind name="c2max">@c2max</bind>
<bind name="service_title">@service_title</bind>
<bind name="creation_date">@creation_date</bind>
<bind name="modification_date">@modification_date</bind>
<bind name="release_date">@release_date</bind>

<bind name="incidence_max">@incidence_max</bind>
<bind name="incidence_min">@incidence_min</bind>

<bind name="phase_max">@phase_max</bind>
<bind name="phase_min">@phase_min</bind>

<bind name="spectral_resolution_min">@spectral_resolution_min</bind>

<!-- QUICK HACK TO MAKE THIS WORK -->

<bind name="s_region">@s_region</bind>
<bind name="processing_level">@processing_level</bind>
<bind name="dataproduct_type">@dataproduct_type</bind>
<bind name="target_name">@target_name</bind>
<bind name="target_class">@target_class</bind>
<bind name="spectral_resolution_min">@spectral_resolution_min</bind>
<bind name="spectral_resolution_min">@spectral_resolution_min</bind>
<bind name="spectral_resolution_min">@spectral_resolution_min</bind>
<bind name="spectral_resolution_max">@spectral_resolution_max</bind>
<bind name="spectral_range_min">@spectral_range_min</bind>
<bind name="spectral_range_max">@spectral_range_max</bind>
<bind name="spectral_sampling_step_min">@spectral_sampling_step_min</bind>
<bind name="spectral_sampling_step_max">@spectral_sampling_step_max</bind>
<bind name="measurement_type">@measurement_type</bind>
<bind name="c1_resol_min">@c1_resol_min</bind>
<bind name="c1_resol_max">@c1_resol_max</bind>
<bind name="c2_resol_min">@c2_resol_min</bind>
<bind name="c2_resol_max">@c2_resol_max</bind>
<bind name="time_min">@time_min</bind>
<bind name="time_max">@time_max</bind>
<bind name="emergence_min">@emergence_min</bind>
<bind name="emergence_max">@emergence_max</bind>


<!-- QUICK HACK TO MAKE THIS WORK ENDS HERE -->

				</apply>
			</rowmaker>
		</make>
        </data>
</resource>
