-- ============================================
-- Esquema de base de datos: Soporte Técnico SEFIR
-- Motor: MySQL 8.0+
-- ============================================

CREATE DATABASE IF NOT EXISTS soporte_tecnico
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE soporte_tecnico;

-- ============================================
-- Tabla: categorias
-- Las 4 categorías fijas del sistema
-- ============================================
CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    clave VARCHAR(30) NOT NULL UNIQUE,   -- incidente, asesoria, capacitacion, reunion
    nombre VARCHAR(60) NOT NULL,
    descripcion_corta VARCHAR(150) NOT NULL,
    icono VARCHAR(40) NOT NULL,
    color VARCHAR(20) NOT NULL,
    activo TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

INSERT INTO categorias (clave, nombre, descripcion_corta, icono, color) VALUES
('incidente', 'Incidente', 'Algo no funciona: equipo, internet, una app o el sistema dejó de servir.', 'ti-alert-triangle', 'red'),
('asesoria', 'Asesoría técnica', 'Tienes una duda o necesitas orientación, pero nada está fallando.', 'ti-bulb', 'blue'),
('capacitacion', 'Capacitación', 'Quieres aprender a usar una herramienta o sistema desde cero.', 'ti-school', 'green'),
('reunion', 'Reunión', 'Necesitas coordinar una junta o platicar con el equipo de soporte.', 'ti-calendar-event', 'amber');

-- ============================================
-- Tabla: ubicaciones
-- Edificios / áreas (usado en incidente y capacitación)
-- ============================================
CREATE TABLE ubicaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    activo TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

INSERT INTO ubicaciones (nombre) VALUES
('Edificio A'), ('Edificio B'), ('Laboratorios'), ('Biblioteca'), ('Otro');

-- ============================================
-- Tabla: usuarios
-- Usuarios autenticados vía AD. No se guarda contraseña,
-- solo se valida contra el directorio en cada login.
-- ============================================
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username_ad VARCHAR(100) NOT NULL UNIQUE,  -- sAMAccountName del AD
    nombre_completo VARCHAR(150) NOT NULL,
    correo VARCHAR(150) NOT NULL,
    rol ENUM('usuario', 'admin') NOT NULL DEFAULT 'usuario',
    activo TINYINT(1) NOT NULL DEFAULT 1,
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ultimo_login DATETIME NULL
) ENGINE=InnoDB;

-- Nota: para marcar al técnico/admin fijo, se actualiza manualmente:
-- UPDATE usuarios SET rol='admin' WHERE username_ad = 'usuario_del_tecnico';

-- ============================================
-- Tabla: solicitudes
-- Tabla principal de todos los tickets
-- ============================================
CREATE TABLE solicitudes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    folio VARCHAR(20) NOT NULL UNIQUE,        -- ej. SOL-2026-000123
    categoria_id INT NOT NULL,
    usuario_id INT NOT NULL,

    -- Datos generales (aplica a todas las categorías)
    nombre_solicitante VARCHAR(150) NOT NULL,
    correo VARCHAR(150) NOT NULL,

    -- Campos específicos por categoría (NULL si no aplica)
    ubicacion_id INT NULL,                    -- incidente, capacitacion
    urgencia ENUM('puede_esperar','pronto','urgente') NULL,  -- incidente
    tema VARCHAR(200) NULL,                   -- asesoria, capacitacion
    num_personas ENUM('solo_yo','2_a_5','6_a_15','mas_15') NULL, -- capacitacion
    fecha_propuesta DATE NULL,                -- capacitacion, reunion
    hora_propuesta TIME NULL,                 -- reunion
    motivo VARCHAR(200) NULL,                 -- reunion
    participantes VARCHAR(300) NULL,          -- reunion

    descripcion TEXT NOT NULL,                -- descripción libre / notas

    estado ENUM('pendiente','en_proceso','terminada') NOT NULL DEFAULT 'pendiente',
    tecnico_id INT NULL,

    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME NULL,
    fecha_cierre DATETIME NULL,

    FOREIGN KEY (categoria_id) REFERENCES categorias(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (ubicacion_id) REFERENCES ubicaciones(id),
    FOREIGN KEY (tecnico_id) REFERENCES usuarios(id),
    INDEX idx_estado (estado),
    INDEX idx_categoria (categoria_id),
    INDEX idx_fecha (fecha_creacion)
) ENGINE=InnoDB;

-- ============================================
-- Tabla: historial_estados
-- Bitácora de cambios de estado de cada solicitud
-- ============================================
CREATE TABLE historial_estados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    solicitud_id INT NOT NULL,
    estado_anterior VARCHAR(20) NULL,
    estado_nuevo VARCHAR(20) NOT NULL,
    comentario VARCHAR(300) NULL,
    usuario_id INT NOT NULL,           -- quién hizo el cambio (técnico/admin)
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (solicitud_id) REFERENCES solicitudes(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
) ENGINE=InnoDB;
