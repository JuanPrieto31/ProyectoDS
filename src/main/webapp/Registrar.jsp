<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Registro de Usuario</title>

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
                background: linear-gradient(135deg, var(--beige-light) 0%, var(--beige) 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .register-container {
                width: 100%;
                max-width: 480px;
                padding: 1rem;
            }

            .register-box {
                background-color: #FFFFFF;
                border-radius: 12px;
                box-shadow: 0 8px 24px rgba(107, 83, 53, 0.2);
                padding: 3rem 2.5rem;
                border: 2px solid var(--beige-dark);
            }

            .register-header {
                text-align: center;
                margin-bottom: 2rem;
            }

            .register-header h2 {
                color: var(--coffee-dark);
                font-size: 2rem;
                font-weight: 700;
                margin-bottom: 0.5rem;
            }

            .register-header p {
                color: var(--coffee);
                font-size: 0.95rem;
            }

            .field label {
                color: var(--coffee-dark);
                font-weight: 600;
                margin-bottom: 0.5rem;
                display: block;
            }

            .input {
                border: 2px solid var(--beige-dark);
                border-radius: 8px;
                padding: 0.75rem 1rem;
                font-size: 1rem;
                background-color: var(--beige-light);
                color: var(--coffee-dark);
            }

            .input:focus {
                border-color: var(--coffee);
                box-shadow: 0 0 0 3px rgba(139, 111, 71, 0.1);
                background-color: #FFFFFF;
            }

            .button-register {
                width: 100%;
                background-color: var(--coffee);
                color: #FFFFFF;
                border: none;
                border-radius: 8px;
                padding: 0.875rem;
                font-size: 1.1rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                margin-top: 1rem;
            }

            .button-register:hover {
                background-color: var(--coffee-dark);
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(107, 83, 53, 0.3);
            }

            .register-footer {
                text-align: center;
                margin-top: 1.5rem;
                border-top: 1px solid var(--beige-dark);
                padding-top: 1.2rem;
            }

            .register-footer a {
                color: var(--coffee);
                font-weight: 600;
                text-decoration: none;
            }

            .register-footer a:hover {
                text-decoration: underline;
                color: var(--coffee-dark);
            }
        </style>
    </head>
    <body>

        <div class="register-container">
            <div class="register-box">
                <div class="register-header">
                    <h2>Crear Cuenta</h2>
                    <p>Completa el formulario para registrarte</p>
                </div>

                <%
                    String error = (String) request.getAttribute("error");
                    if (error != null) {
                %>
                <div style="background-color: #f8d7da; color: #721c24; padding: 12px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #f5c6cb;">
                    <strong>Error:</strong> <%= error%>
                </div>
                <% }%>

                <form action="UsuarioControl" method="POST">
                    <input type="hidden" name="accion" value="registrar">

                    <div class="field">
                        <label for="nombre">Nombre</label>
                        <input 
                            class="input" 
                            type="text" 
                            id="nombre" 
                            name="nombre" 
                            placeholder="Tu nombre" 
                            required
                            >
                    </div>

                    <div class="field">
                        <label for="cedula">Cédula</label>
                        <input 
                            class="input" 
                            type="text" 
                            id="cedula" 
                            name="cedula" 
                            placeholder="Registre su Cédula" 
                            required 
                            pattern="[0-9]+" 
                            oninput="this.value = this.value.replace(/[^0-9]/g, '')"
                            >
                    </div>

                    <div class="field">
                        <label for="email">Correo electrónico</label>
                        <input 
                            class="input" 
                            type="email" 
                            id="email" 
                            name="email" 
                            placeholder="ejemplo@correo.com" 
                            required
                            >
                    </div>

                    <div class="field">
                        <label for="password1">Contraseña</label>
                        <input 
                            class="input" 
                            type="password" 
                            id="password1" 
                            name="password1" 
                            placeholder="Crea una contraseña" 
                            required
                            >
                    </div>

                    <div class="field">
                        <label for="password2">Confirmar contraseña</label>
                        <input 
                            class="input" 
                            type="password" 
                            id="password2" 
                            name="password2" 
                            placeholder="Confirma tu contraseña" 
                            required
                            >
                    </div>
                    <div class="field">
                        <label for="telefono">Telefono</label>
                        <input 
                            class="input" 
                            type="text" 
                            id="telefono" 
                            name="telefono" 
                            placeholder="Registre su Telefono" 
                            required 
                            pattern="[0-9]+" 
                            oninput="this.value = this.value.replace(/[^0-9]/g, '')"
                            >
                    </div>

                    <div class="field">
                        <label for="fechaNacimiento">Fecha de Nacimiento</label>
                        <input 
                            class="input" 
                            type="date" 
                            id="fechaNacimiento" 
                            name="fechaNacimiento" 
                            required
                            >
                    </div>

                    <div class="control">
                        <button type="submit" class="button-register">
                            <i class="fas fa-user-plus"></i> Registrarse
                        </button>
                    </div>
                </form>
                <div class="register-footer">
                    <p>¿Ya tienes cuenta? <a href="login.jsp">Inicia sesión aquí</a></p>
                </div>
            </div>
        </div>

        <script>
            document.querySelector('form').addEventListener('submit', function (e) {
                const password1 = document.getElementById('password1').value;
                const password2 = document.getElementById('password2').value;

                if (password1 !== password2) {
                    e.preventDefault();
                    alert('Las contraseñas no coinciden');
                    return false;
                }

                if (password1.length < 6) {
                    e.preventDefault();
                    alert('La contraseña debe tener al menos 6 caracteres');
                    return false;
                }
            });
        </script>
    </body>
</html>