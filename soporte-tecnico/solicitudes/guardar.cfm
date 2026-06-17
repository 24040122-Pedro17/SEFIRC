<cfscript>
    param name="form.categoria_id" default="0";
    param name="form.nombre" default="";
    param name="form.correo" default="";
    param name="form.descripcion" default="";
    param name="form.ubicacion_id" default="";
    param name="form.urgencia" default="";
    param name="form.tema" default="";
    param name="form.num_personas" default="";
    param name="form.fecha_propuesta" default="";
    param name="form.hora_propuesta" default="";
    param name="form.motivo" default="";
    param name="form.participantes" default="";
</cfscript>

<cfif !len(trim(form.nombre)) || !len(trim(form.correo)) || form.categoria_id eq 0>
    <cflocation url="/soporte-tecnico/solicitudes/seleccionar_categoria.cfm" addToken="false">
</cfif>

<!--- Si la descripción viene vacía (capacitación/reunión con campo opcional) --->
<cfif !len(trim(form.descripcion))>
    <cfset form.descripcion = "Sin detalles adicionales">
</cfif>

<!--- Generamos folio: SOL-AAAA-NNNNNN --->
<cfset anioActual = year(now())>

<cfquery name="qSiguienteNumero" datasource="#application.dsn#">
    SELECT COUNT(*) AS total FROM solicitudes
    WHERE YEAR(fecha_creacion) = <cfqueryparam value="#anioActual#" cfsqltype="cf_sql_integer">
</cfquery>
<cfset numeroFolio = qSiguienteNumero.total + 1>
<cfset folioGenerado = "SOL-" & anioActual & "-" & numericFormat(numeroFolio, "000000")>

<cfquery name="qInsertaSolicitud" datasource="#application.dsn#" result="resultadoInsert">
    INSERT INTO solicitudes (
        folio, categoria_id, usuario_id, nombre_solicitante, correo,
        ubicacion_id, urgencia, tema, num_personas, fecha_propuesta,
        hora_propuesta, motivo, participantes, descripcion, estado
    ) VALUES (
        <cfqueryparam value="#folioGenerado#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#form.categoria_id#" cfsqltype="cf_sql_integer">,
        <cfqueryparam value="#session.usuario.id#" cfsqltype="cf_sql_integer">,
        <cfqueryparam value="#trim(form.nombre)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.correo)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#form.ubicacion_id#" cfsqltype="cf_sql_integer" null="#!len(form.ubicacion_id)#">,
        <cfqueryparam value="#form.urgencia#" cfsqltype="cf_sql_varchar" null="#!len(form.urgencia)#">,
        <cfqueryparam value="#form.tema#" cfsqltype="cf_sql_varchar" null="#!len(form.tema)#">,
        <cfqueryparam value="#form.num_personas#" cfsqltype="cf_sql_varchar" null="#!len(form.num_personas)#">,
        <cfqueryparam value="#form.fecha_propuesta#" cfsqltype="cf_sql_date" null="#!len(form.fecha_propuesta)#">,
        <cfqueryparam value="#form.hora_propuesta#" cfsqltype="cf_sql_time" null="#!len(form.hora_propuesta)#">,
        <cfqueryparam value="#form.motivo#" cfsqltype="cf_sql_varchar" null="#!len(form.motivo)#">,
        <cfqueryparam value="#form.participantes#" cfsqltype="cf_sql_varchar" null="#!len(form.participantes)#">,
        <cfqueryparam value="#trim(form.descripcion)#" cfsqltype="cf_sql_longvarchar">,
        'pendiente'
    )
</cfquery>

<cfset idSolicitud = resultadoInsert.generatedKey>

<!--- Registramos el primer estado en el historial --->
<cfquery name="qHistorial" datasource="#application.dsn#">
    INSERT INTO historial_estados (solicitud_id, estado_anterior, estado_nuevo, usuario_id)
    VALUES (
        <cfqueryparam value="#idSolicitud#" cfsqltype="cf_sql_integer">,
        NULL,
        'pendiente',
        <cfqueryparam value="#session.usuario.id#" cfsqltype="cf_sql_integer">
    )
</cfquery>

<cflocation url="/soporte-tecnico/solicitudes/confirmacion.cfm?folio=#folioGenerado#" addToken="false">
