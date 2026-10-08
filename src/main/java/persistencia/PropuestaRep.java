package persistencia;

import accesodatos.Conexion;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import modelo.Propuesta;

/**
 *
 * @author juana
 */
public class PropuestaRep {

    // Propuesta + nombre del autor + total recaudado y número de donaciones
    private static final String SELECT_CON_TOTALES =
            "SELECT p.idpropuesta, p.titulo, p.descripcion, p.fechacreacion, p.idusuario, p.meta, u.nombre AS autor, "
            + " COALESCE(SUM(d.monto), 0) AS recaudado, COUNT(d.iddonacion) AS numdonaciones "
            + "FROM propuesta p "
            + "JOIN usuario u ON u.idusuario = p.idusuario "
            + "LEFT JOIN donacion d ON d.idpropuesta = p.idpropuesta ";
    private static final String GROUP_ORDER = " GROUP BY p.idpropuesta, u.nombre ORDER BY p.idpropuesta DESC";

    public void guardar(Propuesta propuesta) throws SQLException {
        String sql = "INSERT INTO propuesta (titulo, descripcion, idusuario, meta, fechacreacion) VALUES (?, ?, ?, ?, CURRENT_DATE)";
        try (Connection conn = Conexion.obtener(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, propuesta.getTitulo());
            stmt.setString(2, propuesta.getContenido());
            stmt.setInt(3, propuesta.getIdUsuario());
            stmt.setBigDecimal(4, propuesta.getMeta());
            stmt.executeUpdate();
        }
    }

    public List<Propuesta> listarTodas() throws SQLException {
        return consultar(SELECT_CON_TOTALES + GROUP_ORDER);
    }

    public List<Propuesta> listarPorUsuario(int idUsuario) throws SQLException {
        return consultar(SELECT_CON_TOTALES + "WHERE p.idusuario = ?" + GROUP_ORDER, idUsuario);
    }

    public Propuesta buscarPorId(int idPropuesta) throws SQLException {
        List<Propuesta> lista = consultar(SELECT_CON_TOTALES + "WHERE p.idpropuesta = ?" + GROUP_ORDER, idPropuesta);
        return lista.isEmpty() ? null : lista.get(0);
    }

    private List<Propuesta> consultar(String sql, Object... parametros) throws SQLException {
        List<Propuesta> lista = new ArrayList<>();
        try (Connection conn = Conexion.obtener(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (int i = 0; i < parametros.length; i++) {
                stmt.setObject(i + 1, parametros[i]);
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Propuesta p = new Propuesta(rs.getInt("idpropuesta"), rs.getString("titulo"), rs.getString("descripcion"), rs.getInt("idusuario"));
                    Date fecha = rs.getDate("fechacreacion");
                    if (fecha != null) {
                        p.setFechacreacion(fecha.toLocalDate());
                    }
                    p.setAutor(rs.getString("autor"));
                    p.setMeta(rs.getBigDecimal("meta"));
                    p.setRecaudado(rs.getBigDecimal("recaudado"));
                    p.setNumeroDonaciones(rs.getInt("numdonaciones"));
                    lista.add(p);
                }
            }
        }
        return lista;
    }
}
