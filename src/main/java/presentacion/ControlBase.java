package presentacion;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import modelo.Usuario;

/**
 * Utilidades comunes a los controladores.
 */
abstract class ControlBase extends HttpServlet {

    static final String USUARIO_SESION = "usuario";

    static Usuario usuarioActual(HttpServletRequest request) {
        HttpSession sesion = request.getSession(false);
        return sesion == null ? null : (Usuario) sesion.getAttribute(USUARIO_SESION);
    }

    // Las vistas viven en WEB-INF/vistas para que solo se lleguen a ellas a través de un controlador
    void vista(HttpServletRequest request, HttpServletResponse response, String nombre)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/vistas/" + nombre + ".jsp").forward(request, response);
    }

    void error(HttpServletRequest request, HttpServletResponse response, String mensaje, Exception causa)
            throws ServletException, IOException {
        log(mensaje, causa);
        request.setAttribute("error", mensaje);
        request.getRequestDispatcher("/error.jsp").forward(request, response);
    }

    static int idParametro(HttpServletRequest request) {
        try {
            return Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            return 0;
        }
    }
}
