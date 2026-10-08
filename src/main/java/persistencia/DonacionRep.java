package persistencia;

import accesodatos.Conexion;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import modelo.Donacion;

/**
 * Acceso a datos del microservicio de donaciones.
 */
public class DonacionRep {

    private static final String SELECT_DETALLE =
            "SELECT d.iddonacion, d.monto, d.mensaje, d.fecha, d.idpropuesta, d.idusuario, p.titulo, u.nombre "
            + "FROM donacion d "
            + "JOIN propuesta p ON p.idpropuesta = d.idpropuesta "
            + "JOIN usuario u ON u.idusuario = d.idusuario ";

    public void guardar(Donacion donacion) throws SQLException {
        String sql = "INSERT INTO donacion (monto, mensaje, idpropuesta, idusuario) VALUES (?, ?, ?, ?)";
        try (Connection conn = Conexion.obtener(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setBigDecimal(1, donacion.getMonto());
            stmt.setString(2, donacion.getMensaje());
            stmt.setInt(3, donacion.getIdPropuesta());
            stmt.setInt(4, donacion.getIdUsuario());
            stmt.executeUpdate();
        }
    }

    // Donaciones hechas por un usuario
    public List<Donacion> listarPorDonante(int idUsuario) throws SQLException {
        return consultar(SELECT_DETALLE + "WHERE d.idusuario = ? ORDER BY d.fecha DESC", idUsuario);
    }

    // Donaciones recibidas en los sueños publicados por un usuario
    public List<Donacion> listarRecibidas(int idUsuarioAutor) throws SQLException {
        return consultar(SELECT_DETALLE + "WHERE p.idusuario = ? ORDER BY d.fecha DESC", idUsuarioAutor);
    }

    public List<Donacion> listarPorPropuesta(int idPropuesta) throws SQLException {
        return consultar(SELECT_DETALLE + "WHERE d.idpropuesta = ? ORDER BY d.fecha DESC", idPropuesta);
    }

    public BigDecimal totalGeneral() throws SQLException {
        try (Connection conn = Conexion.obtener();
                PreparedStatement stmt = conn.prepareStatement("SELECT COALESCE(SUM(monto), 0) FROM donacion");
                ResultSet rs = stmt.executeQuery()) {
            rs.next();
            return rs.getBigDecimal(1);
        }
    }

    private List<Donacion> consultar(String sql, int parametro) throws SQLException {
        List<Donacion> lista = new ArrayList<>();
        try (Connection conn = Conexion.obtener(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, parametro);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Donacion d = new Donacion(rs.getInt("iddonacion"), rs.getBigDecimal("monto"), rs.getString("mensaje"),
                            rs.getInt("idpropuesta"), rs.getInt("idusuario"));
                    Timestamp fecha = rs.getTimestamp("fecha");
                    if (fecha != null) {
                        d.setFecha(fecha.toLocalDateTime());
                    }
                    d.setTituloPropuesta(rs.getString("titulo"));
                    d.setNombreDonante(rs.getString("nombre"));
                    lista.add(d);
                }
            }
        }
        return lista;
    }
}
