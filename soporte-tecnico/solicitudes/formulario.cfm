<cfparam name="url.categoria" default="">

<!--- Validamos que la categoría exista y esté activa --->
<cfquery name="qCategoria" datasource="#application.dsn#">
    SELECT id, clave, nombre, descripcion_corta, icono, color
    FROM categorias
    WHERE clave = <cfqueryparam value="#url.categoria#" cfsqltype="cf_sql_varchar">
      AND activo = 1
</cfquery>

<cfif qCategoria.recordCount eq 0>
    <cflocation url="/soporte-tecnico/solicitudes/seleccionar_categoria.cfm" addToken="false">
</cfif>

<cfquery name="qUbicaciones" datasource="#application.dsn#">
    SELECT id, nombre FROM ubicaciones WHERE activo = 1 ORDER BY nombre
</cfquery>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Nueva solicitud - <cfoutput>#qCategoria.nombre#</cfoutput></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/soporte-tecnico/assets/css/estilos.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tabler-icons/2.44.0/iconfont/tabler-icons.min.css">
</head>
<body>

    <cfinclude template="../includes/encabezado.cfm">

    <main class="contenedor-principal contenedor-angosto">

        <a href="/soporte-tecnico/solicitudes/seleccionar_categoria.cfm" class="enlace-volver">
            <i class="ti ti-arrow-left"></i> Cambiar categoría
        </a>

        <cfoutput>
        <div class="encabezado-formulario">
            <div class="icono-categoria icono-#qCategoria.color#">
                <i class="ti #qCategoria.icono#"></i>
            </div>
            <div>
                <p class="formulario-titulo">#qCategoria.nombre#</p>
                <p class="formulario-subtitulo">#qCategoria.descripcion_corta#</p>
            </div>
        </div>
        </cfoutput>

        <div class="tarjeta-formulario">
            <form action="/soporte-tecnico/solicitudes/guardar.cfm" method="post">

                <input type="hidden" name="categoria_id" value="<cfoutput>#qCategoria.id#</cfoutput>">

                <div class="campo">
                    <label for="nombre">Tu nombre completo</label>
                    <input type="text" id="nombre" name="nombre" placeholder="Ej. María López"
                           value="<cfoutput>#session.usuario.nombre#</cfoutput>" required>
                </div>

                <div class="campo">
                    <label for="correo">Correo electrónico</label>
                    <input type="email" id="correo" name="correo" placeholder="tu@correo.com"
                           value="<cfoutput>#session.usuario.correo#</cfoutput>" required>
                </div>

                <cfswitch expression="#qCategoria.clave#">

                    <!-- ===================== INCIDENTE ===================== -->
                    <cfcase value="incidente">
                        <div class="campo">
                            <label for="ubicacion_id">¿Dónde ocurre el problema?</label>
                            <select id="ubicacion_id" name="ubicacion_id" required>
                                <option value="">Selecciona tu edificio o área</option>
                                <cfoutput query="qUbicaciones">
                                    <option value="#id#">#nombre#</option>
                                </cfoutput>
                            </select>
                        </div>

                        <div class="campo">
                            <label>¿Qué tan urgente es?</label>
                            <div class="grupo-opciones-3">
                                <label class="opcion-boton">
                                    <input type="radio" name="urgencia" value="puede_esperar" required>
                                    <i class="ti ti-minus"></i><span>Puede esperar</span>
                                </label>
                                <label class="opcion-boton">
                                    <input type="radio" name="urgencia" value="pronto">
                                    <i class="ti ti-clock"></i><span>Pronto</span>
                                </label>
                                <label class="opcion-boton">
                                    <input type="radio" name="urgencia" value="urgente">
                                    <i class="ti ti-flame"></i><span>Urgente</span>
                                </label>
                            </div>
                        </div>

                        <div class="campo">
                            <label for="descripcion">Describe lo que está pasando</label>
                            <textarea id="descripcion" name="descripcion" rows="4"
                                placeholder="Ej. La impresora del segundo piso no imprime desde esta mañana" required></textarea>
                        </div>
                    </cfcase>

                    <!-- ===================== ASESORÍA TÉCNICA ===================== -->
                    <cfcase value="asesoria">
                        <div class="campo">
                            <label for="tema">¿Sobre qué tienes la duda?</label>
                            <input type="text" id="tema" name="tema"
                                   placeholder="Ej. Correo, sistema escolar, impresora, internet" required>
                        </div>

                        <div class="campo">
                            <label for="descripcion">Cuéntanos más</label>
                            <textarea id="descripcion" name="descripcion" rows="4"
                                placeholder="Ej. No sé cómo configurar mi firma en el correo institucional" required></textarea>
                        </div>
                    </cfcase>

                    <!-- ===================== CAPACITACIÓN ===================== -->
                    <cfcase value="capacitacion">
                        <div class="campo">
                            <label for="tema">¿Qué tema quieres aprender?</label>
                            <input type="text" id="tema" name="tema"
                                   placeholder="Ej. Uso de Excel, manejo del sistema escolar, Zoom" required>
                        </div>

                        <div class="campo">
                            <label for="ubicacion_id">¿Dónde te apoyamos?</label>
                            <select id="ubicacion_id" name="ubicacion_id" required>
                                <option value="">Selecciona tu edificio o área</option>
                                <cfoutput query="qUbicaciones">
                                    <option value="#id#">#nombre#</option>
                                </cfoutput>
                            </select>
                        </div>

                        <div class="campo-grupo-2">
                            <div class="campo">
                                <label for="num_personas">¿Cuántas personas?</label>
                                <select id="num_personas" name="num_personas" required>
                                    <option value="solo_yo">Solo yo</option>
                                    <option value="2_a_5">2 a 5</option>
                                    <option value="6_a_15">6 a 15</option>
                                    <option value="mas_15">Más de 15</option>
                                </select>
                            </div>
                            <div class="campo">
                                <label for="fecha_propuesta">Fecha que te conviene</label>
                                <input type="date" id="fecha_propuesta" name="fecha_propuesta" required>
                            </div>
                        </div>

                        <div class="campo">
                            <label for="descripcion">¿Algo más que debamos saber? (opcional)</label>
                            <textarea id="descripcion" name="descripcion" rows="3"
                                placeholder="Ej. Nivel de experiencia del grupo, equipo disponible, etc."></textarea>
                        </div>
                    </cfcase>

                    <!-- ===================== REUNIÓN ===================== -->
                    <cfcase value="reunion">
                        <div class="campo">
                            <label for="motivo">Motivo de la reunión</label>
                            <input type="text" id="motivo" name="motivo"
                                   placeholder="Ej. Revisar requerimientos de un proyecto nuevo" required>
                        </div>

                        <div class="campo-grupo-2">
                            <div class="campo">
                                <label for="fecha_propuesta">Fecha propuesta</label>
                                <input type="date" id="fecha_propuesta" name="fecha_propuesta" required>
                            </div>
                            <div class="campo">
                                <label for="hora_propuesta">Hora propuesta</label>
                                <input type="time" id="hora_propuesta" name="hora_propuesta" required>
                            </div>
                        </div>

                        <div class="campo">
                            <label for="participantes">¿Quién más participa? (opcional)</label>
                            <input type="text" id="participantes" name="participantes"
                                   placeholder="Ej. Juan Pérez, Ana Gómez">
                        </div>

                        <div class="campo">
                            <label for="descripcion">Detalles adicionales (opcional)</label>
                            <textarea id="descripcion" name="descripcion" rows="3"
                                placeholder="Cualquier otro detalle que nos ayude a preparar la reunión"></textarea>
                        </div>
                    </cfcase>

                </cfswitch>

                <button type="submit" class="boton-primario boton-ancho">Enviar solicitud</button>

            </form>
        </div>

    </main>

</body>
</html>
