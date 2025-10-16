package Servicio;

import Persistencia.Propuesta;
import Persistencia.PropuestaRep;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author juana
 */
public class PropuestaServicio {

    private PropuestaRep pr;

    public PropuestaServicio() {
        pr = new PropuestaRep();
    }

    public int obtenerId(String correo) throws SQLException {
        if (correo == null || correo.trim().isEmpty()) {
            throw new IllegalArgumentException("El correo no puede estar vacío");
        }
        return pr.buscarId(correo);
    }

    public void Crear(Propuesta propuesta) throws SQLException {
        System.out.println("[DEBUG] PropuestaServicio.registrar - Validando datos de la Propuesta");

        if (propuesta != null && propuesta.getTitulo() != null) {
            System.out.println("[DEBUG] Datos válidos, llamando a PropuestaRep.savePropuesta");
            pr.savePropuesta(propuesta);
            System.out.println("[DEBUG] Propuesta creada exitosamente en el servicio");
        } else {
            System.out.println("[ERROR] Datos de la propuesta inválidos");
            throw new IllegalArgumentException("Los datos de la propuesta no son válidos");
        }
    }

    public List<Propuesta> getAllPropuestas() {
        return pr.findAllPropuestas();
    }
}
