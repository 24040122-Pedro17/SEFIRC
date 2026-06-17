<cfquery name="qMisSolicitudes" datasource="#application.dsn#">
    SELECT s.folio, s.estado, s.fecha_creacion, s.descripcion,
           c.nombre AS categoria_nombre, c.icono, c.color
    FROM solicitudes s
    INNER JOIN categorias c ON c.id = s.categoria_id
    WHERE s.usuario_id = <cfqueryparam value="#session.usuario.id#" cfsqltype="cf_sql_integer">
    ORDER BY s.fecha_creacion DESC
</cfquery>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mis solicitudes - <cfoutput>#application.nombreSistema#</cfoutput></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/soporte-tecnico/assets/css/estilos.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tabler-icons/2.44.0/iconfont/tabler-icons.min.css">
</head>
<body>

    <cfinclude template="../includes/encabezado.cfm">

    <main class="contenedor-principal">

        <div class="bloque-intro-fila">
            <h1>Mis solicitudes</h1>
            <a href="/soporte-tecnico/solicitudes/seleccionar_categoria.cfm" class="boton-primario">
                <i class="ti ti-plus"></i> Nueva solicitud
            </a>
        </div>

        <cfif qMisSolicitudes.recordCount eq 0>
            <p class="texto-vacio">Aún no has hecho ninguna solicitud.</p>
        <cfelse>
            <div class="lista-solicitudes">
                <cfoutput query="qMisSolicitudes">
                    <div class="fila-solicitud">
                        <div class="icono-categoria icono-#color# icono-chico">
                            <i class="ti #icono#"></i>
                        </div>
                        <div class="fila-solicitud-info">
                            <p class="fila-solicitud-titulo">#categoria_nombre# &mdash; #folio#</p>
                            <p class="fila-solicitud-descripcion">#left(descripcion, 90)#<cfif len(descripcion) GT 90>&hellip;</cfif></p>
                        </div>
                        <span class="etiqueta-estado etiqueta-#estado#">
                            <cfswitch expression="#estado#">
                                <cfcase value="pendiente">Pendiente</cfcase>
                                <cfcase value="en_proceso">En proceso</cfcase>
                                <cfcase value="terminada">Terminada</cfcase>
                            </cfswitch>
                        </span>
                    </div>
                </cfoutput>
            </div>
        </cfif>

    </main>

</body>
</html>
