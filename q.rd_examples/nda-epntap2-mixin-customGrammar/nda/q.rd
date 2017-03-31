<resource schema="nda">
	<meta name="title">Nancay Decameter Array observation database</meta>
	<meta name="description" format="plain">
		Decametric radio observation from Nancay decameter array.
		The Nancay Decameter Array (NDA) at the Station de Radioastronomie de Nancay (SRN) is a phased array
		of 144 "Teepee" helicoidal antenna, half of which being Right Handed (RH) polarized and the other
		half being Left Handed (LH) polarized. Four receivers are currently connected to the NDA, sampling
		data in spectral ranges within 5 to 80 MHz.
	</meta>
	<meta name="copyright">
		Rules of Use:<br/>
		SRN/NDA observations in open access can be freely used for scientific purposes. 
		Their acquisition, processing and distribution is ensured by the SRN/NDA team, which can be contacted for 
		any questions and/or collaborative purposes. Contact email: contact.nda@obs-nancay.fr
		<br/><br/>
		We kindly request the authors of any communications and publications using these data to let us know about 
		them, include minimal citation to the reference and acknowledgements as presented below.
		<br/><br/>
		Acknowledgement:<br/>
		The authors acknowledge the Station de Radioastronomie de Nancay of the Observatoire de Paris (USR 704-CNRS, 
		supported by Universite d'Orleans, OSUC, and Region Centre in France) for providing access to NDA observations 
		accessible online at http://www.obs-nancay.fr
		<br/><br/>
		Reference:<br/> 
		A. Lecacheux, The Nancay Decameter Array: A Useful Step Towards Giant, New Generation Radio Telescopes 
		for Long Wavelength Radio Astronomy, in Radio Astronomy at Long Wavelengths, eds. R. G. Stone, K. W. 
		Weiler, M. L. Goldstein, and J.-L. Bougeret, AGU Geophys. Monogr. Ser., 119, 321, 2000.
	</meta>
	<meta name="creationDate">2016-03-30T15:52:00</meta>
	<meta name="creator.name">Station de Radioastronmie de Nancay</meta>
	<meta name="subject">Jupiter</meta>
	<meta name="subject">Sun</meta>
	<meta name="subject">Radio emission</meta>
	<meta name="subject">Aurora</meta>
	<meta name="subject">Planet</meta>
	<meta name="subject">Magnetosphere</meta>
	<meta name="subject">Solar Wind</meta>
	<meta name="subject">Radio astronomy</meta>
	<meta name="contact.name">Laurent Lamy</meta>
	<meta name="contact.email">contact.nda@obs-nancay.fr</meta>
	<meta name="contact.address">Station de Radioastronomie Route de Souesmes, F-18330 Nancay, France</meta>
	<meta name="referenceURL">http://www.obs-nancay.fr/-Le-reseau-decametrique-.html?lang=en</meta>
	<meta name="instrument">Nancay Decameter Array#NDA</meta>
	<meta name="facility">Station de Radioastronomie de Nancay#SRN</meta>
	<meta name="source">2000GMS...119..321L</meta>
	<meta name="contentLevel">General</meta>
	<meta name="contentLevel">University</meta>
	<meta name="contentLevel">Research</meta>
	<meta name="contentLevel">Amateur</meta>
	<meta name="type">Catalog</meta>
	<meta name="coverage">
		<meta name="waveband">Radio</meta>
	</meta>
	
	<table id="epn_core" onDisk="true" adql="True" primary="granule_uid">
		<mixin
			spatial_frame_type="body"
			optional_columns="access_url access_format access_estsize time_scale access_md5
				thumbnail_url species publisher bib_reference target_region feature_name"
			>//epntap2#table-2_0</mixin>
	        <column name="receiver_name" type="text" ucd="meta.id" description="Receiver name used with the instrument." />
		<column name="accref" type="text" ucd="meta.ref;meta.file" description="File path from local directory."/>
	</table>


	<data id="import" updating="True">
		
		<sources pattern="data/*.cdf" recurse="True">
			<ignoreSources fromdb="select accref from nda.epn_core;"/>
		</sources>
		
		<customGrammar module="res/get_metadata">
			<rowfilter procDef="//products#define">
				<bind name="table">"\schema.epn_core"</bind>
				<bind key="fsize">int(@access_estsize)*1024</bind>
				<bind key="accref">@accref</bind>
				<bind key="path">@access_url</bind>
				<bind key="mime">@access_format</bind>
			</rowfilter>
		</customGrammar>
		
		<make table="epn_core">
			<rowmaker idmaps="*">
				<var key="dataproduct_type">'ds'</var>
				<map key="time_min">dateTimeToJdn(parseISODT(@time_min))</map>
				<map key="time_max">dateTimeToJdn(parseISODT(@time_max))</map>
				<var key="time_scale">"UTC"</var>	
				<var key="instrument_host_name">"Station de Radioastronomie de Nancay#SRN"</var>
				<var key="instrument_name">"Nancay Decameter Array#NDA"</var>
				<var key="service_title">"nda"</var>
				<map key="accref">\inputRelativePath</map>
			</rowmaker>
		</make>
	</data>
</resource>

