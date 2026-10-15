-- =====================================================================
-- Liwi Flor Eterna - 02_DML.sql  (DATOS, CONSULTAS, TRIGGERS Y PRUEBAS)
--
-- Se ejecuta DESPUES de 01_DDL.sql. Contiene, en este orden:
--
--   1. Carga de datos: mas de 50 registros por tabla (INSERT)
--   2. Consultas: 1 basica y 7 especificas por tabla (SELECT)
--   3. Modificacion y eliminacion de datos (UPDATE / DELETE)
--   4. Consultas avanzadas: 8 JOIN y 8 subconsultas
--   5. Ejemplos de uso de vistas, funcion y procedimientos (CALL)
--   6. Triggers y sus pruebas
--   7. Mejoras de datos: inventario completo y contrasenas SHA-256
--   8. Comprobaciones P1 a P13
--
-- Los triggers se crean aqui y no en el DDL porque deben existir DESPUES
-- de la carga; ver la nota en 01_DDL.sql.
--
-- Las pruebas que modifican datos van dentro de una transaccion anulada
-- con ROLLBACK, de modo que la base queda como estaba. Las que deben
-- fallar van comentadas: se ejecutan solas para ver el mensaje de error.
-- =====================================================================

USE liwi_flor_eterna;

-- B. Insercion de datos (>= 50 datos por tablas)

-- Ordren : los padres en primero para respectar las foreign keys
SET FOREIGN_KEY_CHECKS = 1;


-- PuntoVenta : 50 lineas
INSERT INTO PuntoVenta (idPuntoVenta, nombrePuntoVenta, ciudad, direccionPuntoVenta) VALUES
  (1, 'Liwi Bogota - Teusaquillo', 'Bogota', 'Cra 41 # 65-66'),
  (2, 'Liwi Bogota - Chapinero', 'Bogota', 'Cra 114 # 29-77'),
  (3, 'Liwi Bogota - Usaquen', 'Bogota', 'Transversal 72 # 54-74'),
  (4, 'Liwi Bogota - Suba', 'Bogota', 'Transversal 108 # 94-99'),
  (5, 'Liwi Bogota - Kennedy', 'Bogota', 'Diagonal 97 # 99-76'),
  (6, 'Liwi Bogota - Fontibon', 'Bogota', 'Diagonal 31 # 1-79'),
  (7, 'Liwi Bogota - Engativa', 'Bogota', 'Cra 15 # 37-13'),
  (8, 'Liwi Bogota - Barrios Unidos', 'Bogota', 'Diagonal 2 # 88-63'),
  (9, 'Liwi Bogota - La Candelaria', 'Bogota', 'Av. 27 # 51-33'),
  (10, 'Liwi Bogota - Chico', 'Bogota', 'Av. 119 # 46-49'),
  (11, 'Liwi Bogota - Cedritos', 'Bogota', 'Transversal 82 # 10-93'),
  (12, 'Liwi Bogota - Salitre', 'Bogota', 'Av. 12 # 72-69'),
  (13, 'Liwi Bogota - Puente Aranda', 'Bogota', 'Av. 37 # 59-19'),
  (14, 'Liwi Bogota - Rafael Uribe', 'Bogota', 'Transversal 40 # 4-91'),
  (15, 'Liwi Bogota - Zona T', 'Bogota', 'Av. 47 # 60-55'),
  (16, 'Liwi Medellin - El Poblado', 'Medellin', 'Cra 52 # 75-71'),
  (17, 'Liwi Medellin - Laureles', 'Medellin', 'Diagonal 112 # 15-55'),
  (18, 'Liwi Medellin - Belen', 'Medellin', 'Transversal 103 # 97-77'),
  (19, 'Liwi Medellin - Robledo', 'Medellin', 'Diagonal 51 # 68-34'),
  (20, 'Liwi Cali - Granada', 'Cali', 'Diagonal 73 # 62-66'),
  (21, 'Liwi Cali - San Fernando', 'Cali', 'Transversal 104 # 4-74'),
  (22, 'Liwi Cali - Ciudad Jardin', 'Cali', 'Calle 99 # 17-7'),
  (23, 'Liwi Cali - Centro', 'Cali', 'Transversal 114 # 86-14'),
  (24, 'Liwi Barranquilla - El Prado', 'Barranquilla', 'Transversal 55 # 61-19'),
  (25, 'Liwi Barranquilla - Alto Prado', 'Barranquilla', 'Diagonal 114 # 30-16'),
  (26, 'Liwi Cartagena - Bocagrande', 'Cartagena', 'Diagonal 87 # 61-92'),
  (27, 'Liwi Cartagena - Centro Historico', 'Cartagena', 'Transversal 33 # 72-52'),
  (28, 'Liwi Bucaramanga - Cabecera', 'Bucaramanga', 'Av. 71 # 83-65'),
  (29, 'Liwi Bucaramanga - Canaveral', 'Bucaramanga', 'Diagonal 104 # 52-56'),
  (30, 'Liwi Pereira - Circunvalar', 'Pereira', 'Calle 38 # 35-2'),
  (31, 'Liwi Pereira - Pinares', 'Pereira', 'Cra 20 # 84-77'),
  (32, 'Liwi Manizales - Cable', 'Manizales', 'Diagonal 103 # 67-63'),
  (33, 'Liwi Manizales - Chipre', 'Manizales', 'Av. 118 # 26-34'),
  (34, 'Liwi Cucuta - Caobos', 'Cucuta', 'Diagonal 60 # 66-99'),
  (35, 'Liwi Cucuta - Centro', 'Cucuta', 'Diagonal 104 # 56-72'),
  (36, 'Liwi Santa Marta - El Rodadero', 'Santa Marta', 'Cra 107 # 38-41'),
  (37, 'Liwi Santa Marta - Centro', 'Santa Marta', 'Diagonal 118 # 13-57'),
  (38, 'Liwi Ibague - La Pola', 'Ibague', 'Transversal 34 # 58-24'),
  (39, 'Liwi Ibague - Picalena', 'Ibague', 'Diagonal 108 # 94-62'),
  (40, 'Liwi Villavicencio - Barzal', 'Villavicencio', 'Cra 84 # 35-64'),
  (41, 'Liwi Villavicencio - Centro', 'Villavicencio', 'Av. 13 # 25-96'),
  (42, 'Liwi Pasto - Centro', 'Pasto', 'Diagonal 19 # 58-2'),
  (43, 'Liwi Neiva - Candido', 'Neiva', 'Cra 1 # 58-75'),
  (44, 'Liwi Armenia - Centenario', 'Armenia', 'Transversal 120 # 11-79'),
  (45, 'Liwi Popayan - Centro', 'Popayan', 'Calle 32 # 16-80'),
  (46, 'Liwi Monteria - Recreo', 'Monteria', 'Cra 97 # 70-35'),
  (47, 'Liwi Valledupar - Los Musicos', 'Valledupar', 'Av. 20 # 1-41'),
  (48, 'Liwi Tunja - Centro', 'Tunja', 'Transversal 74 # 99-63'),
  (49, 'Liwi Sincelejo - Centro', 'Sincelejo', 'Calle 70 # 29-61'),
  (50, 'Liwi Inirida - Centro', 'Inirida', 'Transversal 17 # 77-89');

 
-- Usuario : 60 lineas
INSERT INTO Usuario (idUsuario, nombre, correo, contrasena, rol, fechaRegistro, ultimoAcceso, intentosFallidos, bloqueado, idPuntoVenta) VALUES
  (1, 'Laura Lopez', 'laura.lopez1@liwifloreterna.co', '05b258867c5f2c2f02c00a9317dd4ae46049512a', 'Socio', '2026-06-10', '2026-08-03 18:10:00', 5, 1, NULL),
  (2, 'Miguel Ramirez', 'miguel.ramirez2@liwifloreterna.co', 'dfba12e35f13dcb008033cc6341ee93a0a30603c', 'Socio', '2025-11-19', '2026-06-07 10:33:00', 2, 0, NULL),
  (3, 'Sofia Vargas', 'sofia.vargas3@liwifloreterna.co', 'a6e070c4ba523a986501e06da525a581534f6216', 'Socio', '2025-01-24', NULL, 0, 0, NULL),
  (4, 'Daniel Moreno', 'daniel.moreno4@liwifloreterna.co', 'f59dab3e4c925f65ccd934e5904582743432bf7a', 'Socio', '2025-03-26', '2026-03-17 18:22:00', 3, 1, NULL),
  (5, 'Daniela Rincon', 'daniela.rincon5@liwifloreterna.co', '23dc037ccc0c728af78927337e577291505659a0', 'Socio', '2025-02-05', '2026-01-07 18:19:00', 0, 0, NULL),
  (6, 'David Pardo', 'david.pardo6@liwifloreterna.co', '084d364e8f1b53435fe85c8b00a72c925724c3fc', 'Socio', '2025-05-14', '2026-09-04 17:39:00', 1, 0, NULL),
  (7, 'Antonia Rodriguez', 'antonia.rodriguez7@liwifloreterna.co', 'c318f3ec2e81fa32be928e27da734d23293a8927', 'Socio', '2026-06-26', '2026-09-14 13:29:00', 0, 0, NULL),
  (8, 'Alejandro Garcia', 'alejandro.garcia8@liwifloreterna.co', '323bfba7197b009e8573f1464a6322af7f5f93fc', 'Socio', '2025-03-22', '2025-04-26 11:41:00', 3, 1, NULL),
  (9, 'Valentina Torres', 'valentina.torres9@liwifloreterna.co', '1a932cc3db4b6dc2c42776840cc8c9a8f3bb68ba', 'Socio', '2026-07-21', NULL, 0, 0, NULL),
  (10, 'Felipe Castro', 'felipe.castro10@liwifloreterna.co', '2d614e0257772f3d076fc9ac14940ac908df48f3', 'Socio', '2025-07-22', '2026-07-05 08:08:00', 0, 0, NULL),
  (11, 'Luisa Ortiz', 'luisa.ortiz11@liwifloreterna.co', '6a9a7b480c956a62a558d5f8c105575b29e1c2e3', 'Administrador', '2025-08-21', '2026-05-13 10:10:00', 0, 0, 1),
  (12, 'Esteban Mendoza', 'esteban.mendoza12@liwifloreterna.co', 'd15081c63205dbd24efd2c8088f8d61330a1e0cb', 'Administrador', '2025-07-19', '2026-02-22 16:26:00', 2, 0, 2),
  (13, 'Camila Suarez', 'camila.suarez13@liwifloreterna.co', '16f1ba412aea5df5c44d669f7e45b0de65339caf', 'Administrador', '2025-11-18', '2026-02-16 12:29:00', 0, 0, 3),
  (14, 'Sebastian Martinez', 'sebastian.martinez14@liwifloreterna.co', 'f0bb27ef61bb97d36baade3b002a7ae7907f5ce2', 'Administrador', '2026-03-11', '2026-04-26 13:33:00', 0, 0, 4),
  (15, 'Paula Hernandez', 'paula.hernandez15@liwifloreterna.co', 'de867a50fa74fbfb620d41079dea218d8c029405', 'Administrador', '2025-05-12', '2026-02-17 09:54:00', 0, 0, 5),
  (16, 'Camilo Diaz', 'camilo.diaz16@liwifloreterna.co', 'f20b86c84c2618dae59742f413e51a4823731348', 'Administrador', '2025-01-15', NULL, 2, 0, 6),
  (17, 'Catalina Rojas', 'catalina.rojas17@liwifloreterna.co', '109e075b6ff6f3a1fa6e5cdde6a0a77173447bcc', 'Administrador', '2026-03-03', '2026-10-03 18:11:00', 4, 1, 7),
  (18, 'Mateo Silva', 'mateo.silva18@liwifloreterna.co', '67fa13b5db4cfe2c29db0d987edf7e15887516c1', 'Administrador', '2025-06-19', '2026-06-06 17:50:00', 0, 0, 8),
  (19, 'Natalia Cardenas', 'natalia.cardenas19@liwifloreterna.co', 'e5431c097ad9037326e946641a922287810967dd', 'Administrador', '2025-05-02', '2026-02-14 16:48:00', 0, 0, 9),
  (20, 'Julian Gomez', 'julian.gomez20@liwifloreterna.co', 'b93de1881a1d0e6c7075d373051e46e82e2da529', 'Administrador', '2025-08-17', '2026-06-02 12:42:00', 0, 0, 10),
  (21, 'Juliana Lopez', 'juliana.lopez21@liwifloreterna.co', '840249987f93339051142b6d08cbf31d25167cb7', 'Administrador', '2025-04-23', '2025-07-31 14:10:00', 0, 0, 11),
  (22, 'Santiago Ramirez', 'santiago.ramirez22@liwifloreterna.co', 'ba0d9038af5234a9b91d0543f3030d252d0ea36b', 'Administrador', '2025-03-12', '2025-09-18 18:40:00', 0, 0, 12),
  (23, 'Carolina Vargas', 'carolina.vargas23@liwifloreterna.co', '65df0d9d798e63245d20b0f6885d23881427d6c2', 'Administrador', '2025-11-27', '2025-12-30 12:59:00', 0, 0, 13),
  (24, 'Jhonatan Moreno', 'jhonatan.moreno24@liwifloreterna.co', '269149efc0532c96cb654607674d9264ff169aed', 'Administrador', '2025-10-04', '2025-10-12 14:55:00', 4, 1, 14),
  (25, 'Manuela Rincon', 'manuela.rincon25@liwifloreterna.co', 'e3efed8584a3d0d7358cde5ed4bed95c077a5d43', 'Administrador', '2026-03-10', NULL, 0, 0, 15),
  (26, 'Juan Pardo', 'juan.pardo26@liwifloreterna.co', '336327c09d95889174f3960e2c4c076abf427d2f', 'Administrador', '2025-09-07', '2025-11-09 09:43:00', 0, 0, 16),
  (27, 'Mariana Rodriguez', 'mariana.rodriguez27@liwifloreterna.co', 'd231edf5e2205b6fafc467079247379a87fd51ef', 'Administrador', '2026-01-03', '2026-08-25 17:40:00', 0, 0, 17),
  (28, 'Nicolas Garcia', 'nicolas.garcia28@liwifloreterna.co', 'b14765a362acb3fa8856d473de2c05dda96a6adb', 'Administrador', '2025-02-17', NULL, 0, 0, 18),
  (29, 'Isabela Torres', 'isabela.torres29@liwifloreterna.co', '480fa6ec8d8ffbcb28664e408da094ea13d5a5a8', 'Administrador', '2025-08-18', '2026-03-25 18:56:00', 0, 0, 19),
  (30, 'Andres Castro', 'andres.castro30@liwifloreterna.co', 'a4b45bd9d589c2ee9aa04ee7636b024be9605568', 'Administrador', '2026-01-28', NULL, 0, 0, 20),
  (31, 'Laura Ortiz', 'laura.ortiz31@liwifloreterna.co', 'a7e58ca5911b7f06bb30e53e9ef6800e22f855d1', 'Administrador', '2025-09-24', '2026-03-26 08:47:00', 1, 0, 21),
  (32, 'Miguel Mendoza', 'miguel.mendoza32@liwifloreterna.co', 'aea03bc507b97e21f4ecd859c86c7e2ffff7a475', 'Administrador', '2025-10-25', '2026-03-23 09:19:00', 2, 0, 22),
  (33, 'Sofia Suarez', 'sofia.suarez33@liwifloreterna.co', 'eb80c3877a6fd0fa770a835dd6cc47e4f4a4e291', 'Administrador', '2026-09-01', NULL, 0, 0, 23),
  (34, 'Daniel Martinez', 'daniel.martinez34@liwifloreterna.co', '8f81c9a395d6ae6526e96038a7354a3f9aa4fa8d', 'Administrador', '2025-12-26', '2026-01-24 09:10:00', 0, 0, 24),
  (35, 'Daniela Hernandez', 'daniela.hernandez35@liwifloreterna.co', '4f3ce6552d5b9885f3501e689330c0d85db0f8ee', 'Administrador', '2025-05-11', '2026-05-09 17:41:00', 4, 1, 25),
  (36, 'David Diaz', 'david.diaz36@liwifloreterna.co', '90dedf57f3a1e7f449c96f0abbb5e30a6e7021d0', 'Administrador', '2025-02-08', '2025-06-18 13:26:00', 0, 0, 26),
  (37, 'Antonia Rojas', 'antonia.rojas37@liwifloreterna.co', 'c7156742332d55cb5eb5ee15eaef84d5de8815d8', 'Administrador', '2025-09-12', '2026-08-18 11:49:00', 0, 0, 27),
  (38, 'Alejandro Silva', 'alejandro.silva38@liwifloreterna.co', '045d4cdcacf35edd61888215aa862fd77b93bce7', 'Administrador', '2026-07-19', '2026-09-27 18:35:00', 0, 0, 28),
  (39, 'Valentina Cardenas', 'valentina.cardenas39@liwifloreterna.co', 'bbe23690c49cdb8da4834054f8f34b6e4066fbc1', 'Administrador', '2025-09-28', '2026-01-23 08:01:00', 0, 0, 29),
  (40, 'Felipe Gomez', 'felipe.gomez40@liwifloreterna.co', '3868d85f029d4b0efdd7617855faf049f4125d4d', 'Administrador', '2026-05-15', '2026-08-04 10:40:00', 0, 0, 30),
  (41, 'Luisa Lopez', 'luisa.lopez41@liwifloreterna.co', 'd1725d3cb5dc6bc45322bb642245f25fa00ecd61', 'Administrador', '2025-07-12', '2026-06-10 16:52:00', 0, 0, 31),
  (42, 'Esteban Ramirez', 'esteban.ramirez42@liwifloreterna.co', '18ee55f1c43fb9699c84c77f630563bec9dedf6a', 'Administrador', '2026-06-26', '2026-08-06 08:42:00', 1, 0, 32),
  (43, 'Camila Vargas', 'camila.vargas43@liwifloreterna.co', '15d63988d6ebf94916bec37bfe9ca3574fa00596', 'Administrador', '2026-05-06', '2026-07-02 18:32:00', 2, 0, 33),
  (44, 'Sebastian Moreno', 'sebastian.moreno44@liwifloreterna.co', '42becb393321a5b7b61d234af2d50f471ca58d08', 'Administrador', '2026-01-13', NULL, 0, 0, 34),
  (45, 'Paula Rincon', 'paula.rincon45@liwifloreterna.co', '0e3b5be0b447ef8fa899bc6343eb89ed6dafab93', 'Administrador', '2025-10-19', '2026-01-30 13:22:00', 0, 0, 35),
  (46, 'Camilo Pardo', 'camilo.pardo46@liwifloreterna.co', 'c7922780e10fdfb3cee83d841a257432867557e6', 'Administrador', '2026-04-23', '2026-08-23 18:37:00', 0, 0, 36),
  (47, 'Catalina Rodriguez', 'catalina.rodriguez47@liwifloreterna.co', '391da8efe4817eabed608c006995ffcde5ee5e2c', 'Administrador', '2025-06-21', '2025-09-08 15:57:00', 0, 0, 37),
  (48, 'Mateo Garcia', 'mateo.garcia48@liwifloreterna.co', '1fdceed999dc54c7adc2ce6fc39c36ebde403b59', 'Administrador', '2026-01-07', '2026-10-02 14:50:00', 0, 0, 38),
  (49, 'Natalia Torres', 'natalia.torres49@liwifloreterna.co', 'fba000ef80204e814fe8915066c8be736073a736', 'Administrador', '2025-07-05', '2026-01-12 16:46:00', 0, 0, 39),
  (50, 'Julian Castro', 'julian.castro50@liwifloreterna.co', 'f69e7620d15d6d5ec5bda04b619323b2da85603a', 'Administrador', '2025-04-23', NULL, 0, 0, 40),
  (51, 'Juliana Ortiz', 'juliana.ortiz51@liwifloreterna.co', '513edc59748337113f121abc756049de5bfaa9a6', 'Administrador', '2025-08-20', '2026-08-12 17:19:00', 0, 0, 41),
  (52, 'Santiago Mendoza', 'santiago.mendoza52@liwifloreterna.co', '1bce6f47646fe6b9a06797a367edccd243004bfd', 'Administrador', '2026-02-16', '2026-06-29 18:42:00', 0, 0, 42),
  (53, 'Carolina Suarez', 'carolina.suarez53@liwifloreterna.co', 'e145c7ec5b91e8ee06ce35d59df4c419e3968394', 'Administrador', '2026-06-14', '2026-07-03 14:21:00', 0, 0, 43),
  (54, 'Jhonatan Martinez', 'jhonatan.martinez54@liwifloreterna.co', '14444993de56482801e722f503d6a09da1f76c11', 'Administrador', '2025-11-23', '2026-09-23 18:50:00', 0, 0, 44),
  (55, 'Manuela Hernandez', 'manuela.hernandez55@liwifloreterna.co', '3778d9cfb009ad69bd8bd8a2774d69fbd045bd3c', 'Administrador', '2025-11-05', '2026-04-01 13:08:00', 3, 1, 45),
  (56, 'Juan Diaz', 'juan.diaz56@liwifloreterna.co', 'd32b524c5dd8b8647b24381f480cf5b560d80ea5', 'Administrador', '2025-01-19', '2026-05-26 14:22:00', 1, 0, 46),
  (57, 'Mariana Rojas', 'mariana.rojas57@liwifloreterna.co', '709a531228cf0366e5fbea3eb08d13b679accbff', 'Administrador', '2026-06-22', '2026-08-02 16:09:00', 0, 0, 47),
  (58, 'Nicolas Silva', 'nicolas.silva58@liwifloreterna.co', 'a2247ce761ac167e8bd308b5f6d0739516b336fe', 'Administrador', '2025-05-09', '2025-05-12 13:04:00', 0, 0, 48),
  (59, 'Isabela Cardenas', 'isabela.cardenas59@liwifloreterna.co', 'aeedad9d523dfd0ffb756c3ab76c603fccf8f48a', 'Administrador', '2025-08-19', '2026-06-22 17:15:00', 0, 0, 49),
  (60, 'Andres Gomez', 'andres.gomez60@liwifloreterna.co', '0592a10b4c12295579f01b821fb0487b08b49564', 'Administrador', '2025-12-10', '2026-01-17 14:16:00', 0, 0, 50);

 
-- Cliente : 60 lineas
INSERT INTO Cliente (idCliente, nombreCliente, direccion, activo, tipoCliente) VALUES
  (1, 'Floristeria Aurora', 'Av. 61 # 64-16, Cartagena', 1, 'B2B'),
  (2, 'Eventos Montecarlo', 'Av. 88 # 59-75, Medellin', 1, 'B2B'),
  (3, 'Hotel Casa Real', 'Cra 104 # 64-40, Bogota', 1, 'B2B'),
  (4, 'Decoraciones Lirio', 'Calle 22 # 42-56, Barranquilla', 1, 'B2B'),
  (5, 'Boutique Nube', 'Av. 117 # 93-85, Cali', 1, 'B2B'),
  (6, 'Bodas Cielo Azul', 'Calle 26 # 60-29, Santa Marta', 1, 'B2B'),
  (7, 'Cafe Jardin Secreto', 'Av. 53 # 76-49, Bogota', 0, 'B2B'),
  (8, 'Restaurante El Tallo', 'Transversal 85 # 95-17, Cali', 1, 'B2B'),
  (9, 'Regalos Primavera', 'Cra 41 # 35-57, Bogota', 1, 'B2B'),
  (10, 'Spa Agua Viva', 'Av. 30 # 43-19, Cartagena', 1, 'B2B'),
  (11, 'Eventos Santa Clara', 'Av. 38 # 74-59, Manizales', 1, 'B2B'),
  (12, 'Hotel Boutique Luna', 'Cra 71 # 92-43, Cucuta', 1, 'B2B'),
  (13, 'Floral Studio Bogota', 'Cra 87 # 99-64, Cucuta', 1, 'B2B'),
  (14, 'Decora & Celebra', 'Transversal 67 # 27-55, Medellin', 1, 'B2B'),
  (15, 'Detalles del Alma', 'Cra 119 # 52-93, Bogota', 1, 'B2B'),
  (16, 'Bodas y Suenos', 'Transversal 90 # 33-17, Medellin', 1, 'B2B'),
  (17, 'Cafeteria La Orquidea', 'Transversal 54 # 61-62, Medellin', 1, 'B2B'),
  (18, 'Hotel Sabana Real', 'Calle 82 # 16-85, Bogota', 1, 'B2B'),
  (19, 'Eventos Altamira', 'Calle 102 # 59-66, Bogota', 1, 'B2B'),
  (20, 'Regalos El Condor', 'Av. 11 # 72-89, Bogota', 1, 'B2B'),
  (21, 'Arte Floral Zipa', 'Cra 13 # 20-43, Bogota', 1, 'B2B'),
  (22, 'Clinica Estetica Lis', 'Calle 78 # 87-22, Santa Marta', 0, 'B2B'),
  (23, 'Oficinas Torre Norte', 'Transversal 54 # 92-67, Cucuta', 1, 'B2B'),
  (24, 'Hotel Campestre Sol', 'Calle 14 # 4-35, Cali', 1, 'B2B'),
  (25, 'Banquetes Don Mario', 'Transversal 94 # 66-30, Cali', 1, 'B2B'),
  (26, 'Nicolas Ortiz', 'Av. 44 # 45-41, Pereira', 1, 'B2C'),
  (27, 'Juliana Pardo', 'Diagonal 114 # 42-33, Bogota', 1, 'B2C'),
  (28, 'Sebastian Lopez', 'Calle 3 # 62-47, Bogota', 1, 'B2C'),
  (29, 'Antonia Diaz', 'Diagonal 26 # 48-36, Barranquilla', 1, 'B2C'),
  (30, 'Andres Ortiz', 'Diagonal 39 # 28-75, Bogota', 1, 'B2C'),
  (31, 'Carolina Pardo', 'Cra 93 # 93-83, Cucuta', 1, 'B2C'),
  (32, 'Camilo Lopez', 'Transversal 99 # 39-62, Pereira', 1, 'B2C'),
  (33, 'Valentina Diaz', 'Transversal 67 # 77-42, Cali', 1, 'B2C'),
  (34, 'Miguel Ortiz', 'Av. 47 # 24-10, Cartagena', 1, 'B2C'),
  (35, 'Manuela Pardo', 'Calle 98 # 33-68, Barranquilla', 1, 'B2C'),
  (36, 'Mateo Lopez', 'Cra 119 # 78-28, Bogota', 1, 'B2C'),
  (37, 'Luisa Diaz', 'Calle 55 # 66-68, Bogota', 1, 'B2C'),
  (38, 'Daniel Ortiz', 'Av. 100 # 92-63, Bogota', 1, 'B2C'),
  (39, 'Mariana Pardo', 'Av. 47 # 84-51, Cartagena', 1, 'B2C'),
  (40, 'Julian Lopez', 'Transversal 25 # 20-78, Cartagena', 1, 'B2C'),
  (41, 'Camila Diaz', 'Calle 94 # 19-17, Pasto', 1, 'B2C'),
  (42, 'David Ortiz', 'Transversal 8 # 86-5, Bogota', 1, 'B2C'),
  (43, 'Isabela Pardo', 'Calle 18 # 35-70, Santa Marta', 1, 'B2C'),
  (44, 'Santiago Lopez', 'Diagonal 22 # 24-89, Bogota', 1, 'B2C'),
  (45, 'Paula Diaz', 'Calle 53 # 83-80, Cali', 1, 'B2C'),
  (46, 'Alejandro Ortiz', 'Cra 39 # 29-66, Medellin', 0, 'B2C'),
  (47, 'Laura Pardo', 'Cra 60 # 88-96, Cali', 0, 'B2C'),
  (48, 'Jhonatan Lopez', 'Av. 19 # 92-66, Bogota', 1, 'B2C'),
  (49, 'Catalina Diaz', 'Cra 13 # 46-76, Santa Marta', 1, 'B2C'),
  (50, 'Felipe Ortiz', 'Av. 43 # 97-4, Bogota', 1, 'B2C'),
  (51, 'Sofia Pardo', 'Cra 55 # 85-56, Bogota', 1, 'B2C'),
  (52, 'Juan Lopez', 'Calle 31 # 29-85, Cali', 1, 'B2C'),
  (53, 'Natalia Diaz', 'Calle 69 # 55-93, Cali', 1, 'B2C'),
  (54, 'Esteban Ortiz', 'Av. 91 # 27-40, Manizales', 1, 'B2C'),
  (55, 'Daniela Pardo', 'Transversal 78 # 62-12, Bogota', 1, 'B2C'),
  (56, 'Nicolas Lopez', 'Cra 97 # 11-46, Santa Marta', 1, 'B2C'),
  (57, 'Juliana Diaz', 'Calle 15 # 23-27, Manizales', 1, 'B2C'),
  (58, 'Sebastian Ortiz', 'Diagonal 4 # 71-19, Manizales', 1, 'B2C'),
  (59, 'Antonia Pardo', 'Av. 37 # 95-47, Medellin', 0, 'B2C'),
  (60, 'Andres Lopez', 'Transversal 59 # 35-46, Cali', 1, 'B2C');


-- Telefono : 82 linas
INSERT INTO Telefono (idTelefono, idCliente, numeroTelefono) VALUES
  (1, 1, '6012128357'),
  (2, 2, '6016990854'),
  (3, 3, '6011775888'),
  (4, 4, '6011440190'),
  (5, 5, '6011879169'),
  (6, 6, '6017978025'),
  (7, 7, '6012016128'),
  (8, 8, '6014001981'),
  (9, 9, '6015247357'),
  (10, 10, '6013638560'),
  (11, 11, '6017392731'),
  (12, 12, '6019796780'),
  (13, 13, '6017360872'),
  (14, 14, '6014385469'),
  (15, 15, '6010598281'),
  (16, 16, '6019539182'),
  (17, 17, '6017611660'),
  (18, 18, '6013304284'),
  (19, 19, '6015142038'),
  (20, 20, '6011780578'),
  (21, 21, '6010370412'),
  (22, 22, '6011430490'),
  (23, 23, '6017418288'),
  (24, 24, '6019837085'),
  (25, 25, '6013867130'),
  (26, 26, '3006681792'),
  (27, 27, '3103283856'),
  (28, 28, '3122710512'),
  (29, 29, '3208372527'),
  (30, 30, '3161206176'),
  (31, 31, '3219585190'),
  (32, 32, '3214316349'),
  (33, 33, '3219924800'),
  (34, 34, '3132791372'),
  (35, 35, '3208711209'),
  (36, 36, '3164264079'),
  (37, 37, '3122607911'),
  (38, 38, '3115716477'),
  (39, 39, '3124796745'),
  (40, 40, '3101980334'),
  (41, 41, '3143521362'),
  (42, 42, '3205863984'),
  (43, 43, '3168645732'),
  (44, 44, '3164093426'),
  (45, 45, '3219276709'),
  (46, 46, '3120985846'),
  (47, 47, '3118849855'),
  (48, 48, '3148306866'),
  (49, 49, '3205389650'),
  (50, 50, '3013327967'),
  (51, 51, '3106835081'),
  (52, 52, '3011361795'),
  (53, 53, '3218163540'),
  (54, 54, '3011527611'),
  (55, 55, '3118759211'),
  (56, 56, '3133277186'),
  (57, 57, '3101076177'),
  (58, 58, '3007751062'),
  (59, 59, '3141488361'),
  (60, 60, '3132029944'),
  (61, 50, '3208286408'),
  (62, 52, '3204874643'),
  (63, 28, '3207258444'),
  (64, 51, '3019303995'),
  (65, 7, '3131566979'),
  (66, 45, '3141567959'),
  (67, 15, '3145056547'),
  (68, 24, '3005670904'),
  (69, 49, '3168015646'),
  (70, 5, '3124033013'),
  (71, 27, '3100598719'),
  (72, 41, '3168904216'),
  (73, 6, '3111111960'),
  (74, 37, '3107804658'),
  (75, 40, '3217306424'),
  (76, 17, '3218296017'),
  (77, 21, '3206772041'),
  (78, 58, '3106347892'),
  (79, 46, '3115240137'),
  (80, 38, '3141561059'),
  (81, 20, '3211483354'),
  (82, 54, '3014881813');


-- Categoria : 50 lineas
INSERT INTO Categoria (idCategoria, nombreCategoria, descripcion, umbralRentabilidad) VALUES
  (1, 'Inirida natural - Premium', 'Productos de inirida natural con desempeno premium', 45.00),
  (2, 'Inirida natural - Alta', 'Productos de inirida natural con desempeno alta', 35.00),
  (3, 'Inirida natural - Media', 'Productos de inirida natural con desempeno media', 25.00),
  (4, 'Inirida natural - Basica', 'Productos de inirida natural con desempeno basica', 15.00),
  (5, 'Inirida natural - Minima', 'Productos de inirida natural con desempeno minima', 8.00),
  (6, 'Inirida tenida - Premium', 'Productos de inirida tenida con desempeno premium', 45.50),
  (7, 'Inirida tenida - Alta', NULL, 35.50),
  (8, 'Inirida tenida - Media', 'Productos de inirida tenida con desempeno media', 25.50),
  (9, 'Inirida tenida - Basica', 'Productos de inirida tenida con desempeno basica', 15.50),
  (10, 'Inirida tenida - Minima', 'Productos de inirida tenida con desempeno minima', 8.50),
  (11, 'Follaje - Premium', 'Productos de follaje con desempeno premium', 46.00),
  (12, 'Follaje - Alta', 'Productos de follaje con desempeno alta', 36.00),
  (13, 'Follaje - Media', 'Productos de follaje con desempeno media', 26.00),
  (14, 'Follaje - Basica', NULL, 16.00),
  (15, 'Follaje - Minima', 'Productos de follaje con desempeno minima', 9.00),
  (16, 'Cajas - Premium', 'Productos de cajas con desempeno premium', 46.50),
  (17, 'Cajas - Alta', 'Productos de cajas con desempeno alta', 36.50),
  (18, 'Cajas - Media', 'Productos de cajas con desempeno media', 26.50),
  (19, 'Cajas - Basica', 'Productos de cajas con desempeno basica', 16.50),
  (20, 'Cajas - Minima', 'Productos de cajas con desempeno minima', 9.50),
  (21, 'Empaques - Premium', NULL, 47.00),
  (22, 'Empaques - Alta', 'Productos de empaques con desempeno alta', 37.00),
  (23, 'Empaques - Media', 'Productos de empaques con desempeno media', 27.00),
  (24, 'Empaques - Basica', 'Productos de empaques con desempeno basica', 17.00),
  (25, 'Empaques - Minima', 'Productos de empaques con desempeno minima', 10.00),
  (26, 'Tarjetas - Premium', 'Productos de tarjetas con desempeno premium', 47.50),
  (27, 'Tarjetas - Alta', 'Productos de tarjetas con desempeno alta', 37.50),
  (28, 'Tarjetas - Media', NULL, 27.50),
  (29, 'Tarjetas - Basica', 'Productos de tarjetas con desempeno basica', 17.50),
  (30, 'Tarjetas - Minima', 'Productos de tarjetas con desempeno minima', 10.50),
  (31, 'Decoracion - Premium', 'Productos de decoracion con desempeno premium', 48.00),
  (32, 'Decoracion - Alta', 'Productos de decoracion con desempeno alta', 38.00),
  (33, 'Decoracion - Media', 'Productos de decoracion con desempeno media', 28.00),
  (34, 'Decoracion - Basica', 'Productos de decoracion con desempeno basica', 18.00),
  (35, 'Decoracion - Minima', NULL, 11.00),
  (36, 'Arreglos - Premium', 'Productos de arreglos con desempeno premium', 48.50),
  (37, 'Arreglos - Alta', 'Productos de arreglos con desempeno alta', 38.50),
  (38, 'Arreglos - Media', 'Productos de arreglos con desempeno media', 28.50),
  (39, 'Arreglos - Basica', 'Productos de arreglos con desempeno basica', 18.50),
  (40, 'Arreglos - Minima', 'Productos de arreglos con desempeno minima', 11.50),
  (41, 'Kits - Premium', 'Productos de kits con desempeno premium', 49.00),
  (42, 'Kits - Alta', NULL, 39.00),
  (43, 'Kits - Media', 'Productos de kits con desempeno media', 29.00),
  (44, 'Kits - Basica', 'Productos de kits con desempeno basica', 19.00),
  (45, 'Kits - Minima', 'Productos de kits con desempeno minima', 12.00),
  (46, 'Insumos - Premium', 'Productos de insumos con desempeno premium', 49.50),
  (47, 'Insumos - Alta', 'Productos de insumos con desempeno alta', 39.50),
  (48, 'Insumos - Media', 'Productos de insumos con desempeno media', 29.50),
  (49, 'Insumos - Basica', NULL, 19.50),
  (50, 'Insumos - Minima', 'Productos de insumos con desempeno minima', 12.50);


-- Proveedor : 50 lineas
INSERT INTO Proveedor (idProveedor, nombreProveedor, tipoInsumo, contacto) VALUES
  (1, 'Agroflores Sabana S.A.S.', 'Flor de Inirida', 'ventas1@agroflores.com.co'),
  (2, 'Agroflores Amazonia S.A.S.', 'Flor de Inirida', 'ventas2@agroflores.com.co'),
  (3, 'Agroflores Cundinamarca S.A.S.', 'Flor de Inirida', 'ventas3@agroflores.com.co'),
  (4, 'Agroflores El Dorado S.A.S.', 'Flor de Inirida', NULL),
  (5, 'Agroflores Andina S.A.S.', 'Flor de Inirida', 'ventas5@agroflores.com.co'),
  (6, 'Comercializadora Sabana S.A.S.', 'Flor de Inirida', '3101929480'),
  (7, 'Comercializadora Cundinamarca S.A.S.', 'Flor de Inirida', '3103470424'),
  (8, 'Comercializadora Orinoquia S.A.S.', 'Flor de Inirida', 'ventas8@comercializadora.com.co'),
  (9, 'Comercializadora Andina S.A.S.', 'Flor de Inirida', '3201341461'),
  (10, 'Comercializadora El Dorado S.A.S.', 'Flor de Inirida', 'ventas10@comercializadora.com.co'),
  (11, 'Cooperativa Santafe S.A.S.', 'Flor de Inirida', '3106133800'),
  (12, 'Cooperativa Pacifico S.A.S.', 'Flor de Inirida', '3000514786'),
  (13, 'Cooperativa Nacional S.A.S.', 'Flor de Inirida', '3209305977'),
  (14, 'Cooperativa Cundinamarca S.A.S.', 'Flor de Inirida', '3005538488'),
  (15, 'Cooperativa del Guainia S.A.S.', 'Flor de Inirida', 'ventas15@cooperativa.com.co'),
  (16, 'Viveros El Dorado S.A.S.', 'Follaje', '3006709072'),
  (17, 'Viveros Amazonia S.A.S.', 'Follaje', '3106151413'),
  (18, 'Viveros Andina S.A.S.', 'Follaje', 'ventas18@viveros.com.co'),
  (19, 'Viveros Cundinamarca S.A.S.', 'Follaje', '3103701087'),
  (20, 'Viveros Pacifico S.A.S.', 'Follaje', 'ventas20@viveros.com.co'),
  (21, 'Cartonera El Dorado S.A.S.', 'Cajas y empaques', 'ventas21@cartonera.com.co'),
  (22, 'Cartonera Nacional S.A.S.', 'Cajas y empaques', 'ventas22@cartonera.com.co'),
  (23, 'Cartonera Orinoquia S.A.S.', 'Cajas y empaques', 'ventas23@cartonera.com.co'),
  (24, 'Cartonera Cundinamarca S.A.S.', 'Cajas y empaques', 'ventas24@cartonera.com.co'),
  (25, 'Cartonera Santafe S.A.S.', 'Cajas y empaques', 'ventas25@cartonera.com.co'),
  (26, 'Empaques El Dorado S.A.S.', 'Cajas y empaques', '3009899745'),
  (27, 'Empaques Orinoquia S.A.S.', 'Cajas y empaques', '3005813421'),
  (28, 'Empaques Andina S.A.S.', 'Cajas y empaques', 'ventas28@empaques.com.co'),
  (29, 'Empaques Amazonia S.A.S.', 'Cajas y empaques', 'ventas29@empaques.com.co'),
  (30, 'Empaques Pacifico S.A.S.', 'Cajas y empaques', '3109677044'),
  (31, 'Papeleria Andina S.A.S.', 'Tarjetas y papeleria', 'ventas31@papeleria.com.co'),
  (32, 'Papeleria del Guainia S.A.S.', 'Tarjetas y papeleria', '3108865611'),
  (33, 'Papeleria Santafe S.A.S.', 'Tarjetas y papeleria', '3101082359'),
  (34, 'Papeleria El Dorado S.A.S.', 'Tarjetas y papeleria', '3004940429'),
  (35, 'Papeleria Orinoquia S.A.S.', 'Tarjetas y papeleria', '3104781824'),
  (36, 'Distribuidora Santafe S.A.S.', 'Cintas y accesorios', '3205680801'),
  (37, 'Distribuidora El Dorado S.A.S.', 'Cintas y accesorios', NULL),
  (38, 'Distribuidora del Guainia S.A.S.', 'Cintas y accesorios', NULL),
  (39, 'Distribuidora Andina S.A.S.', 'Cintas y accesorios', '3205200700'),
  (40, 'Distribuidora Orinoquia S.A.S.', 'Cintas y accesorios', 'ventas40@distribuidora.com.co'),
  (41, 'Insumos Andina S.A.S.', 'Insumos de conservacion', NULL),
  (42, 'Insumos Sabana S.A.S.', 'Insumos de conservacion', 'ventas42@insumos.com.co'),
  (43, 'Insumos del Guainia S.A.S.', 'Insumos de conservacion', 'ventas43@insumos.com.co'),
  (44, 'Insumos Pacifico S.A.S.', 'Insumos de conservacion', 'ventas44@insumos.com.co'),
  (45, 'Insumos Santafe S.A.S.', 'Insumos de conservacion', NULL),
  (46, 'Importadora del Guainia S.A.S.', 'Floreros y bases', 'ventas46@importadora.com.co'),
  (47, 'Importadora Santafe S.A.S.', 'Floreros y bases', '3106114635'),
  (48, 'Importadora Sabana S.A.S.', 'Floreros y bases', NULL),
  (49, 'Importadora Orinoquia S.A.S.', 'Floreros y bases', NULL),
  (50, 'Importadora Cundinamarca S.A.S.', 'Floreros y bases', NULL);


-- Producto : 60 lineas
INSERT INTO Producto (idProducto, idCategoria, idProveedor, nombreProducto, costoUnitario, unidadMedida, activo) VALUES
  (1, 36, NULL, 'Bouquet novia Inirida', 153500.00, 'unidad', 1),
  (2, 14, NULL, 'Follaje helecho cuero (tallo)', 1800.00, 'tallo', 1),
  (3, 23, 38, 'Bolsa de regalo', 1550.00, 'unidad', 1),
  (4, 23, 37, 'Cono de papel', 1700.00, 'unidad', 1),
  (5, 21, 40, 'Papel kraft (pliego)', 1350.00, 'unidad', 1),
  (6, 20, 25, 'Caja kraft mediana', 3300.00, 'unidad', 1),
  (7, 1, 15, 'Ramo 20 Inirida dorada', 53000.00, 'ramo', 1),
  (8, 3, 14, 'Tallo Inirida blanca', 2800.00, 'tallo', 1),
  (9, 10, 13, 'Caja regalo Inirida tenida azul', 70800.00, 'caja', 1),
  (10, 1, 3, 'Caja regalo Inirida blanca', 81350.00, 'caja', 0),
  (11, 38, 12, 'Mini arreglo Inirida escritorio', 85050.00, 'caja', 1),
  (12, 13, 19, 'Follaje hojas de aralia (ramo)', 6200.00, 'ramo', 1),
  (13, 12, 20, 'Follaje gypsophila (tallo)', 1600.00, 'tallo', 1),
  (14, 32, 46, 'Base de ceramica', 16950.00, 'unidad', 1),
  (15, 8, 5, 'Ramo 10 Inirida tenida rosada', 32750.00, 'ramo', 1),
  (16, 31, NULL, 'Florero de vidrio', 42300.00, 'unidad', 1),
  (17, 2, 3, 'Ramo 10 Inirida dorada', 32000.00, 'ramo', 1),
  (18, 12, 17, 'Follaje ficus (ramo)', 11950.00, 'ramo', 1),
  (19, 18, 28, 'Caja negra premium', 11650.00, 'unidad', 1),
  (20, 26, NULL, 'Tarjeta aniversario', 1650.00, 'unidad', 1),
  (21, 27, NULL, 'Tarjeta amor', 1000.00, 'unidad', 1),
  (22, 17, NULL, 'Caja kraft pequena', 1600.00, 'unidad', 1),
  (23, 7, 10, 'Ramo 20 Inirida tenida roja', 57150.00, 'ramo', 1),
  (24, 30, 34, 'Tarjeta condolencias', 1150.00, 'unidad', 1),
  (25, 27, 31, 'Tarjeta cumpleanos', 1350.00, 'unidad', 1),
  (26, 10, NULL, 'Tallo Inirida tenida azul', 3200.00, 'tallo', 1),
  (27, 14, 19, 'Follaje eucalipto (tallo)', 1550.00, 'tallo', 1),
  (28, 13, 16, 'Follaje ficus (tallo)', 2350.00, 'tallo', 1),
  (29, 16, 24, 'Caja kraft grande', 7050.00, 'unidad', 1),
  (30, 2, 1, 'Tallo Inirida dorada', 3350.00, 'tallo', 1),
  (31, 3, 13, 'Ramo 10 Inirida natural', 28500.00, 'ramo', 1),
  (32, 22, NULL, 'Caja de madera mini', 9750.00, 'unidad', 1),
  (33, 13, 16, 'Follaje ruscus (ramo)', 6200.00, 'ramo', 1),
  (34, 7, 12, 'Tallo Inirida tenida rosada', 2800.00, 'tallo', 1),
  (35, 22, 38, 'Cinta satinada', 1400.00, 'unidad', 1),
  (36, 39, 10, 'Corona Inirida', 179000.00, 'unidad', 0),
  (37, 38, 7, 'Arreglo de mesa Inirida', 129600.00, 'unidad', 1),
  (38, 6, 12, 'Caja regalo Inirida tenida rosada', 64100.00, 'caja', 1),
  (39, 3, 12, 'Ramo 20 Inirida blanca', 50550.00, 'ramo', 1),
  (40, 3, 8, 'Ramo 10 Inirida blanca', 32650.00, 'ramo', 1),
  (41, 10, 1, 'Ramo 20 Inirida tenida azul', 60950.00, 'ramo', 1),
  (42, 11, 19, 'Follaje hojas de aralia (tallo)', 1300.00, 'tallo', 1),
  (43, 12, 19, 'Follaje ruscus (tallo)', 1950.00, 'tallo', 1),
  (44, 9, 10, 'Ramo 10 Inirida tenida azul', 23150.00, 'ramo', 1),
  (45, 14, 19, 'Follaje helecho cuero (ramo)', 13100.00, 'ramo', 1),
  (46, 6, 8, 'Tallo Inirida tenida roja', 4150.00, 'tallo', 0),
  (47, 13, NULL, 'Follaje eucalipto (ramo)', 9150.00, 'ramo', 1),
  (48, 6, 8, 'Ramo 20 Inirida tenida rosada', 62250.00, 'ramo', 0),
  (49, 42, 42, 'Kit de cuidado flor eterna', 19400.00, 'unidad', 1),
  (50, 28, 35, 'Tarjeta gracias', 2400.00, 'unidad', 1),
  (51, 33, NULL, 'Jarron de mimbre', 28650.00, 'unidad', 1),
  (52, 10, 7, 'Ramo 10 Inirida tenida roja', 28400.00, 'ramo', 1),
  (53, 17, 28, 'Caja con ventana', 6350.00, 'unidad', 1),
  (54, 2, 15, 'Tallo Inirida natural', 3600.00, 'tallo', 1),
  (55, 2, 8, 'Caja regalo Inirida dorada', 94600.00, 'caja', 1),
  (56, 33, 49, 'Spray conservante', 13650.00, 'unidad', 1),
  (57, 3, 1, 'Caja regalo Inirida natural', 75000.00, 'caja', 1),
  (58, 4, 3, 'Ramo 20 Inirida natural', 62200.00, 'ramo', 0),
  (59, 8, 6, 'Caja regalo Inirida tenida roja', 90450.00, 'caja', 1),
  (60, 15, 16, 'Follaje gypsophila (ramo)', 11750.00, 'ramo', 0);

 
-- Inventario : 60 lineas
INSERT INTO Inventario (idInventario, idProducto, idPuntoVenta, estado, stockActual, stockMinimo, stockMaximo) VALUES
  (1, 1, 8, 'Disponible', 231, 29, 250),
  (2, 2, 15, 'Disponible', 28, 20, 200),
  (3, 3, 22, 'Disponible', 53, 10, 250),
  (4, 4, 29, 'Agotado', 0, 5, 200),
  (5, 5, 36, 'Disponible', 225, 7, 300),
  (6, 6, 43, 'Disponible', 91, 24, 120),
  (7, 7, 50, 'Bajo', 8, 13, 150),
  (8, 8, 7, 'Agotado', 0, 21, 120),
  (9, 9, 14, 'Disponible', 96, 17, 300),
  (10, 10, 21, 'Bajo', 8, 13, 150),
  (11, 11, 28, 'Bajo', 26, 29, 200),
  (12, 12, 35, 'Bajo', 7, 17, 150),
  (13, 13, 42, 'Disponible', 121, 8, 200),
  (14, 14, 49, 'Bajo', 10, 19, 250),
  (15, 15, 6, 'Bajo', 2, 7, 300),
  (16, 16, 13, 'Bajo', 21, 29, 150),
  (17, 17, 20, 'Disponible', 131, 30, 250),
  (18, 18, 27, 'Disponible', 42, 19, 120),
  (19, 19, 34, 'Disponible', 155, 7, 250),
  (20, 20, 41, 'Bajo', 1, 6, 120),
  (21, 21, 48, 'Disponible', 212, 9, 300),
  (22, 22, 5, 'Disponible', 62, 21, 200),
  (23, 23, 12, 'Disponible', 67, 10, 200),
  (24, 24, 19, 'Disponible', 37, 21, 120),
  (25, 25, 26, 'Bajo', 8, 10, 250),
  (26, 26, 33, 'Disponible', 40, 7, 150),
  (27, 27, 40, 'Disponible', 217, 25, 300),
  (28, 28, 47, 'Bajo', 8, 9, 250),
  (29, 29, 4, 'Bajo', 6, 14, 120),
  (30, 30, 11, 'Disponible', 141, 20, 250),
  (31, 31, 18, 'Disponible', 64, 8, 200),
  (32, 32, 25, 'Bajo', 14, 14, 150),
  (33, 33, 32, 'Disponible', 64, 30, 100),
  (34, 34, 39, 'Disponible', 25, 15, 100),
  (35, 35, 46, 'Bajo', 7, 7, 150),
  (36, 36, 3, 'Agotado', 0, 14, 200),
  (37, 37, 10, 'Disponible', 186, 23, 200),
  (38, 38, 17, 'Bajo', 2, 22, 150),
  (39, 39, 24, 'Disponible', 188, 5, 200),
  (40, 40, 31, 'Agotado', 0, 21, 150),
  (41, 41, 38, 'Agotado', 0, 14, 250),
  (42, 42, 45, 'Bajo', 2, 5, 100),
  (43, 43, 2, 'Disponible', 74, 7, 150),
  (44, 44, 9, 'Agotado', 0, 29, 300),
  (45, 45, 16, 'Disponible', 93, 27, 120),
  (46, 46, 23, 'Disponible', 82, 28, 100),
  (47, 47, 30, 'Agotado', 0, 7, 100),
  (48, 48, 37, 'Disponible', 241, 8, 250),
  (49, 49, 44, 'Disponible', 162, 15, 300),
  (50, 50, 1, 'Bajo', 6, 13, 150),
  (51, 51, 8, 'Disponible', 98, 8, 150),
  (52, 52, 15, 'Bajo', 21, 28, 300),
  (53, 53, 22, 'Disponible', 32, 25, 120),
  (54, 54, 29, 'Bajo', 19, 26, 120),
  (55, 55, 36, 'Disponible', 50, 28, 100),
  (56, 56, 43, 'Disponible', 90, 25, 100),
  (57, 57, 50, 'Agotado', 0, 24, 300),
  (58, 58, 7, 'Bajo', 3, 23, 250),
  (59, 59, 14, 'Bajo', 16, 30, 150),
  (60, 60, 21, 'Bajo', 13, 25, 120);


-- Pedido : 60 lineas
INSERT INTO Pedido (idPedido, idCliente, idPuntoVenta, idUsuario, fechaPedido, fechaEntrega, tipoEmpaque, follaje, tarjeta, direccionEntrega, canalVenta, estado, anticipo, anticipoPagado, costoEnvio, motivoAnulacion) VALUES
  (1, 55, 27, 37, '2026-01-06', '2026-01-19', 'Ramo', 0, 'Con carino y admiracion', 'Diagonal 39 # 34-93, Barranquilla', 'B2C', 'Entregado', 196300.00, 1, 0.00, NULL),
  (2, 12, 21, 31, '2026-01-10', '2026-01-23', 'Ramo', 1, 'Felicitaciones por tu grado', 'Calle 34 # 4-83, Medellin', 'B2B', 'Entregado', 56100.00, 1, 15000.00, NULL),
  (3, 27, 42, 52, '2026-01-17', '2026-01-25', 'Caja', 0, 'Feliz aniversario, mi amor', 'Cra 60 # 79-11, Bogota', 'B2C', 'Entregado', 151275.00, 1, 8000.00, NULL),
  (4, 48, 45, 55, '2026-01-22', '2026-02-03', 'Ramo', 1, 'Con todo mi amor, para siempre', 'Calle 84 # 84-33, Bogota', 'B2C', 'Entregado', 29025.00, 1, 35000.00, NULL),
  (5, 49, 1, 11, '2026-01-28', '2026-02-12', 'Ramo', 0, 'Gracias por confiar en nosotros', 'Transversal 15 # 64-19, Santa Marta', 'B2C', 'Entregado', 13525.00, 1, 12000.00, NULL),
  (6, 44, 41, 51, '2026-02-02', '2026-02-10', 'Ramo', 0, NULL, 'Diagonal 69 # 9-63, Medellin', 'B2C', 'Entregado', 67150.00, 1, 18000.00, NULL),
  (7, 21, 27, 37, '2026-02-09', '2026-02-23', 'Ramo', 1, 'Con carino y admiracion', 'Transversal 25 # 93-86, Santa Marta', 'B2B', 'Entregado', 1337175.00, 1, 25000.00, NULL),
  (8, 32, 34, 44, '2026-02-14', '2026-02-19', 'Caja', 1, 'Feliz aniversario, mi amor', 'Calle 2 # 10-73, Bogota', 'B2C', 'Entregado', 200125.00, 1, 15000.00, NULL),
  (9, 34, 8, 18, '2026-02-19', '2026-03-04', 'Ramo', 0, NULL, 'Av. 89 # 39-46, Cali', 'B2C', 'Entregado', 18100.00, 1, 18000.00, NULL),
  (10, 9, 31, 41, '2026-02-25', '2026-03-06', 'Ramo', 1, 'Con carino y admiracion', 'Calle 41 # 16-16, Medellin', 'B2B', 'Entregado', 60800.00, 1, 18000.00, NULL),
  (11, 5, 30, 40, '2026-03-03', '2026-03-21', 'Caja', 1, 'Con carino y admiracion', 'Av. 18 # 99-71, Cali', 'B2B', 'Anulado', 601500.00, 0, 15000.00, 'Cliente cancelo el pedido'),
  (12, 15, 37, 47, '2026-03-08', '2026-03-20', 'Ramo', 1, 'Con carino y admiracion', 'Calle 107 # 16-39, Bogota', 'B2B', 'Entregado', 2141675.00, 1, 8000.00, NULL),
  (13, 19, 19, 29, '2026-03-15', '2026-04-02', 'Caja', 0, 'Feliz Dia de la Madre', 'Diagonal 51 # 22-84, Cali', 'B2B', 'Entregado', 874575.00, 1, 0.00, NULL),
  (14, 58, 40, 50, '2026-03-19', '2026-04-02', 'Caja', 1, NULL, 'Cra 92 # 47-19, Cartagena', 'B2C', 'Entregado', 225175.00, 1, 35000.00, NULL),
  (15, 20, 21, 31, '2026-03-26', '2026-03-31', 'Ramo', 0, 'Gracias por estar siempre a mi lado', 'Calle 27 # 35-67, Cartagena', 'B2B', 'Entregado', 2096050.00, 1, 18000.00, NULL),
  (16, 51, 38, 48, '2026-03-31', '2026-04-03', 'Caja', 0, 'En tu dia especial, un detalle eterno', 'Calle 19 # 57-48, Medellin', 'B2C', 'Entregado', 384200.00, 1, 8000.00, NULL),
  (17, 39, 35, 45, '2026-04-05', '2026-04-13', 'Caja', 1, NULL, 'Calle 92 # 53-12, Manizales', 'B2C', 'Entregado', 538900.00, 1, 8000.00, NULL),
  (18, 21, 8, 18, '2026-04-12', '2026-04-16', 'Caja', 0, NULL, 'Diagonal 52 # 15-19, Medellin', 'B2B', 'Entregado', 1351175.00, 1, 8000.00, NULL),
  (19, 2, 37, 47, '2026-04-18', '2026-04-27', 'Caja', 0, NULL, 'Diagonal 60 # 29-17, Cali', 'B2B', 'Entregado', 235475.00, 1, 12000.00, NULL),
  (20, 11, 18, 28, '2026-04-22', '2026-05-10', 'Caja', 1, NULL, 'Cra 42 # 20-10, Medellin', 'B2B', 'Entregado', 107050.00, 1, 25000.00, NULL),
  (21, 35, 50, 60, '2026-04-28', '2026-05-12', 'Caja', 0, NULL, 'Transversal 77 # 95-4, Cali', 'B2C', 'Entregado', 137300.00, 1, 15000.00, NULL),
  (22, 4, 10, 20, '2026-05-04', '2026-05-19', 'Ramo', 0, NULL, 'Av. 116 # 35-58, Pereira', 'B2B', 'Anulado', 218400.00, 0, 15000.00, 'Pedido duplicado'),
  (23, 48, 28, 38, '2026-05-10', '2026-05-27', 'Caja', 1, 'Gracias por estar siempre a mi lado', 'Calle 50 # 41-91, Bucaramanga', 'B2C', 'Entregado', 38125.00, 1, 15000.00, NULL),
  (24, 41, 5, 15, '2026-05-15', '2026-05-24', 'Caja', 1, 'Feliz aniversario, mi amor', 'Cra 105 # 40-33, Medellin', 'B2C', 'Entregado', 20475.00, 1, 0.00, NULL),
  (25, 20, 12, 22, '2026-05-21', '2026-06-03', 'Ramo', 0, 'Gracias por estar siempre a mi lado', 'Cra 54 # 86-65, Cali', 'B2B', 'Entregado', 173475.00, 1, 0.00, NULL),
  (26, 49, 6, 16, '2026-05-27', '2026-06-12', 'Caja', 0, NULL, 'Calle 48 # 45-81, Medellin', 'B2C', 'Entregado', 39275.00, 1, 25000.00, NULL),
  (27, 29, 14, 24, '2026-06-02', '2026-06-10', 'Ramo', 1, 'Felicitaciones por tu grado', 'Transversal 62 # 10-49, Bucaramanga', 'B2C', 'Entregado', 61950.00, 1, 25000.00, NULL),
  (28, 52, 50, 60, '2026-06-07', '2026-06-16', 'Ramo', 0, NULL, 'Diagonal 38 # 79-49, Bogota', 'B2C', 'Entregado', 129200.00, 1, 8000.00, NULL),
  (29, 52, 27, 37, '2026-06-13', '2026-07-01', 'Ramo', 0, NULL, 'Av. 28 # 77-64, Bogota', 'B2C', 'Entregado', 155250.00, 1, 12000.00, NULL),
  (30, 16, 28, 38, '2026-06-19', '2026-07-05', 'Ramo', 1, 'En tu dia especial, un detalle eterno', 'Cra 38 # 61-7, Barranquilla', 'B2B', 'Entregado', 703075.00, 1, 35000.00, NULL),
  (31, 37, 11, 21, '2026-06-24', '2026-07-06', 'Ramo', 0, 'Feliz Dia de la Madre', 'Transversal 94 # 64-39, Medellin', 'B2C', 'Entregado', 484950.00, 1, 25000.00, NULL),
  (32, 42, 2, 12, '2026-06-30', '2026-07-08', 'Ramo', 0, NULL, 'Cra 117 # 74-57, Cali', 'B2C', 'Entregado', 48100.00, 1, 35000.00, NULL),
  (33, 58, 39, 49, '2026-07-05', '2026-07-20', 'Ramo', 1, NULL, 'Cra 97 # 91-56, Bogota', 'B2C', 'Anulado', 8700.00, 0, 0.00, 'Cliente cancelo el pedido'),
  (34, 13, 6, 16, '2026-07-12', '2026-07-26', 'Caja', 1, NULL, 'Diagonal 106 # 81-94, Cali', 'B2B', 'Entregado', 898850.00, 1, 12000.00, NULL),
  (35, 13, 10, 20, '2026-07-17', '2026-07-24', 'Caja', 1, 'Con carino y admiracion', 'Diagonal 112 # 64-11, Bogota', 'B2B', 'Entregado', 308750.00, 1, 8000.00, NULL),
  (36, 26, 9, 19, '2026-07-22', '2026-07-27', 'Caja', 1, NULL, 'Calle 25 # 57-51, Pasto', 'B2C', 'Entregado', 21150.00, 1, 35000.00, NULL),
  (37, 8, 1, 11, '2026-07-29', '2026-08-14', 'Ramo', 0, NULL, 'Calle 91 # 20-71, Bogota', 'B2B', 'Entregado', 906425.00, 1, 12000.00, NULL),
  (38, 43, 7, 17, '2026-08-03', '2026-08-12', 'Caja', 1, NULL, 'Diagonal 85 # 98-23, Bogota', 'B2C', 'Entregado', 436150.00, 1, 8000.00, NULL),
  (39, 25, 48, 58, '2026-08-09', '2026-08-15', 'Caja', 1, 'Feliz Dia de la Madre', 'Av. 14 # 5-7, Bogota', 'B2B', 'Entregado', 49275.00, 1, 18000.00, NULL),
  (40, 47, 7, 17, '2026-08-15', '2026-09-02', 'Caja', 0, 'Feliz aniversario, mi amor', 'Av. 58 # 95-97, Bucaramanga', 'B2C', 'Entregado', 30775.00, 1, 35000.00, NULL),
  (41, 57, 50, 60, '2026-08-20', '2026-08-26', 'Caja', 0, 'Gracias por confiar en nosotros', 'Calle 71 # 82-42, Bogota', 'B2C', 'Entregado', 4700.00, 1, 0.00, NULL),
  (42, 44, 12, 22, '2026-08-25', '2026-09-02', 'Caja', 0, NULL, 'Transversal 34 # 37-45, Medellin', 'B2C', 'Entregado', 53775.00, 1, 18000.00, NULL),
  (43, 15, 38, 48, '2026-08-31', '2026-09-12', 'Ramo', 0, 'Con todo mi amor, para siempre', 'Transversal 1 # 63-4, Bogota', 'B2B', 'Entregado', 1217025.00, 1, 35000.00, NULL),
  (44, 44, 22, 32, '2026-09-06', '2026-09-20', 'Caja', 1, 'En tu dia especial, un detalle eterno', 'Diagonal 41 # 19-8, Bogota', 'B2C', 'Anulado', 154550.00, 0, 8000.00, 'Direccion de entrega fuera de cobertura'),
  (45, 19, 3, 13, '2026-09-13', '2026-09-28', 'Ramo', 0, NULL, 'Cra 43 # 30-30, Medellin', 'B2B', 'Entregado', 83125.00, 1, 12000.00, NULL),
  (46, 32, 49, 59, '2026-09-14', '2026-09-18', 'Caja', 0, 'Pronta recuperacion, te enviamos mucha fuerza', 'Calle 64 # 78-13, Bogota', 'B2C', 'Entregado', 30675.00, 1, 0.00, NULL),
  (47, 18, 37, 47, '2026-09-15', '2026-09-19', 'Caja', 0, NULL, 'Cra 26 # 74-4, Bogota', 'B2B', 'Entregado', 1487300.00, 1, 25000.00, NULL),
  (48, 59, 26, 36, '2026-09-17', '2026-09-21', 'Caja', 1, NULL, 'Transversal 93 # 49-81, Medellin', 'B2C', 'Entregado', 139500.00, 1, 25000.00, NULL),
  (49, 8, 32, 42, '2026-09-19', '2026-09-26', 'Ramo', 0, 'Pronta recuperacion, te enviamos mucha fuerza', 'Diagonal 42 # 47-88, Bogota', 'B2B', 'Entregado', 1864000.00, 1, 18000.00, NULL),
  (50, 37, 3, 13, '2026-09-21', '2026-10-02', 'Ramo', 0, 'Gracias por confiar en nosotros', 'Diagonal 26 # 76-35, Bogota', 'B2C', 'Entregado', 25450.00, 1, 35000.00, NULL),
  (51, 18, 48, 58, '2026-09-22', '2026-10-07', 'Caja', 1, NULL, 'Cra 61 # 43-13, Bogota', 'B2B', 'Entregado', 2721175.00, 1, 8000.00, NULL),
  (52, 53, 7, 17, '2026-09-24', '2026-10-10', 'Ramo', 0, 'Gracias por confiar en nosotros', 'Calle 15 # 27-7, Medellin', 'B2C', 'Enviado', 42325.00, 1, 0.00, NULL),
  (53, 27, 6, 16, '2026-09-26', '2026-10-03', 'Ramo', 1, 'Felicitaciones por tu grado', 'Transversal 85 # 77-84, Medellin', 'B2C', 'Entregado', 9675.00, 1, 12000.00, NULL),
  (54, 53, 14, 24, '2026-09-28', '2026-10-11', 'Ramo', 0, NULL, 'Av. 102 # 47-51, Bogota', 'B2C', 'Enviado', 111200.00, 1, 35000.00, NULL),
  (55, 55, 16, 26, '2026-09-29', '2026-10-14', 'Caja', 1, 'Gracias por confiar en nosotros', 'Cra 115 # 6-34, Bogota', 'B2C', 'Anulado', 12225.00, 0, 12000.00, 'Pedido duplicado'),
  (56, 22, 50, 60, '2026-10-01', '2026-10-15', 'Caja', 0, 'Feliz aniversario, mi amor', 'Transversal 43 # 75-66, Pereira', 'B2B', 'En preparacion', 1077800.00, 1, 8000.00, NULL),
  (57, 6, 11, 21, '2026-10-03', '2026-10-21', 'Caja', 1, 'Felicitaciones por tu grado', 'Cra 30 # 36-28, Santa Marta', 'B2B', 'Registrado', 1737225.00, 1, 35000.00, NULL),
  (58, 36, 49, 59, '2026-10-05', '2026-10-22', 'Ramo', 1, 'Feliz aniversario, mi amor', 'Transversal 50 # 13-53, Cucuta', 'B2C', 'Registrado', 22250.00, 0, 35000.00, NULL),
  (59, 47, 21, 31, '2026-10-06', '2026-10-22', 'Caja', 0, NULL, 'Cra 27 # 47-31, Ibague', 'B2C', 'Registrado', 129450.00, 1, 12000.00, NULL),
  (60, 28, 30, 40, '2026-10-08', '2026-10-12', 'Caja', 0, 'Felicitaciones por tu grado', 'Av. 66 # 46-19, Medellin', 'B2C', 'Enviado', 50225.00, 1, 35000.00, NULL);


-- DetallePedido : 134 lineas
INSERT INTO DetallePedido (idDetalle, idPedido, idProducto, cantidad, precioPactado) VALUES
  (1, 1, 19, 5, 12600.00),
  (2, 1, 41, 4, 82400.00),
  (3, 2, 25, 36, 2700.00),
  (4, 3, 33, 4, 8900.00),
  (5, 3, 19, 2, 20600.00),
  (6, 3, 31, 5, 43550.00),
  (7, 4, 43, 4, 4750.00),
  (8, 4, 22, 1, 4050.00),
  (9, 5, 27, 2, 3400.00),
  (10, 5, 20, 1, 1950.00),
  (11, 5, 5, 3, 2100.00),
  (12, 6, 34, 5, 4500.00),
  (13, 6, 18, 4, 23450.00),
  (14, 7, 52, 36, 31000.00),
  (15, 7, 49, 39, 36100.00),
  (16, 7, 43, 37, 2600.00),
  (17, 7, 28, 9, 3250.00),
  (18, 8, 9, 5, 77050.00),
  (19, 9, 8, 4, 4550.00),
  (20, 10, 43, 37, 2800.00),
  (21, 11, 51, 33, 36000.00),
  (22, 12, 6, 37, 7550.00),
  (23, 12, 55, 18, 222000.00),
  (24, 13, 25, 24, 2300.00),
  (25, 13, 49, 30, 26250.00),
  (26, 13, 11, 9, 93950.00),
  (27, 13, 2, 29, 2100.00),
  (28, 14, 24, 3, 1650.00),
  (29, 14, 52, 3, 37700.00),
  (30, 14, 40, 6, 49550.00),
  (31, 15, 4, 30, 3150.00),
  (32, 15, 53, 21, 10600.00),
  (33, 15, 12, 7, 9500.00),
  (34, 15, 11, 38, 99750.00),
  (35, 16, 21, 3, 1250.00),
  (36, 16, 38, 3, 82800.00),
  (37, 16, 59, 3, 100000.00),
  (38, 16, 17, 5, 41650.00),
  (39, 17, 30, 6, 4150.00),
  (40, 17, 15, 3, 37700.00),
  (41, 17, 1, 4, 232950.00),
  (42, 18, 38, 16, 129350.00),
  (43, 18, 56, 35, 17850.00),
  (44, 19, 22, 23, 4050.00),
  (45, 19, 12, 31, 10550.00),
  (46, 19, 33, 5, 7750.00),
  (47, 20, 27, 27, 2700.00),
  (48, 20, 30, 14, 8300.00),
  (49, 21, 7, 2, 129800.00),
  (50, 22, 29, 37, 11400.00),
  (51, 23, 26, 6, 5000.00),
  (52, 23, 3, 4, 2050.00),
  (53, 23, 13, 6, 2300.00),
  (54, 23, 29, 1, 9250.00),
  (55, 24, 6, 5, 6850.00),
  (56, 24, 8, 2, 3350.00),
  (57, 25, 50, 23, 3000.00),
  (58, 25, 53, 17, 16350.00),
  (59, 26, 29, 3, 13550.00),
  (60, 26, 22, 2, 3000.00),
  (61, 26, 8, 1, 3050.00),
  (62, 26, 30, 1, 3850.00),
  (63, 27, 14, 4, 21350.00),
  (64, 27, 5, 5, 2700.00),
  (65, 28, 52, 5, 30100.00),
  (66, 28, 44, 3, 33300.00),
  (67, 29, 11, 3, 99500.00),
  (68, 30, 28, 20, 3500.00),
  (69, 30, 57, 7, 93050.00),
  (70, 30, 6, 36, 5950.00),
  (71, 30, 51, 11, 39600.00),
  (72, 31, 47, 2, 14350.00),
  (73, 31, 59, 6, 152700.00),
  (74, 32, 14, 3, 20400.00),
  (75, 33, 8, 2, 6550.00),
  (76, 33, 4, 2, 2150.00),
  (77, 34, 34, 35, 4350.00),
  (78, 34, 37, 7, 233350.00),
  (79, 35, 29, 39, 12900.00),
  (80, 35, 12, 16, 6650.00),
  (81, 36, 6, 2, 3650.00),
  (82, 37, 2, 8, 2000.00),
  (83, 37, 33, 31, 8350.00),
  (84, 37, 47, 31, 10000.00),
  (85, 37, 52, 32, 38000.00),
  (86, 38, 23, 6, 144050.00),
  (87, 39, 42, 23, 1650.00),
  (88, 39, 13, 12, 3550.00),
  (89, 40, 27, 5, 3300.00),
  (90, 40, 8, 3, 3350.00),
  (91, 41, 22, 4, 2350.00),
  (92, 42, 49, 1, 32650.00),
  (93, 42, 18, 4, 13000.00),
  (94, 42, 43, 2, 2450.00),
  (95, 43, 37, 13, 139250.00),
  (96, 43, 18, 23, 25600.00),
  (97, 44, 19, 1, 27200.00),
  (98, 44, 11, 3, 91300.00),
  (99, 45, 47, 8, 10000.00),
  (100, 45, 53, 11, 6750.00),
  (101, 46, 32, 4, 11400.00),
  (102, 46, 8, 3, 5250.00),
  (103, 47, 11, 22, 91600.00),
  (104, 47, 29, 40, 8000.00),
  (105, 47, 19, 32, 19200.00),
  (106, 48, 45, 4, 21050.00),
  (107, 48, 47, 3, 15400.00),
  (108, 48, 49, 4, 30900.00),
  (109, 49, 57, 40, 92750.00),
  (110, 50, 8, 3, 5300.00),
  (111, 51, 38, 26, 156750.00),
  (112, 51, 44, 32, 39150.00),
  (113, 51, 2, 8, 2200.00),
  (114, 51, 35, 29, 3050.00),
  (115, 52, 44, 1, 32250.00),
  (116, 52, 53, 4, 13100.00),
  (117, 53, 27, 3, 2450.00),
  (118, 54, 54, 4, 7900.00),
  (119, 54, 18, 6, 12850.00),
  (120, 54, 40, 2, 39350.00),
  (121, 55, 34, 3, 4150.00),
  (122, 56, 13, 18, 1800.00),
  (123, 56, 9, 26, 79300.00),
  (124, 56, 26, 9, 4600.00),
  (125, 56, 42, 5, 2400.00),
  (126, 57, 47, 25, 16700.00),
  (127, 57, 57, 29, 99100.00),
  (128, 57, 54, 21, 7050.00),
  (129, 58, 35, 5, 1900.00),
  (130, 59, 17, 5, 44500.00),
  (131, 59, 26, 4, 6100.00),
  (132, 60, 8, 5, 5250.00),
  (133, 60, 47, 2, 9800.00),
  (134, 60, 34, 4, 4900.00);


-- Pago : 102 lineas
INSERT INTO Pago (idPago, idPedido, tipoPago, monto, fechaPago) VALUES
  (1, 1, 'Tarjeta', 196300.00, '2026-01-08'),
  (2, 1, 'Nequi', 196300.00, '2026-01-19'),
  (3, 2, 'Nequi', 56100.00, '2026-01-10'),
  (4, 2, 'PSE', 56100.00, '2026-01-23'),
  (5, 3, 'PSE', 151275.00, '2026-01-18'),
  (6, 3, 'Transferencia', 151275.00, '2026-01-25'),
  (7, 4, 'PSE', 29025.00, '2026-01-22'),
  (8, 4, 'Tarjeta', 29025.00, '2026-02-03'),
  (9, 5, 'Tarjeta', 13525.00, '2026-01-28'),
  (10, 5, 'PSE', 13525.00, '2026-02-12'),
  (11, 6, 'Nequi', 67150.00, '2026-02-02'),
  (12, 6, 'PSE', 67150.00, '2026-02-10'),
  (13, 7, 'Tarjeta', 1337175.00, '2026-02-09'),
  (14, 7, 'Tarjeta', 1337175.00, '2026-02-23'),
  (15, 8, 'Nequi', 200125.00, '2026-02-15'),
  (16, 8, 'Tarjeta', 200125.00, '2026-02-19'),
  (17, 9, 'Efectivo', 18100.00, '2026-02-21'),
  (18, 9, 'PSE', 18100.00, '2026-03-04'),
  (19, 10, 'Nequi', 60800.00, '2026-02-26'),
  (20, 10, 'Nequi', 60800.00, '2026-03-06'),
  (21, 12, 'Tarjeta', 2141675.00, '2026-03-08'),
  (22, 12, 'PSE', 2141675.00, '2026-03-20'),
  (23, 13, 'Tarjeta', 874575.00, '2026-03-17'),
  (24, 13, 'PSE', 874575.00, '2026-04-02'),
  (25, 14, 'Transferencia', 225175.00, '2026-03-19'),
  (26, 14, 'Transferencia', 225175.00, '2026-04-02'),
  (27, 15, 'PSE', 2096050.00, '2026-03-26'),
  (28, 15, 'Tarjeta', 2096050.00, '2026-03-31'),
  (29, 16, 'Tarjeta', 384200.00, '2026-04-02'),
  (30, 16, 'PSE', 384200.00, '2026-04-03'),
  (31, 17, 'Nequi', 538900.00, '2026-04-06'),
  (32, 17, 'PSE', 538900.00, '2026-04-13'),
  (33, 18, 'Nequi', 1351175.00, '2026-04-12'),
  (34, 18, 'Transferencia', 1351175.00, '2026-04-16'),
  (35, 19, 'Transferencia', 235475.00, '2026-04-18'),
  (36, 19, 'Tarjeta', 235475.00, '2026-04-27'),
  (37, 20, 'Tarjeta', 107050.00, '2026-04-22'),
  (38, 20, 'PSE', 107050.00, '2026-05-10'),
  (39, 21, 'Tarjeta', 137300.00, '2026-04-29'),
  (40, 21, 'Nequi', 137300.00, '2026-05-12'),
  (41, 23, 'Nequi', 38125.00, '2026-05-11'),
  (42, 23, 'Nequi', 38125.00, '2026-05-27'),
  (43, 24, 'PSE', 20475.00, '2026-05-16'),
  (44, 24, 'Efectivo', 20475.00, '2026-05-24'),
  (45, 25, 'Transferencia', 173475.00, '2026-05-23'),
  (46, 25, 'Nequi', 173475.00, '2026-06-03'),
  (47, 26, 'Efectivo', 39275.00, '2026-05-29'),
  (48, 26, 'Nequi', 39275.00, '2026-06-12'),
  (49, 27, 'PSE', 61950.00, '2026-06-04'),
  (50, 27, 'Tarjeta', 61950.00, '2026-06-10'),
  (51, 28, 'Tarjeta', 129200.00, '2026-06-09'),
  (52, 28, 'PSE', 129200.00, '2026-06-16'),
  (53, 29, 'Nequi', 155250.00, '2026-06-15'),
  (54, 29, 'Transferencia', 155250.00, '2026-07-01'),
  (55, 30, 'Efectivo', 703075.00, '2026-06-21'),
  (56, 30, 'Nequi', 703075.00, '2026-07-05'),
  (57, 31, 'Tarjeta', 484950.00, '2026-06-25'),
  (58, 31, 'Efectivo', 484950.00, '2026-07-06'),
  (59, 32, 'Nequi', 48100.00, '2026-06-30'),
  (60, 32, 'Efectivo', 48100.00, '2026-07-08'),
  (61, 34, 'PSE', 898850.00, '2026-07-12'),
  (62, 34, 'Transferencia', 898850.00, '2026-07-26'),
  (63, 35, 'Tarjeta', 308750.00, '2026-07-18'),
  (64, 35, 'Efectivo', 308750.00, '2026-07-24'),
  (65, 36, 'Transferencia', 21150.00, '2026-07-24'),
  (66, 36, 'Nequi', 21150.00, '2026-07-27'),
  (67, 37, 'Tarjeta', 906425.00, '2026-07-29'),
  (68, 37, 'PSE', 906425.00, '2026-08-14'),
  (69, 38, 'Efectivo', 436150.00, '2026-08-05'),
  (70, 38, 'Efectivo', 436150.00, '2026-08-12'),
  (71, 39, 'Transferencia', 49275.00, '2026-08-09'),
  (72, 39, 'Efectivo', 49275.00, '2026-08-15'),
  (73, 40, 'Tarjeta', 30775.00, '2026-08-17'),
  (74, 40, 'Tarjeta', 30775.00, '2026-09-02'),
  (75, 41, 'Nequi', 4700.00, '2026-08-20'),
  (76, 41, 'Transferencia', 4700.00, '2026-08-26'),
  (77, 42, 'PSE', 53775.00, '2026-08-25'),
  (78, 42, 'PSE', 53775.00, '2026-09-02'),
  (79, 43, 'PSE', 1217025.00, '2026-09-01'),
  (80, 43, 'Transferencia', 1217025.00, '2026-09-12'),
  (81, 45, 'Tarjeta', 83125.00, '2026-09-14'),
  (82, 45, 'Efectivo', 83125.00, '2026-09-28'),
  (83, 46, 'PSE', 30675.00, '2026-09-16'),
  (84, 46, 'Tarjeta', 30675.00, '2026-09-18'),
  (85, 47, 'Efectivo', 1487300.00, '2026-09-17'),
  (86, 47, 'Nequi', 1487300.00, '2026-09-19'),
  (87, 48, 'Tarjeta', 139500.00, '2026-09-18'),
  (88, 48, 'Efectivo', 139500.00, '2026-09-21'),
  (89, 49, 'Tarjeta', 1864000.00, '2026-09-19'),
  (90, 49, 'Tarjeta', 1864000.00, '2026-09-26'),
  (91, 50, 'Transferencia', 25450.00, '2026-09-23'),
  (92, 50, 'Tarjeta', 25450.00, '2026-10-02'),
  (93, 51, 'Tarjeta', 2721175.00, '2026-09-23'),
  (94, 51, 'Tarjeta', 2721175.00, '2026-10-07'),
  (95, 52, 'Tarjeta', 42325.00, '2026-09-24'),
  (96, 53, 'Nequi', 9675.00, '2026-09-26'),
  (97, 53, 'Nequi', 9675.00, '2026-10-03'),
  (98, 54, 'PSE', 111200.00, '2026-09-28'),
  (99, 56, 'Nequi', 1077800.00, '2026-10-02'),
  (100, 57, 'Tarjeta', 1737225.00, '2026-10-03'),
  (101, 59, 'Transferencia', 129450.00, '2026-10-08'),
  (102, 60, 'PSE', 50225.00, '2026-10-08');


-- Alerta : 93 lineas
INSERT INTO Alerta (idAlerta, idProducto, fechaGeneracion, mensaje, tipoAlerta) VALUES
  (1, 19, '2026-01-06', 'Margen 7.54% inferior al umbral 26.50% en pedido 1', 'Baja rentabilidad'),
  (2, 5, '2026-01-28', 'Margen 35.71% inferior al umbral 47.00% en pedido 5', 'Baja rentabilidad'),
  (3, 20, '2026-01-28', 'Margen 15.38% inferior al umbral 47.50% en pedido 5', 'Baja rentabilidad'),
  (4, 43, '2026-02-09', 'Margen 25.00% inferior al umbral 36.00% en pedido 7', 'Baja rentabilidad'),
  (5, 52, '2026-02-09', 'Margen 8.39% inferior al umbral 8.50% en pedido 7', 'Baja rentabilidad'),
  (6, 9, '2026-02-14', 'Margen 8.11% inferior al umbral 8.50% en pedido 8', 'Baja rentabilidad'),
  (7, 43, '2026-02-25', 'Margen 30.36% inferior al umbral 36.00% en pedido 10', 'Baja rentabilidad'),
  (8, 51, '2026-03-03', 'Margen 20.42% inferior al umbral 28.00% en pedido 11', 'Baja rentabilidad'),
  (9, 2, '2026-03-15', 'Margen 14.29% inferior al umbral 16.00% en pedido 13', 'Baja rentabilidad'),
  (10, 11, '2026-03-15', 'Margen 9.47% inferior al umbral 28.50% en pedido 13', 'Baja rentabilidad'),
  (11, 49, '2026-03-15', 'Margen 26.10% inferior al umbral 39.00% en pedido 13', 'Baja rentabilidad'),
  (12, 11, '2026-03-26', 'Margen 14.74% inferior al umbral 28.50% en pedido 15', 'Baja rentabilidad'),
  (13, 17, '2026-03-31', 'Margen 23.17% inferior al umbral 35.00% en pedido 16', 'Baja rentabilidad'),
  (14, 21, '2026-03-31', 'Margen 20.00% inferior al umbral 37.50% en pedido 16', 'Baja rentabilidad'),
  (15, 38, '2026-03-31', 'Margen 22.58% inferior al umbral 45.50% en pedido 16', 'Baja rentabilidad'),
  (16, 59, '2026-03-31', 'Margen 9.55% inferior al umbral 25.50% en pedido 16', 'Baja rentabilidad'),
  (17, 1, '2026-04-05', 'Margen 34.11% inferior al umbral 48.50% en pedido 17', 'Baja rentabilidad'),
  (18, 15, '2026-04-05', 'Margen 13.13% inferior al umbral 25.50% en pedido 17', 'Baja rentabilidad'),
  (19, 30, '2026-04-05', 'Margen 19.28% inferior al umbral 35.00% en pedido 17', 'Baja rentabilidad'),
  (20, 56, '2026-04-12', 'Margen 23.53% inferior al umbral 28.00% en pedido 18', 'Baja rentabilidad'),
  (21, 33, '2026-04-18', 'Margen 20.00% inferior al umbral 26.00% en pedido 19', 'Baja rentabilidad'),
  (22, 29, '2026-05-04', 'Margen 38.16% inferior al umbral 46.50% en pedido 22', 'Baja rentabilidad'),
  (23, 3, '2026-05-10', 'Margen 24.39% inferior al umbral 27.00% en pedido 23', 'Baja rentabilidad'),
  (24, 13, '2026-05-10', 'Margen 30.43% inferior al umbral 36.00% en pedido 23', 'Baja rentabilidad'),
  (25, 29, '2026-05-10', 'Margen 23.78% inferior al umbral 46.50% en pedido 23', 'Baja rentabilidad'),
  (26, 8, '2026-05-15', 'Margen 16.42% inferior al umbral 25.00% en pedido 24', 'Baja rentabilidad'),
  (27, 50, '2026-05-21', 'Margen 20.00% inferior al umbral 27.50% en pedido 25', 'Baja rentabilidad'),
  (28, 8, '2026-05-27', 'Margen 8.20% inferior al umbral 25.00% en pedido 26', 'Baja rentabilidad'),
  (29, 30, '2026-05-27', 'Margen 12.99% inferior al umbral 35.00% en pedido 26', 'Baja rentabilidad'),
  (30, 14, '2026-06-02', 'Margen 20.61% inferior al umbral 38.00% en pedido 27', 'Baja rentabilidad'),
  (31, 52, '2026-06-07', 'Margen 5.65% inferior al umbral 8.50% en pedido 28', 'Baja rentabilidad'),
  (32, 11, '2026-06-13', 'Margen 14.52% inferior al umbral 28.50% en pedido 29', 'Baja rentabilidad'),
  (33, 51, '2026-06-19', 'Margen 27.65% inferior al umbral 28.00% en pedido 30', 'Baja rentabilidad'),
  (34, 57, '2026-06-19', 'Margen 19.40% inferior al umbral 25.00% en pedido 30', 'Baja rentabilidad'),
  (35, 14, '2026-06-30', 'Margen 16.91% inferior al umbral 38.00% en pedido 32', 'Baja rentabilidad'),
  (36, 4, '2026-07-05', 'Margen 20.93% inferior al umbral 27.00% en pedido 33', 'Baja rentabilidad'),
  (37, 12, '2026-07-17', 'Margen 6.77% inferior al umbral 26.00% en pedido 35', 'Baja rentabilidad'),
  (38, 29, '2026-07-17', 'Margen 45.35% inferior al umbral 46.50% en pedido 35', 'Baja rentabilidad'),
  (39, 2, '2026-07-29', 'Margen 10.00% inferior al umbral 16.00% en pedido 37', 'Baja rentabilidad'),
  (40, 33, '2026-07-29', 'Margen 25.75% inferior al umbral 26.00% en pedido 37', 'Baja rentabilidad'),
  (41, 47, '2026-07-29', 'Margen 8.50% inferior al umbral 26.00% en pedido 37', 'Baja rentabilidad'),
  (42, 42, '2026-08-09', 'Margen 21.21% inferior al umbral 46.00% en pedido 39', 'Baja rentabilidad'),
  (43, 8, '2026-08-15', 'Margen 16.42% inferior al umbral 25.00% en pedido 40', 'Baja rentabilidad'),
  (44, 22, '2026-08-20', 'Margen 31.91% inferior al umbral 36.50% en pedido 41', 'Baja rentabilidad'),
  (45, 18, '2026-08-25', 'Margen 8.08% inferior al umbral 36.00% en pedido 42', 'Baja rentabilidad'),
  (46, 43, '2026-08-25', 'Margen 20.41% inferior al umbral 36.00% en pedido 42', 'Baja rentabilidad'),
  (47, 37, '2026-08-31', 'Margen 6.93% inferior al umbral 28.50% en pedido 43', 'Baja rentabilidad'),
  (48, 11, '2026-09-06', 'Margen 6.85% inferior al umbral 28.50% en pedido 44', 'Baja rentabilidad'),
  (49, 47, '2026-09-13', 'Margen 8.50% inferior al umbral 26.00% en pedido 45', 'Baja rentabilidad'),
  (50, 53, '2026-09-13', 'Margen 5.93% inferior al umbral 36.50% en pedido 45', 'Baja rentabilidad'),
  (51, 32, '2026-09-14', 'Margen 14.47% inferior al umbral 37.00% en pedido 46', 'Baja rentabilidad'),
  (52, 11, '2026-09-15', 'Margen 7.15% inferior al umbral 28.50% en pedido 47', 'Baja rentabilidad'),
  (53, 29, '2026-09-15', 'Margen 11.88% inferior al umbral 46.50% en pedido 47', 'Baja rentabilidad'),
  (54, 49, '2026-09-17', 'Margen 37.22% inferior al umbral 39.00% en pedido 48', 'Baja rentabilidad'),
  (55, 57, '2026-09-19', 'Margen 19.14% inferior al umbral 25.00% en pedido 49', 'Baja rentabilidad'),
  (56, 18, '2026-09-28', 'Margen 7.00% inferior al umbral 36.00% en pedido 54', 'Baja rentabilidad'),
  (57, 40, '2026-09-28', 'Margen 17.03% inferior al umbral 25.00% en pedido 54', 'Baja rentabilidad'),
  (58, 34, '2026-09-29', 'Margen 32.53% inferior al umbral 35.50% en pedido 55', 'Baja rentabilidad'),
  (59, 10, '2026-10-01', 'Stock bajo de Caja regalo Inirida blanca en el punto de venta 21', 'Stock bajo'),
  (60, 11, '2026-10-01', 'Stock bajo de Mini arreglo Inirida escritorio en el punto de venta 28', 'Stock bajo'),
  (61, 13, '2026-10-01', 'Margen 11.11% inferior al umbral 36.00% en pedido 56', 'Baja rentabilidad'),
  (62, 16, '2026-10-01', 'Stock bajo de Florero de vidrio en el punto de venta 13', 'Stock bajo'),
  (63, 20, '2026-10-01', 'Stock bajo de Tarjeta aniversario en el punto de venta 41', 'Stock bajo'),
  (64, 38, '2026-10-01', 'Stock bajo de Caja regalo Inirida tenida rosada en el punto de venta 17', 'Stock bajo'),
  (65, 42, '2026-10-01', 'Margen 45.83% inferior al umbral 46.00% en pedido 56', 'Baja rentabilidad'),
  (66, 44, '2026-10-01', 'Producto Ramo 10 Inirida tenida azul agotado en el punto de venta 9', 'Producto agotado'),
  (67, 50, '2026-10-01', 'Stock bajo de Tarjeta gracias en el punto de venta 1', 'Stock bajo'),
  (68, 54, '2026-10-01', 'Stock bajo de Tallo Inirida natural en el punto de venta 29', 'Stock bajo'),
  (69, 7, '2026-10-02', 'Stock bajo de Ramo 20 Inirida dorada en el punto de venta 50', 'Stock bajo'),
  (70, 8, '2026-10-02', 'Producto Tallo Inirida blanca agotado en el punto de venta 7', 'Producto agotado'),
  (71, 29, '2026-10-02', 'Stock bajo de Caja kraft grande en el punto de venta 4', 'Stock bajo'),
  (72, 42, '2026-10-02', 'Stock bajo de Follaje hojas de aralia (tallo) en el punto de venta 45', 'Stock bajo'),
  (73, 14, '2026-10-03', 'Stock bajo de Base de ceramica en el punto de venta 49', 'Stock bajo'),
  (74, 35, '2026-10-03', 'Stock bajo de Cinta satinada en el punto de venta 46', 'Stock bajo'),
  (75, 40, '2026-10-03', 'Producto Ramo 10 Inirida blanca agotado en el punto de venta 31', 'Producto agotado'),
  (76, 57, '2026-10-03', 'Margen 24.32% inferior al umbral 25.00% en pedido 57', 'Baja rentabilidad'),
  (77, 36, '2026-10-04', 'Producto Corona Inirida agotado en el punto de venta 3', 'Producto agotado'),
  (78, 15, '2026-10-05', 'Stock bajo de Ramo 10 Inirida tenida rosada en el punto de venta 6', 'Stock bajo'),
  (79, 32, '2026-10-05', 'Stock bajo de Caja de madera mini en el punto de venta 25', 'Stock bajo'),
  (80, 35, '2026-10-05', 'Margen 26.32% inferior al umbral 37.00% en pedido 58', 'Baja rentabilidad'),
  (81, 41, '2026-10-05', 'Producto Ramo 20 Inirida tenida azul agotado en el punto de venta 38', 'Producto agotado'),
  (82, 52, '2026-10-05', 'Stock bajo de Ramo 10 Inirida tenida roja en el punto de venta 15', 'Stock bajo'),
  (83, 59, '2026-10-05', 'Stock bajo de Caja regalo Inirida tenida roja en el punto de venta 14', 'Stock bajo'),
  (84, 60, '2026-10-05', 'Stock bajo de Follaje gypsophila (ramo) en el punto de venta 21', 'Stock bajo'),
  (85, 12, '2026-10-06', 'Stock bajo de Follaje hojas de aralia (ramo) en el punto de venta 35', 'Stock bajo'),
  (86, 17, '2026-10-06', 'Margen 28.09% inferior al umbral 35.00% en pedido 59', 'Baja rentabilidad'),
  (87, 28, '2026-10-06', 'Stock bajo de Follaje ficus (tallo) en el punto de venta 47', 'Stock bajo'),
  (88, 57, '2026-10-06', 'Producto Caja regalo Inirida natural agotado en el punto de venta 50', 'Producto agotado'),
  (89, 4, '2026-10-08', 'Producto Cono de papel agotado en el punto de venta 29', 'Producto agotado'),
  (90, 25, '2026-10-08', 'Stock bajo de Tarjeta cumpleanos en el punto de venta 26', 'Stock bajo'),
  (91, 47, '2026-10-08', 'Margen 6.63% inferior al umbral 26.00% en pedido 60', 'Baja rentabilidad'),
  (92, 58, '2026-10-08', 'Stock bajo de Ramo 20 Inirida natural en el punto de venta 7', 'Stock bajo'),
  (93, 47, '2026-10-09', 'Producto Follaje eucalipto (ramo) agotado en el punto de venta 30', 'Producto agotado');


-- Verificacioness : numero de lineas por tablas (todas deben ser >= 50)
SELECT 'PuntoVenta' AS tabla, COUNT(*) AS filas FROM PuntoVenta
UNION ALL SELECT 'Usuario', COUNT(*) FROM Usuario
UNION ALL SELECT 'Cliente', COUNT(*) FROM Cliente
UNION ALL SELECT 'Telefono', COUNT(*) FROM Telefono
UNION ALL SELECT 'Categoria', COUNT(*) FROM Categoria
UNION ALL SELECT 'Proveedor', COUNT(*) FROM Proveedor
UNION ALL SELECT 'Producto', COUNT(*) FROM Producto
UNION ALL SELECT 'Inventario', COUNT(*) FROM Inventario
UNION ALL SELECT 'Pedido', COUNT(*) FROM Pedido
UNION ALL SELECT 'DetallePedido', COUNT(*) FROM DetallePedido
UNION ALL SELECT 'Pago', COUNT(*) FROM Pago
UNION ALL SELECT 'Alerta', COUNT(*) FROM Alerta;


-- C. CONSULTAS (1 básica + 7 específicas por tabla)

-- Tabla Usuario-----------------------------------------------------------------------------------------
-- Usuario 1/8 : consulta basic : todos usuarios
SELECT * FROM Usuario;

-- Usuario 2/8 : Administradores cuya cuenta no esta bloqueada, por orden alfabetico
SELECT idUsuario, nombre, correo, idPuntoVenta
FROM Usuario
WHERE rol = 'Administrador' AND bloqueado = 0
ORDER BY nombre;

-- Usuario 3/8 : Cuentas bloqueadas y numero de intentos fallidos de conexion (filtro + ordenacion)
SELECT idUsuario, nombre, rol, intentosFallidos
FROM Usuario
WHERE bloqueado = 1 AND intentosFallidos >= 3
ORDER BY intentosFallidos DESC, nombre;

-- Usuario 4/8 : Busqueda: usuarios cuyo nombre contenga «Gomez»
SELECT idUsuario, nombre, correo
FROM Usuario
WHERE nombre LIKE '%Gomez%'
ORDER BY nombre;

-- Usuario 5/8 : Agrupacion: numero de usuarios y media de fallos por rol
SELECT rol, COUNT(*) AS total_usuarios, ROUND(AVG(intentosFallidos), 2) AS promedio_intentos
FROM Usuario
GROUP BY rol;

-- Usuario 6/8 : Usuarios que nunca han iniciado sesion (IS NULL)
SELECT idUsuario, nombre, rol, fechaRegistro
FROM Usuario
WHERE ultimoAcceso IS NULL
ORDER BY fechaRegistro;

-- Usuario 7/8 : Calculo: dias transcurridos desde el ultimo acceso (fecha de referencia: 10 de octubre de 2026), los 10 usuarios mas inactivos
SELECT idUsuario, nombre, ultimoAcceso, DATEDIFF('2026-10-10', DATE(ultimoAcceso)) AS dias_sin_acceso
FROM Usuario
WHERE ultimoAcceso IS NOT NULL
ORDER BY dias_sin_acceso DESC
LIMIT 10;

-- Usuario 8/8 : Agrupacion por fecha: inscripciones por ano y por mes
SELECT YEAR(fechaRegistro) AS anio, MONTH(fechaRegistro) AS mes, COUNT(*) AS registros
FROM Usuario
GROUP BY YEAR(fechaRegistro), MONTH(fechaRegistro)
ORDER BY anio, mes;


-- Tabla Cliente---------------------------------------------------------------------------------------------------------
-- Cliente 1/8 : Consulta basica : todos los clientes
SELECT * FROM Cliente;

-- Cliente 2/8 : Clientes B2B activos, por orden alfabetico
SELECT idCliente, nombreCliente, direccion
FROM Cliente
WHERE tipoCliente = 'B2B' AND activo = 1
ORDER BY nombreCliente;

-- Cliente 3/8 : Clientes inactivos
SELECT idCliente, nombreCliente, tipoCliente, direccion
FROM Cliente
WHERE activo = 0
ORDER BY tipoCliente, nombreCliente;

-- Cliente 4/8 : Busqueda : clientes ubicados en Medellin (LIKE sobre la direccion)
SELECT idCliente, nombreCliente, direccion
FROM Cliente
WHERE direccion LIKE '%Medellin%'
ORDER BY nombreCliente;

-- Cliente 5/8 : Agrupacion : numero de clientes por tipo
SELECT tipoCliente, COUNT(*) AS total_clientes
FROM Cliente
GROUP BY tipoCliente;

-- Cliente 6/8 : Agrupacion : clientes por ciudad (extraida de la direccion), de mayor a menor cantidad
SELECT TRIM(SUBSTRING_INDEX(direccion, ',', -1)) AS ciudad, COUNT(*) AS total_clientes
FROM Cliente
GROUP BY TRIM(SUBSTRING_INDEX(direccion, ',', -1))
ORDER BY total_clientes DESC, ciudad;

-- Cliente 7/8 : Calculo : porcentaje de clientes activos por tipo
SELECT tipoCliente, ROUND(AVG(activo) * 100, 1) AS porcentaje_activos
FROM Cliente
GROUP BY tipoCliente;

-- Cliente 8/8 : Los 10 primeros clientes B2C por orden alfabetico (LIMIT)
SELECT idCliente, nombreCliente, direccion
FROM Cliente
WHERE tipoCliente = 'B2C'
ORDER BY nombreCliente
LIMIT 10;


-- Tabla Telefono--------------------------------------------------------------------------------------------------------------------------
-- Telefono 1/8 : Consulta basica : todos los telefonos
SELECT * FROM Telefono;

-- Telefono 2/8 : Telefonos del cliente numero 5 (filtro)
SELECT idTelefono, numeroTelefono
FROM Telefono
WHERE idCliente = 5;

-- Telefono 3/8 : Busqueda : numeros moviles que empiezan por 310
SELECT idTelefono, idCliente, numeroTelefono
FROM Telefono
WHERE numeroTelefono LIKE '310%'
ORDER BY numeroTelefono;

-- Telefono 4/8 : Busqueda : numeros fijos de Bogota (indicativo 601)
SELECT idTelefono, idCliente, numeroTelefono
FROM Telefono
WHERE numeroTelefono LIKE '601%'
ORDER BY idCliente;

-- Telefono 5/8 : Agrupacion : numero de telefonos por cliente, los 10 primeros
SELECT idCliente, COUNT(*) AS total_telefonos
FROM Telefono
GROUP BY idCliente
ORDER BY total_telefonos DESC, idCliente
LIMIT 10;

-- Telefono 6/8 : Clientes que tienen mas de un telefono (HAVING)
SELECT idCliente, COUNT(*) AS total_telefonos
FROM Telefono
GROUP BY idCliente
HAVING COUNT(*) > 1
ORDER BY idCliente;

-- Telefono 7/8 : Calculo : total de numeros, clientes distintos y promedio por cliente
SELECT COUNT(*) AS total_numeros,
       COUNT(DISTINCT idCliente) AS clientes_con_telefono,
       ROUND(COUNT(*) / COUNT(DISTINCT idCliente), 2) AS promedio_por_cliente
FROM Telefono;

-- Telefono 8/8 : Agrupacion : reparto de los numeros por prefijo (3 primeros digitos)
SELECT LEFT(numeroTelefono, 3) AS prefijo, COUNT(*) AS total_numeros
FROM Telefono
GROUP BY LEFT(numeroTelefono, 3)
ORDER BY total_numeros DESC, prefijo;


-- Tabla PuntoVenta------------------------------------------------------------------------------------------------------------------------------
-- PuntoVenta 1/8 : Consulta basica : todos los puntos de venta
SELECT * FROM PuntoVenta;

-- PuntoVenta 2/8 : Puntos de venta de Bogota, por orden alfabetico
SELECT idPuntoVenta, nombrePuntoVenta, direccionPuntoVenta
FROM PuntoVenta
WHERE ciudad = 'Bogota'
ORDER BY nombrePuntoVenta;

-- PuntoVenta 3/8 : Busqueda : puntos de venta cuyo nombre contiene " Centro "
SELECT idPuntoVenta, nombrePuntoVenta, ciudad
FROM PuntoVenta
WHERE nombrePuntoVenta LIKE '%Centro%'
ORDER BY ciudad;

-- PuntoVenta 4/8 : Agrupacion : numero de puntos de venta por ciudad
SELECT ciudad, COUNT(*) AS total_puntos
FROM PuntoVenta
GROUP BY ciudad
ORDER BY total_puntos DESC, ciudad;

-- PuntoVenta 5/8 : Ciudades que tienen al menos 3 puntos de venta (HAVING)
SELECT ciudad, COUNT(*) AS total_puntos
FROM PuntoVenta
GROUP BY ciudad
HAVING COUNT(*) >= 3
ORDER BY total_puntos DESC;

-- PuntoVenta 6/8 : Calculo : numero de ciudades distintas cubiertas
SELECT COUNT(DISTINCT ciudad) AS ciudades_cubiertas, COUNT(*) AS total_puntos
FROM PuntoVenta;

-- PuntoVenta 7/8 : Orden doble : ciudades y luego nombres, excluyendo Bogota
SELECT idPuntoVenta, ciudad, nombrePuntoVenta
FROM PuntoVenta
WHERE ciudad <> 'Bogota'
ORDER BY ciudad, nombrePuntoVenta;

-- PuntoVenta 8/8 : Busqueda : direcciones ubicadas en una " Cra " (carrera)
SELECT idPuntoVenta, nombrePuntoVenta, direccionPuntoVenta
FROM PuntoVenta
WHERE direccionPuntoVenta LIKE 'Cra%'
ORDER BY idPuntoVenta;


-- Tabla Categoria-------------------------------------------------------------------------------------------------------------------
-- Categoria 1/8 : Consulta basica : todas las categorias
SELECT * FROM Categoria;

-- Categoria 2/8 : Categorias cuyo umbral de rentabilidad es >= 35 %, orden descendente
SELECT idCategoria, nombreCategoria, umbralRentabilidad
FROM Categoria
WHERE umbralRentabilidad >= 35
ORDER BY umbralRentabilidad DESC;

-- Categoria 3/8 : Busqueda : categorias de la familia " Inirida "
SELECT idCategoria, nombreCategoria, umbralRentabilidad
FROM Categoria
WHERE nombreCategoria LIKE 'Inirida%'
ORDER BY nombreCategoria;

-- Categoria 4/8 : Calculo : umbral minimo, maximo y promedio
SELECT MIN(umbralRentabilidad) AS umbral_minimo,
       MAX(umbralRentabilidad) AS umbral_maximo,
       ROUND(AVG(umbralRentabilidad), 2) AS umbral_promedio
FROM Categoria;

-- Categoria 5/8 : Categorias sin descripcion (IS NULL)
SELECT idCategoria, nombreCategoria, umbralRentabilidad
FROM Categoria
WHERE descripcion IS NULL;

-- Categoria 6/8 : Las 5 categorias con el umbral mas alto
SELECT idCategoria, nombreCategoria, umbralRentabilidad
FROM Categoria
ORDER BY umbralRentabilidad DESC, nombreCategoria
LIMIT 5;

-- Categoria 7/8 : Agrupacion : umbral promedio por nivel de desempeno (texto despues de " - ")
SELECT SUBSTRING_INDEX(nombreCategoria, ' - ', -1) AS nivel,
       COUNT(*) AS categorias,
       ROUND(AVG(umbralRentabilidad), 2) AS umbral_promedio
FROM Categoria
GROUP BY SUBSTRING_INDEX(nombreCategoria, ' - ', -1)
ORDER BY umbral_promedio DESC;

-- Categoria 8/8 : Categorias con umbral comprendido entre 20 y 30 (BETWEEN)
SELECT idCategoria, nombreCategoria, umbralRentabilidad
FROM Categoria
WHERE umbralRentabilidad BETWEEN 20 AND 30
ORDER BY umbralRentabilidad;


-- Tabla Proveedor------------------------------------------------------------------------------------------------------------------------------
-- Proveedor 1/8 : Consulta basica : todos los proveedores
SELECT * FROM Proveedor;

-- Proveedor 2/8 : Proveedores de flor de Inirida, por orden alfabetico
SELECT idProveedor, nombreProveedor, contacto
FROM Proveedor
WHERE tipoInsumo = 'Flor de Inirida'
ORDER BY nombreProveedor;

-- Proveedor 3/8 : Proveedores sin contacto registrado (IS NULL)
SELECT idProveedor, nombreProveedor, tipoInsumo
FROM Proveedor
WHERE contacto IS NULL
ORDER BY nombreProveedor;

-- Proveedor 4/8 : Busqueda : proveedores cuyo nombre contiene " Agro "
SELECT idProveedor, nombreProveedor, tipoInsumo
FROM Proveedor
WHERE nombreProveedor LIKE '%Agro%'
ORDER BY nombreProveedor;

-- Proveedor 5/8 : Agrupacion : numero de proveedores por tipo de insumo
SELECT tipoInsumo, COUNT(*) AS total_proveedores
FROM Proveedor
GROUP BY tipoInsumo
ORDER BY total_proveedores DESC, tipoInsumo;

-- Proveedor 6/8 : Tipos de insumo con mas de 5 proveedores (HAVING)
SELECT tipoInsumo, COUNT(*) AS total_proveedores
FROM Proveedor
GROUP BY tipoInsumo
HAVING COUNT(*) > 5;

-- Proveedor 7/8 : Proveedores cuyo contacto es una direccion de correo electronico
SELECT idProveedor, nombreProveedor, contacto
FROM Proveedor
WHERE contacto LIKE '%@%'
ORDER BY nombreProveedor;

-- Proveedor 8/8 : Proveedores cuyo contacto es un numero de telefono (10 digitos)
SELECT idProveedor, nombreProveedor, contacto
FROM Proveedor
WHERE contacto REGEXP '^[0-9]{10}$'
ORDER BY idProveedor;


-- Tabla Producto----------------------------------------------------------------------------------------------------------------------
-- Producto 1/8 : Consulta basica : todos los productos
SELECT * FROM Producto;

-- Producto 2/8 : Productos activos cuyo costo supera 20 000, del mas caro al mas barato
SELECT idProducto, nombreProducto, costoUnitario, unidadMedida
FROM Producto
WHERE activo = 1 AND costoUnitario > 20000
ORDER BY costoUnitario DESC;

-- Producto 3/8 : Productos inactivos
SELECT idProducto, nombreProducto, costoUnitario
FROM Producto
WHERE activo = 0
ORDER BY nombreProducto;

-- Producto 4/8 : Busqueda : productos cuyo nombre contiene " Inirida "
SELECT idProducto, nombreProducto, costoUnitario
FROM Producto
WHERE nombreProducto LIKE '%Inirida%'
ORDER BY nombreProducto;

-- Producto 5/8 : Agrupacion : costo promedio, minimo y maximo por unidad de medida
SELECT unidadMedida,
       COUNT(*) AS productos,
       ROUND(AVG(costoUnitario), 2) AS costo_promedio,
       MIN(costoUnitario) AS costo_minimo,
       MAX(costoUnitario) AS costo_maximo
FROM Producto
GROUP BY unidadMedida
ORDER BY costo_promedio DESC;

-- Producto 6/8 : Productos sin proveedor principal (IS NULL)
SELECT idProducto, nombreProducto, costoUnitario
FROM Producto
WHERE idProveedor IS NULL
ORDER BY nombreProducto;

-- Producto 7/8 : Los 10 productos mas caros
SELECT idProducto, nombreProducto, costoUnitario
FROM Producto
ORDER BY costoUnitario DESC
LIMIT 10;

-- Producto 8/8 : Productos cuyo costo esta comprendido entre 5 000 y 15 000 (BETWEEN)
SELECT idProducto, nombreProducto, costoUnitario
FROM Producto
WHERE costoUnitario BETWEEN 5000 AND 15000
ORDER BY costoUnitario;


-- Tabla Inventario----------------------------------------------------------------------------------------------------------------------------
-- Inventario 1/8 : Consulta basica : todo el inventario
SELECT * FROM Inventario;

-- Inventario 2/8 : Articulos con stock bajo (stock actual <= stock minimo)
SELECT idInventario, idProducto, idPuntoVenta, stockActual, stockMinimo
FROM Inventario
WHERE stockActual <= stockMinimo
ORDER BY stockActual;

-- Inventario 3/8 : Articulos agotados
SELECT idInventario, idProducto, idPuntoVenta, estado
FROM Inventario
WHERE stockActual = 0;

-- Inventario 4/8 : Agrupacion : numero de registros y stock total por estado
SELECT estado, COUNT(*) AS registros, SUM(stockActual) AS stock_total
FROM Inventario
GROUP BY estado
ORDER BY registros DESC;

-- Inventario 5/8 : Agrupacion : stock total por punto de venta, los 10 mejor abastecidos
SELECT idPuntoVenta, SUM(stockActual) AS stock_total
FROM Inventario
GROUP BY idPuntoVenta
ORDER BY stock_total DESC
LIMIT 10;

-- Inventario 6/8 : Calculo : tasa de ocupacion (stock actual / stock maximo) en %
SELECT idInventario, idProducto, stockActual, stockMaximo,
       ROUND(stockActual / stockMaximo * 100, 1) AS porcentaje_ocupacion
FROM Inventario
ORDER BY porcentaje_ocupacion DESC;

-- Inventario 7/8 : Calculo : cantidad a reabastecer para los articulos con stock bajo
SELECT idInventario, idProducto, idPuntoVenta, stockMaximo - stockActual AS unidades_a_reponer
FROM Inventario
WHERE estado IN ('Bajo', 'Agotado')
ORDER BY unidades_a_reponer DESC;

-- Inventario 8/8 : Articulos en sobrestock (mas del 80 % del maximo)
SELECT idInventario, idProducto, stockActual, stockMaximo
FROM Inventario
WHERE stockActual > stockMaximo * 0.8
ORDER BY stockActual DESC;


-- Tabla Pedido----------------------------------------------------------------------------------------------------------------------------------
-- Pedido 1/8 : Consulta basica : todos los pedidos
SELECT * FROM Pedido;

-- Pedido 2/8 : Pedidos cuyo anticipo aun no esta pagado (excluyendo los anulados)
SELECT idPedido, idCliente, fechaPedido, estado, anticipo
FROM Pedido
WHERE anticipoPagado = 0 AND estado <> 'Anulado'
ORDER BY fechaPedido;

-- Pedido 3/8 : Pedidos por procesar : estados " Registrado " o " En preparacion " (IN)
SELECT idPedido, idCliente, fechaEntrega, estado
FROM Pedido
WHERE estado IN ('Registrado', 'En preparacion')
ORDER BY fechaEntrega;

-- Pedido 4/8 : Pedidos anulados con su motivo
SELECT idPedido, fechaPedido, motivoAnulacion
FROM Pedido
WHERE estado = 'Anulado'
ORDER BY fechaPedido;

-- Pedido 5/8 : Agrupacion : numero de pedidos por estado
SELECT estado, COUNT(*) AS total_pedidos
FROM Pedido
GROUP BY estado
ORDER BY total_pedidos DESC;

-- Pedido 6/8 : Busqueda : tarjetas que contienen la palabra " amor "
SELECT idPedido, tarjeta
FROM Pedido
WHERE tarjeta LIKE '%amor%'
ORDER BY idPedido;

-- Pedido 7/8 : Calculo : costo de envio promedio y total por canal de venta y tipo de empaque
SELECT canalVenta, tipoEmpaque,
       COUNT(*) AS pedidos,
       ROUND(AVG(costoEnvio), 2) AS envio_promedio,
       SUM(costoEnvio) AS envio_total
FROM Pedido
GROUP BY canalVenta, tipoEmpaque
ORDER BY canalVenta, tipoEmpaque;

-- Pedido 8/8 : Entregas previstas en los proximos 7 dias a partir del 2026-10-10 (BETWEEN)
SELECT idPedido, fechaEntrega, direccionEntrega, estado
FROM Pedido
WHERE fechaEntrega BETWEEN '2026-10-10' AND '2026-10-17'
  AND estado <> 'Anulado'
ORDER BY fechaEntrega;


-- Tabla DetallePedido---------------------------------------------------------------------------------------------------------------------------
-- DetallePedido 1/8 : Consulta basica : todas las lineas de detalle
SELECT * FROM DetallePedido;

-- DetallePedido 2/8 : Lineas con una cantidad de al menos 10 unidades
SELECT idDetalle, idPedido, idProducto, cantidad, precioPactado
FROM DetallePedido
WHERE cantidad >= 10
ORDER BY cantidad DESC;

-- DetallePedido 3/8 : Calculo : subtotal por linea (cantidad x precio), los 10 mas altos
SELECT idDetalle, idPedido, cantidad, precioPactado, cantidad * precioPactado AS subtotal
FROM DetallePedido
ORDER BY subtotal DESC
LIMIT 10;

-- DetallePedido 4/8 : Agrupacion : unidades vendidas por producto, los 10 primeros
SELECT idProducto, SUM(cantidad) AS unidades_vendidas
FROM DetallePedido
GROUP BY idProducto
ORDER BY unidades_vendidas DESC
LIMIT 10;

-- DetallePedido 5/8 : Agrupacion : monto de los productos por pedido, los 10 mas altos
SELECT idPedido, SUM(cantidad * precioPactado) AS total_productos
FROM DetallePedido
GROUP BY idPedido
ORDER BY total_productos DESC
LIMIT 10;

-- DetallePedido 6/8 : Calculo : precio pactado minimo, maximo y promedio
SELECT MIN(precioPactado) AS precio_minimo,
       MAX(precioPactado) AS precio_maximo,
       ROUND(AVG(precioPactado), 2) AS precio_promedio
FROM DetallePedido;

-- DetallePedido 7/8 : Pedidos con mas de 2 lineas (HAVING)
SELECT idPedido, COUNT(*) AS lineas
FROM DetallePedido
GROUP BY idPedido
HAVING COUNT(*) > 2
ORDER BY lineas DESC, idPedido;

-- DetallePedido 8/8 : Detalle del pedido numero 10 (filtro)
SELECT idDetalle, idProducto, cantidad, precioPactado, cantidad * precioPactado AS subtotal
FROM DetallePedido
WHERE idPedido = 10;


-- Tabla Pago--------------------------------------------------------------------------------------------------------------------------------------
-- Pago 1/8 : Consulta basica : todos los pagos
SELECT * FROM Pago;

-- Pago 2/8 : Pagos realizados por transferencia (" Transferencia ")
SELECT idPago, idPedido, monto, fechaPago
FROM Pago
WHERE tipoPago = 'Transferencia'
ORDER BY fechaPago;

-- Pago 3/8 : Pagos superiores a 500 000, del mas alto al mas bajo
SELECT idPago, idPedido, tipoPago, monto
FROM Pago
WHERE monto > 500000
ORDER BY monto DESC;

-- Pago 4/8 : Pagos de septiembre de 2026 (BETWEEN sobre fechas)
SELECT idPago, idPedido, tipoPago, monto, fechaPago
FROM Pago
WHERE fechaPago BETWEEN '2026-09-01' AND '2026-09-30'
ORDER BY fechaPago;

-- Pago 5/8 : Agrupacion : monto total recaudado por medio de pago
SELECT tipoPago, COUNT(*) AS pagos, SUM(monto) AS total_recaudado, ROUND(AVG(monto), 2) AS pago_promedio
FROM Pago
GROUP BY tipoPago
ORDER BY total_recaudado DESC;

-- Pago 6/8 : Agrupacion : recaudos por mes
SELECT YEAR(fechaPago) AS anio, MONTH(fechaPago) AS mes, SUM(monto) AS total_mes
FROM Pago
GROUP BY YEAR(fechaPago), MONTH(fechaPago)
ORDER BY anio, mes;

-- Pago 7/8 : Pedidos que recibieron 2 pagos (anticipo + saldo)
SELECT idPedido, COUNT(*) AS num_pagos, SUM(monto) AS total_pagado
FROM Pago
GROUP BY idPedido
HAVING COUNT(*) = 2
ORDER BY idPedido
LIMIT 15;

-- Pago 8/8 : Los 10 pagos mas recientes
SELECT idPago, idPedido, tipoPago, monto, fechaPago
FROM Pago
ORDER BY fechaPago DESC, idPago DESC
LIMIT 10;


-- Tabla Alerta---------------------------------------------------------------------------------------------------------------------------------------
-- Alerta 1/8 : Consulta basica : todas las alertas
SELECT * FROM Alerta;

-- Alerta 2/8 : Alertas de tipo " Baja rentabilidad "
SELECT idAlerta, idProducto, fechaGeneracion, mensaje
FROM Alerta
WHERE tipoAlerta = 'Baja rentabilidad'
ORDER BY fechaGeneracion;

-- Alerta 3/8 : Alertas generadas en septiembre de 2026
SELECT idAlerta, idProducto, fechaGeneracion, tipoAlerta
FROM Alerta
WHERE fechaGeneracion BETWEEN '2026-09-01' AND '2026-09-30'
ORDER BY fechaGeneracion;

-- Alerta 4/8 : Busqueda : alertas que mencionan " agotado "
SELECT idAlerta, idProducto, mensaje
FROM Alerta
WHERE mensaje LIKE '%agotado%';

-- Alerta 5/8 : Agrupacion : numero de alertas por tipo
SELECT tipoAlerta, COUNT(*) AS total_alertas
FROM Alerta
GROUP BY tipoAlerta
ORDER BY total_alertas DESC;

-- Alerta 6/8 : Los 5 productos que generan mas alertas
SELECT idProducto, COUNT(*) AS total_alertas
FROM Alerta
GROUP BY idProducto
ORDER BY total_alertas DESC, idProducto
LIMIT 5;

-- Alerta 7/8 : Agrupacion : alertas por mes
SELECT YEAR(fechaGeneracion) AS anio, MONTH(fechaGeneracion) AS mes, COUNT(*) AS total_alertas
FROM Alerta
GROUP BY YEAR(fechaGeneracion), MONTH(fechaGeneracion)
ORDER BY anio, mes;

-- Alerta 8/8 : Las 10 ultimas alertas generadas
SELECT idAlerta, idProducto, fechaGeneracion, tipoAlerta
FROM Alerta
ORDER BY fechaGeneracion DESC, idAlerta DESC
LIMIT 10;


-- D. MODIFICACION Y ELIMINACION DE DATOS (5 UPDATE + 1 DELETE)

-- NB : el enunciado no precisa si estas operaciones deben aplicarse a cada tabla o a
-- toda la base de datos. Aqui : 5 UPDATE sobre 5 tablas diferentes + 1 DELETE, para toda la base.
-- El modo " safe updates " de Workbench rechaza los UPDATE/DELETE sin clave en el WHERE :
-- se desactiva durante esta seccion.
SET SQL_SAFE_UPDATES = 0;

-- UPDATE 1 : aumentar un 5 % el costo de los productos de la familia " Inirida natural "
UPDATE Producto
SET costoUnitario = ROUND(costoUnitario * 1.05, 2)
WHERE idCategoria IN (SELECT idCategoria FROM Categoria WHERE nombreCategoria LIKE 'Inirida natural%');

-- UPDATE 2 : pasar a preparacion los pedidos registrados cuyo anticipo esta pagado
UPDATE Pedido
SET estado = 'En preparacion'
WHERE estado = 'Registrado' AND anticipoPagado = 1;

-- UPDATE 3 : corregir la direccion del cliente numero 5
UPDATE Cliente
SET direccion = 'Cra 7 # 45-10, Bogota'
WHERE idCliente = 5;

-- UPDATE 4 : reabastecer en 50 unidades los articulos con stock bajo
UPDATE Inventario
SET stockActual = stockActual + 50,
    estado = 'Disponible'
WHERE estado = 'Bajo';

-- UPDATE 5 : desbloquear la cuenta del usuario 1 y reiniciar a cero sus intentos fallidos
UPDATE Usuario
SET intentosFallidos = 0,
    bloqueado = 0
WHERE idUsuario = 1;

-- DELETE : eliminar una alerta de stock bajo que quedo obsoleta (ninguna tabla depende de ella)
DELETE FROM Alerta
WHERE idAlerta = 59 AND tipoAlerta = 'Stock bajo';

SET SQL_SAFE_UPDATES = 1;

-- Verificacion de las modificaciones
SELECT idUsuario, nombre, intentosFallidos, bloqueado FROM Usuario WHERE idUsuario = 1;
SELECT idCliente, direccion FROM Cliente WHERE idCliente = 5;
SELECT estado, COUNT(*) AS total FROM Inventario GROUP BY estado;
SELECT COUNT(*) AS alertas_restantes FROM Alerta;


-- E. CONSULTAS AVANZADAS : JOIN Y SUBCONSULTAS
-- E.1 Uniones (JOIN)
-- JOIN 1/8 : INNER JOIN sobre 3 tablas : pedidos con cliente y punto de venta
SELECT p.idPedido, p.fechaPedido, p.estado, c.nombreCliente, c.tipoCliente, pv.nombrePuntoVenta, pv.ciudad
FROM Pedido p
INNER JOIN Cliente c      ON c.idCliente = p.idCliente
INNER JOIN PuntoVenta pv  ON pv.idPuntoVenta = p.idPuntoVenta
ORDER BY p.fechaPedido DESC
LIMIT 15;

-- JOIN 2/8 : INNER JOIN sobre 4 tablas : detalle de los 10 primeros pedidos con subtotal calculado
SELECT p.idPedido, c.nombreCliente, pr.nombreProducto, dp.cantidad, dp.precioPactado,
       dp.cantidad * dp.precioPactado AS subtotal
FROM DetallePedido dp
INNER JOIN Pedido p   ON p.idPedido = dp.idPedido
INNER JOIN Cliente c  ON c.idCliente = p.idCliente
INNER JOIN Producto pr ON pr.idProducto = dp.idProducto
WHERE p.idPedido <= 10
ORDER BY p.idPedido, pr.nombreProducto;

-- JOIN 3/8 : LEFT JOIN : clientes que nunca han hecho un pedido
SELECT c.idCliente, c.nombreCliente, c.tipoCliente, c.activo
FROM Cliente c
LEFT JOIN Pedido p ON p.idCliente = c.idCliente
WHERE p.idPedido IS NULL
ORDER BY c.nombreCliente;

-- JOIN 4/8 : JOIN Producto - Categoria - Proveedor (LEFT JOIN porque el proveedor puede ser NULL)
SELECT pr.idProducto, pr.nombreProducto, ca.nombreCategoria, ca.umbralRentabilidad,
       COALESCE(prov.nombreProveedor, 'Sin proveedor') AS proveedor
FROM Producto pr
INNER JOIN Categoria ca ON ca.idCategoria = pr.idCategoria
LEFT JOIN Proveedor prov ON prov.idProveedor = pr.idProveedor
ORDER BY ca.nombreCategoria, pr.nombreProducto
LIMIT 20;

-- JOIN 5/8 : JOIN + agregacion : anticipo, total pagado y numero de pagos por pedido
SELECT p.idPedido, c.nombreCliente, p.estado, p.anticipo,
       COALESCE(SUM(pg.monto), 0) AS total_pagado,
       COUNT(pg.idPago) AS num_pagos
FROM Pedido p
INNER JOIN Cliente c ON c.idCliente = p.idCliente
LEFT JOIN Pago pg    ON pg.idPedido = p.idPedido
GROUP BY p.idPedido, c.nombreCliente, p.estado, p.anticipo
ORDER BY total_pagado DESC
LIMIT 15;

-- JOIN 6/8 : JOIN Inventario - Producto - PuntoVenta : articulos por reabastecer
SELECT pv.nombrePuntoVenta, pr.nombreProducto, i.stockActual, i.stockMinimo, i.estado
FROM Inventario i
INNER JOIN Producto pr   ON pr.idProducto = i.idProducto
INNER JOIN PuntoVenta pv ON pv.idPuntoVenta = i.idPuntoVenta
WHERE i.stockActual <= i.stockMinimo
ORDER BY i.stockActual, pv.nombrePuntoVenta;

-- JOIN 7/8 : Rentabilidad por punto de venta (4 tablas : PuntoVenta, Pedido, DetallePedido, Producto)
SELECT pv.idPuntoVenta, pv.nombrePuntoVenta, pv.ciudad,
       SUM(dp.cantidad * dp.precioPactado) AS ingresos,
       SUM(dp.cantidad * pr.costoUnitario) AS costos,
       SUM(dp.cantidad * (dp.precioPactado - pr.costoUnitario)) AS utilidad,
       ROUND(SUM(dp.cantidad * (dp.precioPactado - pr.costoUnitario))
             / SUM(dp.cantidad * dp.precioPactado) * 100, 2) AS margen_pct
FROM PuntoVenta pv
INNER JOIN Pedido p         ON p.idPuntoVenta = pv.idPuntoVenta AND p.estado <> 'Anulado'
INNER JOIN DetallePedido dp ON dp.idPedido = p.idPedido
INNER JOIN Producto pr      ON pr.idProducto = dp.idProducto
GROUP BY pv.idPuntoVenta, pv.nombrePuntoVenta, pv.ciudad
ORDER BY utilidad DESC
LIMIT 10;

-- JOIN 8/8 : JOIN Usuario - PuntoVenta - Pedido : pedidos gestionados por cada administrador
SELECT u.idUsuario, u.nombre, pv.nombrePuntoVenta, COUNT(p.idPedido) AS pedidos_gestionados
FROM Usuario u
INNER JOIN PuntoVenta pv ON pv.idPuntoVenta = u.idPuntoVenta
LEFT JOIN Pedido p       ON p.idUsuario = u.idUsuario
GROUP BY u.idUsuario, u.nombre, pv.nombrePuntoVenta
ORDER BY pedidos_gestionados DESC, u.nombre
LIMIT 10;


-- E.2 Subconsultas (subqueries)----------------------------------------------------------------------------------------------
-- SUBCONSULTA 1/8 : Subconsulta escalar : productos cuyo costo supera el promedio
SELECT idProducto, nombreProducto, costoUnitario
FROM Producto
WHERE costoUnitario > (SELECT AVG(costoUnitario) FROM Producto)
ORDER BY costoUnitario DESC;

-- SUBCONSULTA 2/8 : Subconsulta con IN : clientes con al menos un pedido entregado
SELECT idCliente, nombreCliente, tipoCliente
FROM Cliente
WHERE idCliente IN (SELECT idCliente FROM Pedido WHERE estado = 'Entregado')
ORDER BY nombreCliente;

-- SUBCONSULTA 3/8 : Subconsulta con NOT EXISTS : puntos de venta sin ningun pedido
SELECT pv.idPuntoVenta, pv.nombrePuntoVenta, pv.ciudad
FROM PuntoVenta pv
WHERE NOT EXISTS (SELECT 1 FROM Pedido p WHERE p.idPuntoVenta = pv.idPuntoVenta)
ORDER BY pv.ciudad, pv.nombrePuntoVenta;

-- SUBCONSULTA 4/8 : Subconsultas en FROM y WHERE : pedidos cuyo monto supera el promedio
SELECT t.idPedido, t.total_productos
FROM (SELECT idPedido, SUM(cantidad * precioPactado) AS total_productos
      FROM DetallePedido
      GROUP BY idPedido) AS t
WHERE t.total_productos > (SELECT AVG(x.total_productos)
                           FROM (SELECT SUM(cantidad * precioPactado) AS total_productos
                                 FROM DetallePedido
                                 GROUP BY idPedido) AS x)
ORDER BY t.total_productos DESC;

-- SUBCONSULTA 5/8 : Subconsulta en HAVING : producto(s) mas vendido(s)
SELECT pr.idProducto, pr.nombreProducto, SUM(dp.cantidad) AS unidades
FROM DetallePedido dp
INNER JOIN Producto pr ON pr.idProducto = dp.idProducto
GROUP BY pr.idProducto, pr.nombreProducto
HAVING SUM(dp.cantidad) = (SELECT MAX(m.unidades)
                           FROM (SELECT SUM(cantidad) AS unidades
                                 FROM DetallePedido
                                 GROUP BY idProducto) AS m);

-- SUBCONSULTA 6/8 : Subconsulta correlacionada : ultimo pago de cada pedido
SELECT pg.idPedido, pg.idPago, pg.tipoPago, pg.monto, pg.fechaPago
FROM Pago pg
WHERE pg.fechaPago = (SELECT MAX(p2.fechaPago) FROM Pago p2 WHERE p2.idPedido = pg.idPedido)
ORDER BY pg.idPedido
LIMIT 15;

-- SUBCONSULTA 7/8 : Subconsulta con EXISTS : productos con al menos una alerta de baja rentabilidad
SELECT pr.idProducto, pr.nombreProducto, pr.costoUnitario
FROM Producto pr
WHERE EXISTS (SELECT 1 FROM Alerta a
              WHERE a.idProducto = pr.idProducto AND a.tipoAlerta = 'Baja rentabilidad')
ORDER BY pr.nombreProducto;

-- SUBCONSULTA 8/8 : Subconsulta en SELECT : numero de productos por categoria, top 10
SELECT ca.idCategoria, ca.nombreCategoria,
       (SELECT COUNT(*) FROM Producto pr WHERE pr.idCategoria = ca.idCategoria) AS num_productos
FROM Categoria ca
ORDER BY num_productos DESC, ca.nombreCategoria
LIMIT 10;





-- =====================================================================
-- 5. EJEMPLOS DE USO DE VISTAS, FUNCION Y PROCEDIMIENTOS
-- =====================================================================

-- Ejemplos de uso de las vistas, de la funcion y de los procedimientos
SELECT * FROM vw_detalle_pedido WHERE idPedido = 10;
SELECT * FROM vw_resumen_pedido WHERE saldo_pendiente > 0 AND estado <> 'Anulado' ORDER BY saldo_pendiente DESC LIMIT 10;
SELECT * FROM vw_rentabilidad_producto WHERE diagnostico = 'Bajo el umbral' ORDER BY margen_pct LIMIT 10;
SELECT * FROM vw_inventario_critico ORDER BY unidades_a_reponer DESC;

SELECT fn_total_pedido(10) AS total_pedido_10;

CALL sp_resumen_pedido(10);
CALL sp_rentabilidad_punto_venta(50, '2026-01-01', '2026-10-10');

-- Las siguientes llamadas modifican datos : se ejecutan dentro de una transaccion
-- anulada con ROLLBACK para dejar la base de datos intacta.
START TRANSACTION;
    SET @anticipo = (SELECT anticipo FROM Pedido WHERE idPedido = 58);
    CALL sp_registrar_pago(58, 'Transferencia', @anticipo, '2026-10-10');
    SELECT idPedido, anticipoPagado FROM Pedido WHERE idPedido = 58;   -- debe valer 1
    CALL sp_actualizar_estado_pedido(57, 'En preparacion', NULL);
ROLLBACK;

-- Ejemplo de error controlado (ejecutar solo, debe mostrar un mensaje de error) :
-- CALL sp_actualizar_estado_pedido(57, 'Anulado', NULL);



-- =====================================================================
-- 6. TRIGGERS Y SUS PRUEBAS
-- =====================================================================

-- 6.1 Los tres triggers del script principal
-- G. TRIGGERS (3)
DELIMITER $$
-- Trigger 1 : despues de insertar una linea de pedido, generar automaticamente
-- una alerta " Baja rentabilidad " si el margen es inferior al umbral de la categoria.

CREATE TRIGGER trg_detalle_alerta_rentabilidad
AFTER INSERT ON DetallePedido
FOR EACH ROW
BEGIN
    DECLARE v_costo  DECIMAL(12,2);
    DECLARE v_umbral DECIMAL(5,2);
    DECLARE v_margen DECIMAL(10,2);

    SELECT pr.costoUnitario, ca.umbralRentabilidad
      INTO v_costo, v_umbral
    FROM Producto pr
    INNER JOIN Categoria ca ON ca.idCategoria = pr.idCategoria
    WHERE pr.idProducto = NEW.idProducto;

    SET v_margen = ROUND((NEW.precioPactado - v_costo) / NEW.precioPactado * 100, 2);

    IF v_margen < v_umbral THEN
        INSERT INTO Alerta (idProducto, fechaGeneracion, mensaje, tipoAlerta)
        VALUES (NEW.idProducto, CURDATE(),
                CONCAT('Margen ', v_margen, '% inferior al umbral ', v_umbral, '% en pedido ', NEW.idPedido),
                'Baja rentabilidad');
    END IF;
END$$


-- Trigger 2 : antes de modificar un pedido, prohibir el estado " Anulado "----------------------------------------------------------------
-- sin motivo, y borrar el motivo si el pedido ya no esta anulado.
CREATE TRIGGER trg_pedido_validar_anulacion
BEFORE UPDATE ON Pedido
FOR EACH ROW
BEGIN
    IF NEW.estado = 'Anulado' AND (NEW.motivoAnulacion IS NULL OR TRIM(NEW.motivoAnulacion) = '') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Un pedido anulado debe tener un motivo de anulacion';
    END IF;

    IF NEW.estado <> 'Anulado' THEN
        SET NEW.motivoAnulacion = NULL;
    END IF;
END$$


-- Trigger 3 : antes de modificar un usuario, bloquear la cuenta-------------------------------------------------------------------
-- automaticamente a partir de 3 intentos de conexion fallidos.
CREATE TRIGGER trg_usuario_bloqueo_automatico
BEFORE UPDATE ON Usuario
FOR EACH ROW
BEGIN
    IF NEW.intentosFallidos >= 3 THEN
        SET NEW.bloqueado = 1;
    END IF;
END$$

DELIMITER ;

-- Pruebas de los triggers (dentro de una transaccion anulada con ROLLBACK)
START TRANSACTION;
    -- Prueba trigger 1 : precio apenas superior al costo => margen ~2 % => alerta creada
    INSERT INTO DetallePedido (idPedido, idProducto, cantidad, precioPactado)
    VALUES (1, 1, 2, 156570.00);
    SELECT * FROM Alerta ORDER BY idAlerta DESC LIMIT 1;          -- la alerta acaba de generarse

    -- Prueba trigger 3 : 3 fallos de conexion => bloqueado pasa a 1 automaticamente
    UPDATE Usuario SET intentosFallidos = 3 WHERE idUsuario = 11;
    SELECT idUsuario, intentosFallidos, bloqueado FROM Usuario WHERE idUsuario = 11;
ROLLBACK;

-- Prueba trigger 2 (ejecutar solo : debe fallar con el mensaje del trigger) :
-- UPDATE Pedido SET estado = 'Anulado' WHERE idPedido = 57;
-- Con un motivo, la modificacion es aceptada :

-- 6.2 Coherencia de las alertas (before insert / before update)

-- La coherencia entre estado, fechaAtencion e idUsuarioAtiende se controla
-- con un trigger y no con un CHECK, porque MySQL no admite una restriccion
-- CHECK sobre una columna que tiene clave foranea. Se comprobo en los dos
-- ordenes posibles y el motor la rechaza igual.
DROP TRIGGER IF EXISTS trg_alerta_coherencia_bi;
DROP TRIGGER IF EXISTS trg_alerta_coherencia_bu;

DELIMITER $$

CREATE TRIGGER trg_alerta_coherencia_bi
BEFORE INSERT ON Alerta
FOR EACH ROW
BEGIN
    IF NEW.estado = 'Abierta'
       AND (NEW.fechaAtencion IS NOT NULL OR NEW.idUsuarioAtiende IS NOT NULL) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Una alerta abierta no lleva fecha ni usuario de atencion';
    END IF;
    IF NEW.estado <> 'Abierta'
       AND (NEW.fechaAtencion IS NULL OR NEW.idUsuarioAtiende IS NULL) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Una alerta cerrada exige fecha y usuario de atencion';
    END IF;
END$$

CREATE TRIGGER trg_alerta_coherencia_bu
BEFORE UPDATE ON Alerta
FOR EACH ROW
BEGIN
    IF NEW.estado = 'Abierta'
       AND (NEW.fechaAtencion IS NOT NULL OR NEW.idUsuarioAtiende IS NOT NULL) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Una alerta abierta no lleva fecha ni usuario de atencion';
    END IF;
    IF NEW.estado <> 'Abierta'
       AND (NEW.fechaAtencion IS NULL OR NEW.idUsuarioAtiende IS NULL) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Una alerta cerrada exige fecha y usuario de atencion';
    END IF;
END$$

DELIMITER ;


-- =====================================================================
-- 7. MEJORAS DE DATOS Y TRIGGERS DE INVENTARIO
-- =====================================================================

-- 7.1 El inventario cubria 3 de los 132 pares producto / punto de venta que
-- registran ventas. Se completa con niveles derivados de lo vendido, para
-- que el control de existencias tenga sobre que actuar.
INSERT INTO Inventario (idProducto, idPuntoVenta, estado,
                        stockActual, stockMinimo, stockMaximo)
SELECT v.idProducto,
       v.idPuntoVenta,
       'Disponible',
       GREATEST(CEIL(GREATEST(60, v.unidades * 2) * 0.60), 1),
       CEIL(GREATEST(60, v.unidades * 2) * 0.15),
       GREATEST(60, v.unidades * 2)
FROM (
    SELECT dp.idProducto, p.idPuntoVenta, SUM(dp.cantidad) AS unidades
    FROM DetallePedido dp
    INNER JOIN Pedido p ON p.idPedido = dp.idPedido
    WHERE p.estado <> 'Anulado'
    GROUP BY dp.idProducto, p.idPuntoVenta
) v
LEFT JOIN Inventario i
       ON i.idProducto = v.idProducto AND i.idPuntoVenta = v.idPuntoVenta
WHERE i.idInventario IS NULL;

-- 7.2 Triggers que mantienen el saldo del inventario
DROP TRIGGER IF EXISTS trg_detalle_valida_stock;
DROP TRIGGER IF EXISTS trg_detalle_descuenta_stock;
DROP TRIGGER IF EXISTS trg_detalle_reintegra_stock;

DELIMITER $$

-- Antes de insertar la linea se comprueba que haya existencias.
CREATE TRIGGER trg_detalle_valida_stock
BEFORE INSERT ON DetallePedido
FOR EACH ROW
BEGIN
    DECLARE v_puntoVenta INT;
    DECLARE v_stock      INT;

    SELECT idPuntoVenta INTO v_puntoVenta
      FROM Pedido WHERE idPedido = NEW.idPedido;

    SELECT stockActual INTO v_stock
      FROM Inventario
     WHERE idProducto = NEW.idProducto AND idPuntoVenta = v_puntoVenta;

    IF v_stock IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El producto no tiene inventario en ese punto de venta';
    END IF;
    IF v_stock < NEW.cantidad THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Existencias insuficientes en el punto de venta';
    END IF;
END$$

-- Despues de insertarla se descuenta el saldo y se recalcula el estado.
CREATE TRIGGER trg_detalle_descuenta_stock
AFTER INSERT ON DetallePedido
FOR EACH ROW
BEGIN
    DECLARE v_puntoVenta INT;

    SELECT idPuntoVenta INTO v_puntoVenta
      FROM Pedido WHERE idPedido = NEW.idPedido;

    UPDATE Inventario
       SET stockActual = stockActual - NEW.cantidad,
           estado = IF(stockActual - NEW.cantidad = 0, 'Agotado', 'Disponible')
     WHERE idProducto = NEW.idProducto AND idPuntoVenta = v_puntoVenta;
END$$

-- Si la linea se elimina, las existencias vuelven.
CREATE TRIGGER trg_detalle_reintegra_stock
AFTER DELETE ON DetallePedido
FOR EACH ROW
BEGIN
    DECLARE v_puntoVenta INT;

    SELECT idPuntoVenta INTO v_puntoVenta
      FROM Pedido WHERE idPedido = OLD.idPedido;

    IF v_puntoVenta IS NOT NULL THEN
        UPDATE Inventario
           SET stockActual = stockActual + OLD.cantidad,
               estado = 'Disponible'
         WHERE idProducto = OLD.idProducto AND idPuntoVenta = v_puntoVenta;
    END IF;
END$$

DELIMITER ;

-- 7.3 Contrasenas: se reemplazan por SHA-256 de una clave temporal
-- (CambiarEnPrimerIngreso2026) y se marca que deben cambiarla. Un hash no
-- se puede convertir: no se conserva la contrasena original.
UPDATE Usuario
   SET contrasena = SHA2('CambiarEnPrimerIngreso2026', 256),
       debeCambiarClave = 1
 WHERE idUsuario > 0;   -- WHERE sobre la clave: compatible con el modo seguro de Workbench


-- =====================================================================
-- 8. COMPROBACIONES
-- =====================================================================

SELECT '--- P1: las alertas quedan con estado ---' AS prueba;
SELECT estado, COUNT(*) AS alertas FROM Alerta GROUP BY estado;

SELECT '--- P2: cerrar una alerta ---' AS prueba;
START TRANSACTION;
  CALL sp_atender_alerta((SELECT MIN(idAlerta) FROM Alerta WHERE estado='Abierta'),
                         1, 'Atendida');
ROLLBACK;

SELECT '--- P3: no se puede cerrar dos veces ---' AS prueba;
START TRANSACTION;
  SET @a = (SELECT MIN(idAlerta) FROM Alerta WHERE estado='Abierta');
  CALL sp_atender_alerta(@a, 1, 'Atendida');
  -- Segunda llamada (debe fallar: La alerta ya fue cerrada). Ejecutar sola:
  -- CALL sp_atender_alerta(@a, 1, 'Atendida');
ROLLBACK;

SELECT '--- P4: cerrar una alerta sin usuario se rechaza ---' AS prueba;
-- Debe fallar: Una alerta cerrada exige fecha y usuario de atencion. Ejecutar solo:
-- UPDATE Alerta SET estado = 'Atendida'
--  WHERE idAlerta = (SELECT MIN(idAlerta) FROM Alerta WHERE estado = 'Abierta');

SELECT '--- P5: cobertura del inventario ---' AS prueba;
SELECT (SELECT COUNT(*) FROM Inventario) AS filas_inventario,
       (SELECT COUNT(*) FROM (
          SELECT DISTINCT dp.idProducto, p.idPuntoVenta
          FROM DetallePedido dp JOIN Pedido p ON p.idPedido = dp.idPedido
          WHERE p.estado <> 'Anulado') t
        LEFT JOIN Inventario i ON i.idProducto = t.idProducto
                              AND i.idPuntoVenta = t.idPuntoVenta
        WHERE i.idInventario IS NULL) AS pares_sin_inventario;

SELECT '--- P6: una venta descuenta el inventario ---' AS prueba;
-- Se elige un pedido y un producto que tenga existencias en el punto de
-- venta de ese pedido y que no este ya en su detalle.
SET @ped = (SELECT p.idPedido FROM Pedido p
            JOIN Inventario i ON i.idPuntoVenta = p.idPuntoVenta
            WHERE i.stockActual >= 10
              AND NOT EXISTS (SELECT 1 FROM DetallePedido d
                              WHERE d.idPedido = p.idPedido
                                AND d.idProducto = i.idProducto)
            ORDER BY p.idPedido LIMIT 1);
SET @prod = (SELECT i.idProducto FROM Pedido p
             JOIN Inventario i ON i.idPuntoVenta = p.idPuntoVenta
             WHERE p.idPedido = @ped AND i.stockActual >= 10
               AND NOT EXISTS (SELECT 1 FROM DetallePedido d
                               WHERE d.idPedido = p.idPedido
                                 AND d.idProducto = i.idProducto)
             ORDER BY i.idProducto LIMIT 1);
SELECT @ped AS pedido_de_prueba, @prod AS producto_de_prueba;

START TRANSACTION;
  SELECT stockActual AS stock_antes FROM Inventario
   WHERE idProducto = @prod
     AND idPuntoVenta = (SELECT idPuntoVenta FROM Pedido WHERE idPedido = @ped);
  INSERT INTO DetallePedido (idPedido, idProducto, cantidad, precioPactado)
  VALUES (@ped, @prod, 5, 200000.00);
  SELECT stockActual AS stock_despues FROM Inventario
   WHERE idProducto = @prod
     AND idPuntoVenta = (SELECT idPuntoVenta FROM Pedido WHERE idPedido = @ped);
ROLLBACK;

SELECT '--- P7: vender mas de lo que hay se rechaza ---' AS prueba;
-- Debe fallar: Existencias insuficientes en el punto de venta. Ejecutar solo:
-- INSERT INTO DetallePedido (idPedido, idProducto, cantidad, precioPactado)
-- VALUES (@ped, @prod, 99999, 200000.00);

SELECT '--- P8: vender un producto sin inventario en ese punto se rechaza ---' AS prueba;
SET @sinInv = (SELECT pr.idProducto FROM Producto pr
               WHERE NOT EXISTS (SELECT 1 FROM Inventario i
                                 WHERE i.idProducto = pr.idProducto
                                   AND i.idPuntoVenta = (SELECT idPuntoVenta
                                       FROM Pedido WHERE idPedido = @ped))
               LIMIT 1);
-- Debe fallar: El producto no tiene inventario en ese punto de venta. Ejecutar solo:
-- INSERT INTO DetallePedido (idPedido, idProducto, cantidad, precioPactado)
-- VALUES (@ped, @sinInv, 1, 200000.00);

SELECT '--- P9: eliminar una linea reintegra el inventario ---' AS prueba;
START TRANSACTION;
  INSERT INTO DetallePedido (idPedido, idProducto, cantidad, precioPactado)
  VALUES (@ped, @prod, 5, 200000.00);
  SET @d = LAST_INSERT_ID();
  SELECT stockActual AS stock_tras_venta FROM Inventario
   WHERE idProducto = @prod
     AND idPuntoVenta = (SELECT idPuntoVenta FROM Pedido WHERE idPedido = @ped);
  DELETE FROM DetallePedido WHERE idDetalle = @d;
  SELECT stockActual AS stock_tras_borrado FROM Inventario
   WHERE idProducto = @prod
     AND idPuntoVenta = (SELECT idPuntoVenta FROM Pedido WHERE idPedido = @ped);
ROLLBACK;

SELECT '--- P10: la contrasena quedo en SHA-256 ---' AS prueba;
SELECT CHARACTER_MAXIMUM_LENGTH AS largo_columna
  FROM information_schema.COLUMNS
 WHERE TABLE_SCHEMA='liwi_flor_eterna' AND TABLE_NAME='Usuario'
   AND COLUMN_NAME='contrasena';
SELECT COUNT(*) AS usuarios_que_deben_cambiarla FROM Usuario WHERE debeCambiarClave = 1;

SELECT '--- P11: cambio de contrasena correcto ---' AS prueba;
START TRANSACTION;
  CALL sp_cambiar_clave(1, 'CambiarEnPrimerIngreso2026', 'FlorDeInirida2026');
  SELECT idUsuario, debeCambiarClave FROM Usuario WHERE idUsuario = 1;
ROLLBACK;

SELECT '--- P12: contrasena actual equivocada se rechaza ---' AS prueba;
-- Debe fallar: La contrasena actual no coincide. Ejecutar solo:
-- CALL sp_cambiar_clave(1, 'claveQueNoEs', 'FlorDeInirida2026');

SELECT '--- P13: contrasena nueva demasiado corta se rechaza ---' AS prueba;
-- Debe fallar: La nueva contrasena debe tener al menos 8 caracteres. Ejecutar solo:
-- CALL sp_cambiar_clave(1, 'CambiarEnPrimerIngreso2026', 'corta');


-- Fin de 02_DML.sql
