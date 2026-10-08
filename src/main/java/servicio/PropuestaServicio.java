package servicio;

import java.sql.SQLException;
import java.util.List;
import modelo.Propuesta;
import modelo.Usuario;
import persistencia.PropuestaRep;

/**
 * Reglas de negocio de los sueños (propuestas).
 *
 * @author juana
 */
public class PropuestaServicio {

    private final PropuestaRep pr = new PropuestaRep();

    public void publicar(Usuario autor, String titulo, String contenido, String metaTexto) throws SQLException {
        if (!autor.esAdultoMayor()) {
            throw new IllegalArgumentException("Solo las personas de 60 años o más pueden publicar sueños.");
        }
        if (titulo == null || titulo.trim().isEmpty() || contenido == null || contenido.trim().isEmpty()) {
            throw new IllegalArgumentException("Escribe un título y cuéntanos tu sueño.");
        }
        if (titulo.trim().length() > 120) {
            throw new IllegalArgumentException("El título puede tener máximo 120 caracteres.");
        }

        Propuesta propuesta = new Propuesta(0, titulo.trim(), contenido.trim(), autor.getId());
        if (metaTexto != null && !metaTexto.trim().isEmpty()) {
            try {
                propuesta.setMeta(DonacionServicio.leerMonto(metaTexto));
            } catch (IllegalArgumentException e) {
                throw new IllegalArgumentException("La meta debe ser un número mayor que cero, por ejemplo 500000.");
            }
        }
        pr.guardar(propuesta);
    }

    public List<Propuesta> listarTodas() throws SQLException {
        return pr.listarTodas();
    }

    public List<Propuesta> listarDeUsuario(int idUsuario) throws SQLException {
        return pr.listarPorUsuario(idUsuario);
    }

    public Propuesta buscar(int idPropuesta) throws SQLException {
        return pr.buscarPorId(idPropuesta);
    }
}
