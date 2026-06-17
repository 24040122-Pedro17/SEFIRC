<cfparam name="url.id" default="0">

<cfquery name="qSolicitud" datasource="#application.dsn#">
    SELECT s.*, c.nombre AS categoria_nombre, c.clave AS categoria_clave, c.icono, c.color,
           u.nombre AS ubicacion_nombre
    FROM solicitudes s
    INNER JOIN categorias c ON c.id = s.categoria_id
    LEFT JOIN ubicaciones u ON u.id = s.ubicacion_id
    WHERE s.id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif qSolicitud.recordCount eq 0>
    <cflocation url="/soporte-tecnico/admin/solicitudes.cfm" addToken="false">
</cfif>

<cfquery name="qHistorial" datasource="#application.dsn#">
    SELECT h.estado_anterior, h.estado_nuevo, h.fecha, us.nombre_completo
    FROM historial_estados h
    INNER JOIN usuarios us ON us.id = h.usuario_id
    WHERE h.solicitud_id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
    ORDER BY h.fecha ASC
</cfquery>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Detalle de solicitud - <cfoutput>#application.nombreSistema#</cfoutput></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/soporte-tecnico/assets/css/estilos.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tabler-icons/2.44.0/iconfont/tabler-icons.min.css">
</head>
<body>

    <cfinclude template="../includes/encabezado.cfm">

    <main class="contenedor-principal contenedor-angosto">

        <a href="/soporte-tecnico/admin/solicitudes.cfm" class="enlace-volver">
            <i class="ti ti-arrow-left"></i> Volver al panel
        </a>

        <cfoutput>
        <div class="encabezado-formulario">
            <div class="icono-categoria icono-#qSolicitud.color#">
                <i class="ti #qSolicitud.icono#"></i>
            </div>
            <div>
                <p class="formulario-titulo">#qSolicitud.categoria_nombre# &mdash; #qSolicitud.folio#</p>
                <p class="formulario-subtitulo">Creada el #dateFormat(qSolicitud.fecha_creacion, "dd/mm/yyyy")# a las #timeFormat(qSolicitud.fecha_creacion, "h:mm tt")#</p>
            </div>
        </div>
        </cfoutput>

        <div class="tarjeta-formulario">

            <cfoutput>
            <div class="detalle-fila"><span>Solicitante</span><strong>#qSolicitud.nombre_solicitante#</strong></div>
            <div class="detalle-fila"><span>Correo</span><strong>#qSolicitud.correo#</strong></div>

            <cfif len(qSolicitud.ubicacion_nombre ?: "")>
                <div class="detalle-fila"><span>Ubicación</span><strong>#qSolicitud.ubicacion_nombre#</strong></div>
            </cfif>
            <cfif len(qSolicitud.urgencia ?: "")>
                <div class="detalle-fila"><span>Urgencia</span><strong>
                    <cfswitch expression="#qSolicitud.urgencia#">
                        <cfcase value="puede_esperar">Puede esperar</cfcase>
                        <cfcase value="pronto">Pronto</cfcase>
                        <cfcase value="urgente">Urgente</cfcase>
                    </cfswitch>
                </strong></div>
            </cfif>
            <cfif len(qSolicitud.tema ?: "")>
                <div class="detalle-fila"><span>Tema</span><strong>#qSolicitud.tema#</strong></div>
            </cfif>
            <cfif len(qSolicitud.num_personas ?: "")>
                <div class="detalle-fila"><span>Personas</span><strong>
                    <cfswitch expression="#qSolicitud.num_personas#">
                        <cfcase value="solo_yo">Solo 1</cfcase>
                        <cfcase value="2_a_5">2 a 5</cfcase>
                        <cfcase value="6_a_15">6 a 15</cfcase>
                        <cfcase value="mas_15">Más de 15</cfcase>
                    </cfswitch>
                </strong></div>
            </cfif>
            <cfif isDate(qSolicitud.fecha_propuesta ?: "")>
                <div class="detalle-fila"><span>Fecha propuesta</span><strong>#dateFormat(qSolicitud.fecha_propuesta, "dd/mm/yyyy")#</strong></div>
            </cfif>
            <cfif len(qSolicitud.hora_propuesta ?: "")>
                <div class="detalle-fila"><span>Hora propuesta</span><strong>#timeFormat(qSolicitud.hora_propuesta, "h:mm tt")#</strong></div>
            </cfif>
            <cfif len(qSolicitud.motivo ?: "")>
                <div class="detalle-fila"><span>Motivo</span><strong>#qSolicitud.motivo#</strong></div>
            </cfif>
            <cfif len(qSolicitud.participantes ?: "")>
                <div class="detalle-fila"><span>Participantes</span><strong>#qSolicitud.participantes#</strong></div>
            </cfif>

            <div class="detalle-fila detalle-fila-columna">
                <span>Descripción</span>
                <p class="detalle-descripcion">#qSolicitud.descripcion#</p>
            </div>
            </cfoutput>

            <hr class="separador">

            <form action="/soporte-tecnico/admin/cambiar_estado.cfm" method="post" class="form-estado-detalle">
                <input type="hidden" name="id" value="<cfoutput>#qSolicitud.id#</cfoutput>">
                <input type="hidden" name="estado_actual" value="<cfoutput>#qSolicitud.estado#</cfoutput>">
                <label for="nuevo_estado">Cambiar estado</label>
                <select name="nuevo_estado" id="nuevo_estado">
                    <option value="pendiente" <cfif qSolicitud.estado eq "pendiente">selected</cfif>>Pendiente</option>
                    <option value="en_proceso" <cfif qSolicitud.estado eq "en_proceso">selected</cfif>>En proceso</option>
                    <option value="terminada" <cfif qSolicitud.estado eq "terminada">selected</cfif>>Terminada</option>
                </select>
                <button type="submit" class="boton-primario">Guardar cambio</button>
            </form>

        </div>

        <cfif qHistorial.recordCount gt 0>
            <div class="bloque-historial">
                <p class="subtitulo-seccion">Historial</p>
                <cfoutput query="qHistorial">
                    <div class="fila-historial">
                        <span class="texto-secundario">#dateFormat(fecha, "dd/mm/yyyy")# #timeFormat(fecha, "h:mm tt")#</span>
                        <span>#nombre_completo# cambió el estado a <strong>#estado_nuevo#</strong></span>
                    </div>
                </cfoutput>
            </div>
        </cfif>

    </main>

</body>
</html>
