package Persistencia;

import Accesodatos.datos;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;

/**
 *
 * @author juana
 */
public class UsuarioRep {

    static final String URL = "jdbc:postgresql://localhost:5432/ProyectoDS";
    private static final String USER = "postgres";
    private static final String PASSWORD = "123456";

    public void saveUsuario(Usuario usuario) throws SQLException {
        System.out.println("[DEBUG] UsuarioRep.saveUsuario - Iniciando registro de usuario");
        System.out.println("[DEBUG] Datos del usuario - Nombre: " + usuario.getNombre() + ", Correo: " + usuario.getCorreo());

        String sql = "INSERT INTO Usuario(nombre, correo, contraseña, rol, fechanacimiento, telefono, cedula) VALUES (?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            Class.forName("org.postgresql.Driver");
            System.out.println("[DEBUG] Driver PostgreSQL cargado correctamente");

            datos conbd = new datos(URL, USER, PASSWORD);
            conn = conbd.getConn();

            if (conn == null) {
                throw new SQLException("No se pudo establecer conexión a la base de datos");
            }

            System.out.println("[DEBUG] Conexión establecida, preparando statement");

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, usuario.getNombre());
            stmt.setString(2, usuario.getCorreo());
            stmt.setString(3, usuario.getContraseña());
            stmt.setString(4, usuario.getRol());
            stmt.setDate(5, java.sql.Date.valueOf(usuario.getFechanacimiento()));
            stmt.setString(6, usuario.getTelefono());
            stmt.setInt(7, usuario.getCedula());

            System.out.println("[DEBUG] Ejecutando INSERT en la base de datos");
            int rowsAffected = stmt.executeUpdate();
            System.out.println("[DEBUG] Usuario guardado exitosamente. Filas afectadas: " + rowsAffected);

        } catch (ClassNotFoundException e) {
            System.out.println("[ERROR] Driver PostgreSQL no encontrado: " + e.getMessage());
            e.printStackTrace();
            throw new SQLException("Driver PostgreSQL no encontrado", e);
        } catch (SQLException e) {
            System.out.println("[ERROR] Error SQL al guardar usuario: " + e.getMessage());
            e.printStackTrace();
            throw e;
        } catch (Exception e) {
            System.out.println("[ERROR] Error general al guardar usuario: " + e.getMessage());
            e.printStackTrace();
            throw new SQLException("Error al guardar usuario", e);
        } finally {
            try {
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
                System.out.println("[DEBUG] Conexión cerrada correctamente");
            } catch (SQLException e) {
                System.out.println("[ERROR] Error al cerrar conexión: " + e.getMessage());
            }
        }
    }

    public boolean verificarLogin(String correo, String contraseña) {
        String sql = "SELECT * FROM usuario WHERE correo = ? AND contraseña = ?";
        boolean existe = false;

        System.out.println("[DEBUG] Intentando login con correo: " + correo);

        try {
            Class.forName("org.postgresql.Driver");
            System.out.println("[DEBUG] Driver PostgreSQL cargado correctamente");

            datos conbd = new datos(URL, USER, PASSWORD);
            Connection conn = conbd.getConn();

            if (conn != null) {
                System.out.println("[DEBUG] Conexión a base de datos establecida");
            } else {
                System.out.println("[ERROR] No se pudo establecer conexión a la base de datos");
                return false;
            }

            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, correo);
            stmt.setString(2, contraseña);

            System.out.println("[DEBUG] Ejecutando query: " + sql);
            System.out.println("[DEBUG] Parámetros - Correo: " + correo + ", Contraseña: " + contraseña);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                existe = true;
                System.out.println("[DEBUG] Usuario encontrado en la base de datos");
            } else {
                System.out.println("[DEBUG] Usuario NO encontrado en la base de datos");
            }

            rs.close();
            stmt.close();
            conn.close();
            System.out.println("[DEBUG] Conexión cerrada correctamente");

        } catch (ClassNotFoundException e) {
            System.out.println("[ERROR] Driver PostgreSQL no encontrado: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("[ERROR] Error SQL al validar login: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("[ERROR] Error general al validar login: " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println("[DEBUG] Resultado de verificación: " + existe);
        return existe;
    }

    public Usuario buscarUsuarioPorCorreo(String correo) throws SQLException {

        String sql = "SELECT nombre, correo, telefono, rol, cedula, fechanacimiento "
                + "FROM usuario WHERE correo = ?";

        System.out.println("[DEBUG] UsuarioRep.buscarUsuarioPorCorreo - Buscando: " + correo);
        System.out.println("[DEBUG] SQL: " + sql);

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Usuario usuario = null;

        try {
            Class.forName("org.postgresql.Driver");
            datos conbd = new datos(URL, USER, PASSWORD);
            conn = conbd.getConn();

            if (conn == null) {
                throw new SQLException("No se pudo establecer conexión");
            }

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, correo);
            rs = stmt.executeQuery();

            if (rs.next()) {

                usuario = new Usuario(
                        0,
                        rs.getString("nombre"),
                        rs.getString("correo"),
                        null,
                        rs.getString("telefono"),
                        rs.getString("rol"),
                        rs.getInt("cedula"),
                        rs.getDate("fechanacimiento").toLocalDate()
                );

                java.sql.Date fechaBd = rs.getDate("fechanacimiento");
                if (fechaBd != null) {
                    usuario.setFechanacimiento(fechaBd.toLocalDate());
                    System.out.println("[DEBUG] Fecha de nacimiento: " + usuario.getFechanacimiento());
                }

                System.out.println("[DEBUG] Usuario encontrado: " + usuario.getNombre());
                System.out.println("[DEBUG] Cédula: " + usuario.getCedula());
            } else {
                System.out.println("[DEBUG] No se encontró usuario con correo: " + correo);
            }

        } catch (ClassNotFoundException e) {
            System.out.println("[ERROR] Driver PostgreSQL no encontrado: " + e.getMessage());
            e.printStackTrace();
            throw new SQLException("Driver PostgreSQL no encontrado", e);
        } catch (SQLException e) {
            System.out.println("[ERROR] Error SQL: " + e.getMessage());
            e.printStackTrace();
            throw e;
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
                System.out.println("[DEBUG] Recursos cerrados correctamente");
            } catch (SQLException e) {
                System.out.println("[ERROR] Error cerrando recursos: " + e.getMessage());
            }
        }

        return usuario;
    }

    public boolean eliminarPorCorreo(String correo) throws SQLException {
        String sql = "DELETE FROM usuario WHERE correo = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            Class.forName("org.postgresql.Driver");
            datos conbd = new datos(URL, USER, PASSWORD);
            conn = conbd.getConn();

            if (conn == null) {
                throw new SQLException("No se pudo establecer conexión con la base de datos");
            }

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, correo);
            int filasAfectadas = stmt.executeUpdate();

            return filasAfectadas > 0; 
        } catch (ClassNotFoundException e) {
            throw new SQLException("Error al cargar el driver de PostgreSQL", e);
        } finally {
            if (stmt != null) {
                stmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
    }
}
