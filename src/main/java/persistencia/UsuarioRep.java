package persistencia;

import accesodatos.Conexion;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import modelo.Usuario;

/**
 *
 * @author juana
 */
public class UsuarioRep {

    private static final String SELECT = "SELECT idusuario, nombre, correo, telefono, rol, cedula, fechanacimiento FROM usuario ";

    public void guardar(Usuario usuario) throws SQLException {
        String sql = "INSERT INTO usuario (nombre, correo, contraseña, rol, fechanacimiento, telefono, cedula) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = Conexion.obtener(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, usuario.getNombre());
            stmt.setString(2, usuario.getCorreo());
            stmt.setString(3, usuario.getContrasena());
            stmt.setString(4, usuario.getRol());
            stmt.setDate(5, Date.valueOf(usuario.getFechaNacimiento()));
            stmt.setString(6, usuario.getTelefono());
            stmt.setInt(7, usuario.getCedula());
            stmt.executeUpdate();
        }
    }

    // Devuelve el usuario si el correo y la contraseña coinciden; null si no
    public Usuario buscarPorCredenciales(String correo, String contrasena) throws SQLException {
        return buscarUno(SELECT + "WHERE lower(correo) = lower(?) AND contraseña = ?", correo, contrasena);
    }

    public Usuario buscarPorCorreo(String correo) throws SQLException {
        return buscarUno(SELECT + "WHERE lower(correo) = lower(?)", correo);
    }

    public Usuario buscarPorId(int id) throws SQLException {
        return buscarUno(SELECT + "WHERE idusuario = ?", id);
    }

    public boolean eliminar(int id) throws SQLException {
        try (Connection conn = Conexion.obtener(); PreparedStatement stmt = conn.prepareStatement("DELETE FROM usuario WHERE idusuario = ?")) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    private Usuario buscarUno(String sql, Object... parametros) throws SQLException {
        try (Connection conn = Conexion.obtener(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (int i = 0; i < parametros.length; i++) {
                stmt.setObject(i + 1, parametros[i]);
            }
            try (ResultSet rs = stmt.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                Date nacimiento = rs.getDate("fechanacimiento");
                return new Usuario(
                        rs.getInt("idusuario"),
                        rs.getString("nombre"),
                        rs.getString("correo"),
                        null,
                        rs.getString("telefono"),
                        rs.getString("rol"),
                        rs.getInt("cedula"),
                        nacimiento == null ? null : nacimiento.toLocalDate());
            }
        }
    }
}
