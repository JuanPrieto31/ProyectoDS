package modelo;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;

public class Propuesta {
    private int id;
    private String titulo;
    private String contenido;
    private LocalDate fechacreacion;
    private int idUsuario;
    private String autor;
    private BigDecimal meta = BigDecimal.ZERO;
    private BigDecimal recaudado = BigDecimal.ZERO;
    private int numeroDonaciones;

    public Propuesta(int id, String titulo, String contenido, int idUsuario) {
        this.id = id;
        this.titulo = titulo;
        this.contenido = contenido;
        this.idUsuario = idUsuario;
        this.fechacreacion = null;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getContenido() {
        return contenido;
    }

    public void setContenido(String contenido) {
        this.contenido = contenido;
    }

    public LocalDate getFechacreacion() {
        return fechacreacion;
    }

    public void setFechacreacion(LocalDate fechacreacion) {
        this.fechacreacion = fechacreacion;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getAutor() {
        return autor;
    }

    public void setAutor(String autor) {
        this.autor = autor;
    }

    public BigDecimal getMeta() {
        return meta;
    }

    public void setMeta(BigDecimal meta) {
        this.meta = meta == null ? BigDecimal.ZERO : meta;
    }

    public BigDecimal getRecaudado() {
        return recaudado;
    }

    public void setRecaudado(BigDecimal recaudado) {
        this.recaudado = recaudado == null ? BigDecimal.ZERO : recaudado;
    }

    public int getNumeroDonaciones() {
        return numeroDonaciones;
    }

    public void setNumeroDonaciones(int numeroDonaciones) {
        this.numeroDonaciones = numeroDonaciones;
    }

    // Porcentaje de la meta alcanzado (0 a 100). Sin meta definida devuelve 0.
    public int getPorcentaje() {
        if (meta.signum() <= 0) {
            return 0;
        }
        int pct = recaudado.multiply(BigDecimal.valueOf(100)).divide(meta, 0, RoundingMode.DOWN).intValue();
        return Math.min(pct, 100);
    }
}
