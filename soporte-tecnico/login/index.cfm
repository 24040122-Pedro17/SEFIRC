<cfparam name="url.error" default="">
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Iniciar sesión - <cfoutput>#application.nombreSistema#</cfoutput></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/soporte-tecnico/assets/css/estilos.css">
</head>
<body class="pagina-login">

    <div class="contenedor-login">
        <div class="tarjeta-login">

            <div class="login-encabezado">
                <p class="login-titulo">Soporte Técnico</p>
                <p class="login-subtitulo">Inicia sesión con tu cuenta institucional</p>
            </div>

            <cfif len(url.error)>
                <div class="alerta-error">
                    <cfswitch expression="#url.error#">
                        <cfcase value="credenciales">
                            Usuario o contraseña incorrectos.
                        </cfcase>
                        <cfcase value="ldap">
                            No se pudo validar tu cuenta. Intenta de nuevo o contacta a soporte.
                        </cfcase>
                        <cfdefaultcase>
                            Ocurrió un error al iniciar sesión.
                        </cfdefaultcase>
                    </cfswitch>
                </div>
            </cfif>

            <form action="/soporte-tecnico/login/procesar_login.cfm" method="post">
                <div class="campo">
                    <label for="usuario">Usuario institucional</label>
                    <input type="text" id="usuario" name="usuario" placeholder="Ej. maria.lopez" required autofocus>
                </div>

                <div class="campo">
                    <label for="password">Contraseña</label>
                    <input type="password" id="password" name="password" required>
                </div>

                <button type="submit" class="boton-primario boton-ancho">Iniciar sesión</button>
            </form>

            <p class="login-pie">Usa el mismo usuario y contraseña de tu correo institucional</p>
        </div>
    </div>

</body>
</html>
