<cfquery name="qCategorias" datasource="#application.dsn#">
    SELECT id, clave, nombre, descripcion_corta, icono, color
    FROM categorias
    WHERE activo = 1
    ORDER BY id
</cfquery>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Nueva solicitud - <cfoutput>#application.nombreSistema#</cfoutput></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/soporte-tecnico/assets/css/estilos.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tabler-icons/2.44.0/iconfont/tabler-icons.min.css">
</head>
<body>

    <cfinclude template="../includes/encabezado.cfm">

    <main class="contenedor-principal">

        <div class="bloque-intro">
            <h1>¿En qué te podemos ayudar?</h1>
            <p>Elige la opción que mejor describa tu situación</p>
        </div>

        <div class="rejilla-categorias">
            <cfoutput>
                <cfloop query="qCategorias">
                    <a href="/soporte-tecnico/solicitudes/formulario.cfm?categoria=#qCategorias.clave#" class="tarjeta-categoria">
                        <div class="icono-categoria icono-#qCategorias.color#">
                            <i class="ti #qCategorias.icono#"></i>
                        </div>
                        <p class="tarjeta-titulo">#qCategorias.nombre#</p>
                        <p class="tarjeta-descripcion">#qCategorias.descripcion_corta#</p>
                    </a>
                </cfloop>
            </cfoutput>
        </div>

        <div class="bloque-mis-solicitudes">
            <a href="/soporte-tecnico/solicitudes/mis_solicitudes.cfm" class="enlace-secundario">
                <i class="ti ti-list-check"></i> Ver mis solicitudes anteriores
            </a>
        </div>

    </main>

</body>
</html>
