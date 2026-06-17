<cfparam name="url.estado" default="todas">
<cfparam name="url.categoria" default="todas">

<cfquery name="qCategorias" datasource="#application.dsn#">
    SELECT id, clave, nombre FROM categorias WHERE activo = 1 ORDER BY nombre
</cfquery>

<cfset condiciones = []>
<cfquery name="qSolicitudes" datasource="#application.dsn#">
    SELECT s.id, s.folio, s.estado, s.nombre_solicitante, s.correo,
           s.fecha_creacion, s.descripcion, s.urgencia,
           c.nombre AS categoria_nombre, c.icono, c.color
    FROM solicitudes s
    INNER JOIN categorias c ON c.id = s.categoria_id
    WHERE 1=1
    <cfif url.estado neq "todas">
        AND s.estado = <cfqueryparam value="#url.estado#" cfsqltype="cf_sql_varchar">
    </cfif>
    <cfif url.categoria neq "todas">
        AND c.clave = <cfqueryparam value="#url.categoria#" cfsqltype="cf_sql_varchar">
    </cfif>
    ORDER BY
        CASE s.estado WHEN 'pendiente' THEN 1 WHEN 'en_proceso' THEN 2 ELSE 3 END,
        s.fecha_creacion DESC
</cfquery>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel de solicitudes - <cfoutput>#application.nombreSistema#</cfoutput></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/soporte-tecnico/assets/css/estilos.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tabler-icons/2.44.0/iconfont/tabler-icons.min.css">
</head>
<body>

    <cfinclude template="../includes/encabezado.cfm">

    <main class="contenedor-principal contenedor-ancho">

        <h1>Panel de solicitudes</h1>

        <div class="barra-filtros">
            <form method="get" class="filtros-form">
                <select name="estado" onchange="this.form.submit()">
                    <option value="todas" <cfif url.estado eq "todas">selected</cfif>>Todos los estados</option>
                    <option value="pendiente" <cfif url.estado eq "pendiente">selected</cfif>>Pendiente</option>
                    <option value="en_proceso" <cfif url.estado eq "en_proceso">selected</cfif>>En proceso</option>
                    <option value="terminada" <cfif url.estado eq "terminada">selected</cfif>>Terminada</option>
                </select>

                <select name="categoria" onchange="this.form.submit()">
                    <option value="todas" <cfif url.categoria eq "todas">selected</cfif>>Todas las categorías</option>
                    <cfoutput query="qCategorias">
                        <option value="#clave#" <cfif url.categoria eq clave>selected</cfif>>#nombre#</option>
                    </cfoutput>
                </select>
            </form>

            <span class="contador-resultados">
                <cfoutput>#qSolicitudes.recordCount# solicitud(es)</cfoutput>
            </span>
        </div>

        <cfif qSolicitudes.recordCount eq 0>
            <p class="texto-vacio">No hay solicitudes con estos filtros.</p>
        <cfelse>
            <table class="tabla-solicitudes">
                <thead>
                    <tr>
                        <th>Folio</th>
                        <th>Categoría</th>
                        <th>Solicitante</th>
                        <th>Descripción</th>
                        <th>Fecha</th>
                        <th>Estado</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="qSolicitudes">
                        <tr>
                            <td>#folio#</td>
                            <td>
                                <span class="etiqueta-categoria icono-#color#">
                                    <i class="ti #icono#"></i> #categoria_nombre#
                                </span>
                            </td>
                            <td>
                                #nombre_solicitante#<br>
                                <span class="texto-secundario">#correo#</span>
                            </td>
                            <td class="celda-descripcion">#left(descripcion, 80)#<cfif len(descripcion) GT 80>&hellip;</cfif></td>
                            <td>#dateFormat(fecha_creacion, "dd/mm/yyyy")#</td>
                            <td>
                                <form action="/soporte-tecnico/admin/cambiar_estado.cfm" method="post" class="form-estado">
                                    <input type="hidden" name="id" value="#id#">
                                    <input type="hidden" name="estado_actual" value="#estado#">
                                    <input type="hidden" name="filtro_estado" value="#url.estado#">
                                    <input type="hidden" name="filtro_categoria" value="#url.categoria#">
                                    <select name="nuevo_estado" onchange="this.form.submit()" class="select-estado select-estado-#estado#">
                                        <option value="pendiente" <cfif estado eq "pendiente">selected</cfif>>Pendiente</option>
                                        <option value="en_proceso" <cfif estado eq "en_proceso">selected</cfif>>En proceso</option>
                                        <option value="terminada" <cfif estado eq "terminada">selected</cfif>>Terminada</option>
                                    </select>
                                </form>
                            </td>
                            <td>
                                <a href="/soporte-tecnico/admin/detalle.cfm?id=#id#" class="enlace-detalle">
                                    <i class="ti ti-eye"></i>
                                </a>
                            </td>
                        </tr>
                    </cfoutput>
                </tbody>
            </table>
        </cfif>

    </main>

</body>
</html>
