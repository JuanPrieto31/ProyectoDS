<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="presentacion.Html" %>
<%
    String error = (String) request.getAttribute("error");
    if (error == null) {
        error = "No encontramos la página que buscabas.";
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <%@ include file="WEB-INF/vistas/fragmentos/head.jspf" %>
        <title>Algo salió mal · Sueños de Plata</title>
    </head>
    <body>
        <main class="acceso-form" style="min-height: 100dvh;">
            <div class="acceso-caja vacio">
                <i class="fas fa-compass" aria-hidden="true"></i>
                <h1 style="font-size: 1.8rem;">Algo salió mal</h1>
                <p><%= Html.esc(error)%></p>
                <a class="boton" href="javascript:history.back()"><i class="fas fa-arrow-left" aria-hidden="true"></i> Volver atrás</a>
                <a href="login.jsp">Ir al inicio de sesión</a>
            </div>
        </main>
    </body>
</html>
