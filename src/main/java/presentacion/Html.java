package presentacion;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

/**
 * Utilidades de presentación para los JSP (Tomcat no trae JSTL).
 */
public final class Html {

    private static final Locale CO = new Locale("es", "CO");
    private static final BigDecimal UN_MILLON = new BigDecimal("1000000");
    private static final DateTimeFormatter FECHA = DateTimeFormatter.ofPattern("d 'de' MMMM 'de' yyyy", CO);

    private Html() {
    }

    // Escapa texto para mostrarlo dentro de HTML o de un atributo
    public static String esc(Object valor) {
        if (valor == null) {
            return "";
        }
        String s = valor.toString();
        StringBuilder sb = new StringBuilder(s.length());
        for (char c : s.toCharArray()) {
            switch (c) {
                case '<': sb.append("&lt;"); break;
                case '>': sb.append("&gt;"); break;
                case '&': sb.append("&amp;"); break;
                case '"': sb.append("&quot;"); break;
                case '\'': sb.append("&#39;"); break;
                default: sb.append(c);
            }
        }
        return sb.toString();
    }

    // $ 1.250.000
    public static String dinero(BigDecimal valor) {
        NumberFormat nf = NumberFormat.getNumberInstance(CO);
        nf.setMaximumFractionDigits(valor != null && valor.stripTrailingZeros().scale() > 0 ? 2 : 0);
        return "$ " + nf.format(valor == null ? BigDecimal.ZERO : valor);
    }

    // Clase CSS que achica la letra de los montos de 7 dígitos o más (desde $ 1.000.000)
    public static String claseMonto(BigDecimal valor) {
        return valor != null && valor.abs().compareTo(UN_MILLON) >= 0 ? "monto-largo" : "";
    }

    public static String fecha(LocalDate fecha) {
        return fecha == null ? "Sin fecha" : fecha.format(FECHA);
    }

    public static String fecha(LocalDateTime fecha) {
        return fecha == null ? "Sin fecha" : fecha.toLocalDate().format(FECHA);
    }
}
