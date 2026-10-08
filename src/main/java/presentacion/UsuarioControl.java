package presentacion;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import modelo.Donacion;
import modelo.Usuario;
import servicio.DonacionServicio;
import servicio.PropuestaServicio;
import servicio.UsuarioServicio;

/**
 * GET  accion=perfil | salir
 * POST accion=login | registrar | eliminar | salir
 */
@WebServlet("/UsuarioControl")
public class UsuarioControl extends ControlBase {

    private final UsuarioServicio us = new UsuarioServicio();
    private final PropuestaServicio ps = new PropuestaServicio();
    private final DonacionServicio ds = new DonacionServicio();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = String.valueOf(request.getParameter("accion"));
        if (accion.equals("salir")) {
            salir(request, response);
        } else if (accion.equals("perfil")) {
            perfil(request, response);
        } else {
            response.sendRedirect("PropuestaControl?accion=listar");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        switch (String.valueOf(request.getParameter("accion"))) {
            case "login":
                login(request, response);
                break;
            case "registrar":
                registrar(request, response);
                break;
            case "eliminar":
                eliminar(request, response);
                break;
            case "salir":
                salir(request, response);
                break;
            default:
                response.sendRedirect("PropuestaControl?accion=listar");
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try {
            Usuario usuario = us.iniciarSesion(request.getParameter("Correo"), request.getParameter("password"));
            if (usuario == null) {
                request.setAttribute("error", "Correo o contraseña incorrectos.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }
            // Sesión nueva al entrar para evitar fijación de sesión
            HttpSession anterior = request.getSession(false);
            if (anterior != null) {
                anterior.invalidate();
            }
            request.getSession(true).setAttribute(USUARIO_SESION, usuario);
            response.sendRedirect("PropuestaControl?accion=listar");
        } catch (SQLException e) {
            error(request, response, "No pudimos conectarnos con la base de datos. Intenta de nuevo en unos minutos.", e);
        }
    }

    private void registrar(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try {
            us.registrar(request.getParameter("nombre"), request.getParameter("cedula"), request.getParameter("email"),
                    request.getParameter("password1"), request.getParameter("password2"),
                    request.getParameter("telefono"), request.getParameter("fechaNacimiento"));
            response.sendRedirect("login.jsp?registro=exitoso");
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/registrar.jsp").forward(request, response);
        } catch (SQLException e) {
            error(request, response, "No pudimos crear tu cuenta. Intenta de nuevo en unos minutos.", e);
        }
    }

    private void perfil(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try {
            int id = usuarioActual(request).getId();
            Usuario usuario = us.buscarPorId(id);
            if (usuario == null) {
                salir(request, response);
                return;
            }
            List<Donacion> hechas = ds.hechasPor(id);
            request.setAttribute("perfil", usuario);
            request.setAttribute("numPropuestas", ps.listarDeUsuario(id).size());
            request.setAttribute("numDonaciones", hechas.size());
            request.setAttribute("totalDonado", DonacionServicio.total(hechas));
            request.setAttribute("totalRecibido", DonacionServicio.total(ds.recibidasPor(id)));
            vista(request, response, "perfil");
        } catch (SQLException e) {
            error(request, response, "No pudimos cargar tu perfil.", e);
        }
    }

    private void eliminar(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try {
            us.eliminar(usuarioActual(request).getId());
            request.getSession().invalidate();
            response.sendRedirect("login.jsp?eliminada=1");
        } catch (SQLException e) {
            error(request, response, "No pudimos eliminar tu cuenta.", e);
        }
    }

    private void salir(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession sesion = request.getSession(false);
        if (sesion != null) {
            sesion.invalidate();
        }
        response.sendRedirect("login.jsp");
    }
}
