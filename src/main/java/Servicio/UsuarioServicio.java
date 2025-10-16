package Servicio;

import Persistencia.Usuario;
import Persistencia.UsuarioRep;
import java.sql.SQLException;

public class UsuarioServicio {

    private UsuarioRep ur;

    public UsuarioServicio() {
        ur = new UsuarioRep();
    }

    public void registrar(Usuario usuario) throws SQLException {
        System.out.println("[DEBUG] UsuarioServicio.registrar - Validando datos del usuario");

        if (usuario != null && usuario.getNombre() != null) {
            System.out.println("[DEBUG] Datos válidos, llamando a UsuarioRep.saveUsuario");
            ur.saveUsuario(usuario);
            System.out.println("[DEBUG] Usuario registrado exitosamente en el servicio");
        } else {
            System.out.println("[ERROR] Datos de usuario inválidos");
            throw new IllegalArgumentException("Usuario data is invalid");
        }
    }

    public boolean validarLogin(String correo, String contraseña) {
        if (correo == null || correo.isEmpty() || contraseña == null || contraseña.isEmpty()) {
            System.out.println("[DEBUG] validarLogin - Correo o contraseña vacíos");
            return false;
        }
        System.out.println("[DEBUG] validarLogin - Verificando credenciales para: " + correo);
        return ur.verificarLogin(correo, contraseña);
    }

    public Usuario buscarUsuarioPorCorreo(String correo) throws SQLException {
        if (correo == null || correo.trim().isEmpty()) {
            System.out.println("[ERROR] buscarUsuarioPorCorreo - Correo inválido");
            throw new IllegalArgumentException("Correo no puede ser nulo o vacío");
        }

        System.out.println("[DEBUG] buscarUsuarioPorCorreo - Buscando usuario: " + correo);
        Usuario usuario = ur.buscarUsuarioPorCorreo(correo);

        if (usuario != null) {
            System.out.println("[DEBUG] Usuario encontrado: " + usuario.getNombre());
        } else {
            System.out.println("[DEBUG] No se encontró usuario con correo: " + correo);
        }
        return usuario;
    }

    public boolean eliminarPorCorreo(String correo) throws SQLException {
        if (correo == null || correo.trim().isEmpty()) {
            System.out.println("[ERROR] eliminarPorCorreo - Correo inválido");
            throw new IllegalArgumentException("Correo no puede ser nulo o vacío");
        }

        System.out.println("[DEBUG] eliminando usuario con correo: " + correo);
        return ur.eliminarPorCorreo(correo);
    }

}
