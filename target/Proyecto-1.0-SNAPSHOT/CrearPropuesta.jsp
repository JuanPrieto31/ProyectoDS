<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Crear Propuesta</title>

        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <style>
            :root {
                --beige-light: #F5E6D3;
                --beige: #E8D4B8;
                --beige-dark: #D4B896;
                --coffee: #8B6F47;
                --coffee-dark: #6B5335;
            }

            body {
                background-color: #FFFFFF!important;
                min-height: 100vh;
            }

            .navbar {
                background-color: var(--beige)!important;
                border-bottom: 2px solid var(--coffee);
                box-shadow: 0 2px 4px rgba(107, 83, 53, 0.1);
            }

            .navbar-brand .title {
                color: var(--coffee-dark)!important;
                margin: 0;
            }

            .navbar-item {
                color: var(--coffee-dark)!important;
                font-weight: 600;
            }

            .navbar-item:hover {
                background-color: var(--beige-dark)!important;
                color: var(--coffee-dark)!important;
            }

            .navbar-dropdown {
                background-color: var(--beige)!important;
                border: 1px solid var(--coffee)!important;
                box-shadow: 0 4px 8px rgba(107, 83, 53, 0.2)!important;
            }

            .navbar-dropdown .navbar-item {
                color: var(--coffee-dark)!important;
            }

            .navbar-dropdown .navbar-item:hover {
                background-color: var(--beige-dark);
            }

            .navbar-link {
                color: var(--coffee-dark) !important;
                font-weight: 600;
            }

            .navbar-link:hover {
                background-color: var(--beige-dark) !important;
            }

            .navbar-link::after {
                border-color: var(--coffee-dark)!important;
            }

            .main-container {
                max-width: 800px;
                margin: 0 auto;
                padding: 2rem 1rem;
            }

            .page-title {
                text-align: center;
                color: var(--coffee-dark);
                font-size: 1.75rem;
                font-weight: 600;
                margin-bottom: 2rem;
            }

            .form-card {
                background-color: var(--beige-light);
                border-radius: 8px;
                padding: 2rem;
                box-shadow: 0 2px 8px rgba(139, 111, 71, 0.15);
            }

            .field {
                margin-bottom: 1.5rem;
            }

            .editor-label {
                color: var(--coffee-dark);
                font-weight: 600;
                margin-bottom: 0.5rem;
                display: block;
            }

            .editor-toolbar {
                background-color: #FFFFFF;
                border: 1px solid var(--beige-dark);
                border-bottom: none;
                padding: 0.5rem;
                display: flex;
                gap: 0.5rem;
                flex-wrap: wrap;
                align-items: center;
                border-radius: 4px 4px 0 0;
                margin-bottom: 0;
            }

            .editor-toolbar button,
            .editor-toolbar select {
                background-color: transparent;
                border: 1px solid var(--beige-dark);
                color: var(--coffee-dark);
                padding: 0.25rem 0.5rem;
                cursor: pointer;
                border-radius: 3px;
                font-size: 0.875rem;
            }

            .editor-toolbar button:hover,
            .editor-toolbar select:hover {
                background-color: var(--beige-light);
            }

            .editor-toolbar .separator {
                width: 1px;
                height: 20px;
                background-color: var(--beige-dark);
                margin: 0 0.25rem;
            }

            .editor-content {
                background-color: #FFFFFF;
                border: 1px solid var(--beige-dark);
                min-height: 300px;
                padding: 1rem;
                border-radius: 0 0 4px 4px;
                color: var(--coffee-dark);
                font-family: Arial, sans-serif;
                line-height: 1.6;
            }

            .editor-content:focus {
                outline: none;
                border-color: var(--coffee);
                box-shadow: 0 0 0 2px rgba(139, 111, 71, 0.2);
            }

            .submit-section {
                margin-top: 2rem;
                text-align: right;
            }

            .submit-button {
                background-color: var(--coffee)!important;
                color: #FFFFFF!important;
                border: none!important;
                padding: 0.75rem 2rem;
                border-radius: 4px;
                cursor: pointer;
                font-weight: 600;
                font-size: 1rem;
            }

            .submit-button:hover {
                background-color: var(--coffee-dark)!important;
            }

            .footer {
                background-color: var(--beige);
                border-top: 2px solid var(--coffee);
                color: var(--coffee-dark);
                margin-top: 3rem;
            }

            .footer a {
                color: var(--coffee);
                transition: color 0.3s ease;
            }

            .footer a:hover {
                color: var(--coffee-dark);
            }

            .button-as-link {
                background: none;
                border: none;
                color: inherit;
                font: inherit;
                cursor: pointer;
                display: flex;
                align-items: center;
                height: 100%;
                padding: 0.5rem 1rem;
                width: 100%;
                text-align: left;
            }

            .button-as-link:hover {
                background-color: rgba(0, 0, 0, 0.05);
            }
        </style>
    </head>
    <body>
        <%
            String correo = request.getParameter("correo");
            if (correo == null || correo.trim().isEmpty()) {
                System.out.println("[ERROR] crear-propuesta.jsp - No se recibió correo");
                response.sendRedirect("login.jsp?error=no_correo");
                return;
            }

            String correoEncoded = URLEncoder.encode(correo, StandardCharsets.UTF_8.toString());
        %>

        <nav class="navbar is-fixed-top" role="navigation" aria-label="main navigation">
            <div class="navbar-brand">

                <a href="PropuestaControl?accion=listar&correo=<%= correoEncoded%>" class="navbar-item">
                    <i class="fas fa-arrow-left"></i>
                    <span class="ml-2">Volver</span>
                </a>

                <form action="UsuarioControl" method="post" style="margin: 0; display: inline;">
                    <input type="hidden" name="accion" value="perfil">
                    <input type="hidden" name="correo" value="<%= correo%>">
                    <button type="submit" class="navbar-item button-as-link">
                        <i class="fas fa-user"></i>
                        <span class="ml-2">Perfil</span>
                    </button>
                </form>

                <a role="button" class="navbar-burger" aria-label="menu" aria-expanded="false" data-target="navbarMenu">
                    <span aria-hidden="true"></span>
                    <span aria-hidden="true"></span>
                    <span aria-hidden="true"></span>
                </a>
            </div>

            <div id="navbarMenu" class="navbar-menu">
                <div class="navbar-end">
                    
                    <div class="navbar-item has-dropdown is-hoverable">
                        <a class="navbar-link">
                            <i class="fas fa-bars"></i>
                            <span class="ml-2">Menú</span>
                        </a>
                        <div class="navbar-dropdown is-right">
                            <a class="navbar-item" href="PropuestaControl?accion=listar&correo=<%= correoEncoded%>">
                                <i class="fas fa-home mr-2"></i> Inicio
                            </a>
                            <a class="navbar-item" href="#">
                                <i class="fas fa-lightbulb mr-2"></i> Mis Propuestas
                            </a>
                            <hr class="navbar-divider">
                            <a class="navbar-item" href="login.jsp">
                                <i class="fas fa-sign-out-alt mr-2"></i> Cerrar Sesión
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </nav>

        <div style="height: 52px;"></div>

        <main class="main-container">
            <h1 class="page-title">Crear Nueva Propuesta</h1>

            <form action="PropuestaControl" method="post" class="form-card">
                <input type="hidden" name="accion" value="crear">
                <input type="hidden" name="correo" value="<%= correo%>">

                <div class="field">
                    <label class="label">Título de la Propuesta</label>
                    <div class="control">
                        <input 
                            class="input" 
                            type="text" 
                            name="titulo"
                            id="titulo"
                            placeholder="Escribe un título breve y claro"
                            required>
                    </div>
                </div>

                <div class="field">
                    <label class="label">Descripción</label>
                    <div class="control">
                        <textarea 
                            name="contenido"
                            id="contenido"
                            class="textarea" 
                            placeholder="Describe tu propuesta en detalle..."
                            rows="8"
                            required></textarea>
                    </div>
                </div>

                <div class="submit-section">
                    <button type="submit" class="button submit-button">
                        <i class="fas fa-paper-plane mr-2"></i>
                        Publicar Propuesta
                    </button>
                </div>
            </form>

        </main>

        <footer class="footer">
            <div class="content has-text-centered">
                <p class="title is-5 has-text-weight-bold">Logo</p>
                <nav class="level is-mobile" style="max-width: 600px; margin: 1rem auto;">
                    <div class="level-item"><a href="#">Link one</a></div>
                    <div class="level-item"><a href="#">Link two</a></div>
                    <div class="level-item"><a href="#">Link three</a></div>
                    <div class="level-item"><a href="#">Link four</a></div>
                </nav>
                <div class="mt-4">
                    <p><small>© 2025 Your Website. All rights reserved.</small></p>
                    <p class="mt-2"><a href="#">Privacy Policy</a> | <a href="#">Terms of Service</a></p>
                    <div class="social-icons mt-3">
                        <a href="#" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
                        <a href="#" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
                        <a href="#" aria-label="Facebook"><i class="fab fa-facebook"></i></a>
                    </div>
                </div>
            </div>
        </footer>

        <script>
            document.addEventListener('DOMContentLoaded', function () {

                const $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);

                $navbarBurgers.forEach(function (el) {
                    el.addEventListener('click', function () {
                        const target = el.dataset.target;
                        const $target = document.getElementById(target);

                        if ($target !== null) {
                            el.classList.toggle('is-active');
                            $target.classList.toggle('is-active');
                        }
                    });
                });
            });
        </script>
    </body>
</html>