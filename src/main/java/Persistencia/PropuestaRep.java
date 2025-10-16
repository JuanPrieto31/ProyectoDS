/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Persistencia;

import Accesodatos.datos;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

/**
 *
 * @author juana
 */
public class PropuestaRep {

    static final String URL = "jdbc:postgresql://localhost:5432/ProyectoDS";
    private static final String USER = "postgres";
    private static final String PASSWORD = "123456";

    public int buscarId(String correo) throws SQLException {
        System.out.println("[DEBUG] PropuestaRep.buscarId - Buscando ID de usuario por correo: " + correo);

        String sql = "SELECT idusuario FROM usuario WHERE correo = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("org.postgresql.Driver");
            System.out.println("[DEBUG] Driver PostgreSQL cargado correctamente");

            datos conbd = new datos(URL, USER, PASSWORD);
            conn = conbd.getConn();

            if (conn == null) {
                throw new SQLException("No se pudo establecer conexión a la base de datos");
            }

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, correo);
            rs = stmt.executeQuery();

            if (rs.next()) {
                int id = rs.getInt("idusuario");
                System.out.println("[DEBUG] ID encontrado: " + id);
                return id;
            } else {
                System.out.println("[WARN] No se encontró usuario con el correo: " + correo);
                return 0;
            }

        } catch (ClassNotFoundException e) {
            System.out.println("[ERROR] Driver PostgreSQL no encontrado: " + e.getMessage());
            e.printStackTrace();
            throw new SQLException("Driver PostgreSQL no encontrado", e);
        } catch (SQLException e) {
            System.out.println("[ERROR] Error SQL en buscarId: " + e.getMessage());
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
                System.out.println("[DEBUG] Conexión cerrada correctamente");
            } catch (SQLException e) {
                System.out.println("[ERROR] Error al cerrar conexión: " + e.getMessage());
            }
        }
    }

    public void savePropuesta(Propuesta propuesta) throws SQLException {
        System.out.println("[DEBUG] PropuestaRep.savePropuesta - Iniciando registro de Propuesta");
        System.out.println("[DEBUG] Datos de la propuesta - Título: " + propuesta.getTitulo());

        String sql = "INSERT INTO propuesta (titulo, descripcion, idusuario) VALUES (?, ?, ?)";
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
            stmt.setString(1, propuesta.getTitulo());
            stmt.setString(2, propuesta.getContenido());
            stmt.setInt(3, propuesta.getIdUsuario());

            System.out.println("[DEBUG] Ejecutando INSERT en la base de datos");
            int rowsAffected = stmt.executeUpdate();
            System.out.println("[DEBUG] Propuesta guardada exitosamente. Filas afectadas: " + rowsAffected);

        } catch (ClassNotFoundException e) {
            System.out.println("[ERROR] Driver PostgreSQL no encontrado: " + e.getMessage());
            throw new SQLException("Driver PostgreSQL no encontrado", e);
        } catch (SQLException e) {
            System.out.println("[ERROR] Error SQL al guardar propuesta: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            System.out.println("[ERROR] Error general al guardar propuesta: " + e.getMessage());
            throw new SQLException("Error al guardar propuesta", e);
        } finally {
            if (stmt != null) try {
                stmt.close();
            } catch (SQLException ignored) {
            }
            if (conn != null) try {
                conn.close();
            } catch (SQLException ignored) {
            }
            System.out.println("[DEBUG] Conexión cerrada correctamente");
        }
    }

   public List<Propuesta> findAllPropuestas() {
        List<Propuesta> lista = new LinkedList<>();
        String sql = "SELECT * FROM propuesta";

        try {
            datos conbd = new datos(URL, USER, PASSWORD);
            Connection conn = conbd.getConn();

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);

            while (rs.next()) {
                int idPropuesta = rs.getInt("idpropuesta");
                String titulo = rs.getString("titulo");
                String descripcion = rs.getString("descripcion");
                Date fechaCreacion = rs.getDate("fechacreacion");
                int idUsuario = rs.getInt("idusuario");

               Propuesta p = new Propuesta(idPropuesta, titulo, descripcion, idUsuario);
                lista.add(p);
            }

            rs.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("[ERROR] Error al listar propuestas: " + e.getMessage());
        }

        return lista;
    }
}
