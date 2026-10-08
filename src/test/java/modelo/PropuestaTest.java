package modelo;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.math.BigDecimal;
import org.junit.jupiter.api.Test;

class PropuestaTest {

    private static Propuesta con(String meta, String recaudado) {
        Propuesta p = new Propuesta(1, "Título", "Texto", 1);
        p.setMeta(new BigDecimal(meta));
        p.setRecaudado(new BigDecimal(recaudado));
        return p;
    }

    @Test
    void calculaElPorcentajeRedondeandoHaciaAbajo() {
        assertEquals(13, con("900000", "120000").getPorcentaje());
    }

    @Test
    void nuncaPasaDeCien() {
        assertEquals(100, con("100000", "250000").getPorcentaje());
    }

    @Test
    void sinMetaEsCero() {
        assertEquals(0, con("0", "50000").getPorcentaje());
    }
}
