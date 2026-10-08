package servicio;

import java.sql.SQLException;
import java.time.LocalDate;
import java.time.Period;
import java.time.format.DateTimeParseException;
import modelo.Usuario;
import persistencia.UsuarioRep;

/**
 * Reglas de negocio de usuarios. Los errores de validación se lanzan como
 * IllegalArgumentException con un mensaje listo para mostrar.
 */
public class UsuarioServicio {

    static final int EDAD_ADULTO_MAYOR = 60;

    private final UsuarioRep ur = new UsuarioRep();

    public static String rolPorEdad(LocalDate fechaNacimiento, LocalDate hoy) {
        return Period.between(fechaNacimiento, hoy).getYears() >= EDAD_ADULTO_MAYOR
                ? Usuario.ROL_ADULTO_MAYOR
                : Usuario.ROL_DONANTE;
    }

    public void registrar(String nombre, String cedula, String correo, String contrasena, String confirmacion,
            String telefono, String fechaTexto) throws SQLException {
        if (vacio(nombre) || vacio(cedula) || vacio(correo) || vacio(contrasena) || vacio(confirmacion)
                || vacio(telefono) || vacio(fechaTexto)) {
            throw new IllegalArgumentException("Todos los campos son obligatorios.");
        }
        if (contrasena.length() < 6) {
            throw new IllegalArgumentException("La contraseña debe tener al menos 6 caracteres.");
        }
        if (!contrasena.equals(confirmacion)) {
            throw new IllegalArgumentException("Las contraseñas no coinciden.");
        }

        int numeroCedula;
        try {
            numeroCedula = Integer.parseInt(cedula.trim());
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("La cédula debe tener solo números.");
        }

        LocalDate nacimiento;
        try {
            nacimiento = LocalDate.parse(fechaTexto);
        } catch (DateTimeParseException e) {
            throw new IllegalArgumentException("La fecha de nacimiento no es válida.");
        }
        LocalDate hoy = LocalDate.now();
        if (nacimiento.isAfter(hoy) || nacimiento.isBefore(hoy.minusYears(120))) {
            throw new IllegalArgumentException("La fecha de nacimiento no es válida.");
        }

        String correoLimpio = correo.trim().toLowerCase();
        if (ur.buscarPorCorreo(correoLimpio) != null) {
            throw new IllegalArgumentException("Ya existe una cuenta con ese correo.");
        }

        ur.guardar(new Usuario(0, nombre.trim(), correoLimpio, contrasena, telefono.trim(),
                rolPorEdad(nacimiento, hoy), numeroCedula, nacimiento));
    }

    // Devuelve el usuario autenticado o null si las credenciales no coinciden
    public Usuario iniciarSesion(String correo, String contrasena) throws SQLException {
        if (vacio(correo) || vacio(contrasena)) {
            return null;
        }
        return ur.buscarPorCredenciales(correo.trim(), contrasena);
    }

    public Usuario buscarPorId(int id) throws SQLException {
        return ur.buscarPorId(id);
    }

    public boolean eliminar(int id) throws SQLException {
        return ur.eliminar(id);
    }

    private static boolean vacio(String s) {
        return s == null || s.trim().isEmpty();
    }
}
