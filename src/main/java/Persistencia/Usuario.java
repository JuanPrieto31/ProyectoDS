/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Persistencia;

import java.time.LocalDate;

/**
 *
 * @author juana
 */
public class Usuario {
   protected int id; 
    String nombre;
    String Correo;
    private String Contraseña;
    String telefono;
    private String rol;
    private int cedula;
    private LocalDate fechanacimiento; 

    public Usuario(int id, String nombre, String Correo, String Contraseña, String telefono, String rol, int cedula, LocalDate fechanacimiento) {
        this.id = id;
        this.nombre = nombre;
        this.Correo = Correo;
        this.Contraseña = Contraseña;
        this.telefono = telefono;
        this.rol = rol;
        this.cedula = cedula;
        this.fechanacimiento = fechanacimiento;
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
        return Correo;
    }

    public void setCorreo(String Correo) {
        this.Correo = Correo;
    }

    public String getContraseña() {
        return Contraseña;
    }

    public void setContraseña(String Contraseña) {
        this.Contraseña = Contraseña;
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

    public LocalDate getFechanacimiento() {
        return fechanacimiento;
    }

    public void setFechanacimiento(LocalDate fechanacimiento) {
        this.fechanacimiento = fechanacimiento;
    }
}
    