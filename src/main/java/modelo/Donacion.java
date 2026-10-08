package modelo;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Donacion {

    private int id;
    private BigDecimal monto;
    private String mensaje;
    private LocalDateTime fecha;
    private int idPropuesta;
    private int idUsuario;
    private String tituloPropuesta;
    private String nombreDonante;

    public Donacion(int id, BigDecimal monto, String mensaje, int idPropuesta, int idUsuario) {
        this.id = id;
        this.monto = monto;
        this.mensaje = mensaje;
        this.idPropuesta = idPropuesta;
        this.idUsuario = idUsuario;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public BigDecimal getMonto() {
        return monto;
    }

    public void setMonto(BigDecimal monto) {
        this.monto = monto;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public LocalDateTime getFecha() {
        return fecha;
    }

    public void setFecha(LocalDateTime fecha) {
        this.fecha = fecha;
    }

    public int getIdPropuesta() {
        return idPropuesta;
    }

    public void setIdPropuesta(int idPropuesta) {
        this.idPropuesta = idPropuesta;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getTituloPropuesta() {
        return tituloPropuesta;
    }

    public void setTituloPropuesta(String tituloPropuesta) {
        this.tituloPropuesta = tituloPropuesta;
    }

    public String getNombreDonante() {
        return nombreDonante;
    }

    public void setNombreDonante(String nombreDonante) {
        this.nombreDonante = nombreDonante;
    }
}
