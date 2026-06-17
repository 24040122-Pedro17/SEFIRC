<cfscript>
    param name="form.id" default="0";
    param name="form.estado_actual" default="";
    param name="form.nuevo_estado" default="";
    param name="form.filtro_estado" default="todas";
    param name="form.filtro_categoria" default="todas";

    estadosValidos = ["pendiente", "en_proceso", "terminada"];
</cfscript>

<cfif form.id eq 0 || !arrayFindNoCase(estadosValidos, form.nuevo_estado)>
    <cflocation url="/soporte-tecnico/admin/solicitudes.cfm" addToken="false">
</cfif>

<cfif form.nuevo_estado neq form.estado_actual>

    <cfquery name="qActualiza" datasource="#application.dsn#">
        UPDATE solicitudes
        SET estado = <cfqueryparam value="#form.nuevo_estado#" cfsqltype="cf_sql_varchar">,
            fecha_actualizacion = NOW(),
            tecnico_id = <cfqueryparam value="#session.usuario.id#" cfsqltype="cf_sql_integer">
            <cfif form.nuevo_estado eq "terminada">
                , fecha_cierre = NOW()
            </cfif>
        WHERE id = <cfqueryparam value="#form.id#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfquery name="qHistorial" datasource="#application.dsn#">
        INSERT INTO historial_estados (solicitud_id, estado_anterior, estado_nuevo, usuario_id)
        VALUES (
            <cfqueryparam value="#form.id#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#form.estado_actual#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.nuevo_estado#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#session.usuario.id#" cfsqltype="cf_sql_integer">
        )
    </cfquery>

</cfif>

<cflocation url="/soporte-tecnico/admin/solicitudes.cfm?estado=#form.filtro_estado#&categoria=#form.filtro_categoria#" addToken="false">
