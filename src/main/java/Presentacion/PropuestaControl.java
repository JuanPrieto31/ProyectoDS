package Presentacion;

import Persistencia.Propuesta;
import Servicio.PropuestaServicio;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet("/PropuestaControl")
public class PropuestaControl extends HttpServlet {

    private final PropuestaServicio ps = new PropuestaServicio();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        System.out.println("[DEBUG] PropuestaControl - Acción recibida: " + accion);

        switch (accion) {
            case "crear":
                crearPropuesta(request, response);
                break;
            case "listar":
                listarPropuestas(request, response);
                break;
            default:
                System.out.println("[DEBUG] Acción desconocida: " + accion);
                response.sendRedirect("error.jsp");
                break;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    private void crearPropuesta(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        System.out.println("[DEBUG] PropuestaControl.crearPropuesta - Iniciando proceso");

        try {
            String correo = request.getParameter("correo");
            String titulo = request.getParameter("titulo");
            String contenido = request.getParameter("contenido");

            if (correo == null || correo.trim().isEmpty()
                    || titulo == null || titulo.trim().isEmpty()
                    || contenido == null || contenido.trim().isEmpty()) {
                System.out.println("[ERROR] Campos vacíos detectados");
                request.setAttribute("error", "Todos los campos son obligatorios");
                request.getRequestDispatcher("CrearPropuesta.jsp").forward(request, response);
                return;
            }

            int idUsuario = ps.obtenerId(correo);
            if (idUsuario == 0) {
                System.out.println("[ERROR] Usuario no encontrado");
                request.setAttribute("error", "Usuario no encontrado");
                request.getRequestDispatcher("CrearPropuesta.jsp").forward(request, response);
                return;
            }

            Propuesta propuesta = new Propuesta(0, titulo, contenido, idUsuario);
            ps.Crear(propuesta);

            System.out.println("[DEBUG] Registro exitoso, redirigiendo a front.jsp");
            response.sendRedirect("PropuestaControl?accion=listar&correo=" + java.net.URLEncoder.encode(correo, "UTF-8"));

        } catch (SQLException e) {
            System.out.println("[ERROR] Error SQL: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al guardar en la base de datos.");
            request.getRequestDispatcher("CrearPropuesta.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("[ERROR] Error general: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error inesperado: " + e.getMessage());
            request.getRequestDispatcher("CrearPropuesta.jsp").forward(request, response);
        }
    }

    private void listarPropuestas(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        System.out.println("[DEBUG] PropuestaControl.listarPropuestas - Obteniendo lista de propuestas");

        try {
            String correo = request.getParameter("correo"); 
            System.out.println("[DEBUG] Correo recibido para listar propuestas: " + correo);

            List<Propuesta> propuestas = ps.getAllPropuestas();
            request.setAttribute("listaPropuestas", propuestas);
            request.setAttribute("correo", correo); 
            request.getRequestDispatcher("front.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println("[ERROR] Error al listar propuestas: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al listar propuestas.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}
