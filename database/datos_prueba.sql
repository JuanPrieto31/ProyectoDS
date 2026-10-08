-- Datos de ejemplo. Todas las cuentas usan la contraseña 123456.
-- Adultos mayores: rosa@correo.com, jorge@correo.com, carmen@correo.com, luis@correo.com
-- Donantes:        valentina@correo.com, andres@correo.com

INSERT INTO usuario (nombre, correo, contraseña, rol, fechanacimiento, telefono, cedula) VALUES
('Rosa Elena Martínez', 'rosa@correo.com',      '123456', 'Adulto Mayor', '1951-03-14', '3104567821', 41234567),
('Jorge Iván Restrepo', 'jorge@correo.com',     '123456', 'Adulto Mayor', '1948-11-02', '3158812047', 17654321),
('Carmen Lucía Ortiz',  'carmen@correo.com',    '123456', 'Adulto Mayor', '1956-07-21', '3002931176', 51876234),
('Luis Alberto Gómez',  'luis@correo.com',      '123456', 'Adulto Mayor', '1944-01-30', '3127745503', 19223841),
('Valentina Ruiz',      'valentina@correo.com', '123456', 'Donante',      '1994-05-09', '3016620948', 1020456789),
('Andrés Felipe Mora',  'andres@correo.com',    '123456', 'Donante',      '1988-09-17', '3186043312', 1032457810);

INSERT INTO propuesta (titulo, descripcion, fechacreacion, idusuario, meta) VALUES
('Conocer el mar con mis nietos',
 'Nunca he visto el mar. Mis tres nietos tampoco. Quiero llevarlos una semana a Santa Marta para que tengamos ese recuerdo juntos.
Necesito ayuda con los pasajes de bus y el hospedaje.', '2025-09-02', 1, 1800000),
('Un audífono para volver a escuchar a mi familia',
 'Desde hace dos años casi no escucho. En las reuniones familiares me quedo por fuera de las conversaciones. Un audífono me devolvería eso.', '2025-09-10', 2, 2400000),
('Clases de pintura en acuarela',
 'Siempre quise pintar. En la casa de la cultura de mi barrio dan un curso de seis meses y necesito los materiales y la matrícula.', '2025-09-18', 3, 650000),
('Reencontrarme con mi hermana en Pasto',
 'Hace 22 años no veo a mi hermana menor. Ella ya no puede viajar, así que quiero ir yo a visitarla antes de que sea tarde.', '2025-09-25', 4, 900000),
('Arreglar la huerta de la casa',
 'Tengo un patio donde siembro cebolla, cilantro y tomate. Quiero poner un techo de plástico y mangueras para regar sin agacharme tanto.', '2025-10-01', 1, 420000),
('Publicar mis recetas en un libro',
 'Llevo 50 años cocinando para mi familia. Quiero imprimir 30 copias de un recetario para regalarle a cada hijo y nieto.', '2025-10-03', 3, 0);

INSERT INTO donacion (monto, mensaje, fecha, idpropuesta, idusuario) VALUES
(150000, 'Que disfruten mucho ese viaje, doña Rosa.', '2025-09-04 10:12', 1, 5),
(320000, NULL,                                         '2025-09-07 18:40', 1, 6),
(50000,  'Con cariño de un vecino.',                   '2025-09-12 09:05', 1, 2),
(400000, 'Mi abuelo usó uno y le cambió la vida.',     '2025-09-11 15:30', 2, 5),
(250000, NULL,                                         '2025-09-15 20:18', 2, 6),
(180000, 'Ánimo don Jorge.',                           '2025-09-20 11:47', 2, 3),
(300000, 'Quiero ver sus cuadros.',                    '2025-09-19 14:02', 3, 6),
(200000, NULL,                                         '2025-09-22 08:26', 3, 5),
(150000, 'Para los pinceles buenos.',                  '2025-09-26 17:55', 3, 4),
(120000, 'Ojalá pueda abrazarla pronto.',              '2025-09-27 12:10', 4, 5),
(80000,  NULL,                                         '2025-10-02 19:33', 5, 6),
(35000,  'Me encantaría tener una copia.',             '2025-10-04 10:20', 6, 5);
