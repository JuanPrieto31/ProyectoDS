<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="modelo.Donacion" %>
<%@ page import="presentacion.Html" %>
<%
    List<Donacion> hechas = (List<Donacion>) request.getAttribute("hechas");
    List<Donacion> recibidas = (List<Donacion>) request.getAttribute("recibidas");
    BigDecimal totalHechas = (BigDecimal) request.getAttribute("totalHechas");
    BigDecimal totalRecibidas = (BigDecimal) request.getAttribute("totalRecibidas");
    String activo = "donaciones";
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <%@ include file="fragmentos/head.jspf" %>
        <title>Mis donaciones · Sueños de Plata</title>
    </head>
    <body>
        <div class="app">
            <%@ include file="fragmentos/menu.jspf" %>

            <main class="contenido" id="contenido">
                <header class="encabezado">
                    <div>
                        <h1>Mis donaciones</h1>
                        <p>Todo lo que has donado y lo que has recibido en tus sueños, en un solo lugar.</p>
                    </div>
                    <a class="boton secundario" href="PropuestaControl?accion=listar">
                        <i class="fas fa-hand-holding-heart" aria-hidden="true"></i> Buscar un sueño para apoyar
                    </a>
                </header>

                <section class="cifras" aria-label="Resumen de donaciones">
                    <article class="cifra destacada">
                        <span class="cifra-icono" aria-hidden="true"><i class="fas fa-hand-holding-heart"></i></span>
                        <div>
                            <div class="cifra-etiqueta">Has donado</div>
                            <div class="cifra-valor <%= Html.claseMonto(totalHechas)%>"><%= Html.dinero(totalHechas)%></div>
                        </div>
                    </article>
                    <article class="cifra">
                        <span class="cifra-icono" aria-hidden="true"><i class="fas fa-receipt"></i></span>
                        <div>
                            <div class="cifra-etiqueta">Donaciones hechas</div>
                            <div class="cifra-valor"><%= hechas.size()%></div>
                        </div>
                    </article>
                    <article class="cifra">
                        <span class="cifra-icono" aria-hidden="true"><i class="fas fa-piggy-bank"></i></span>
                        <div>
                            <div class="cifra-etiqueta">Has recibido</div>
                            <div class="cifra-valor <%= Html.claseMonto(totalRecibidas)%>"><%= Html.dinero(totalRecibidas)%></div>
                        </div>
                    </article>
                </section>

                <section class="panel" aria-labelledby="titulo-hechas">
                    <h2 id="titulo-hechas">Donaciones que hiciste</h2>
                    <% if (hechas.isEmpty()) {%>
                    <p style="color: var(--ink-soft);">Aún no has donado. Cuando apoyes un sueño, lo verás aquí.</p>
                    <% } else {%>
                    <table class="tabla">
                        <thead>
                            <tr><th>Sueño</th><th class="fecha">Fecha</th><th style="text-align:right;">Monto</th></tr>
                        </thead>
                        <tbody>
                            <% for (Donacion d : hechas) {%>
                            <tr>
                                <td>
                                    <a href="DonacionControl?accion=ver&id=<%= d.getIdPropuesta()%>"><strong><%= Html.esc(d.getTituloPropuesta())%></strong></a>
                                    <% if (d.getMensaje() != null) {%><p class="nota">“<%= Html.esc(d.getMensaje())%>”</p><% }%>
                                </td>
                                <td class="fecha"><%= Html.fecha(d.getFecha())%></td>
                                <td class="monto"><%= Html.dinero(d.getMonto())%></td>
                            </tr>
                            <% }%>
                        </tbody>
                    </table>
                    <% }%>
                </section>

                <section class="panel" aria-labelledby="titulo-recibidas">
                    <h2 id="titulo-recibidas">Donaciones que recibiste</h2>
                    <% if (recibidas.isEmpty()) {%>
                    <p style="color: var(--ink-soft);">Tus sueños aún no han recibido donaciones.</p>
                    <% } else {%>
                    <table class="tabla">
                        <thead>
                            <tr><th>De</th><th>Para el sueño</th><th class="fecha">Fecha</th><th style="text-align:right;">Monto</th></tr>
                        </thead>
                        <tbody>
                            <% for (Donacion d : recibidas) {%>
                            <tr>
                                <td>
                                    <strong><%= Html.esc(d.getNombreDonante())%></strong>
                                    <% if (d.getMensaje() != null) {%><p class="nota">“<%= Html.esc(d.getMensaje())%>”</p><% }%>
                                </td>
                                <td><%= Html.esc(d.getTituloPropuesta())%></td>
                                <td class="fecha"><%= Html.fecha(d.getFecha())%></td>
                                <td class="monto"><%= Html.dinero(d.getMonto())%></td>
                            </tr>
                            <% }%>
                        </tbody>
                    </table>
                    <% }%>
                </section>
            </main>
        </div>
    </body>
</html>
