<header class="encabezado">
    <cfoutput>
    <div class="encabezado-marca">#application.nombreSistema#</div>
    <div class="encabezado-usuario">
        <span>#session.usuario.nombre#</span>
        <a href="/soporte-tecnico/login/logout.cfm" class="enlace-salir"><i class="ti ti-logout"></i> Salir</a>
    </div>
    </cfoutput>
</header>
