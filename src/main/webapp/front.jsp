<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="Persistencia.Propuesta" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Propuestas</title>

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
                background-color: var(--beige-light)!important;
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

            .propuesta-card {
                background-color: #FFFFFF;
                border: 1px solid var(--beige-dark)!important;
                border-radius: 8px;
                margin-bottom: 1.5rem;
                box-shadow: 0 2px 8px rgba(139, 111, 71, 0.15)!important;
            }

            .propuesta-card .card-header {
                background-color: var(--beige)!important;
                border-bottom: 1px solid var(--beige-dark)!important;
            }

            .propuesta-card .card-header-title {
                color: var(--coffee-dark)!important;
            }

            .propuesta-card .card-content {
                color: var(--coffee-dark)!important;
            }

            .propuesta-card .card-footer {
                border-top: 1px solid var(--beige-dark)!important;
            }

            .propuesta-card .card-footer-item {
                color: var(--coffee)!important;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .propuesta-card .card-footer-item:hover {
                background-color: var(--beige-light);
                color: var(--coffee-dark);
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

            .footer .social-icons a {
                font-size: 1.5rem;
                margin: 0 0.5rem;
            }

            .main-container {
                max-width: 800px;
                margin: 0 auto;
                padding: 2rem 1rem;
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
                System.out.println("[ERROR] front.jsp - No se recibió correo");
                response.sendRedirect("login.jsp?error=no_correo");
                return;
            }

            List<Propuesta> lista = (List<Propuesta>) request.getAttribute("listaPropuestas");
        %>

        <nav class="navbar is-fixed-top" role="navigation" aria-label="main navigation">
            <div class="navbar-brand">
                <form action="UsuarioControl" method="post" style="margin: 0;">
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
                            <a class="navbar-item" href="#"><i class="fas fa-home mr-2"></i> Inicio</a>
                            <form action="PropuestaControl" method="post" style="margin: 0;">
                                <input type="hidden" name="accion" value="ver">
                                <input type="hidden" name="correo" value="<%= correo%>">
                                <button type="submit" class="navbar-item button-as-link" style="width: 100%; text-align: left;">
                                    <i class="fas fa-lightbulb mr-2"></i> Ver Propuestas
                                </button>
                            </form>
                            <form action="PropuestaControl" method="post" style="margin: 0; display: inline;">
                                <input type="hidden" name="accion" value="crear">
                                <input type="hidden" name="correo" value="<%= correo%>">
                                <button type="submit" class="navbar-item button-as-link" style="width: 100%; text-align: left;">
                                    <i class="fas fa-plus-circle mr-2"></i>
                                    Nueva Propuesta
                                </button>
                            </form>
                            <hr class="navbar-divider">
                            <a class="navbar-item" href="#"><i class="fas fa-cog mr-2"></i> Configuración</a>
                            <a class="navbar-item" href="login.jsp"><i class="fas fa-sign-out-alt mr-2"></i> Cerrar Sesión</a>
                        </div>
                    </div>
                </div>
            </div>
        </nav>

        <div style="height: 52px;"></div>

        <main class="main-container">
            <div id="propuestas">
                <% 
                    if (lista != null && !lista.isEmpty()) {
                        for (Propuesta p : lista) { 
                %>
                    <div class="card propuesta-card">
                        <header class="card-header">
                            <p class="card-header-title"><%= p.getTitulo() %></p>
                        </header>
                        <div class="card-content">
                            <div class="content"><%= p.getContenido() %></div>
                            <p><small><strong>Creado el:</strong> <%= p.getFechacreacion() %></small></p>
                        </div>
                        <footer class="card-footer">
                            <a href="#" class="card-footer-item">Ver</a>
                        </footer>
                    </div>
                <% 
                        } 
                    } else { 
                %>
                    <div class="notification is-warning has-text-centered">
                        No hay propuestas disponibles.
                    </div>
                <% 
                    } 
                %>
            </div>
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
            document.addEventListener('DOMContentLoaded', () => {
                const $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);
                $navbarBurgers.forEach(el => {
                    el.addEventListener('click', () => {
                        const target = el.dataset.target;
                        const $target = document.getElementById(target);
                        el.classList.toggle('is-active');
                        $target.classList.toggle('is-active');
                    });
                });
            });
        </script>
    </body>
</html>
