<!-----------------------------------------------------------------------
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author     :	Luis Majano
Date        :	9/28/2007
Description :
	An error observer
----------------------------------------------------------------------->
<cfcomponent hint="This is a simple error observer"	output="false">

<!------------------------------------------- CONSTRUCTOR ------------------------------------------->

	<cffunction name="Configure" access="public" returntype="void" hint="Configuration" output="false" >
		<!--- Nothing --->
		
	</cffunction>

<!------------------------------------------- INTERCEPTION POINTS ------------------------------------------->

	<cffunction name="afterAspectsLoad" access="public" returntype="void" hint="My very own custom interception point. " output="true" >
		<!--- ************************************************************* --->
		<cfargument name="event" required="true" type="coldbox.system.web.context.RequestContext" hint="The event object.">
		<cfargument name="interceptData" required="true" type="struct" hint="Metadata of intercepted info.">
		<!--- ************************************************************* --->
		<cfscript>
			var lightwireBeanConfig = CreateObject("component", "coldbox.system.ioc.lightwire.BaseConfigObject").init();	
			var defFile = getSetting('ApplicationPath') & "/config/parent.xml.cfm";
			var parentLightwire = 0;
			
			if( getPlugin("IOC").getIOCFramework() eq "lightwire"){
				/* Setup Parent Factory */
				lightwireBeanConfig.parseXMLConfigFile(defFile,getSettingStructure());
				
				/* Create the parent Lightwire factory */
				parentLightwire = createObject("component","coldbox.system.ioc.lightwire.LightWire").init(lightwireBeanConfig);
				
				/* set it up */
				getPlugin("IOC").getIOCFactory().setParentFactory(parentLightwire);
			}
		</cfscript>
	</cffunction>


</cfcomponent>