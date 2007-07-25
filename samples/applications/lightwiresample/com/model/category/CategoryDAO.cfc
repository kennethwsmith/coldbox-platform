<cfcomponent name="CategoryDAO">

<cffunction name="init" output="false" returntype="any">
	setdsn('');
	<cfreturn THIS>
</cffunction>

<!--- Author: luis5198 - Date: 7/24/2007 --->
<!--- getter and setter for dsn --->
<cffunction name="getdsn" access="public" returntype="string" output="false">
	<cfreturn variables.dsn>
</cffunction>
<cffunction name="setdsn" access="public" returntype="void" output="false">
	<cfargument name="dsn" type="string" required="true">
	<cfset variables.dsn = arguments.dsn>
</cffunction>

</cfcomponent>