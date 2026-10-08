-- Microservicio de donaciones.
-- La aplicación ejecuta esto sola la primera vez que se conecta (Accesodatos.datos),
-- pero puedes correrlo a mano en pgAdmin sobre la base ProyectoDS.

ALTER TABLE propuesta ADD COLUMN IF NOT EXISTS meta NUMERIC(12,2) NOT NULL DEFAULT 0;
ALTER TABLE propuesta ALTER COLUMN fechacreacion SET DEFAULT CURRENT_DATE;

CREATE TABLE IF NOT EXISTS donacion (
    iddonacion  SERIAL PRIMARY KEY,
    monto       NUMERIC(12,2) NOT NULL CHECK (monto > 0),
    mensaje     VARCHAR(300),
    fecha       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    idpropuesta INT NOT NULL REFERENCES propuesta(idpropuesta) ON DELETE CASCADE,
    idusuario   INT NOT NULL REFERENCES usuario(idusuario) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS donacion_idpropuesta_idx ON donacion(idpropuesta);
CREATE INDEX IF NOT EXISTS donacion_idusuario_idx ON donacion(idusuario);
