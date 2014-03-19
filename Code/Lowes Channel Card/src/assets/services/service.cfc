<cfcomponent>
    <cffunction 
        name="saveXML"  
        access="remote" output="false" 
        displayname="catalogGateway" >
    	<cfargument name="xmlString" type="xml" required="yes" />
        <cffile action = "write" file = "\\10.1.1.110\Webshop\Drop Zone XML" output = "#xmlString#" charset = "iso-8859-1">
        
    </cffunction>		
</cffunction>