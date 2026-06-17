<cfscript>
    structClear(session);
    sessionInvalidate();
</cfscript>
<cflocation url="/soporte-tecnico/login/index.cfm" addToken="false">
