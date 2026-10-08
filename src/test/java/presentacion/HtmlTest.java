package presentacion;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.math.BigDecimal;
import org.junit.jupiter.api.Test;

class HtmlTest {

    @Test
    void escapaCaracteresPeligrosos() {
        assertEquals("&lt;script&gt;alert(&quot;x&quot;)&lt;/script&gt; &amp; &#39;",
                Html.esc("<script>alert(\"x\")</script> & '"));
        assertEquals("", Html.esc(null));
    }

    @Test
    void formateaPesosColombianos() {
        assertEquals("$ 1.250.000", Html.dinero(new BigDecimal("1250000")));
        assertEquals("$ 1.250.000", Html.dinero(new BigDecimal("1250000.00")));
        assertEquals("$ 20,5", Html.dinero(new BigDecimal("20.5")));
        assertEquals("$ 0", Html.dinero(null));
    }

    @Test
    void achicaLaLetraDesdeSieteDigitos() {
        assertEquals("", Html.claseMonto(new BigDecimal("999999")));
        assertEquals("monto-largo", Html.claseMonto(new BigDecimal("1000000")));
        assertEquals("monto-largo", Html.claseMonto(new BigDecimal("18135000")));
        assertEquals("", Html.claseMonto(null));
    }
}
