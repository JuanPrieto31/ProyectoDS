package presentacion;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Set;

/**
 * Pone UTF-8 en todas las peticiones y exige sesión iniciada en los controladores,
 * salvo para entrar, registrarse y salir.
 */
@WebFilter(urlPatterns = {"/PropuestaControl", "/DonacionControl", "/UsuarioControl"})
public class SesionFiltro extends HttpFilter {

    private static final Set<String> ACCIONES_PUBLICAS = Set.of("login", "registrar", "salir");

    @Override
    protected void doFilter(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        // Debe ir antes de leer cualquier parámetro
        request.setCharacterEncoding("UTF-8");

        boolean publica = request.getServletPath().equals("/UsuarioControl")
                && ACCIONES_PUBLICAS.contains(request.getParameter("accion"));

        if (!publica && ControlBase.usuarioActual(request) == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        chain.doFilter(request, response);
    }
}
