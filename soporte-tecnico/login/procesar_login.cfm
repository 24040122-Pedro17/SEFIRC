<cfscript>
    param name="form.usuario" default="";
    param name="form.password" default="";
</cfscript>

<cfif !len(trim(form.usuario)) || !len(trim(form.password))>
    <cflocation url="/soporte-tecnico/login/index.cfm?error=credenciales" addToken="false">
</cfif>

<cfset loginExitoso = false>
<cfset rolFinal = "">

<cftry>

    <cfif application.modoAutenticacion eq "temporal">

        <!--- ===================== MODO TEMPORAL (sin AD) ===================== --->
        <!--- Válida solo mientras no tengas los datos de LDAP. Usuarios definidos en config.cfm --->
        <cfset claveUsuario = trim(form.usuario)>

        <cfif !structKeyExists(application.usuariosTemporales, claveUsuario)>
            <cflocation url="/soporte-tecnico/login/index.cfm?error=credenciales" addToken="false">
        </cfif>

        <cfset datosTemp = application.usuariosTemporales[claveUsuario]>

        <cfif datosTemp.password neq form.password>
            <cflocation url="/soporte-tecnico/login/index.cfm?error=credenciales" addToken="false">
        </cfif>

        <cfset nombreCompleto = datosTemp.nombre>
        <cfset correoUsuario = datosTemp.correo>
        <cfset usernameAD = claveUsuario>

    <cfelse>

        <!--- ===================== MODO LDAP (Active Directory) ===================== --->
        <cfset usuarioLDAP = application.ldap.domain & "\" & trim(form.usuario)>

        <cfldap
            action="query"
            server="#application.ldap.server#"
            port="#application.ldap.port#"
            secure="#application.ldap.useSSL#"
            username="#usuarioLDAP#"
            password="#form.password#"
            start="#application.ldap.baseDN#"
            scope="subtree"
            filter="(sAMAccountName=#trim(form.usuario)#)"
            attributes="sAMAccountName,displayName,mail"
            name="resultadoLDAP"
            timeout="8000">

        <cfif resultadoLDAP.recordCount eq 0>
            <cflocation url="/soporte-tecnico/login/index.cfm?error=credenciales" addToken="false">
        </cfif>

        <cfset nombreCompleto = resultadoLDAP.displayName[1]>
        <cfset correoUsuario = resultadoLDAP.mail[1]>
        <cfset usernameAD = resultadoLDAP.sAMAccountName[1]>

    </cfif>

    <!--- Buscamos o creamos el usuario en nuestra base de datos --->
    <cfquery name="qBuscaUsuario" datasource="#application.dsn#">
        SELECT id, rol, activo
        FROM usuarios
        WHERE username_ad = <cfqueryparam value="#usernameAD#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfif qBuscaUsuario.recordCount eq 0>
        <!--- Primer login: se crea el registro con rol usuario por default --->
        <cfquery name="qInsertaUsuario" datasource="#application.dsn#" result="resInsert">
            INSERT INTO usuarios (username_ad, nombre_completo, correo, rol, ultimo_login)
            VALUES (
                <cfqueryparam value="#usernameAD#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#nombreCompleto#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#correoUsuario#" cfsqltype="cf_sql_varchar">,
                'usuario',
                NOW()
            )
        </cfquery>
        <cfset idUsuario = resInsert.generatedKey>
        <cfset rolUsuario = "usuario">
    <cfelse>
        <cfif qBuscaUsuario.activo eq 0>
            <cflocation url="/soporte-tecnico/login/index.cfm?error=credenciales" addToken="false">
        </cfif>

        <cfquery name="qActualizaLogin" datasource="#application.dsn#">
            UPDATE usuarios
            SET ultimo_login = NOW(),
                nombre_completo = <cfqueryparam value="#nombreCompleto#" cfsqltype="cf_sql_varchar">,
                correo = <cfqueryparam value="#correoUsuario#" cfsqltype="cf_sql_varchar">
            WHERE id = <cfqueryparam value="#qBuscaUsuario.id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfset idUsuario = qBuscaUsuario.id>
        <cfset rolUsuario = qBuscaUsuario.rol>
    </cfif>

    <!--- Guardamos sesión --->
    <cfset session.usuario = {
        id: idUsuario,
        username: usernameAD,
        nombre: nombreCompleto,
        correo: correoUsuario,
        rol: rolUsuario
    }>

    <cfset loginExitoso = true>
    <cfset rolFinal = rolUsuario>

    <cfcatch type="any">
        <cflocation url="/soporte-tecnico/login/index.cfm?error=ldap" addToken="false">
    </cfcatch>
</cftry>

<cfif loginExitoso>
    <cfif rolFinal eq "admin">
        <cflocation url="/soporte-tecnico/admin/solicitudes.cfm" addToken="false">
    <cfelse>
        <cflocation url="/soporte-tecnico/solicitudes/seleccionar_categoria.cfm" addToken="false">
    </cfif>
</cfif>
