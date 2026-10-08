package servicio;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.time.LocalDate;
import modelo.Usuario;
import org.junit.jupiter.api.Test;

class UsuarioServicioTest {

    private static final LocalDate HOY = LocalDate.of(2025, 10, 7);

    @Test
    void sesentaAniosCumplidosEsAdultoMayor() {
        assertEquals(Usuario.ROL_ADULTO_MAYOR, UsuarioServicio.rolPorEdad(LocalDate.of(1965, 10, 7), HOY));
    }

    @Test
    void unDiaAntesDeCumplirSesentaEsDonante() {
        assertEquals(Usuario.ROL_DONANTE, UsuarioServicio.rolPorEdad(LocalDate.of(1965, 10, 8), HOY));
    }
}
