package servicio;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import modelo.Donacion;
import modelo.Propuesta;
import persistencia.DonacionRep;
import persistencia.PropuestaRep;

/**
 * Reglas de negocio del microservicio de donaciones.
 */
public class DonacionServicio {

    static final BigDecimal MONTO_MAXIMO = new BigDecimal("100000000");
    static final int MENSAJE_MAXIMO = 300;

    private final DonacionRep dr = new DonacionRep();
    private final PropuestaRep pr = new PropuestaRep();

    // Acepta "50000", "50.000", "50,000" o "50000.50". Lanza IllegalArgumentException con un mensaje para mostrar al usuario.
    public static BigDecimal leerMonto(String texto) {
        if (texto == null || texto.trim().isEmpty()) {
            throw new IllegalArgumentException("Escribe cuánto deseas donar.");
        }
        String limpio = texto.trim().replace("$", "").replace(" ", "");
        // Separadores de miles con punto o coma (formato colombiano): se quitan si dejan grupos de 3 dígitos
        if (limpio.matches("\\d{1,3}([.,]\\d{3})+")) {
            limpio = limpio.replaceAll("[.,]", "");
        } else {
            limpio = limpio.replace(",", ".");
        }
        BigDecimal monto;
        try {
            monto = new BigDecimal(limpio);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("El monto debe ser un número, por ejemplo 50000.");
        }
        if (monto.signum() <= 0) {
            throw new IllegalArgumentException("El monto debe ser mayor que cero.");
        }
        if (monto.scale() > 2) {
            throw new IllegalArgumentException("El monto puede tener como máximo dos decimales.");
        }
        if (monto.compareTo(MONTO_MAXIMO) > 0) {
            throw new IllegalArgumentException("El monto máximo por donación es $100.000.000.");
        }
        return monto;
    }

    public void donar(int idPropuesta, int idDonante, String montoTexto, String mensaje) throws SQLException {
        BigDecimal monto = leerMonto(montoTexto);

        Propuesta propuesta = pr.buscarPorId(idPropuesta);
        if (propuesta == null) {
            throw new IllegalArgumentException("Ese sueño ya no existe.");
        }
        if (propuesta.getIdUsuario() == idDonante) {
            throw new IllegalArgumentException("No puedes donar a tu propio sueño.");
        }

        String nota = mensaje == null ? "" : mensaje.trim();
        if (nota.length() > MENSAJE_MAXIMO) {
            nota = nota.substring(0, MENSAJE_MAXIMO);
        }
        dr.guardar(new Donacion(0, monto, nota.isEmpty() ? null : nota, idPropuesta, idDonante));
    }

    public List<Donacion> hechasPor(int idUsuario) throws SQLException {
        return dr.listarPorDonante(idUsuario);
    }

    public List<Donacion> recibidasPor(int idUsuario) throws SQLException {
        return dr.listarRecibidas(idUsuario);
    }

    public List<Donacion> dePropuesta(int idPropuesta) throws SQLException {
        return dr.listarPorPropuesta(idPropuesta);
    }

    public static BigDecimal total(List<Donacion> donaciones) {
        return donaciones.stream().map(Donacion::getMonto).reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public BigDecimal totalGeneral() throws SQLException {
        return dr.totalGeneral();
    }
}
