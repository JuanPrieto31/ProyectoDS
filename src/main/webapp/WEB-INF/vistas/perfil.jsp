<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="modelo.Usuario" %>
<%@ page import="presentacion.Html" %>
<%
    Usuario perfil = (Usuario) request.getAttribute("perfil");
    String activo = "perfil";
    Object numPropuestas = request.getAttribute("numPropuestas");
    Object numDonaciones = request.getAttribute("numDonaciones");
    BigDecimal totalDonado = (BigDecimal) request.getAttribute("totalDonado");
    BigDecimal totalRecibido = (BigDecimal) request.getAttribute("totalRecibido");
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <%@ include file="fragmentos/head.jspf" %>
        <title>Mi perfil · Sueños de Plata</title>
    </head>
    <body>
        <div class="app">
            <%@ include file="fragmentos/menu.jspf" %>

            <main class="contenido" id="contenido">
                <header class="encabezado">
                    <div>
                        <h1>Mi perfil</h1>
                        <p>Tus datos personales y un resumen de tu actividad en Sueños de Plata.</p>
                    </div>
                </header>

                <section class="cifras" aria-label="Mi actividad">
                    <article class="cifra">
                        <span class="cifra-icono" aria-hidden="true"><i class="fas fa-star"></i></span>
                        <div>
                            <div class="cifra-etiqueta">Sueños publicados</div>
                            <div class="cifra-valor"><%= numPropuestas%></div>
                        </div>
                    </article>
                    <article class="cifra">
                        <span class="cifra-icono" aria-hidden="true"><i class="fas fa-piggy-bank"></i></span>
                        <div>
                            <div class="cifra-etiqueta">Recibido</div>
                            <div class="cifra-valor <%= Html.claseMonto(totalRecibido)%>"><%= Html.dinero(totalRecibido)%></div>
                        </div>
                    </article>
                    <article class="cifra">
                        <span class="cifra-icono" aria-hidden="true"><i class="fas fa-hand-holding-heart"></i></span>
                        <div>
                            <div class="cifra-etiqueta">Donado (<%= numDonaciones%> <%= Integer.valueOf(1).equals(numDonaciones) ? "vez" : "veces"%>)</div>
                            <div class="cifra-valor <%= Html.claseMonto(totalDonado)%>"><%= Html.dinero(totalDonado)%></div>
                        </div>
                    </article>
                </section>

                <div class="dos-columnas">
                    <section class="panel" aria-labelledby="titulo-datos">
                        <h2 id="titulo-datos">Datos personales</h2>
                        <dl class="datos">
                            <div><dt>Nombre</dt><dd><%= Html.esc(perfil.getNombre())%></dd></div>
                            <div><dt>Correo</dt><dd><%= Html.esc(perfil.getCorreo())%></dd></div>
                            <div><dt>Teléfono</dt><dd class="num"><%= Html.esc(perfil.getTelefono())%></dd></div>
                            <div><dt>Cédula</dt><dd class="num"><%= perfil.getCedula()%></dd></div>
                            <div><dt>Fecha de nacimiento</dt><dd><%= Html.fecha(perfil.getFechaNacimiento())%></dd></div>
                            <div><dt>Tipo de cuenta</dt><dd><%= Html.esc(perfil.getRol())%></dd></div>
                        </dl>
                    </section>

                    <section class="panel zona-peligro" aria-labelledby="titulo-eliminar">
                        <h2 id="titulo-eliminar">Eliminar mi cuenta</h2>
                        <p>Se borrarán tu cuenta, tus sueños y las donaciones asociadas. Esta acción no se puede deshacer.</p>
                        <form action="UsuarioControl" method="post"
                              onsubmit="return confirm('¿Seguro que quieres eliminar tu cuenta? Esta acción no se puede deshacer.');">
                            <input type="hidden" name="accion" value="eliminar">
                            <button type="submit" class="boton peligro ancho">
                                <i class="fas fa-trash-can" aria-hidden="true"></i> Eliminar mi cuenta
                            </button>
                        </form>
                    </section>
                </div>
            </main>
        </div>
    </body>
</html>
