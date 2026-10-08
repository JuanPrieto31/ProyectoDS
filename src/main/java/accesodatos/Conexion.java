package accesodatos;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Único punto de acceso a la base de datos.
 * La conexión se puede cambiar con las variables de entorno DB_URL, DB_USER y DB_PASSWORD.
 *
 * @author esteb
 */
public final class Conexion {

    private static final String URL = config("DB_URL", "jdbc:postgresql://localhost:5432/ProyectoDS");
    private static final String USER = config("DB_USER", "postgres");
    private static final String PASSWORD = config("DB_PASSWORD", "123456");

    private static boolean esquemaListo = false;

    static {
        // En Tomcat el driver dentro de WEB-INF/lib no siempre se registra solo
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError("Driver PostgreSQL no encontrado: agrega postgresql al pom.xml");
        }
    }

    private Conexion() {
    }

    public static Connection obtener() throws SQLException {
        Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
        asegurarEsquema(conn);
        return conn;
    }

    private static String config(String nombre, String porDefecto) {
        String valor = System.getenv(nombre);
        return valor == null || valor.isEmpty() ? porDefecto : valor;
    }

    // Crea la tabla de donaciones y la columna meta la primera vez que se conecta la app.
    // El mismo SQL está en database/donaciones.sql por si se prefiere correrlo a mano.
    private static synchronized void asegurarEsquema(Connection conn) throws SQLException {
        if (esquemaListo) {
            return;
        }
        try (Statement st = conn.createStatement()) {
            st.execute("ALTER TABLE propuesta ADD COLUMN IF NOT EXISTS meta NUMERIC(12,2) NOT NULL DEFAULT 0");
            st.execute("ALTER TABLE propuesta ALTER COLUMN fechacreacion SET DEFAULT CURRENT_DATE");
            st.execute("CREATE TABLE IF NOT EXISTS donacion ("
                    + " iddonacion SERIAL PRIMARY KEY,"
                    + " monto NUMERIC(12,2) NOT NULL CHECK (monto > 0),"
                    + " mensaje VARCHAR(300),"
                    + " fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,"
                    + " idpropuesta INT NOT NULL REFERENCES propuesta(idpropuesta) ON DELETE CASCADE,"
                    + " idusuario INT NOT NULL REFERENCES usuario(idusuario) ON DELETE CASCADE)");
            st.execute("CREATE INDEX IF NOT EXISTS donacion_idpropuesta_idx ON donacion(idpropuesta)");
            st.execute("CREATE INDEX IF NOT EXISTS donacion_idusuario_idx ON donacion(idusuario)");
        }
        esquemaListo = true;
    }
}
