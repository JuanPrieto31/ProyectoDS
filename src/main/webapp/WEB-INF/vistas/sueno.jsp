<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Propuesta" %>
<%@ page import="modelo.Donacion" %>
<%@ page import="presentacion.Html" %>
<%
    Propuesta p = (Propuesta) request.getAttribute("propuesta");
    List<Donacion> donaciones = (List<Donacion>) request.getAttribute("donaciones");
    String error = (String) request.getAttribute("error");
    boolean ok = "1".equals(request.getParameter("ok"));
    boolean conMeta = p.getMeta().signum() > 0;
    String autor = p.getAutor() == null ? "Anónimo" : p.getAutor();
    boolean propio = p.getIdUsuario() == ((modelo.Usuario) session.getAttribute("usuario")).getId();
    String activo = propio ? "mias" : "inicio";
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <%@ include file="fragmentos/head.jspf" %>
        <title><%= Html.esc(p.getTitulo())%> · Sueños de Plata</title>
    </head>
    <body>
        <div class="app">
            <%@ include file="fragmentos/menu.jspf" %>

            <main class="contenido" id="contenido">
                <a class="miga" href="PropuestaControl?accion=listar<%= propio ? "&filtro=mias" : ""%>">
                    <i class="fas fa-arrow-left" aria-hidden="true"></i> Volver a <%= propio ? "mis sueños" : "todos los sueños"%>
                </a>

                <% if (ok) {%>
                <div class="aviso exito" role="status">
                    <i class="fas fa-heart" aria-hidden="true"></i>
                    <span>Gracias. Tu donación quedó registrada y ya suma al sueño de <%= Html.esc(autor)%>.</span>
                </div>
                <% }%>

                <div class="dos-columnas">
                    <div>
                        <article class="panel">
                            <div class="sueno-meta" style="margin-bottom: 1.25rem;">
                                <span class="avatar" aria-hidden="true" style="width:48px;height:48px;"><%= Html.esc(autor.substring(0, 1).toUpperCase())%></span>
                                <div>
                                    <strong><%= propio ? "Tu sueño" : "El sueño de " + Html.esc(autor)%></strong>
                                    Publicado el <%= Html.fecha(p.getFechacreacion())%>
                                </div>
                            </div>
                            <h1 style="font-size: clamp(1.6rem, 3vw, 2.2rem); margin-bottom: 1.25rem;"><%= Html.esc(p.getTitulo())%></h1>

                            <div class="progreso" style="margin-bottom: 1.75rem;">
                                <div class="progreso-cifras">
                                    <strong class="monto-principal <%= Html.claseMonto(p.getRecaudado())%>"><%= Html.dinero(p.getRecaudado())%></strong>
                                    <span>
                                        <%= conMeta ? "recaudados de " + Html.dinero(p.getMeta()) + " (" + p.getPorcentaje() + "%)" : "recaudados"%>
                                        · <%= p.getNumeroDonaciones()%> <%= p.getNumeroDonaciones() == 1 ? "donación" : "donaciones"%>
                                    </span>
                                </div>
                                <% if (conMeta) {%>
                                <div class="barra" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="<%= p.getPorcentaje()%>" aria-label="Avance de la meta">
                                    <span style="width: <%= p.getPorcentaje()%>%"></span>
                                </div>
                                <% }%>
                            </div>

                            <p class="texto-largo"><%= Html.esc(p.getContenido())%></p>
                        </article>

                        <section class="panel" aria-labelledby="titulo-donantes">
                            <h2 id="titulo-donantes">Quienes han apoyado este sueño</h2>
                            <% if (!donaciones.isEmpty()) {%>
                            <ul class="donantes">
                                <% for (Donacion d : donaciones) {
                                        String donante = d.getNombreDonante() == null ? "Anónimo" : d.getNombreDonante();
                                %>
                                <li>
                                    <span class="avatar" aria-hidden="true"><%= Html.esc(donante.substring(0, 1).toUpperCase())%></span>
                                    <div>
                                        <strong><%= Html.esc(donante)%></strong> donó <strong class="num"><%= Html.dinero(d.getMonto())%></strong>
                                        <div style="color: var(--ink-soft); font-size: .9rem;"><%= Html.fecha(d.getFecha())%></div>
                                        <% if (d.getMensaje() != null) {%>
                                        <p class="nota">“<%= Html.esc(d.getMensaje())%>”</p>
                                        <% }%>
                                    </div>
                                </li>
                                <% }%>
                            </ul>
                            <% } else {%>
                            <p style="color: var(--ink-soft);">Todavía nadie ha donado. <%= propio ? "Comparte tu sueño con tu familia y amigos." : "Puedes ser la primera persona en apoyarlo."%></p>
                            <% }%>
                        </section>
                    </div>

                    <aside>
                        <% if (propio) {%>
                        <div class="panel">
                            <h2>Este es tu sueño</h2>
                            <p style="color: var(--ink-soft); margin-bottom: 1.25rem;">
                                No puedes donarte a ti mismo, pero aquí verás cada aporte que recibas.
                            </p>
                            <a class="boton secundario ancho" href="DonacionControl?accion=mis">
                                <i class="fas fa-list" aria-hidden="true"></i> Ver todas mis donaciones
                            </a>
                        </div>
                        <% } else {%>
                        <form class="panel" action="DonacionControl" method="post" id="formDonar" novalidate>
                            <h2>Apoyar este sueño</h2>
                            <input type="hidden" name="accion" value="donar">
                            <input type="hidden" name="id" value="<%= p.getId()%>">

                            <% if (error != null) {%>
                            <div class="aviso error" role="alert">
                                <i class="fas fa-circle-exclamation" aria-hidden="true"></i>
                                <span><%= Html.esc(error)%></span>
                            </div>
                            <% }%>

                            <p style="font-weight: 700; margin-bottom: .6rem;">Elige un monto</p>
                            <div class="montos-rapidos">
                                <button type="button" data-monto="10000" aria-pressed="false">$ 10.000</button>
                                <button type="button" data-monto="20000" aria-pressed="false">$ 20.000</button>
                                <button type="button" data-monto="50000" aria-pressed="false">$ 50.000</button>
                                <button type="button" data-monto="100000" aria-pressed="false">$ 100.000</button>
                            </div>

                            <div class="campo">
                                <label for="monto">O escribe otro monto (en pesos)</label>
                                <div class="con-prefijo">
                                    <span aria-hidden="true">$</span>
                                    <input class="entrada" type="text" inputmode="numeric" id="monto" name="monto"
                                           placeholder="30000" autocomplete="off" required
                                           value="<%= Html.esc(request.getParameter("monto"))%>" aria-describedby="ayudaMonto">
                                </div>
                                <span class="ayuda" id="ayudaMonto">Escribe solo números, sin puntos. Ejemplo: 30000</span>
                            </div>

                            <div class="campo">
                                <label for="mensaje">Mensaje de ánimo <span style="font-weight:400; color: var(--ink-soft);">(opcional)</span></label>
                                <textarea class="entrada" id="mensaje" name="mensaje" maxlength="300" rows="3"
                                          style="min-height: 110px;" placeholder="Mucho éxito con tu sueño"><%= Html.esc(request.getParameter("mensaje"))%></textarea>
                            </div>

                            <div class="aviso error" role="alert" id="errorMonto" hidden>
                                <i class="fas fa-circle-exclamation" aria-hidden="true"></i>
                                <span>Escribe un monto mayor que cero.</span>
                            </div>

                            <button type="submit" class="boton ancho">
                                <i class="fas fa-hand-holding-heart" aria-hidden="true"></i> Donar ahora
                            </button>
                            <p style="color: var(--ink-soft); font-size: .85rem; margin-top: 1rem;">
                                Proyecto académico: la donación se registra en el sistema, no se cobra dinero real.
                            </p>
                        </form>
                        <% }%>
                    </aside>
                </div>
            </main>
        </div>

        <% if (!propio) {%>
        <script>
            (function () {
                var monto = document.getElementById("monto");
                var botones = document.querySelectorAll("[data-monto]");
                var error = document.getElementById("errorMonto");

                function marcar() {
                    botones.forEach(function (b) {
                        b.setAttribute("aria-pressed", b.dataset.monto === monto.value ? "true" : "false");
                    });
                }
                botones.forEach(function (b) {
                    b.addEventListener("click", function () {
                        monto.value = b.dataset.monto;
                        error.hidden = true;
                        marcar();
                    });
                });
                monto.addEventListener("input", function () {
                    monto.value = monto.value.replace(/[^0-9]/g, "");
                    error.hidden = true;
                    marcar();
                });
                document.getElementById("formDonar").addEventListener("submit", function (e) {
                    if (!monto.value || Number(monto.value) <= 0) {
                        e.preventDefault();
                        error.hidden = false;
                        monto.focus();
                    }
                });
                marcar();
            })();
        </script>
        <% }%>
    </body>
</html>
