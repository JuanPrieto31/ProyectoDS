<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="modelo.Propuesta" %>
<%@ page import="presentacion.Html" %>
<%
    List<Propuesta> lista = (List<Propuesta>) request.getAttribute("listaPropuestas");
    boolean soloMias = Boolean.TRUE.equals(request.getAttribute("soloMias"));
    BigDecimal totalRecaudado = (BigDecimal) request.getAttribute("totalRecaudado");
    String activo = soloMias ? "mias" : "inicio";

    BigDecimal recaudadoLista = BigDecimal.ZERO;
    int logrados = 0;
    int donacionesLista = 0;
    for (Propuesta p : lista) {
        recaudadoLista = recaudadoLista.add(p.getRecaudado());
        donacionesLista += p.getNumeroDonaciones();
        if (p.getMeta().signum() > 0 && p.getRecaudado().compareTo(p.getMeta()) >= 0) {
            logrados++;
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <%@ include file="fragmentos/head.jspf" %>
        <title><%= soloMias ? "Mis sueños" : "Inicio"%> · Sueños de Plata</title>
    </head>
    <body>
        <div class="app">
            <%@ include file="fragmentos/menu.jspf" %>

            <main class="contenido" id="contenido">
                <header class="encabezado">
                    <div>
                        <h1><%= soloMias ? "Mis sueños" : "Hola, " + Html.esc(usuario.getNombre().trim().split("\\s+")[0])%></h1>
                        <p>
                            <%= soloMias
                                    ? "Aquí ves los sueños que has publicado y cuánto has recibido en cada uno."
                                    : "Estos son los sueños que adultos mayores de nuestra comunidad quieren cumplir. Elige uno para conocerlo y apoyarlo."%>
                        </p>
                    </div>
                    <% if (usuario.esAdultoMayor()) {%>
                    <a class="boton" href="PropuestaControl?accion=nuevo">
                        <i class="fas fa-circle-plus" aria-hidden="true"></i> Publicar un sueño
                    </a>
                    <% }%>
                </header>

                <% if ("1".equals(request.getParameter("publicado"))) {%>
                <div class="aviso exito" role="status">
                    <i class="fas fa-circle-check" aria-hidden="true"></i>
                    <span>Tu sueño quedó publicado. Ya puede recibir donaciones.</span>
                </div>
                <% }%>

                <section class="cifras" aria-label="Resumen">
                    <article class="cifra destacada">
                        <span class="cifra-icono" aria-hidden="true"><i class="fas fa-hand-holding-dollar"></i></span>
                        <div>
                            <div class="cifra-etiqueta"><%= soloMias ? "Has recibido" : "Recaudado entre todos"%></div>
                            <div class="cifra-valor <%= Html.claseMonto(soloMias ? recaudadoLista : totalRecaudado)%>"><%= Html.dinero(soloMias ? recaudadoLista : totalRecaudado)%></div>
                        </div>
                    </article>
                    <article class="cifra">
                        <span class="cifra-icono" aria-hidden="true"><i class="fas fa-star"></i></span>
                        <div>
                            <div class="cifra-etiqueta"><%= soloMias ? "Sueños publicados" : "Sueños activos"%></div>
                            <div class="cifra-valor"><%= lista.size()%></div>
                        </div>
                    </article>
                    <article class="cifra">
                        <span class="cifra-icono" aria-hidden="true"><i class="fas fa-heart"></i></span>
                        <div>
                            <div class="cifra-etiqueta">Donaciones recibidas</div>
                            <div class="cifra-valor"><%= donacionesLista%></div>
                        </div>
                    </article>
                    <article class="cifra">
                        <span class="cifra-icono" aria-hidden="true"><i class="fas fa-flag-checkered"></i></span>
                        <div>
                            <div class="cifra-etiqueta">Metas cumplidas</div>
                            <div class="cifra-valor"><%= logrados%></div>
                        </div>
                    </article>
                </section>

                <section aria-labelledby="titulo-lista">
                    <div class="seccion-titulo">
                        <h2 id="titulo-lista"><%= soloMias ? "Tus publicaciones" : "Sueños por cumplir"%></h2>
                        <% if (!lista.isEmpty()) {%>
                        <span><%= lista.size()%> <%= lista.size() == 1 ? "sueño" : "sueños"%></span>
                        <% }%>
                    </div>

                    <% if (!lista.isEmpty()) {%>
                    <div class="suenos">
                        <% for (Propuesta p : lista) {
                                boolean propio = p.getIdUsuario() == usuario.getId();
                                boolean conMeta = p.getMeta().signum() > 0;
                                boolean lograda = conMeta && p.getRecaudado().compareTo(p.getMeta()) >= 0;
                                String autor = p.getAutor() == null ? "Anónimo" : p.getAutor();
                        %>
                        <article class="sueno">
                            <div class="sueno-meta">
                                <span class="avatar" aria-hidden="true"><%= Html.esc(autor.substring(0, 1).toUpperCase())%></span>
                                <div>
                                    <strong><%= propio ? "Tú" : Html.esc(autor)%></strong>
                                    Publicado el <%= Html.fecha(p.getFechacreacion())%>
                                </div>
                            </div>

                            <% if (lograda) {%>
                            <span class="etiqueta lograda"><i class="fas fa-circle-check" aria-hidden="true"></i> Meta cumplida</span>
                            <% } else if (p.getNumeroDonaciones() == 0) {%>
                            <span class="etiqueta"><i class="fas fa-seedling" aria-hidden="true"></i> Esperando su primera donación</span>
                            <% }%>

                            <h3><%= Html.esc(p.getTitulo())%></h3>
                            <p class="sueno-texto"><%= Html.esc(p.getContenido())%></p>

                            <div class="progreso">
                                <div class="progreso-cifras">
                                    <strong class="<%= Html.claseMonto(p.getRecaudado())%>"><%= Html.dinero(p.getRecaudado())%></strong>
                                    <span><%= conMeta ? "de " + Html.dinero(p.getMeta()) + " · " + p.getPorcentaje() + "%" : p.getNumeroDonaciones() + (p.getNumeroDonaciones() == 1 ? " donación" : " donaciones")%></span>
                                </div>
                                <% if (conMeta) {%>
                                <div class="barra" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="<%= p.getPorcentaje()%>" aria-label="Avance de la meta">
                                    <span style="width: <%= p.getPorcentaje()%>%"></span>
                                </div>
                                <% }%>
                            </div>

                            <a class="boton <%= propio ? "secundario" : ""%>" href="DonacionControl?accion=ver&id=<%= p.getId()%>">
                                <% if (propio) {%>
                                <i class="fas fa-eye" aria-hidden="true"></i> Ver mi sueño
                                <% } else {%>
                                <i class="fas fa-hand-holding-heart" aria-hidden="true"></i> Conocer y donar
                                <% }%>
                            </a>
                        </article>
                        <% }%>
                    </div>
                    <% } else {%>
                    <div class="vacio">
                        <i class="fas fa-star" aria-hidden="true"></i>
                        <h3><%= soloMias ? "Todavía no has publicado ningún sueño" : "Aún no hay sueños publicados"%></h3>
                        <% if (usuario.esAdultoMayor()) {%>
                        <p>Cuéntanos qué te gustaría cumplir: un viaje, un curso, una visita a tu familia. La comunidad puede ayudarte.</p>
                        <a class="boton" href="PropuestaControl?accion=nuevo">
                            <i class="fas fa-circle-plus" aria-hidden="true"></i> Publicar mi primer sueño
                        </a>
                        <% } else {%>
                        <p>Cuando los adultos mayores publiquen sus sueños, aparecerán aquí para que puedas apoyarlos.</p>
                        <% }%>
                    </div>
                    <% }%>
                </section>

                <footer class="pie-pagina">© 2025 Sueños de Plata · Proyecto académico</footer>
            </main>
        </div>
    </body>
</html>
