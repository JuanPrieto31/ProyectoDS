<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login</title>
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

            .login-container {
                width: 100%;
                max-width: 420px;
                padding: 1rem;
            }

            .login-box {
                background-color: #FFFFFF;
                border-radius: 12px;
                box-shadow: 0 8px 24px rgba(107, 83, 53, 0.2);
                padding: 3rem 2.5rem;
                border: 2px solid var(--beige-dark);
            }

            .login-header {
                text-align: center;
                margin-bottom: 2rem;
            }

            .login-header h2 {
                color: var(--coffee-dark);
                font-size: 2rem;
                font-weight: 700;
                margin-bottom: 0.5rem;
            }

            .login-header p {
                color: var(--coffee);
                font-size: 0.95rem;
            }

            .field {
                margin-bottom: 1.5rem;
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
                transition: all 0.3s ease;
                background-color: var(--beige-light);
                color: var(--coffee-dark);
            }

            .input:focus {
                border-color: var(--coffee);
                box-shadow: 0 0 0 3px rgba(139, 111, 71, 0.1);
                background-color: #FFFFFF;
            }

            .input::placeholder {
                color: var(--coffee);
                opacity: 0.6;
            }

            .button-login {
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

            .button-login:hover {
                background-color: var(--coffee-dark);
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(107, 83, 53, 0.3);
            }

            .button-login:active {
                transform: translateY(0);
            }

            .login-footer {
                text-align: center;
                margin-top: 1.5rem;
                padding-top: 1.5rem;
                border-top: 1px solid var(--beige-dark);
            }

            .login-footer a {
                color: var(--coffee);
                text-decoration: none;
                font-weight: 600;
                transition: color 0.3s ease;
            }

            .login-footer a:hover {
                color: var(--coffee-dark);
                text-decoration: underline;
            }

            .icon-input {
                position: relative;
            }

            .icon-input .icon {
                position: absolute;
                left: 1rem;
                top: 50%;
                transform: translateY(-50%);
                color: var(--coffee);
                pointer-events: none;
            }

            .icon-input .input {
                padding-left: 3rem;
            }
            
           
            .error-message {
                background-color: #f8d7da;
                color: #721c24;
                padding: 0.75rem 1rem;
                border-radius: 8px;
                margin-bottom: 1rem;
                border: 1px solid #f5c6cb;
                text-align: center;
            }
            
            .success-message {
                background-color: #d4edda;
                color: #155724;
                padding: 0.75rem 1rem;
                border-radius: 8px;
                margin-bottom: 1rem;
                border: 1px solid #c3e6cb;
                text-align: center;
            }
        </style>
    </head>
    <body>

        <div class="login-container">
            <div class="login-box">
                <div class="login-header">
                    <h2>Iniciar Sesión</h2>
                    <p>Ingresa tus credenciales para continuar</p>
                </div>


                <% 
                    String error = (String) request.getAttribute("error");
                    String registro = request.getParameter("registro");
                    
                    if (error != null && !error.isEmpty()) {
                %>
                    <div class="error-message">
                        <i class="fas fa-exclamation-circle"></i> <%= error %>
                    </div>
                <% 
                    }
                    
                    if ("exitoso".equals(registro)) {
                %>
                    <div class="success-message">
                        <i class="fas fa-check-circle"></i> Registro exitoso. Por favor inicia sesión.
                    </div>
                <% 
                    }
                %>

                <form action="UsuarioControl" method="POST">
                    <input type="hidden" name="accion" value="login">
                    <div class="field">
                        <label for="Correo">Correo</label>
                        <div class="control icon-input">
                            <span class="icon">
                                <i class="fas fa-user"></i>
                            </span>
                            <input 
                                class="input" 
                                type="text" 
                                id="Correo" 
                                name="Correo" 
                                placeholder="Ingresa tu correo" 
                                required
                                autocomplete="correo"
                                >
                        </div>
                    </div>

                    <div class="field">
                        <label for="password">Contraseña</label>
                        <div class="control icon-input">
                            <span class="icon">
                                <i class="fas fa-lock"></i>
                            </span>
                            <input 
                                class="input" 
                                type="password" 
                                id="password" 
                                name="password" 
                                placeholder="Ingresa tu contraseña" 
                                required
                                autocomplete="current-password"
                                >
                        </div>
                    </div>

                    <div class="control">
                        <button type="submit" class="button-login">
                            <i class="fas fa-sign-in-alt mr-2"></i>
                            Entrar
                        </button>
                    </div>
                </form>

                <div class="login-footer">
                    <p>
                        <a href="#">¿Olvidaste tu contraseña?</a>
                    </p>
                    <p class="mt-2">
                        ¿No tienes cuenta? <a href="Registrar.jsp">Regístrate aquí</a>
                    </p>
                </div>
            </div>
        </div>

    </body>
</html>