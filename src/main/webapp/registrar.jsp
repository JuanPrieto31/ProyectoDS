<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="presentacion.Html" %>
<%
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <%@ include file="WEB-INF/vistas/fragmentos/head.jspf" %>
        <title>Crear cuenta · Sueños de Plata</title>
    </head>
    <body>
        <div class="acceso">
            <section class="acceso-lado">
                <span class="marca" style="padding:0;">
                    <span class="marca-icono" aria-hidden="true"><i class="fas fa-star"></i></span>
                    Sueños de Plata
                </span>
                <div>
                    <h1>Únete a la comunidad.</h1>
                    <p>Si tienes 60 años o más podrás publicar tus sueños. Si eres menor, tu cuenta será de donante para apoyar los sueños de otros.</p>
                </div>
                <ol class="pasos">
                    <li><b>1</b> Completa tus datos.</li>
                    <li><b>2</b> Inicia sesión con tu correo.</li>
                    <li><b>3</b> Publica o apoya un sueño.</li>
                </ol>
            </section>

            <main class="acceso-form" id="contenido">
                <div class="acceso-caja">
                    <h2>Crear cuenta</h2>
                    <p>Todos los campos son necesarios.</p>

                    <% if (error != null) {%>
                    <div class="aviso error" role="alert">
                        <i class="fas fa-circle-exclamation" aria-hidden="true"></i>
                        <span><%= Html.esc(error)%></span>
                    </div>
                    <% }%>
                    <div class="aviso error" role="alert" id="errorCliente" hidden>
                        <i class="fas fa-circle-exclamation" aria-hidden="true"></i>
                        <span></span>
                    </div>

                    <form action="UsuarioControl" method="POST" id="formRegistro" class="rejilla-form">
                        <input type="hidden" name="accion" value="registrar">

                        <div class="campo completo">
                            <label for="nombre">Nombre completo</label>
                            <input class="entrada" type="text" id="nombre" name="nombre" placeholder="Rosa Elena Martínez"
                                   required autocomplete="name" value="<%= Html.esc(request.getParameter("nombre"))%>">
                        </div>

                        <div class="campo">
                            <label for="cedula">Cédula</label>
                            <input class="entrada" type="text" inputmode="numeric" id="cedula" name="cedula" placeholder="41234567"
                                   required pattern="[0-9]+" oninput="this.value = this.value.replace(/[^0-9]/g, '')"
                                   value="<%= Html.esc(request.getParameter("cedula"))%>">
                        </div>

                        <div class="campo">
                            <label for="telefono">Teléfono</label>
                            <input class="entrada" type="tel" inputmode="numeric" id="telefono" name="telefono" placeholder="3104567821"
                                   required pattern="[0-9]+" oninput="this.value = this.value.replace(/[^0-9]/g, '')" autocomplete="tel"
                                   value="<%= Html.esc(request.getParameter("telefono"))%>">
                        </div>

                        <div class="campo completo">
                            <label for="email">Correo electrónico</label>
                            <input class="entrada" type="email" id="email" name="email" placeholder="nombre@correo.com"
                                   required autocomplete="email" value="<%= Html.esc(request.getParameter("email"))%>">
                        </div>

                        <div class="campo completo">
                            <label for="fechaNacimiento">Fecha de nacimiento</label>
                            <input class="entrada" type="date" id="fechaNacimiento" name="fechaNacimiento" required
                                   value="<%= Html.esc(request.getParameter("fechaNacimiento"))%>">
                        </div>

                        <div class="campo">
                            <label for="password1">Contraseña</label>
                            <input class="entrada" type="password" id="password1" name="password1" placeholder="Mínimo 6 caracteres"
                                   required minlength="6" autocomplete="new-password">
                        </div>

                        <div class="campo">
                            <label for="password2">Repite la contraseña</label>
                            <input class="entrada" type="password" id="password2" name="password2" placeholder="Igual a la anterior"
                                   required autocomplete="new-password">
                        </div>

                        <button type="submit" class="boton ancho completo">
                            <i class="fas fa-user-plus" aria-hidden="true"></i> Crear mi cuenta
                        </button>
                    </form>

                    <div class="acceso-pie">
                        ¿Ya tienes cuenta? <a href="login.jsp">Inicia sesión</a>
                    </div>
                </div>
            </main>
        </div>

        <script>
            document.getElementById("formRegistro").addEventListener("submit", function (e) {
                var p1 = document.getElementById("password1").value;
                var p2 = document.getElementById("password2").value;
                var caja = document.getElementById("errorCliente");
                var problema = null;

                if (p1.length < 6) {
                    problema = "La contraseña debe tener al menos 6 caracteres.";
                } else if (p1 !== p2) {
                    problema = "Las dos contraseñas no coinciden. Escríbelas de nuevo.";
                }
                if (problema) {
                    e.preventDefault();
                    caja.querySelector("span").textContent = problema;
                    caja.hidden = false;
                    caja.scrollIntoView({block: "center"});
                    document.getElementById(p1.length < 6 ? "password1" : "password2").focus();
                }
            });
        </script>
    </body>
</html>
