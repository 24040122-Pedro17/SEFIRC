<cfparam name="url.folio" default="">

<cfif !len(url.folio)>
    <cflocation url="/soporte-tecnico/solicitudes/seleccionar_categoria.cfm" addToken="false">
</cfif>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Solicitud enviada - <cfoutput>#application.nombreSistema#</cfoutput></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/soporte-tecnico/assets/css/estilos.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tabler-icons/2.44.0/iconfont/tabler-icons.min.css">
</head>
<body>

    <cfinclude template="../includes/encabezado.cfm">

    <main class="contenedor-principal contenedor-angosto">
        <div class="tarjeta-confirmacion">
            <div class="icono-confirmacion">
                <i class="ti ti-circle-check"></i>
            </div>
            <p class="confirmacion-titulo">Solicitud enviada</p>
            <p class="confirmacion-texto">Te notificaremos por correo cuando haya avances</p>

            <div class="folio-caja">
                <span>Tu número de folio</span>
                <strong><cfoutput>#url.folio#</cfoutput></strong>
            </div>

            <div class="confirmacion-botones">
                <a href="/soporte-tecnico/solicitudes/seleccionar_categoria.cfm" class="boton-secundario">Nueva solicitud</a>
                <a href="/soporte-tecnico/solicitudes/mis_solicitudes.cfm" class="boton-primario">Ver mis solicitudes</a>
            </div>
        </div>
    </main>

</body>
</html>
