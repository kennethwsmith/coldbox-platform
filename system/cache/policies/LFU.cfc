<!-----------------------------------------------------------------------
********************************************************************************
Copyright 2005-2008 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldboxframework.com | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author     :	Luis Majano
Date        :	11/14/2007
Description :
	This is an AbstractEviction Policy object.
----------------------------------------------------------------------->
<cfcomponent name="LFU" 
			 output="false" 
			 hint="LFU Eviction Policy Command" 
			 extends="coldbox.system.cache.policies.AbstractEvictionPolicy">

<!------------------------------------------- CONSTRUCTOR ------------------------------------------->

	<!--- init --->
	<cffunction name="init" output="false" access="public" returntype="LFU" hint="Constructor">
		<cfargument name="cacheManager" type="coldbox.system.cache.CacheManager" required="true" hint="The cache manager"/>
		<cfscript>
			setCacheManager(arguments.cacheManager);
			return this;
		</cfscript>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->

	<!--- execute --->
	<cffunction name="execute" output="false" access="public" returntype="void" hint="Execute the policy">
		<cfscript>
			var oCacheManager = getCacheManager();
			var poolMD = oCacheManager.getPoolMetadata(deepCopy=false);
			var LFUIndex = "";
			var indexLength = 0;
			var x = 1;
			var md = "";
			var evictCount = oCacheManager.getCacheConfig().getEvictCount();
			var evictedCounter = 0;
			
		
			// Get searchable index
			try{
				LFUIndex = structSort(poolMD,"numeric", "ASC", "hits");
			}
			catch(Any e){
				$log("error","Error sorting metadata pool. #e.message# #e.detail#. Serialized Pool: #poolMD.toString()#");
			}
			indexLength = ArrayLen(LFUIndex);
			
			//Loop Through Metadata
			for (x=1; x lte indexLength; x=x+1){
				//get object metadata and verify it
				md = oCacheManager.getCachedObjectMetadata(LFUIndex[x]);
				if( structIsEmpty(md) ){ continue; }
				
				//Override Eternal Checks
				if ( md.timeout gt 0 AND NOT md.isExpired ){
					// Expire Key
					oCacheManager.expireKey(LFUIndex[x]);
					// Record Eviction 
					oCacheManager.getCacheStats().evictionHit();
					evictedCounter = evictedCounter + 1;
					
					// Can we break or keep on evicting
					if( evictedCounter gte evictCount ){
						break;
					}
				}//end timeout gt 0
			}//end for loop			
		</cfscript>
	</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------->


</cfcomponent>