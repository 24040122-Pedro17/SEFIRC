<cfscript>
    /*
        ============================================
        CONFIGURACIÓN — completa estos valores
        ============================================
        Este archivo NO debe estar en una carpeta accesible
        directamente por URL. Colócalo fuera de wwwroot,
        o protégelo con reglas de Application.cfc.
    */

    // ---- Base de datos MySQL ----
    application.dsn = "soporte_tecnico"; // nombre del DSN configurado en CF Administrator

    // ---- Active Directory / LDAP ----
    application.ldap = {
        server   : "IP_O_HOST_DEL_DOMAIN_CONTROLLER",  // ej. 172.30.0.10
        port     : 389,                                  // 389 sin SSL, 636 con SSL
        useSSL   : false,                                // true si usas puerto 636
        baseDN   : "DC=sefircoahuila,DC=gob,DC=mx",     // ajustar a tu dominio real
        domain   : "SEFIRCOAHUILA"                       // prefijo NetBIOS del dominio, para usuario@dominio o DOMINIO\usuario
    };

    // ---- Modo de autenticación ----
    // "temporal" = usuarios fijos de prueba (sin AD), útil mientras consigues los datos de LDAP
    // "ldap"     = validación real contra Active Directory
    application.modoAutenticacion = "temporal";

    // Usuarios de prueba para el modo "temporal".
    // Quita o cambia esto cuando pases a modo "ldap".
    application.usuariosTemporales = {
        "usuario1" : { password: "1234", nombre: "Usuario de prueba", correo: "usuario1@sefircoahuila.gob.mx", rol: "usuario" },
        "admin1"   : { password: "1234", nombre: "Admin de prueba", correo: "admin1@sefircoahuila.gob.mx", rol: "admin" }
    };

    // ---- Técnico/administrador fijo ----
    // El username_ad de la persona que debe tener rol admin.
    // (la asignación real del rol se hace en la tabla usuarios, esto es solo referencia)
    application.tecnicoFijoUsername = "cesar.martinez";

    // ---- Otros ----
    application.nombreSistema = "Soporte Técnico SEFIR";
</cfscript>
