-- =====================================================================
-- Liwi Flor Eterna - 01_DDL.sql  (DEFINICION DE LA ESTRUCTURA)
--
-- Crea la base de datos y todo lo que la define, sin cargar datos:
--
--   1. Base de datos y las 12 tablas (claves, restricciones CHECK, FK)
--   2. Ajustes de estructura: estado de las alertas y hash SHA-256
--   3. Indices
--   4. La funcion y los 6 procedimientos almacenados
--   5. Las 5 vistas
--
-- Los 8 triggers NO estan aqui a proposito. Se crean en 02_DML.sql
-- justo despues de la carga, porque si existieran antes se dispararian
-- durante la insercion de los datos (crearian alertas de mas y el control
-- de existencias rechazaria las ventas historicas).
--
-- ORDEN DE EJECUCION:  1) 01_DDL.sql    2) 02_DML.sql
--
--   mysql -u root -p < 01_DDL.sql
--   mysql -u root -p < 02_DML.sql
-- =====================================================================


-- =====================================================================
-- 1. BASE DE DATOS Y TABLAS
-- =====================================================================

SET FOREIGN_KEY_CHECKS = 0; -- desactiva la comprobacion de claves externas, lo que permite eliminar y volver a crear la base de datos

DROP DATABASE IF EXISTS liwi_flor_eterna;	-- en caso de que ya hayamos la database 
CREATE DATABASE liwi_flor_eterna CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE liwi_flor_eterna;

SET FOREIGN_KEY_CHECKS = 1;

-- creamos las tablas en el orden padres to hijos

CREATE TABLE PuntoVenta (
    idPuntoVenta INT NOT NULL AUTO_INCREMENT,
    nombrePuntoVenta VARCHAR(50)  NOT NULL,
    ciudad VARCHAR(30)  NOT NULL,
    direccionPuntoVenta VARCHAR(100) NOT NULL,
    CONSTRAINT pk_puntoventa PRIMARY KEY (idPuntoVenta)
) ENGINE = InnoDB;

CREATE TABLE Usuario (
    idUsuario INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    correo VARCHAR(50) NOT NULL,
    contrasena VARCHAR(50)  NOT NULL,      -- hash de la contrasena (SHA-1 hex = 40 car.)
    rol VARCHAR(15) NOT NULL,
    fechaRegistro DATE NOT NULL,
    ultimoAcceso DATETIME NULL,
    intentosFallidos INT NOT NULL DEFAULT 0,
    bloqueado BOOLEAN NOT NULL DEFAULT 0,
    idPuntoVenta INT NULL,
    CONSTRAINT pk_usuario PRIMARY KEY (idUsuario),
    CONSTRAINT uq_usuario_correo UNIQUE (correo),
    CONSTRAINT chk_usuario_rol CHECK (rol IN ('Socio', 'Administrador')),
    CONSTRAINT chk_usuario_intentos CHECK (intentosFallidos >= 0), -- Un socio no tiene punto de venta pero un admin tiene uno
    CONSTRAINT chk_usuario_pv CHECK ((rol = 'Socio' AND idPuntoVenta IS NULL)
                                  OR (rol = 'Administrador' AND idPuntoVenta IS NOT NULL)),
    CONSTRAINT fk_usuario_puntov FOREIGN KEY (idPuntoVenta) REFERENCES PuntoVenta (idPuntoVenta)
) ENGINE = InnoDB;

CREATE TABLE Cliente (
    idCliente INT NOT NULL AUTO_INCREMENT,
    nombreCliente VARCHAR(25)  NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT 1,
    tipoCliente VARCHAR(3) NOT NULL,
    CONSTRAINT pk_cliente PRIMARY KEY (idCliente),
    CONSTRAINT chk_cliente_tipo CHECK (tipoCliente IN ('B2B', 'B2C'))
) ENGINE = InnoDB;

CREATE TABLE Telefono (
    idTelefono INT NOT NULL AUTO_INCREMENT,
    idCliente INT NOT NULL,
    numeroTelefono VARCHAR(15) NOT NULL,
    CONSTRAINT pk_telefono PRIMARY KEY (idTelefono),
    CONSTRAINT fk_telefono_cliente FOREIGN KEY (idCliente) REFERENCES Cliente (idCliente)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Categoria (
    idCategoria INT NOT NULL AUTO_INCREMENT,
    nombreCategoria VARCHAR(30)  NOT NULL,
    descripcion VARCHAR(100) NULL,
    umbralRentabilidad DECIMAL(5,2) NOT NULL,
    CONSTRAINT pk_categoria PRIMARY KEY (idCategoria),
    CONSTRAINT chk_categoria_umbral CHECK (umbralRentabilidad >= 0)
) ENGINE = InnoDB;

CREATE TABLE Proveedor (
    idProveedor INT NOT NULL AUTO_INCREMENT,
    nombreProveedor VARCHAR(50) NOT NULL,
    tipoInsumo VARCHAR(30) NOT NULL,
    contacto VARCHAR(50) NULL,
    CONSTRAINT pk_proveedor PRIMARY KEY (idProveedor)
) ENGINE = InnoDB;

CREATE TABLE Producto (
    idProducto INT NOT NULL AUTO_INCREMENT,
    idCategoria INT NOT NULL,
    idProveedor INT NULL,
    nombreProducto VARCHAR(50) NOT NULL,
    costoUnitario DECIMAL(12,2) NOT NULL,
    unidadMedida  VARCHAR(15)   NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT 1,
    CONSTRAINT pk_producto PRIMARY KEY (idProducto),
    CONSTRAINT chk_producto_costo CHECK (costoUnitario > 0),
    CONSTRAINT fk_producto_categoria FOREIGN KEY (idCategoria) REFERENCES Categoria (idCategoria)
        ON UPDATE CASCADE,
    CONSTRAINT fk_producto_proveedor FOREIGN KEY (idProveedor) REFERENCES Proveedor (idProveedor)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE = InnoDB;

CREATE TABLE Inventario (
    idInventario INT NOT NULL AUTO_INCREMENT,
    idProducto INT NOT NULL,
    idPuntoVenta INT NOT NULL,
    estado VARCHAR(20) NOT NULL,
    stockActual INT NOT NULL DEFAULT 0,
    stockMinimo INT NOT NULL,
    stockMaximo INT NOT NULL,
    CONSTRAINT pk_inventario PRIMARY KEY (idInventario),
    CONSTRAINT uq_inventario_prod_pv UNIQUE (idProducto, idPuntoVenta),
    CONSTRAINT chk_inventario_stock CHECK (stockActual >= 0 AND stockMinimo >= 0 AND stockMinimo <= stockMaximo),
    CONSTRAINT fk_inventario_producto FOREIGN KEY (idProducto) REFERENCES Producto (idProducto)
        ON UPDATE CASCADE,
    CONSTRAINT fk_inventario_puntov FOREIGN KEY (idPuntoVenta) REFERENCES PuntoVenta (idPuntoVenta)
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Pedido (
    idPedido INT NOT NULL AUTO_INCREMENT,
    idCliente INT NOT NULL,
    idPuntoVenta INT NOT NULL,
    idUsuario INT NOT NULL,
    fechaPedido DATE NOT NULL,
    fechaEntrega DATE NOT NULL,
    tipoEmpaque VARCHAR(20) NOT NULL,
    follaje BOOLEAN NOT NULL,
    tarjeta VARCHAR(100) NULL,
    direccionEntrega VARCHAR(100) NOT NULL,
    canalVenta  VARCHAR(3) NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'Registrado',
    anticipo DECIMAL(12,2) NOT NULL DEFAULT 0,
    anticipoPagado BOOLEAN NOT NULL DEFAULT 0,
    costoEnvio DECIMAL(12,2) NOT NULL DEFAULT 0,
    motivoAnulacion VARCHAR(100)  NULL,
    CONSTRAINT pk_pedido PRIMARY KEY (idPedido),
    CONSTRAINT chk_pedido_fechas CHECK (fechaEntrega >= fechaPedido),
    CONSTRAINT chk_pedido_empaque CHECK (tipoEmpaque IN ('Caja', 'Ramo')),
    CONSTRAINT chk_pedido_canal CHECK (canalVenta IN ('B2B', 'B2C')),
    CONSTRAINT chk_pedido_estado CHECK (estado IN ('Registrado', 'En preparacion', 'Enviado', 'Entregado', 'Anulado')),
    CONSTRAINT chk_pedido_valores CHECK (anticipo >= 0 AND costoEnvio >= 0),
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (idCliente) REFERENCES Cliente (idCliente) ON UPDATE CASCADE,
    CONSTRAINT fk_pedido_puntov FOREIGN KEY (idPuntoVenta) REFERENCES PuntoVenta (idPuntoVenta) ON UPDATE CASCADE,
    CONSTRAINT fk_pedido_usuario FOREIGN KEY (idUsuario) REFERENCES Usuario (idUsuario) ON UPDATE CASCADE
) ENGINE = InnoDB;

-- El subtotal (cantidad × precio acordado) es un atributo derivado: no se almacena (vease la vista vw_detalle_pedido).

CREATE TABLE DetallePedido (
    idDetalle INT NOT NULL AUTO_INCREMENT,
    idPedido INT NOT NULL,
    idProducto INT NOT NULL,
    cantidad INT NOT NULL,
    precioPactado DECIMAL(12,2) NOT NULL,
    CONSTRAINT pk_detallepedido PRIMARY KEY (idDetalle),
    CONSTRAINT uq_detalle_pedido_prod UNIQUE (idPedido, idProducto),
    CONSTRAINT chk_detalle_cantidad CHECK (cantidad > 0),
    CONSTRAINT chk_detalle_precio CHECK (precioPactado > 0),
    CONSTRAINT fk_detalle_pedido FOREIGN KEY (idPedido) REFERENCES Pedido (idPedido)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_detalle_producto FOREIGN KEY (idProducto) REFERENCES Producto (idProducto)
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Pago (
    idPago INT NOT NULL AUTO_INCREMENT,
    idPedido INT NOT NULL,
    tipoPago VARCHAR(20) NOT NULL,
    monto DECIMAL(12,2) NOT NULL,
    fechaPago DATE NOT NULL,
    CONSTRAINT pk_pago PRIMARY KEY (idPago),
    CONSTRAINT chk_pago_monto CHECK (monto > 0),
    CONSTRAINT fk_pago_pedido FOREIGN KEY (idPedido) REFERENCES Pedido (idPedido)
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Alerta (
    idAlerta INT NOT NULL AUTO_INCREMENT,
    idProducto INT NOT NULL,
    fechaGeneracion DATE NOT NULL,
    mensaje VARCHAR(150) NOT NULL,
    tipoAlerta VARCHAR(30)  NOT NULL,
    CONSTRAINT pk_alerta PRIMARY KEY (idAlerta),
    CONSTRAINT fk_alerta_producto FOREIGN KEY (idProducto) REFERENCES Producto (idProducto)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB;



-- =====================================================================
-- 2. AJUSTES DE ESTRUCTURA
-- =====================================================================

-- 2.1 Las alertas se pueden cerrar: estado, fecha y usuario que atiende.
-- Primero las columnas. Las restricciones van aparte porque MySQL no
-- admite un CHECK que referencie columnas anadidas en la misma sentencia.
ALTER TABLE Alerta
  ADD COLUMN estado VARCHAR(20) NOT NULL DEFAULT 'Abierta' AFTER tipoAlerta,
  ADD COLUMN fechaAtencion DATE NULL AFTER estado,
  ADD COLUMN idUsuarioAtiende INT NULL AFTER fechaAtencion;

ALTER TABLE Alerta
  ADD CONSTRAINT chk_alerta_estado
      CHECK (estado IN ('Abierta', 'Atendida', 'Descartada'));

ALTER TABLE Alerta
  ADD CONSTRAINT fk_alerta_usuario FOREIGN KEY (idUsuarioAtiende)
      REFERENCES Usuario (idUsuario) ON DELETE SET NULL ON UPDATE CASCADE;

-- 2.2 Contrasenas en SHA-256: la columna pasa a CHAR(64) y se agrega la
-- bandera que obliga a cambiar la clave en el primer ingreso.
ALTER TABLE Usuario
  MODIFY contrasena CHAR(64) NOT NULL COMMENT 'Hash SHA-256 en hexadecimal',
  ADD COLUMN debeCambiarClave TINYINT(1) NOT NULL DEFAULT 0 AFTER contrasena;


-- =====================================================================
-- 3. INDICES
-- =====================================================================

CREATE INDEX ix_alerta_estado ON Alerta (estado, fechaGeneracion);


-- =====================================================================
-- 4. FUNCION Y PROCEDIMIENTOS ALMACENADOS
-- =====================================================================

DELIMITER $$
-- Funcion : total de un pedido = suma de las lineas + costo de envio
-- (corresponde al metodo calcularTotal() del diagrama de clases)

CREATE FUNCTION fn_total_pedido(p_idPedido INT)
RETURNS DECIMAL(14,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(14,2);

    SELECT COALESCE((SELECT SUM(cantidad * precioPactado)
                     FROM DetallePedido
                     WHERE idPedido = p_idPedido), 0)
         + COALESCE((SELECT costoEnvio
                     FROM Pedido
                     WHERE idPedido = p_idPedido), 0)
      INTO v_total;

    RETURN v_total;
END$$

-- Procedimiento 1 : resumen completo de un pedido (encabezado + lineas de detalle)
CREATE PROCEDURE sp_resumen_pedido(IN p_idPedido INT)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Pedido WHERE idPedido = p_idPedido) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El pedido no existe';
    END IF;

    SELECT p.idPedido, c.nombreCliente, pv.nombrePuntoVenta, p.estado, p.fechaEntrega,
           fn_total_pedido(p.idPedido) AS total,
           (SELECT COALESCE(SUM(monto), 0) FROM Pago WHERE idPedido = p.idPedido) AS total_pagado,
           fn_total_pedido(p.idPedido)
             - (SELECT COALESCE(SUM(monto), 0) FROM Pago WHERE idPedido = p.idPedido) AS saldo_pendiente
    FROM Pedido p
    INNER JOIN Cliente c     ON c.idCliente = p.idCliente
    INNER JOIN PuntoVenta pv ON pv.idPuntoVenta = p.idPuntoVenta
    WHERE p.idPedido = p_idPedido;

    SELECT dp.idDetalle, pr.nombreProducto, dp.cantidad, dp.precioPactado,
           dp.cantidad * dp.precioPactado AS subtotal
    FROM DetallePedido dp
    INNER JOIN Producto pr ON pr.idProducto = dp.idProducto
    WHERE dp.idPedido = p_idPedido;
END$$


-- Procedimiento 2 : registrar un pago y marcar el anticipo como pagado
CREATE PROCEDURE sp_registrar_pago(
    IN p_idPedido  INT,
    IN p_tipoPago  VARCHAR(20),
    IN p_monto     DECIMAL(12,2),
    IN p_fechaPago DATE)
BEGIN
    DECLARE v_estado   VARCHAR(20);
    DECLARE v_anticipo DECIMAL(12,2);
    DECLARE v_pagado   DECIMAL(14,2);
    DECLARE v_total    DECIMAL(14,2);

    SELECT estado, anticipo INTO v_estado, v_anticipo
    FROM Pedido WHERE idPedido = p_idPedido;

    IF v_estado IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El pedido no existe';
    END IF;
    IF v_estado = 'Anulado' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede pagar un pedido anulado';
    END IF;
    IF p_monto <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El monto debe ser positivo';
    END IF;

    SET v_total = fn_total_pedido(p_idPedido);
    SELECT COALESCE(SUM(monto), 0) INTO v_pagado FROM Pago WHERE idPedido = p_idPedido;

    IF v_pagado + p_monto > v_total THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El pago excede el total del pedido';
    END IF;

    INSERT INTO Pago (idPedido, tipoPago, monto, fechaPago)
    VALUES (p_idPedido, p_tipoPago, p_monto, p_fechaPago);

    IF v_pagado + p_monto >= v_anticipo THEN
        UPDATE Pedido SET anticipoPagado = 1 WHERE idPedido = p_idPedido;
    END IF;

    SELECT p_idPedido AS idPedido, v_total AS total,
           v_pagado + p_monto AS total_pagado,
           v_total - (v_pagado + p_monto) AS saldo_pendiente;
END$$

-- Procedimiento 3 : cambiar el estado de un pedido con controles
-- (corresponde a actualizarEstado(estado) del diagrama de clases)
CREATE PROCEDURE sp_actualizar_estado_pedido(
    IN p_idPedido    INT,
    IN p_nuevoEstado VARCHAR(20),
    IN p_motivo      VARCHAR(100))
BEGIN
    DECLARE v_actual VARCHAR(20);

    SELECT estado INTO v_actual FROM Pedido WHERE idPedido = p_idPedido;

    IF v_actual IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El pedido no existe';
    END IF;
    IF v_actual IN ('Entregado', 'Anulado') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El pedido ya esta en un estado final';
    END IF;
    IF p_nuevoEstado NOT IN ('Registrado', 'En preparacion', 'Enviado', 'Entregado', 'Anulado') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estado no valido';
    END IF;
    IF p_nuevoEstado = 'Anulado' AND (p_motivo IS NULL OR TRIM(p_motivo) = '') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Debe indicar el motivo de anulacion';
    END IF;

    UPDATE Pedido
    SET estado = p_nuevoEstado,
        motivoAnulacion = IF(p_nuevoEstado = 'Anulado', p_motivo, NULL)
    WHERE idPedido = p_idPedido;

    SELECT idPedido, estado, motivoAnulacion FROM Pedido WHERE idPedido = p_idPedido;
END$$

-- Procedimiento 4 : rentabilidad de un punto de venta en un periodo
-- (corresponde a calcularRentabilidad(periodo) del diagrama de clases)
CREATE PROCEDURE sp_rentabilidad_punto_venta(
    IN p_idPuntoVenta INT,
    IN p_inicio   DATE,
    IN p_fin      DATE)
BEGIN
    SELECT pv.idPuntoVenta, pv.nombrePuntoVenta,
           COUNT(DISTINCT p.idPedido) AS pedidos,
           COALESCE(SUM(dp.cantidad * dp.precioPactado), 0) AS ingresos,
           COALESCE(SUM(dp.cantidad * pr.costoUnitario), 0) AS costos,
           COALESCE(SUM(dp.cantidad * (dp.precioPactado - pr.costoUnitario)), 0) AS utilidad,
           ROUND(SUM(dp.cantidad * (dp.precioPactado - pr.costoUnitario))
                 / NULLIF(SUM(dp.cantidad * dp.precioPactado), 0) * 100, 2) AS margen_pct
    FROM PuntoVenta pv
    LEFT JOIN Pedido p         ON p.idPuntoVenta = pv.idPuntoVenta
                               AND p.estado <> 'Anulado'
                               AND p.fechaPedido BETWEEN p_inicio AND p_fin
    LEFT JOIN DetallePedido dp ON dp.idPedido = p.idPedido
    LEFT JOIN Producto pr      ON pr.idProducto = dp.idProducto
    WHERE pv.idPuntoVenta = p_idPuntoVenta
    GROUP BY pv.idPuntoVenta, pv.nombrePuntoVenta;
END$$

DELIMITER ;

-- Procedimiento 5 : cerrar una alerta
DROP PROCEDURE IF EXISTS sp_atender_alerta;
DELIMITER $$

-- El parametro es VARCHAR y no ENUM a proposito: cuando un parametro ENUM
-- tiene una lista distinta a la de la columna, MySQL convierte el valor por
-- su posicion y no por su texto, y se guarda un valor equivocado sin avisar.
CREATE PROCEDURE sp_atender_alerta(
    IN p_idAlerta  INT,
    IN p_idUsuario INT,
    IN p_decision  VARCHAR(20))
BEGIN
    DECLARE v_estado VARCHAR(20);

    IF p_decision NOT IN ('Atendida', 'Descartada') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La decision debe ser Atendida o Descartada';
    END IF;

    SELECT estado INTO v_estado FROM Alerta WHERE idAlerta = p_idAlerta;

    IF v_estado IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La alerta no existe';
    END IF;
    IF v_estado <> 'Abierta' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La alerta ya fue cerrada';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM Usuario WHERE idUsuario = p_idUsuario) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no existe';
    END IF;

    UPDATE Alerta
       SET estado = p_decision,
           fechaAtencion = CURDATE(),
           idUsuarioAtiende = p_idUsuario
     WHERE idAlerta = p_idAlerta;

    SELECT idAlerta, tipoAlerta, estado, fechaAtencion, idUsuarioAtiende
      FROM Alerta WHERE idAlerta = p_idAlerta;
END$$

DELIMITER ;

-- Procedimiento 6 : cambiar la contrasena
DROP PROCEDURE IF EXISTS sp_cambiar_clave;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_clave(
    IN p_idUsuario   INT,
    IN p_claveActual VARCHAR(100),
    IN p_claveNueva  VARCHAR(100))
BEGIN
    DECLARE v_hash CHAR(64);

    SELECT contrasena INTO v_hash FROM Usuario WHERE idUsuario = p_idUsuario;

    IF v_hash IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no existe';
    END IF;
    IF v_hash <> SHA2(p_claveActual, 256) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La contrasena actual no coincide';
    END IF;
    IF CHAR_LENGTH(p_claveNueva) < 8 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La nueva contrasena debe tener al menos 8 caracteres';
    END IF;
    IF p_claveNueva = p_claveActual THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La nueva contrasena debe ser distinta de la actual';
    END IF;

    UPDATE Usuario
       SET contrasena = SHA2(p_claveNueva, 256),
           debeCambiarClave = 0
     WHERE idUsuario = p_idUsuario;
END$$

DELIMITER ;


-- =====================================================================
-- 5. VISTAS
-- =====================================================================

-- Vistas (tablas virtuales)
-- Vista 1 : lineas de pedido con el subtotal derivado y la utilidad de la linea
CREATE VIEW vw_detalle_pedido AS
SELECT dp.idDetalle, dp.idPedido, pr.idProducto, pr.nombreProducto,
       dp.cantidad, dp.precioPactado,
       dp.cantidad * dp.precioPactado                      AS subtotal,
       dp.cantidad * (dp.precioPactado - pr.costoUnitario) AS utilidad
FROM DetallePedido dp
INNER JOIN Producto pr ON pr.idProducto = dp.idProducto;

-- Vista 2 : resumen financiero de cada pedido (total, pagado, saldo)------------------------------------------------
CREATE VIEW vw_resumen_pedido AS
SELECT p.idPedido, p.fechaPedido, p.fechaEntrega, p.estado, p.canalVenta,
       c.nombreCliente, pv.nombrePuntoVenta,
       fn_total_pedido(p.idPedido)                             AS total,
       COALESCE(pg.pagado, 0)                                  AS total_pagado,
       fn_total_pedido(p.idPedido) - COALESCE(pg.pagado, 0)    AS saldo_pendiente
FROM Pedido p
INNER JOIN Cliente c     ON c.idCliente = p.idCliente
INNER JOIN PuntoVenta pv ON pv.idPuntoVenta = p.idPuntoVenta
LEFT JOIN (SELECT idPedido, SUM(monto) AS pagado FROM Pago GROUP BY idPedido) pg
       ON pg.idPedido = p.idPedido;

-- Vista 3 : rentabilidad por producto comparada con el umbral de su categoria (pedidos no anulados)------------------------------------------
CREATE VIEW vw_rentabilidad_producto AS
SELECT pr.idProducto, pr.nombreProducto, ca.nombreCategoria, ca.umbralRentabilidad,
       COALESCE(SUM(dp.cantidad), 0)                                     AS unidades_vendidas,
       COALESCE(SUM(dp.cantidad * dp.precioPactado), 0)                  AS ingresos,
       COALESCE(SUM(dp.cantidad * pr.costoUnitario), 0)                  AS costos,
       ROUND(SUM(dp.cantidad * (dp.precioPactado - pr.costoUnitario))
             / NULLIF(SUM(dp.cantidad * dp.precioPactado), 0) * 100, 2)  AS margen_pct,
       CASE
           WHEN SUM(dp.cantidad) IS NULL THEN 'Sin ventas'
           WHEN SUM(dp.cantidad * (dp.precioPactado - pr.costoUnitario))
                / SUM(dp.cantidad * dp.precioPactado) * 100 < ca.umbralRentabilidad THEN 'Bajo el umbral'
           ELSE 'Correcto'
       END AS diagnostico
FROM Producto pr
INNER JOIN Categoria ca ON ca.idCategoria = pr.idCategoria
LEFT JOIN (DetallePedido dp INNER JOIN Pedido p
              ON p.idPedido = dp.idPedido AND p.estado <> 'Anulado')
       ON dp.idProducto = pr.idProducto
GROUP BY pr.idProducto, pr.nombreProducto, ca.nombreCategoria, ca.umbralRentabilidad;

-- Vista 4 : articulos de inventario por reabastecer----------------------------------------------------------
CREATE VIEW vw_inventario_critico AS
SELECT i.idInventario, pv.nombrePuntoVenta, pr.nombreProducto,
       i.stockActual, i.stockMinimo, i.stockMaximo, i.estado,
       i.stockMaximo - i.stockActual AS unidades_a_reponer
FROM Inventario i
INNER JOIN Producto pr   ON pr.idProducto = i.idProducto
INNER JOIN PuntoVenta pv ON pv.idPuntoVenta = i.idPuntoVenta
WHERE i.stockActual <= i.stockMinimo;

-- Vista 5 : alertas pendientes con los dias que llevan abiertas
DROP VIEW IF EXISTS vw_alertas_abiertas;
CREATE VIEW vw_alertas_abiertas AS
SELECT a.idAlerta, a.tipoAlerta, a.fechaGeneracion,
       DATEDIFF(CURDATE(), a.fechaGeneracion) AS dias_abierta,
       pr.nombreProducto, ca.nombreCategoria, a.mensaje
FROM Alerta a
INNER JOIN Producto  pr ON pr.idProducto  = a.idProducto
INNER JOIN Categoria ca ON ca.idCategoria = pr.idCategoria
WHERE a.estado = 'Abierta';


-- Fin de 01_DDL.sql. Siga con 02_DML.sql
