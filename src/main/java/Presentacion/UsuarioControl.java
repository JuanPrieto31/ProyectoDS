package Presentacion;

import Persistencia.Usuario;
import Servicio.UsuarioServicio;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.Period;
import java.sql.SQLException;

@WebServlet("/UsuarioControl")
public class UsuarioControl extends HttpServlet {

    private final UsuarioServicio us = new UsuarioServicio();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        System.out.println("[DEBUG] UsuarioControl - Acción recibida: " + accion);

        if (accion == null) {
            System.out.println("[DEBUG] Acción es null, redirigiendo a login.jsp");
            response.sendRedirect("login.jsp");
            return;
        }

        switch (accion) {
            case "login":
                loginUsuario(request, response);
                break;
            case "registrar":
                registrarUsuario(request, response);
                break;
            case "perfil":
                leerUsuario(request, response);
                break;
            case "eliminar":
                eliminarUsuario(request, response);
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

    private void loginUsuario(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String correo = request.getParameter("Correo");
        String contraseña = request.getParameter("password");

        System.out.println("[DEBUG] loginUsuario - Correo recibido: " + correo);
        System.out.println("[DEBUG] loginUsuario - Contraseña recibida: " + (contraseña != null ? "*" : "null"));

        if (correo == null || contraseña == null || correo.trim().isEmpty() || contraseña.trim().isEmpty()) {
            System.out.println("[ERROR] Correo o contraseña vacíos");
            request.setAttribute("error", "Por favor ingrese correo y contraseña");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        boolean valido = us.validarLogin(correo, contraseña);

        System.out.println("[DEBUG] Resultado de validación: " + valido);

        if (valido) {
            System.out.println("[DEBUG] Login exitoso, redirigiendo a front.jsp con correo");
            response.sendRedirect("PropuestaControl?accion=listar&correo=" + java.net.URLEncoder.encode(correo, "UTF-8"));
        } else {
            System.out.println("[DEBUG] Login fallido, volviendo a login.jsp con error");
            request.setAttribute("error", "Correo o contraseña incorrectos");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private void registrarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        System.out.println("[DEBUG] UsuarioControl.registrarUsuario - Iniciando proceso de registro");

        try {
            String nombre = request.getParameter("nombre");
            String cedula = request.getParameter("cedula");
            String email = request.getParameter("email");
            String contraseña1 = request.getParameter("password1");
            String contraseña2 = request.getParameter("password2");
            String fechaTexto = request.getParameter("fechaNacimiento");
            String telefono = request.getParameter("telefono");

            System.out.println("[DEBUG] Parámetros recibidos - Nombre: " + nombre + ", Email: " + email + ", Cédula: " + cedula);

            if (nombre == null || nombre.trim().isEmpty()
                    || cedula == null || cedula.trim().isEmpty()
                    || email == null || email.trim().isEmpty()
                    || contraseña1 == null || contraseña1.trim().isEmpty()
                    || contraseña2 == null || contraseña2.trim().isEmpty()
                    || fechaTexto == null || fechaTexto.trim().isEmpty()
                    || telefono == null || telefono.trim().isEmpty()) {

                System.out.println("[ERROR] Campos vacíos detectados");
                request.setAttribute("error", "Todos los campos son obligatorios");
                request.getRequestDispatcher("Registrar.jsp").forward(request, response);
                return;
            }

            if (!contraseña1.equals(contraseña2)) {
                System.out.println("[ERROR] Las contraseñas no coinciden");
                request.setAttribute("error", "Las contraseñas no coinciden");
                request.getRequestDispatcher("Registrar.jsp").forward(request, response);
                return;
            }

            LocalDate fechaNacimiento = LocalDate.parse(fechaTexto);
            int edad = Period.between(fechaNacimiento, LocalDate.now()).getYears();

            String rol = (edad >= 60) ? "Adulto Mayor" : "Donante";

            System.out.println("[DEBUG] Creando objeto Usuario con rol: " + rol);

            Usuario usuario = new Usuario(0, nombre, email, contraseña1, telefono, rol, Integer.parseInt(cedula), LocalDate.parse(fechaTexto));

            System.out.println("[DEBUG] Llamando a UsuarioServicio.registrar");
            us.registrar(usuario);

            System.out.println("[DEBUG] Registro exitoso, redirigiendo a login.jsp");
            response.sendRedirect("login.jsp?registro=exitoso");

        } catch (SQLException e) {
            System.out.println("[ERROR] Error de base de datos: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al guardar en la base de datos: " + e.getMessage());
            request.getRequestDispatcher("Registrar.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("[ERROR] Error general en registro: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error en el registro: " + e.getMessage());
            request.getRequestDispatcher("Registrar.jsp").forward(request, response);
        }

    }

    private void leerUsuario(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String correo = request.getParameter("correo");

        System.out.println("[DEBUG] leerUsuario - Correo recibido: " + correo);

        if (correo == null || correo.trim().isEmpty()) {
            System.out.println("[ERROR] Correo no proporcionado, redirigiendo a login.jsp");
            request.setAttribute("error", "Correo no proporcionado");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try {

            Usuario usuario = us.buscarUsuarioPorCorreo(correo);

            if (usuario == null) {
                System.out.println("[ERROR] Usuario no encontrado para el correo: " + correo);
                request.setAttribute("error", "Usuario no encontrado");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            System.out.println("[DEBUG] Usuario encontrado: " + usuario.getNombre());
            request.setAttribute("usuario", usuario);
            request.getRequestDispatcher("perfil.jsp").forward(request, response);

        } catch (SQLException e) {
            System.out.println("[ERROR] Error al consultar usuario: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al consultar el usuario: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private void eliminarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String correo = request.getParameter("correo");
        System.out.println("[DEBUG] eliminarUsuario - Correo recibido: " + correo);

        if (correo == null || correo.trim().isEmpty()) {
            request.setAttribute("error", "Correo no proporcionado");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try {
            boolean eliminado = us.eliminarPorCorreo(correo);

            if (eliminado) {
                System.out.println("[DEBUG] Usuario eliminado exitosamente");
                response.sendRedirect("login.jsp?mensaje="
                        + java.net.URLEncoder.encode("Cuenta eliminada correctamente", "UTF-8"));
            } else {
                System.out.println("[ERROR] No se encontró usuario con correo: " + correo);
                request.setAttribute("error", "No se encontró el usuario");
                request.getRequestDispatcher("perfil.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            System.out.println("[ERROR] Error al eliminar usuario: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al eliminar el usuario: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

}
