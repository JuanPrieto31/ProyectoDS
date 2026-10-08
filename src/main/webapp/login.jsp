<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="presentacion.Html" %>
<%
    String error = (String) request.getAttribute("error");
    String registro = request.getParameter("registro");
    boolean eliminada = "1".equals(request.getParameter("eliminada"));
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <%@ include file="WEB-INF/vistas/fragmentos/head.jspf" %>
        <title>Iniciar sesión · Sueños de Plata</title>
    </head>
    <body>
        <div class="acceso">
            <section class="acceso-lado">
                <span class="marca" style="padding:0;">
                    <span class="marca-icono" aria-hidden="true"><i class="fas fa-star"></i></span>
                    Sueños de Plata
                </span>
                <div>
                    <h1>Nunca es tarde para cumplir un sueño.</h1>
                    <p>Adultos mayores comparten lo que quieren lograr y la comunidad les ayuda con donaciones.</p>
                </div>
                <ol class="pasos">
                    <li><b>1</b> Publica tu sueño con tus propias palabras.</li>
                    <li><b>2</b> Familia, amigos y vecinos lo apoyan.</li>
                    <li><b>3</b> Sigue el avance hasta cumplir tu meta.</li>
                </ol>
            </section>

            <main class="acceso-form" id="contenido">
                <div class="acceso-caja">
                    <h2>Iniciar sesión</h2>
                    <p>Escribe tu correo y tu contraseña para entrar.</p>

                    <% if (error != null && !error.isEmpty()) {%>
                    <div class="aviso error" role="alert">
                        <i class="fas fa-circle-exclamation" aria-hidden="true"></i>
                        <span><%= Html.esc(error)%></span>
                    </div>
                    <% }%>
                    <% if ("exitoso".equals(registro)) {%>
                    <div class="aviso exito" role="status">
                        <i class="fas fa-circle-check" aria-hidden="true"></i>
                        <span>Tu cuenta quedó creada. Ahora inicia sesión.</span>
                    </div>
                    <% }%>
                    <% if (eliminada) {%>
                    <div class="aviso exito" role="status">
                        <i class="fas fa-circle-check" aria-hidden="true"></i>
                        <span>Tu cuenta fue eliminada.</span>
                    </div>
                    <% }%>

                    <form action="UsuarioControl" method="POST">
                        <input type="hidden" name="accion" value="login">

                        <div class="campo">
                            <label for="Correo">Correo electrónico</label>
                            <input class="entrada" type="email" id="Correo" name="Correo"
                                   placeholder="nombre@correo.com" required autocomplete="email"
                                   value="<%= Html.esc(request.getParameter("Correo"))%>">
                        </div>

                        <div class="campo">
                            <label for="password">Contraseña</label>
                            <div class="ver-clave">
                                <input class="entrada" type="password" id="password" name="password"
                                       placeholder="Tu contraseña" required autocomplete="current-password">
                                <button type="button" data-ver="password" aria-controls="password">Mostrar</button>
                            </div>
                        </div>

                        <button type="submit" class="boton ancho">
                            <i class="fas fa-right-to-bracket" aria-hidden="true"></i> Entrar
                        </button>
                    </form>

                    <div class="acceso-pie">
                        ¿Es tu primera vez aquí? <a href="registrar.jsp">Crea tu cuenta</a>
                    </div>
                </div>
            </main>
        </div>

        <script>
            document.querySelectorAll("[data-ver]").forEach(function (b) {
                b.addEventListener("click", function () {
                    var campo = document.getElementById(b.dataset.ver);
                    var oculto = campo.type === "password";
                    campo.type = oculto ? "text" : "password";
                    b.textContent = oculto ? "Ocultar" : "Mostrar";
                });
            });
        </script>
    </body>
</html>
