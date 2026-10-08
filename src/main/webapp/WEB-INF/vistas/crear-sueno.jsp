<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="presentacion.Html" %>
<%
    String error = (String) request.getAttribute("error");
    String activo = "crear";
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <%@ include file="fragmentos/head.jspf" %>
        <title>Publicar un sueño · Sueños de Plata</title>
    </head>
    <body>
        <div class="app">
            <%@ include file="fragmentos/menu.jspf" %>

            <main class="contenido" id="contenido">
                <a class="miga" href="PropuestaControl?accion=listar">
                    <i class="fas fa-arrow-left" aria-hidden="true"></i> Volver al inicio
                </a>
                <header class="encabezado">
                    <div>
                        <h1>Publicar un sueño</h1>
                        <p>Cuéntale a la comunidad qué te gustaría cumplir. Escribe con tus palabras, como si se lo contaras a un amigo.</p>
                    </div>
                </header>

                <div class="dos-columnas">
                    <form class="panel" action="PropuestaControl" method="post">
                        <input type="hidden" name="accion" value="crear">

                        <% if (error != null) {%>
                        <div class="aviso error" role="alert">
                            <i class="fas fa-circle-exclamation" aria-hidden="true"></i>
                            <span><%= Html.esc(error)%></span>
                        </div>
                        <% }%>

                        <div class="campo">
                            <label for="titulo">1. ¿Cuál es tu sueño?</label>
                            <input class="entrada" type="text" id="titulo" name="titulo" maxlength="120" required
                                   placeholder="Ejemplo: Conocer el mar con mis nietos"
                                   value="<%= Html.esc(request.getParameter("titulo"))%>">
                            <span class="ayuda">Una frase corta y clara.</span>
                        </div>

                        <div class="campo">
                            <label for="contenido">2. Cuéntanos más</label>
                            <textarea class="entrada" id="contenido" name="contenido" rows="8" required
                                      placeholder="¿Por qué es importante para ti? ¿Qué necesitas para cumplirlo?"><%= Html.esc(request.getParameter("contenido"))%></textarea>
                        </div>

                        <div class="campo">
                            <label for="meta">3. ¿Cuánto dinero necesitas? <span style="font-weight:400; color: var(--ink-soft);">(opcional)</span></label>
                            <div class="con-prefijo">
                                <span aria-hidden="true">$</span>
                                <input class="entrada" type="text" inputmode="numeric" id="meta" name="meta" placeholder="800000"
                                       oninput="this.value = this.value.replace(/[^0-9]/g, '')"
                                       value="<%= Html.esc(request.getParameter("meta"))%>">
                            </div>
                            <span class="ayuda">Escribe solo números, sin puntos. Si lo dejas vacío, recibirás donaciones sin una meta fija.</span>
                        </div>

                        <button type="submit" class="boton ancho">
                            <i class="fas fa-paper-plane" aria-hidden="true"></i> Publicar mi sueño
                        </button>
                    </form>

                    <aside class="panel">
                        <h2>Consejos para tu publicación</h2>
                        <ul class="pasos" style="color: var(--ink);">
                            <li><b style="background: var(--primary-soft); color: var(--primary);">1</b> Di claramente qué quieres lograr.</li>
                            <li><b style="background: var(--primary-soft); color: var(--primary);">2</b> Explica por qué es importante para ti.</li>
                            <li><b style="background: var(--primary-soft); color: var(--primary);">3</b> Pon una meta realista: así la gente ve cuánto falta.</li>
                        </ul>
                    </aside>
                </div>
            </main>
        </div>
    </body>
</html>
