package servicio;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import java.math.BigDecimal;
import java.util.List;
import modelo.Donacion;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.junit.jupiter.params.provider.ValueSource;

class DonacionServicioTest {

    @ParameterizedTest
    @CsvSource({
        "50000, 50000",
        "50.000, 50000",
        "'1,250,000', 1250000",
        "$ 20.000, 20000",
        "1.999, 1999",
        "50000.50, 50000.50",
        "'12,5', 12.5"
    })
    void leeMontosEnFormatoColombiano(String texto, String esperado) {
        assertEquals(0, new BigDecimal(esperado).compareTo(DonacionServicio.leerMonto(texto)));
    }

    @ParameterizedTest
    @ValueSource(strings = {"", "   ", "abc", "0", "-5", "12.3456", "200000000"})
    void rechazaMontosInvalidos(String texto) {
        assertThrows(IllegalArgumentException.class, () -> DonacionServicio.leerMonto(texto));
    }

    @Test
    void rechazaMontoNulo() {
        assertThrows(IllegalArgumentException.class, () -> DonacionServicio.leerMonto(null));
    }

    @Test
    void sumaElTotalDeDonaciones() {
        List<Donacion> donaciones = List.of(
                new Donacion(1, new BigDecimal("15000"), null, 1, 1),
                new Donacion(2, new BigDecimal("2500.50"), null, 1, 2));
        assertEquals(new BigDecimal("17500.50"), DonacionServicio.total(donaciones));
        assertEquals(BigDecimal.ZERO, DonacionServicio.total(List.of()));
    }
}
