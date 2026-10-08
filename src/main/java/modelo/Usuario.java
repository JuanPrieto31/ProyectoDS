package modelo;

import java.io.Serializable;
import java.time.LocalDate;

/**
 *
 * @author juana
 */
public class Usuario implements Serializable {

    private static final long serialVersionUID = 1L;

    public static final String ROL_ADULTO_MAYOR = "Adulto Mayor";
    public static final String ROL_DONANTE = "Donante";

    private int id;
    private String nombre;
    private String correo;
    private String contrasena;
    private String telefono;
    private String rol;
    private int cedula;
    private LocalDate fechaNacimiento;

    public Usuario(int id, String nombre, String correo, String contrasena, String telefono, String rol, int cedula, LocalDate fechaNacimiento) {
        this.id = id;
        this.nombre = nombre;
        this.correo = correo;
        this.contrasena = contrasena;
        this.telefono = telefono;
        this.rol = rol;
        this.cedula = cedula;
        this.fechaNacimiento = fechaNacimiento;
    }

    public boolean esAdultoMayor() {
        return ROL_ADULTO_MAYOR.equals(rol);
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getContrasena() {
        return contrasena;
    }

    public void setContrasena(String contrasena) {
        this.contrasena = contrasena;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }

    public int getCedula() {
        return cedula;
    }

    public void setCedula(int cedula) {
        this.cedula = cedula;
    }

    public LocalDate getFechaNacimiento() {
        return fechaNacimiento;
    }

    public void setFechaNacimiento(LocalDate fechaNacimiento) {
        this.fechaNacimiento = fechaNacimiento;
    }
}
