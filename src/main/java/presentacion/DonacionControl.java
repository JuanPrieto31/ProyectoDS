package presentacion;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import modelo.Donacion;
import modelo.Propuesta;
import servicio.DonacionServicio;
import servicio.PropuestaServicio;

/**
 * Microservicio de donaciones.
 *
 * GET  accion=ver&id=N              -> detalle del sueño + formulario para donar
 * GET  accion=mis                   -> donaciones hechas y recibidas
 * POST accion=donar&id=N            -> registra la donación (monto, mensaje)
 */
@WebServlet("/DonacionControl")
public class DonacionControl extends ControlBase {

    private final DonacionServicio ds = new DonacionServicio();
    private final PropuestaServicio ps = new PropuestaServicio();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if ("mis".equals(request.getParameter("accion"))) {
                misDonaciones(request, response);
            } else {
                verPropuesta(request, response);
            }
        } catch (SQLException e) {
            error(request, response, "No pudimos consultar las donaciones. Intenta de nuevo en unos minutos.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!"donar".equals(request.getParameter("accion"))) {
            response.sendRedirect("PropuestaControl?accion=listar");
            return;
        }
        int id = idParametro(request);
        try {
            try {
                ds.donar(id, usuarioActual(request).getId(), request.getParameter("monto"), request.getParameter("mensaje"));
                // Redirección tras POST para que recargar la página no repita la donación
                response.sendRedirect("DonacionControl?accion=ver&ok=1&id=" + id);
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", e.getMessage());
                verPropuesta(request, response);
            }
        } catch (SQLException e) {
            error(request, response, "No pudimos guardar tu donación. Intenta de nuevo.", e);
        }
    }

    private void verPropuesta(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        Propuesta propuesta = ps.buscar(idParametro(request));
        if (propuesta == null) {
            error(request, response, "Ese sueño no existe o fue eliminado.", null);
            return;
        }
        request.setAttribute("propuesta", propuesta);
        request.setAttribute("donaciones", ds.dePropuesta(propuesta.getId()));
        vista(request, response, "sueno");
    }

    private void misDonaciones(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int id = usuarioActual(request).getId();
        List<Donacion> hechas = ds.hechasPor(id);
        List<Donacion> recibidas = ds.recibidasPor(id);

        request.setAttribute("hechas", hechas);
        request.setAttribute("recibidas", recibidas);
        request.setAttribute("totalHechas", DonacionServicio.total(hechas));
        request.setAttribute("totalRecibidas", DonacionServicio.total(recibidas));
        vista(request, response, "mis-donaciones");
    }
}
