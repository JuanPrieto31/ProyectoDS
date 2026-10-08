-- Esquema completo de la base ProyectoDS (PostgreSQL).
-- Uso:  createdb ProyectoDS   y luego   psql -d ProyectoDS -f schema.sql

CREATE TABLE IF NOT EXISTS usuario (
    idusuario       SERIAL PRIMARY KEY,
    nombre          VARCHAR(120) NOT NULL,
    correo          VARCHAR(150) NOT NULL UNIQUE,
    contraseña      VARCHAR(100) NOT NULL,
    rol             VARCHAR(30)  NOT NULL,
    fechanacimiento DATE,
    telefono        VARCHAR(20),
    cedula          INT
);

CREATE TABLE IF NOT EXISTS propuesta (
    idpropuesta   SERIAL PRIMARY KEY,
    titulo        VARCHAR(120) NOT NULL,
    descripcion   TEXT NOT NULL,
    fechacreacion DATE NOT NULL DEFAULT CURRENT_DATE,
    idusuario     INT NOT NULL REFERENCES usuario(idusuario) ON DELETE CASCADE,
    meta          NUMERIC(12,2) NOT NULL DEFAULT 0
);

\i donaciones.sql
