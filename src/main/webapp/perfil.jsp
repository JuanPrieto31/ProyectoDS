<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="Persistencia.Usuario" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Mi Perfil</title>

        <!-- Bulma CSS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">

        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <style>
            /* Agregando paleta de colores personalizada basada en el diseño */
            :root {
                --coffee-dark: #6B5744;
                --coffee-medium: #8B7355;
                --coffee-light: #A89080;
                --beige-bg: #D9C9B3;
                --beige-light: #E8DDD0;
                --cream: #F5F0E8;
            }

            /* Estilo del body con fondo beige */
            body {
                background-color: var(--beige-bg);
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                min-height: 100vh;
            }

            /* Navbar con colores personalizados */
            .navbar {
                background-color: white;
                box-shadow: 0 2px 8px rgba(107, 87, 68, 0.1);
            }

            .navbar-item,
            .navbar-link {
                color: var(--coffee-dark);
                font-weight: 500;
            }

            .navbar-item:hover,
            .navbar-link:hover {
                background-color: var(--beige-light);
                color: var(--coffee-dark);
            }

            .navbar-dropdown {
                border-top: 2px solid var(--coffee-medium);
            }

            .navbar-dropdown .navbar-item:hover {
                background-color: var(--beige-light);
            }

            /* Contenedor principal del perfil */
            .profile-container {
                max-width: 1200px;
                margin: 2rem auto;
                padding: 0 1.5rem;
            }

            /* Tarjetas de bienvenida con estilo elegante */
            .welcome-card {
                background-color: white;
                border-radius: 12px;
                padding: 2rem;
                margin-bottom: 2rem;
                box-shadow: 0 4px 12px rgba(107, 87, 68, 0.15);
            }

            .welcome-card .title {
                color: var(--coffee-dark);
                margin-bottom: 1.5rem;
            }

            /* Caja de descripción con fondo beige claro */
            .description-box {
                background-color: var(--beige-light);
                border-left: 4px solid var(--coffee-medium);
                padding: 1.5rem;
                border-radius: 8px;
                color: var(--coffee-dark);
                line-height: 1.6;
            }

            /* Tarjetas de estadísticas */
            .stats-card {
                background-color: white;
                border-radius: 12px;
                padding: 1.5rem;
                margin-bottom: 1.5rem;
                box-shadow: 0 4px 12px rgba(107, 87, 68, 0.15);
                border-top: 3px solid var(--coffee-medium);
            }

            .section-title {
                color: var(--coffee-dark);
                font-size: 1.25rem;
                font-weight: 600;
                margin-bottom: 1rem;
                padding-bottom: 0.5rem;
                border-bottom: 2px solid var(--beige-light);
            }

            /* Lista de estadísticas */
            .stats-list {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .stats-list li {
                padding: 0.75rem;
                margin-bottom: 0.5rem;
                background-color: var(--cream);
                border-radius: 6px;
                color: var(--coffee-dark);
            }

            /* Tarjeta de datos personales */
            .personal-data-card {
                background-color: white;
                border-radius: 12px;
                padding: 1.5rem;
                box-shadow: 0 4px 12px rgba(107, 87, 68, 0.15);
                border-top: 3px solid var(--coffee-medium);
                height: fit-content;
            }

            /* Items de datos personales */
            .data-item {
                display: flex;
                flex-direction: column;
                padding: 1rem;
                margin-bottom: 0.75rem;
                background-color: var(--cream);
                border-radius: 8px;
                border-left: 3px solid var(--coffee-light);
            }

            .data-label {
                font-size: 0.85rem;
                color: var(--coffee-light);
                font-weight: 600;
                margin-bottom: 0.25rem;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .data-value {
                color: var(--coffee-dark);
                font-size: 1rem;
                font-weight: 500;
            }

            /* Botones de actualización con estilo café */
            .buttons {
                display: flex;
                gap: 1rem;
                flex-wrap: wrap;
                justify-content: center;
            }

            .update-button {
                background-color: var(--coffee-medium);
                color: white;
                border: none;
                padding: 0.75rem 2rem;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: 0 2px 6px rgba(107, 87, 68, 0.2);
            }

            .update-button:hover {
                background-color: var(--coffee-dark);
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(107, 87, 68, 0.3);
            }

            .update-button:active {
                transform: translateY(0);
            }

            /* Footer con diseño elegante */
            .footer {
                background-color: var(--coffee-dark);
                color: var(--beige-light);
                padding: 3rem 1.5rem 2rem;
                margin-top: 4rem;
            }

            .footer-logo {
                font-size: 1.5rem;
                font-weight: bold;
                color: white;
                margin-bottom: 1.5rem;
                text-align: center;
            }

            .footer-links {
                display: flex;
                justify-content: center;
                gap: 2rem;
                margin-bottom: 2rem;
                flex-wrap: wrap;
            }

            .footer-links a {
                color: var(--beige-light);
                text-decoration: none;
                transition: color 0.3s ease;
            }

            .footer-links a:hover {
                color: white;
            }

            .footer-bottom {
                text-align: center;
                border-top: 1px solid var(--coffee-medium);
                padding-top: 1.5rem;
            }

            .social-icons {
                display: flex;
                justify-content: center;
                gap: 1.5rem;
                margin-bottom: 1rem;
            }

            .social-icons a {
                color: var(--beige-light);
                font-size: 1.5rem;
                transition: all 0.3s ease;
            }

            .social-icons a:hover {
                color: white;
                transform: scale(1.2);
            }

            .footer-bottom a {
                color: var(--beige-light);
                text-decoration: none;
            }

            .footer-bottom a:hover {
                color: white;
            }

            /* Responsive design para móviles */
            @media screen and (max-width: 768px) {
                .profile-container {
                    padding: 0 1rem;
                }

                .welcome-card,
                .stats-card,
                .personal-data-card {
                    padding: 1.25rem;
                }

                .buttons {
                    flex-direction: column;
                }

                .update-button {
                    width: 100%;
                }

                .footer-links {
                    flex-direction: column;
                    gap: 1rem;
                }
            }
        </style>
    </head>
    <body>
        <%
            // VALIDAR QUE EL OBJETO USUARIO EXISTA
            Usuario usuario = (Usuario) request.getAttribute("usuario");
            if (usuario == null) {
                System.out.println("[ERROR] perfil.jsp - No se recibió objeto Usuario");
                response.sendRedirect("login.jsp?error=no_usuario");
                return;
            }

            // Codificar correo para enlaces
            String correoEncoded = URLEncoder.encode(usuario.getCorreo(), StandardCharsets.UTF_8);
        %>

        <!-- Navbar corregido con enlace de vuelta que incluye correo -->
        <nav class="navbar is-fixed-top">
            <div class="navbar-brand">
                <a class="navbar-item" href="PropuestaControl?accion=listar&correo=<%= correoEncoded%>">
                    <i class="fas fa-arrow-left"></i> Volver
                </a>
                <div class="navbar-item">
                    <h1 class="title is-4">Mi Perfil</h1>
                </div>
                <a role="button" class="navbar-burger" aria-label="menu" aria-expanded="false" data-target="navbarMenu">
                    <span aria-hidden="true"></span><span aria-hidden="true"></span><span aria-hidden="true"></span>
                </a>
            </div>
            <div id="navbarMenu" class="navbar-menu">
                <div class="navbar-end">
                    <div class="navbar-item has-dropdown is-hoverable">
                        <a class="navbar-link"><i class="fas fa-bars"></i> Menú</a>
                        <div class="navbar-dropdown is-right">
                            <a class="navbar-item" href="PropuestaControl?accion=listar&correo=<%= correoEncoded%>">
                                <i class="fas fa-home mr-2"></i> Inicio
                            </a>
                            <a class="navbar-item" href="#"><i class="fas fa-lightbulb mr-2"></i> Mis Propuestas</a>
                            <form action="PropuestaControl" method="post" style="margin: 0; display: inline;">
                                <input type="hidden" name="accion" value="crear">
                                <input type="hidden" name="correo" value="<%= usuario.getCorreo()%>">
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


        <div class="profile-container">
            <div class="welcome-card">
                <h1 class="title is-3">
                    Bienvenido, <%= usuario.getNombre()%>
                </h1>
                <div class="description-box">
                    <p>Bienvenido a tu perfil. Aquí puedes ver y actualizar tus datos personales, propuestas y donaciones realizadas.</p>
                </div>
            </div>

            <div class="columns">
                <div class="column is-8">
                    <div class="stats-card">
                        <h2 class="section-title">Propuestas Publicadas</h2>
                        <ul class="stats-list">
                            <li>Número de propuestas: <strong>0</strong></li>
                        </ul>
                    </div>
                    <div class="stats-card">
                        <h2 class="section-title">Donaciones Realizadas</h2>
                        <ul class="stats-list">
                            <li>Número de donaciones: <strong>0</strong></li>
                        </ul>
                    </div>
                </div>

                <div class="column is-4">
                    <div class="personal-data-card">
                        <h2 class="section-title">Datos Personales</h2>
                        <div class="data-item">
                            <span class="data-label">Nombre y Apellido:</span>
                            <span class="data-value"><%= usuario.getNombre()%></span>
                        </div>
                        <div class="data-item">
                            <span class="data-label">Correo:</span>
                            <span class="data-value"><%= usuario.getCorreo()%></span>
                        </div>
                        <div class="data-item">
                            <span class="data-label">Teléfono:</span>
                            <span class="data-value"><%= usuario.getTelefono()%></span>
                        </div>
                        <div class="data-item">
                            <span class="data-label">Contraseña:</span>
                            <span class="data-value">••••••••</span>
                        </div>
                        <div class="data-item">
                            <span class="data-label">Rol:</span>
                            <span class="data-value"><%= usuario.getRol()%></span>
                        </div>
                        <div class="data-item">
                            <span class="data-label">Cédula:</span>
                            <span class="data-value"><%= usuario.getCedula()%></span>
                        </div>
                        <div class="data-item">
                            <span class="data-label">Fecha de Nacimiento:</span>
                            <span class="data-value">
                                <%= usuario.getFechanacimiento() != null
                                        ? usuario.getFechanacimiento().toString() : "No especificada"%>
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="welcome-card">
                <div class="buttons">
                    <button class="update-button">Actualizar Perfil</button>
                    <form action="UsuarioControl" method="post" style="margin: 0; display: inline;">
                        <input type="hidden" name="accion" value="eliminar">
                        <input type="hidden" name="correo" value="<%= usuario.getCorreo()%>">
                        <button type="submit" class="update-button" style="width: 100%; text-align: left;">
                            Eliminar Usuario
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <footer class="footer">
            <div class="content has-text-centered">
                <p class="footer-logo">Logo</p>
                <nav class="level is-mobile" style="max-width: 600px; margin: 1rem auto;">
                    <div class="level-item">
                        <a href="#" class="footer-links">Link one</a>
                    </div>
                    <div class="level-item">
                        <a href="#" class="footer-links">Link two</a>
                    </div>
                    <div class="level-item">
                        <a href="#" class="footer-links">Link three</a>
                    </div>
                    <div class="level-item">
                        <a href="#" class="footer-links">Link four</a>
                    </div>
                </nav>
                <div class="footer-bottom">
                    <p><small>© 2025 Your Website. All rights reserved.</small></p>
                    <p>
                        <a href="#">Privacy Policy</a> | <a href="#">Terms of Service</a>
                    </p>
                    <div class="social-icons">
                        <a href="#" aria-label="Instagram">
                            <i class="fab fa-instagram"></i>
                        </a>
                        <a href="#" aria-label="Twitter">
                            <i class="fab fa-twitter"></i>
                        </a>
                        <a href="#" aria-label="Facebook">
                            <i class="fab fa-facebook"></i>
                        </a>
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