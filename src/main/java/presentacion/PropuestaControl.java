package presentacion;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import modelo.Propuesta;
import modelo.Usuario;
import servicio.DonacionServicio;
import servicio.PropuestaServicio;

/**
 * GET  accion=listar [filtro=mias]  -> panel de sueños
 * GET  accion=nuevo                 -> formulario para publicar
 * POST accion=crear                 -> publica el sueño
 */
@WebServlet("/PropuestaControl")
public class PropuestaControl extends ControlBase {

    private final PropuestaServicio ps = new PropuestaServicio();
    private final DonacionServicio ds = new DonacionServicio();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("nuevo".equals(request.getParameter("accion"))) {
            vista(request, response, "crear-sueno");
        } else {
            listar(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("crear".equals(request.getParameter("accion"))) {
            crear(request, response);
        } else {
            response.sendRedirect("PropuestaControl?accion=listar");
        }
    }

    private void crear(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try {
            ps.publicar(usuarioActual(request), request.getParameter("titulo"),
                    request.getParameter("contenido"), request.getParameter("meta"));
            response.sendRedirect("PropuestaControl?accion=listar&filtro=mias&publicado=1");
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            vista(request, response, "crear-sueno");
        } catch (SQLException e) {
            error(request, response, "No pudimos guardar tu sueño. Intenta de nuevo.", e);
        }
    }

    private void listar(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try {
            Usuario usuario = usuarioActual(request);
            boolean soloMias = "mias".equals(request.getParameter("filtro"));
            List<Propuesta> propuestas = soloMias ? ps.listarDeUsuario(usuario.getId()) : ps.listarTodas();

            request.setAttribute("listaPropuestas", propuestas);
            request.setAttribute("soloMias", soloMias);
            request.setAttribute("totalRecaudado", ds.totalGeneral());
            vista(request, response, "inicio");
        } catch (SQLException e) {
            error(request, response, "No pudimos cargar los sueños. Revisa la conexión a la base de datos.", e);
        }
    }
}
