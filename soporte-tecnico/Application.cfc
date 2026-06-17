component {

    this.name = "SoporteTecnicoSEFIR";
    this.sessionManagement = true;
    this.sessionTimeout = createTimeSpan(0, 2, 0, 0); // 2 horas
    this.applicationTimeout = createTimeSpan(1, 0, 0, 0);
    this.setClientCookies = true;

    public boolean function onApplicationStart() {
        include "./config/config.cfm";
        return true;
    }

    public boolean function onRequestStart(required string targetPage) {
        // Páginas públicas que no requieren sesión iniciada
        var paginasPublicas = [
            "/soporte-tecnico/login/index.cfm",
            "/soporte-tecnico/login/procesar_login.cfm",
            "/soporte-tecnico/login/logout.cfm"
        ];

        var rutaActual = cgi.script_name;
        var esPublica = arrayFindNoCase(paginasPublicas, rutaActual) > 0;

        if (!esPublica && !structKeyExists(session, "usuario")) {
            location(url="/soporte-tecnico/login/index.cfm", addToken=false);
        }

        // Protección de la sección admin: solo rol admin
        if (findNoCase("/admin/", rutaActual) && structKeyExists(session, "usuario")) {
            if (session.usuario.rol != "admin") {
                location(url="/soporte-tecnico/solicitudes/seleccionar_categoria.cfm", addToken=false);
            }
        }

        return true;
    }

    public void function onSessionStart() {
        session.usuario = {};
    }
}
