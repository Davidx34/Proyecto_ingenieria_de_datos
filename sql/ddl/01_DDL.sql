-- =====================================================================
-- Liwi Flor Eterna - 01_DDL.sql   (MODELO INTEGRADO: ESTRUCTURA)
--
-- Modelo final, ajustado a lo que el cliente registra de verdad en sus libros
-- de ingresos y de gastos. Reemplaza al modelo de pedidos del Entregable 2
-- (liwi_flor_eterna anterior). Motor MySQL 8 / MariaDB 10.6+, InnoDB, utf8mb4.
--
-- Cuatro bloques:
--   A. Acceso y puntos de venta   PuntoVenta, Usuario
--   B. Productos                  Categoria, Producto, Presentacion, AliasProducto
--   C. Ventas                     Ciudad, MetodoPago, Cliente, Venta, DetalleVenta
--   D. Gastos y cierre            Proveedor, TipoDocumento, CategoriaGasto,
--                                 ConceptoGasto, AliasConcepto, Etiqueta, Gasto,
--                                 GastoEtiqueta, CierreFinanciero
--   Auditoria                     BitacoraCambio
--
-- Todas las tablas tienen un id entero auto_increment.
-- Orden: 1) 01_DDL.sql   2) 02_DML.sql  (los triggers se crean al final del DML,
-- para que no se disparen durante la carga).
-- =====================================================================

set names utf8mb4;
set foreign_key_checks = 0;
drop database if exists liwi_flor_eterna;
create database liwi_flor_eterna character set utf8mb4 collate utf8mb4_unicode_ci;
use liwi_flor_eterna;
set foreign_key_checks = 1;

-- La colacion utf8mb4_unicode_ci ignora mayusculas y tildes: "Manoco", "MANOCO"
-- y "Mañoco" chocan contra la misma clave unique. Los errores de digitacion
-- (peuqeno, Domiclio) los resuelven las tablas de alias.

-- =====================================================================
-- A. ACCESO Y PUNTOS DE VENTA
-- =====================================================================

create table PuntoVenta (
    idPuntoVenta        int not null auto_increment,
    nombrePuntoVenta    varchar(50)  not null,
    ciudad              varchar(30)  not null,
    direccionPuntoVenta varchar(100) null,
    constraint pk_puntoventa primary key (idPuntoVenta),
    constraint uq_puntoventa_nombre unique (nombrePuntoVenta)
) engine = InnoDB;

create table Usuario (
    idUsuario        int not null auto_increment,
    nombre           varchar(50) not null,
    correo           varchar(60) not null,
    contrasena       varchar(64) not null comment 'SHA-256 en hexadecimal (64 caracteres)',
    rol              varchar(15) not null,
    fechaRegistro    date not null,
    ultimoAcceso     datetime null,
    intentosFallidos int not null default 0,
    bloqueado        boolean not null default 0,
    idPuntoVenta     int null,
    constraint pk_usuario primary key (idUsuario),
    constraint uq_usuario_correo unique (correo),
    constraint chk_usuario_rol check (rol in ('Socio', 'Administrador')),
    constraint chk_usuario_intentos check (intentosFallidos >= 0),
    -- el socio no pertenece a un punto de venta; el administrador si
    constraint chk_usuario_pv check ((rol = 'Socio' and idPuntoVenta is null)
                                  or (rol = 'Administrador' and idPuntoVenta is not null)),
    constraint fk_usuario_puntov foreign key (idPuntoVenta)
        references PuntoVenta (idPuntoVenta)   -- sin accion referencial: el check de arriba usa esta columna
) engine = InnoDB;

-- =====================================================================
-- B. PRODUCTOS: familia, presentacion y alias
--    Producto es la familia (Jalea, Vino...). Presentacion es lo que se vende
--    de verdad (Jalea pequena, Jalea grande) y lleva el SKU.
-- =====================================================================

create table Categoria (
    idCategoria     int not null auto_increment,
    nombreCategoria varchar(40) not null,
    constraint pk_categoria primary key (idCategoria),
    constraint uq_categoria_nombre unique (nombreCategoria)
) engine = InnoDB;

create table Producto (
    idProducto     int not null auto_increment,
    idCategoria    int not null,
    nombreProducto varchar(40) not null,
    activo         boolean not null default 1,
    constraint pk_producto primary key (idProducto),
    constraint uq_producto_nombre unique (nombreProducto),
    constraint fk_producto_categoria foreign key (idCategoria)
        references Categoria (idCategoria) on update cascade
) engine = InnoDB;

create table Presentacion (
    idPresentacion     int not null auto_increment,
    idProducto         int not null,
    sku                varchar(10) not null,
    nombrePresentacion varchar(50) not null,
    activo             boolean not null default 1,
    requiereRevision   boolean not null default 0,
    motivoRevision     varchar(120) null,
    constraint pk_presentacion primary key (idPresentacion),
    constraint uq_presentacion_sku unique (sku),
    constraint uq_presentacion_nombre unique (idProducto, nombrePresentacion),
    constraint fk_presentacion_producto foreign key (idProducto)
        references Producto (idProducto) on update cascade
) engine = InnoDB;

create table AliasProducto (
    idAlias        int not null auto_increment,
    idPresentacion int not null,
    textoAlias     varchar(120) not null,
    origen         varchar(40) not null default 'Escrito en el libro',
    constraint pk_alias primary key (idAlias),
    constraint uq_alias_texto unique (textoAlias),
    constraint fk_alias_presentacion foreign key (idPresentacion)
        references Presentacion (idPresentacion) on update cascade
) engine = InnoDB;

-- =====================================================================
-- C. VENTAS
-- =====================================================================

create table Ciudad (
    idCiudad     int not null auto_increment,
    nombreCiudad varchar(40) not null,
    constraint pk_ciudad primary key (idCiudad),
    constraint uq_ciudad_nombre unique (nombreCiudad)
) engine = InnoDB;

create table MetodoPago (
    idMetodoPago     int not null auto_increment,
    nombreMetodoPago varchar(30) not null,
    constraint pk_metodopago primary key (idMetodoPago),
    constraint uq_metodopago_nombre unique (nombreMetodoPago)
) engine = InnoDB;

-- El canal B2C/B2B ya no se guarda: sale del tipo de cliente
-- (Cliente final = B2C; Intermediario y Floristeria = B2B).
create table Cliente (
    idCliente     int not null auto_increment,
    nombreCliente varchar(60) not null,
    tipoCliente   varchar(15) not null,
    activo        boolean not null default 1,
    constraint pk_cliente primary key (idCliente),
    constraint uq_cliente unique (nombreCliente, tipoCliente),
    constraint chk_cliente_tipo check (tipoCliente in ('Cliente final', 'Intermediario', 'Floristería'))
) engine = InnoDB;

-- idPuntoVenta lleno = venta hecha en el local fisico; null = venta fuera del local.
-- Reemplaza a la columna "venta local" (SI/NO) del libro.
create table Venta (
    idVenta          int not null auto_increment,
    fechaVenta       date not null,
    idCliente        int not null,
    idCiudad         int not null,
    idMetodoPago     int not null,
    idPuntoVenta     int null,
    facturada        boolean not null default 0,
    valorTotal       decimal(12,2) not null,
    productoOriginal varchar(120) null comment 'Texto tal como se escribio en el libro',
    cantidadOriginal varchar(30)  null comment 'Texto tal como se escribio en el libro',
    constraint pk_venta primary key (idVenta),
    constraint chk_venta_valor check (valorTotal > 0),
    constraint fk_venta_cliente foreign key (idCliente)
        references Cliente (idCliente) on update cascade,
    constraint fk_venta_ciudad foreign key (idCiudad)
        references Ciudad (idCiudad) on update cascade,
    constraint fk_venta_metodopago foreign key (idMetodoPago)
        references MetodoPago (idMetodoPago) on update cascade,
    constraint fk_venta_puntoventa foreign key (idPuntoVenta)
        references PuntoVenta (idPuntoVenta) on update cascade
) engine = InnoDB;

-- Una venta con varios productos trae un solo valor total en el libro: sus
-- lineas quedan 'Pendiente' (sin inventar precios) hasta que el cliente los
-- confirme.
create table DetalleVenta (
    idDetalle      int not null auto_increment,
    idVenta        int not null,
    idPresentacion int not null,
    cantidad       int not null,
    valorLinea     decimal(12,2) null,
    origenValor    varchar(10) not null default 'Exacto',
    constraint pk_detalleventa primary key (idDetalle),
    constraint chk_detalle_cantidad check (cantidad > 0),
    constraint chk_detalle_origen check (origenValor in ('Exacto', 'Pendiente')),
    constraint chk_detalle_valor check (
        (origenValor = 'Exacto'    and valorLinea is not null and valorLinea > 0)
     or (origenValor = 'Pendiente' and valorLinea is null)),
    constraint fk_detalle_venta foreign key (idVenta)
        references Venta (idVenta) on update cascade on delete cascade,
    constraint fk_detalle_presentacion foreign key (idPresentacion)
        references Presentacion (idPresentacion) on update cascade
) engine = InnoDB;

-- =====================================================================
-- D. GASTOS Y CIERRE FINANCIERO
-- =====================================================================

create table Proveedor (
    idProveedor     int not null auto_increment,
    nombreProveedor varchar(60) not null,
    contacto        varchar(60) null,
    constraint pk_proveedor primary key (idProveedor),
    constraint uq_proveedor_nombre unique (nombreProveedor)
) engine = InnoDB;

create table TipoDocumento (
    idTipoDocumento     int not null auto_increment,
    nombreTipoDocumento varchar(30) not null,
    constraint pk_tipodocumento primary key (idTipoDocumento),
    constraint uq_tipodocumento_nombre unique (nombreTipoDocumento)
) engine = InnoDB;

create table CategoriaGasto (
    idCategoriaGasto     int not null auto_increment,
    nombreCategoriaGasto varchar(30) not null,
    constraint pk_categoriagasto primary key (idCategoriaGasto),
    constraint uq_categoriagasto_nombre unique (nombreCategoriaGasto)
) engine = InnoDB;

create table Etiqueta (
    idEtiqueta     int not null auto_increment,
    nombreEtiqueta varchar(30) not null,
    constraint pk_etiqueta primary key (idEtiqueta),
    constraint uq_etiqueta_nombre unique (nombreEtiqueta)
) engine = InnoDB;

-- La categoria depende del concepto, por eso vive aqui y no en cada gasto.
-- idProducto: cuando el concepto es la compra de algo que se vende.
-- asociadoLocal: el concepto es un costo del local fisico (arriendo, luz, internet).
create table ConceptoGasto (
    idConcepto       int not null auto_increment,
    idCategoriaGasto int not null,
    idProducto       int null,
    nombreConcepto   varchar(50) not null,
    asociadoLocal    boolean not null default 0,
    constraint pk_conceptogasto primary key (idConcepto),
    constraint uq_conceptogasto_nombre unique (nombreConcepto),
    constraint fk_concepto_categoria foreign key (idCategoriaGasto)
        references CategoriaGasto (idCategoriaGasto) on update cascade,
    constraint fk_concepto_producto foreign key (idProducto)
        references Producto (idProducto) on update cascade on delete set null
) engine = InnoDB;

create table AliasConcepto (
    idAliasConcepto int not null auto_increment,
    idConcepto      int not null,
    textoAlias      varchar(80) not null,
    constraint pk_aliasconcepto primary key (idAliasConcepto),
    constraint uq_aliasconcepto_texto unique (textoAlias),
    constraint fk_alias_concepto foreign key (idConcepto)
        references ConceptoGasto (idConcepto) on update cascade
) engine = InnoDB;

create table Gasto (
    idGasto             int not null auto_increment,
    fechaGasto          date not null,
    idConcepto          int not null,
    valor               decimal(12,2) not null,
    idTipoDocumento     int not null,
    idMetodoPago        int not null,
    idProveedor         int null,
    conceptoOriginal    varchar(80) null comment 'Texto tal como se escribio en el libro',
    observacionOriginal varchar(40) null comment 'Texto tal como se escribio en el libro',
    constraint pk_gasto primary key (idGasto),
    constraint chk_gasto_valor check (valor > 0),
    constraint fk_gasto_concepto foreign key (idConcepto)
        references ConceptoGasto (idConcepto) on update cascade,
    constraint fk_gasto_tipodoc foreign key (idTipoDocumento)
        references TipoDocumento (idTipoDocumento) on update cascade,
    constraint fk_gasto_metodopago foreign key (idMetodoPago)
        references MetodoPago (idMetodoPago) on update cascade,
    constraint fk_gasto_proveedor foreign key (idProveedor)
        references Proveedor (idProveedor) on update cascade on delete set null
) engine = InnoDB;

-- Un gasto puede llevar varias etiquetas ("F/LIWI"): una fila por cada una.
create table GastoEtiqueta (
    idGastoEtiqueta int not null auto_increment,
    idGasto         int not null,
    idEtiqueta      int not null,
    constraint pk_gastoetiqueta primary key (idGastoEtiqueta),
    constraint uq_gastoetiqueta unique (idGasto, idEtiqueta),
    constraint fk_ge_gasto foreign key (idGasto)
        references Gasto (idGasto) on update cascade on delete cascade,
    constraint fk_ge_etiqueta foreign key (idEtiqueta)
        references Etiqueta (idEtiqueta) on update cascade
) engine = InnoDB;

-- Foto del cierre de un periodo (el cliente cierra el dia 15). Los totales se
-- guardan para que el cierre no cambie si despues se corrige un registro.
create table CierreFinanciero (
    idCierre        int not null auto_increment,
    fechaInicio     date not null,
    fechaFin        date not null,
    totalIngresos   decimal(14,2) not null,
    totalOperacion  decimal(14,2) not null,
    totalInventario decimal(14,2) not null,
    totalInversion  decimal(14,2) not null,
    fechaCierre     datetime not null,
    idUsuario       int not null,
    constraint pk_cierre primary key (idCierre),
    constraint uq_cierre_periodo unique (fechaInicio, fechaFin),
    constraint chk_cierre_fechas check (fechaFin >= fechaInicio),
    constraint chk_cierre_totales check (totalIngresos >= 0 and totalOperacion >= 0
                                     and totalInventario >= 0 and totalInversion >= 0),
    constraint fk_cierre_usuario foreign key (idUsuario)
        references Usuario (idUsuario) on update cascade
) engine = InnoDB;

-- =====================================================================
-- AUDITORIA
-- =====================================================================

-- Quien cambio o borro una venta o un gasto, cuando y como estaba antes.
create table BitacoraCambio (
    idBitacora      int not null auto_increment,
    fechaCambio     datetime not null,
    usuarioBD       varchar(80) not null,
    tablaAfectada   varchar(20) not null,
    idRegistro      int not null,
    accion          varchar(10) not null,
    valorAnterior   varchar(255) not null,
    valorNuevo      varchar(255) null,
    constraint pk_bitacora primary key (idBitacora),
    constraint chk_bitacora_tabla check (tablaAfectada in ('Venta', 'Gasto')),
    constraint chk_bitacora_accion check (accion in ('MODIFICA', 'ELIMINA'))
) engine = InnoDB;

-- Indices para las consultas del tablero (por fecha y por clave foranea)
create index ix_venta_fecha    on Venta (fechaVenta);
create index ix_venta_cliente  on Venta (idCliente);
create index ix_gasto_fecha    on Gasto (fechaGasto);
create index ix_gasto_concepto on Gasto (idConcepto);
create index ix_detalle_venta  on DetalleVenta (idVenta);

-- =====================================================================
-- FUNCIONES Y PROCEDIMIENTOS
-- =====================================================================

delimiter $$

-- Texto escrito -> presentacion. null si esa forma de escribirlo aun no esta en
-- el diccionario. Ignora mayusculas, tildes y espacios sobrantes.
create function fn_buscar_presentacion(p_texto varchar(120))
returns int
reads sql data
begin
    declare v_id int;
    select idPresentacion into v_id from AliasProducto where textoAlias = trim(p_texto) limit 1;
    return v_id;
end$$

-- Texto escrito -> concepto de gasto.
create function fn_buscar_concepto(p_texto varchar(80))
returns int
reads sql data
begin
    declare v_id int;
    select idConcepto into v_id from AliasConcepto where textoAlias = trim(p_texto) limit 1;
    return v_id;
end$$

-- Agrega una forma nueva de escribir un producto que ya existe.
create procedure sp_registrar_alias(in p_texto varchar(120), in p_sku varchar(10))
begin
    declare v_pres int;
    declare v_otra int;
    if p_texto is null or trim(p_texto) = '' then
        signal sqlstate '45000' set message_text = 'El texto del alias no puede estar vacio';
    end if;
    select idPresentacion into v_pres from Presentacion where sku = p_sku;
    if v_pres is null then
        signal sqlstate '45000' set message_text = 'El SKU no existe';
    end if;
    set v_otra = fn_buscar_presentacion(p_texto);
    if v_otra is not null and v_otra <> v_pres then
        signal sqlstate '45000' set message_text = 'Ese texto ya esta asociado a otra presentacion';
    end if;
    if v_otra is null then
        insert into AliasProducto (idPresentacion, textoAlias, origen)
        values (v_pres, trim(p_texto), 'Registrado despues de la carga');
    end if;
    select idAlias, textoAlias, idPresentacion from AliasProducto where textoAlias = trim(p_texto);
end$$

-- Agrega una forma nueva de escribir un concepto de gasto que ya existe.
create procedure sp_registrar_alias_concepto(in p_texto varchar(80), in p_concepto varchar(50))
begin
    declare v_concepto int;
    declare v_otro     int;
    if p_texto is null or trim(p_texto) = '' then
        signal sqlstate '45000' set message_text = 'El texto del alias no puede estar vacio';
    end if;
    select idConcepto into v_concepto from ConceptoGasto where nombreConcepto = p_concepto;
    if v_concepto is null then
        signal sqlstate '45000' set message_text = 'El concepto no existe';
    end if;
    set v_otro = fn_buscar_concepto(p_texto);
    if v_otro is not null and v_otro <> v_concepto then
        signal sqlstate '45000' set message_text = 'Ese texto ya esta asociado a otro concepto';
    end if;
    if v_otro is null then
        insert into AliasConcepto (idConcepto, textoAlias) values (v_concepto, trim(p_texto));
    end if;
    select idAliasConcepto, textoAlias, idConcepto from AliasConcepto where textoAlias = trim(p_texto);
end$$

-- Registra la cabecera de una venta. Las lineas se agregan con sp_agregar_linea_venta.
create procedure sp_registrar_venta(
    in p_fecha        date,
    in p_idCliente    int,
    in p_ciudad       varchar(40),
    in p_metodoPago   varchar(30),
    in p_idPuntoVenta int,
    in p_facturada    boolean,
    in p_valorTotal   decimal(12,2))
begin
    declare v_ciudad int;
    declare v_metodo int;
    if not exists (select 1 from Cliente where idCliente = p_idCliente and activo = 1) then
        signal sqlstate '45000' set message_text = 'El cliente no existe o esta inactivo';
    end if;
    select idCiudad into v_ciudad from Ciudad where nombreCiudad = p_ciudad;
    if v_ciudad is null then
        signal sqlstate '45000' set message_text = 'La ciudad no existe';
    end if;
    select idMetodoPago into v_metodo from MetodoPago where nombreMetodoPago = p_metodoPago;
    if v_metodo is null then
        signal sqlstate '45000' set message_text = 'El metodo de pago no existe';
    end if;
    if p_idPuntoVenta is not null and not exists (select 1 from PuntoVenta where idPuntoVenta = p_idPuntoVenta) then
        signal sqlstate '45000' set message_text = 'El punto de venta no existe';
    end if;
    insert into Venta (fechaVenta, idCliente, idCiudad, idMetodoPago, idPuntoVenta, facturada, valorTotal)
    values (p_fecha, p_idCliente, v_ciudad, v_metodo, p_idPuntoVenta, p_facturada, p_valorTotal);
    select last_insert_id() as idVenta;
end$$

-- Agrega un producto a una venta a partir del texto escrito. Si el texto no
-- esta en el diccionario no crea nada: obliga a registrar primero el alias.
create procedure sp_agregar_linea_venta(
    in p_idVenta  int,
    in p_texto    varchar(120),
    in p_cantidad int,
    in p_valor    decimal(12,2))
begin
    declare v_pres int;
    if not exists (select 1 from Venta where idVenta = p_idVenta) then
        signal sqlstate '45000' set message_text = 'La venta no existe';
    end if;
    set v_pres = fn_buscar_presentacion(p_texto);
    if v_pres is null then
        signal sqlstate '45000' set message_text = 'Producto no reconocido: registre primero el alias';
    end if;
    insert into DetalleVenta (idVenta, idPresentacion, cantidad, valorLinea, origenValor)
    values (p_idVenta, v_pres, p_cantidad, p_valor, if(p_valor is null, 'Pendiente', 'Exacto'));
    select last_insert_id() as idDetalle;
end$$

-- Registra un gasto a partir del texto escrito del concepto.
create procedure sp_registrar_gasto(
    in p_fecha         date,
    in p_textoConcepto varchar(80),
    in p_valor         decimal(12,2),
    in p_tipoDocumento varchar(30),
    in p_metodoPago    varchar(30),
    in p_proveedor     varchar(60))
begin
    declare v_concepto int;
    declare v_tipo     int;
    declare v_metodo   int;
    declare v_prov     int default null;
    set v_concepto = fn_buscar_concepto(p_textoConcepto);
    if v_concepto is null then
        signal sqlstate '45000' set message_text = 'Concepto no reconocido: registre primero el alias';
    end if;
    select idTipoDocumento into v_tipo from TipoDocumento where nombreTipoDocumento = p_tipoDocumento;
    if v_tipo is null then
        signal sqlstate '45000' set message_text = 'El tipo de documento no existe';
    end if;
    select idMetodoPago into v_metodo from MetodoPago where nombreMetodoPago = p_metodoPago;
    if v_metodo is null then
        signal sqlstate '45000' set message_text = 'El metodo de pago no existe';
    end if;
    if p_proveedor is not null then
        select idProveedor into v_prov from Proveedor where nombreProveedor = p_proveedor;
        if v_prov is null then
            signal sqlstate '45000' set message_text = 'El proveedor no existe';
        end if;
    end if;
    insert into Gasto (fechaGasto, idConcepto, valor, idTipoDocumento, idMetodoPago, idProveedor, conceptoOriginal)
    values (p_fecha, v_concepto, p_valor, v_tipo, v_metodo, v_prov, trim(p_textoConcepto));
    select last_insert_id() as idGasto;
end$$

-- Cierra un periodo: suma ingresos y gastos por categoria y guarda la foto.
-- Solo un socio puede cerrar, y los periodos no pueden solaparse.
create procedure sp_cerrar_periodo(in p_inicio date, in p_fin date, in p_idUsuario int)
begin
    declare v_rol  varchar(15);
    declare v_ing  decimal(14,2);
    declare v_op   decimal(14,2);
    declare v_inv  decimal(14,2);
    declare v_ini  decimal(14,2);

    select rol into v_rol from Usuario where idUsuario = p_idUsuario and bloqueado = 0;
    if v_rol is null or v_rol <> 'Socio' then
        signal sqlstate '45000' set message_text = 'Solo un socio activo puede cerrar un periodo';
    end if;
    if p_fin < p_inicio then
        signal sqlstate '45000' set message_text = 'La fecha final es anterior a la inicial';
    end if;
    if exists (select 1 from CierreFinanciero where fechaInicio <= p_fin and fechaFin >= p_inicio) then
        signal sqlstate '45000' set message_text = 'El periodo se cruza con un cierre ya hecho';
    end if;

    select coalesce(sum(valorTotal), 0) into v_ing from Venta where fechaVenta between p_inicio and p_fin;
    select coalesce(sum(case when cg.nombreCategoriaGasto = 'Operación'         then ga.valor end), 0),
           coalesce(sum(case when cg.nombreCategoriaGasto = 'Inventario'        then ga.valor end), 0),
           coalesce(sum(case when cg.nombreCategoriaGasto = 'Inversión inicial' then ga.valor end), 0)
      into v_op, v_inv, v_ini
      from Gasto ga
      inner join ConceptoGasto  co on co.idConcepto = ga.idConcepto
      inner join CategoriaGasto cg on cg.idCategoriaGasto = co.idCategoriaGasto
     where ga.fechaGasto between p_inicio and p_fin;

    insert into CierreFinanciero (fechaInicio, fechaFin, totalIngresos, totalOperacion, totalInventario,
                                  totalInversion, fechaCierre, idUsuario)
    values (p_inicio, p_fin, v_ing, v_op, v_inv, v_ini, now(), p_idUsuario);

    select idCierre, fechaInicio, fechaFin, totalIngresos,
           totalOperacion + totalInventario + totalInversion as totalEgresos,
           totalIngresos - (totalOperacion + totalInventario + totalInversion) as saldo
      from CierreFinanciero where idCierre = last_insert_id();
end$$

-- Compras contra ventas por producto en un rango. El margen es aproximado: solo
-- cuenta las compras enlazadas a un producto y las lineas con valor exacto.
create procedure sp_rentabilidad_producto(in p_inicio date, in p_fin date)
begin
    select pr.nombreProducto,
           (select coalesce(sum(ga.valor), 0) from Gasto ga
              inner join ConceptoGasto co on co.idConcepto = ga.idConcepto
             where co.idProducto = pr.idProducto and ga.fechaGasto between p_inicio and p_fin) as valor_comprado,
           (select coalesce(sum(dv.cantidad), 0) from DetalleVenta dv
              inner join Venta v on v.idVenta = dv.idVenta
              inner join Presentacion pe on pe.idPresentacion = dv.idPresentacion
             where pe.idProducto = pr.idProducto and v.fechaVenta between p_inicio and p_fin) as unidades_vendidas,
           (select coalesce(sum(dv.valorLinea), 0) from DetalleVenta dv
              inner join Venta v on v.idVenta = dv.idVenta
              inner join Presentacion pe on pe.idPresentacion = dv.idPresentacion
             where pe.idProducto = pr.idProducto and v.fechaVenta between p_inicio and p_fin) as valor_vendido_exacto
    from Producto pr
    where pr.idProducto in (select idProducto from ConceptoGasto where idProducto is not null);
end$$

-- Resultado parcial del punto fisico: sus ventas contra los gastos que el
-- catalogo marca como del local (arriendo, luz, internet).
create procedure sp_rentabilidad_punto_venta(in p_idPuntoVenta int, in p_inicio date, in p_fin date)
begin
    if not exists (select 1 from PuntoVenta where idPuntoVenta = p_idPuntoVenta) then
        signal sqlstate '45000' set message_text = 'El punto de venta no existe';
    end if;
    select pv.nombrePuntoVenta,
           (select coalesce(sum(valorTotal), 0) from Venta
             where idPuntoVenta = pv.idPuntoVenta and fechaVenta between p_inicio and p_fin) as ventas_del_local,
           (select coalesce(sum(ga.valor), 0) from Gasto ga
              inner join ConceptoGasto co on co.idConcepto = ga.idConcepto
             where co.asociadoLocal = 1 and ga.fechaGasto between p_inicio and p_fin) as gastos_del_local,
           (select coalesce(sum(valorTotal), 0) from Venta
             where idPuntoVenta = pv.idPuntoVenta and fechaVenta between p_inicio and p_fin)
         - (select coalesce(sum(ga.valor), 0) from Gasto ga
              inner join ConceptoGasto co on co.idConcepto = ga.idConcepto
             where co.asociadoLocal = 1 and ga.fechaGasto between p_inicio and p_fin) as resultado_parcial
    from PuntoVenta pv where pv.idPuntoVenta = p_idPuntoVenta;
end$$

-- Inicio de sesion. Tres fallos seguidos bloquean la cuenta (trigger).
create procedure sp_autenticar(in p_correo varchar(60), in p_contrasena varchar(100))
begin
    declare v_id    int;
    declare v_hash  varchar(64);
    declare v_bloq  boolean;
    declare v_rol   varchar(15);
    select idUsuario, contrasena, bloqueado, rol into v_id, v_hash, v_bloq, v_rol
      from Usuario where correo = p_correo;
    if v_id is null then
        signal sqlstate '45000' set message_text = 'Usuario o contrasena incorrectos';
    end if;
    if v_bloq = 1 then
        signal sqlstate '45000' set message_text = 'La cuenta esta bloqueada';
    end if;
    if sha2(p_contrasena, 256) <> v_hash then
        update Usuario set intentosFallidos = intentosFallidos + 1 where idUsuario = v_id;
        signal sqlstate '45000' set message_text = 'Usuario o contrasena incorrectos';
    end if;
    update Usuario set intentosFallidos = 0, ultimoAcceso = now() where idUsuario = v_id;
    select v_id as idUsuario, v_rol as rol;
end$$

-- Un socio activo reactiva una cuenta bloqueada. Reinicia tambien el contador:
-- si quedara en tres, el trigger la volveria a bloquear al instante.
create procedure sp_desbloquear_usuario(in p_idSocio int, in p_idUsuario int)
begin
    declare v_rol varchar(15);
    select rol into v_rol from Usuario where idUsuario = p_idSocio and bloqueado = 0;
    if v_rol is null or v_rol <> 'Socio' then
        signal sqlstate '45000' set message_text = 'Solo un socio activo puede desbloquear una cuenta';
    end if;
    if not exists (select 1 from Usuario where idUsuario = p_idUsuario) then
        signal sqlstate '45000' set message_text = 'El usuario no existe';
    end if;
    update Usuario set bloqueado = 0, intentosFallidos = 0 where idUsuario = p_idUsuario;
    select idUsuario, bloqueado, intentosFallidos from Usuario where idUsuario = p_idUsuario;
end$$

-- Cada usuario cambia su propia contrasena. Largo minimo de 8: propuesta
-- provisional, el cliente puede cambiarla.
create procedure sp_cambiar_contrasena(in p_idUsuario int, in p_actual varchar(100), in p_nueva varchar(100))
begin
    declare v_hash varchar(64);
    select contrasena into v_hash from Usuario where idUsuario = p_idUsuario;
    if v_hash is null then
        signal sqlstate '45000' set message_text = 'El usuario no existe';
    end if;
    if sha2(p_actual, 256) <> v_hash then
        signal sqlstate '45000' set message_text = 'La contrasena actual no coincide';
    end if;
    if p_nueva = p_actual then
        signal sqlstate '45000' set message_text = 'La contrasena nueva debe ser distinta de la actual';
    end if;
    if char_length(p_nueva) < 8 then
        signal sqlstate '45000' set message_text = 'La contrasena nueva debe tener al menos 8 caracteres';
    end if;
    update Usuario set contrasena = sha2(p_nueva, 256) where idUsuario = p_idUsuario;
    select p_idUsuario as idUsuario, 'Contrasena cambiada' as resultado;
end$$

-- Completa el valor de una linea que estaba pendiente. El trigger comprueba que
-- no supere el total de la venta.
create procedure sp_completar_linea_venta(in p_idDetalle int, in p_valor decimal(12,2))
begin
    if not exists (select 1 from DetalleVenta where idDetalle = p_idDetalle) then
        signal sqlstate '45000' set message_text = 'La linea no existe';
    end if;
    if p_valor is null or p_valor <= 0 then
        signal sqlstate '45000' set message_text = 'El valor debe ser mayor que cero';
    end if;
    update DetalleVenta set valorLinea = p_valor, origenValor = 'Exacto' where idDetalle = p_idDetalle;
    select idDetalle, idVenta, cantidad, valorLinea, origenValor from DetalleVenta where idDetalle = p_idDetalle;
end$$

delimiter ;

-- =====================================================================
-- VISTAS
-- =====================================================================

create view vw_detalle_venta as
select dv.idDetalle, v.idVenta, v.fechaVenta, c.nombreCliente, c.tipoCliente, ci.nombreCiudad,
       pr.nombreProducto, pe.nombrePresentacion, pe.sku, dv.cantidad, dv.valorLinea,
       round(dv.valorLinea / dv.cantidad, 2) as precioUnitario, dv.origenValor
from DetalleVenta dv
inner join Venta        v  on v.idVenta = dv.idVenta
inner join Cliente      c  on c.idCliente = v.idCliente
inner join Ciudad       ci on ci.idCiudad = v.idCiudad
inner join Presentacion pe on pe.idPresentacion = dv.idPresentacion
inner join Producto     pr on pr.idProducto = pe.idProducto;

-- Una fila por venta, con el canal calculado a partir del tipo de cliente
create view vw_venta_resumen as
select v.idVenta, v.fechaVenta, c.nombreCliente, c.tipoCliente,
       if(c.tipoCliente = 'Cliente final', 'B2C', 'B2B') as canal,
       ci.nombreCiudad, mp.nombreMetodoPago, v.facturada,
       if(v.idPuntoVenta is null, 'Fuera del local', pv.nombrePuntoVenta) as lugar,
       v.valorTotal,
       (select count(*) from DetalleVenta d where d.idVenta = v.idVenta) as lineas
from Venta v
inner join Cliente    c  on c.idCliente = v.idCliente
inner join Ciudad     ci on ci.idCiudad = v.idCiudad
inner join MetodoPago mp on mp.idMetodoPago = v.idMetodoPago
left  join PuntoVenta pv on pv.idPuntoVenta = v.idPuntoVenta;

create view vw_ventas_por_producto as
select pr.nombreProducto, sum(dv.cantidad) as unidades, count(distinct dv.idVenta) as ventas,
       coalesce(sum(dv.valorLinea), 0) as valor_exacto, sum(dv.origenValor = 'Pendiente') as lineas_sin_valor
from DetalleVenta dv
inner join Presentacion pe on pe.idPresentacion = dv.idPresentacion
inner join Producto     pr on pr.idProducto = pe.idProducto
group by pr.nombreProducto;

-- Historial de compras de cada cliente registrado (RF: consultar historial)
create view vw_historial_cliente as
select c.idCliente, c.nombreCliente, c.tipoCliente, count(v.idVenta) as ventas,
       coalesce(sum(v.valorTotal), 0) as total_comprado, min(v.fechaVenta) as primera_compra,
       max(v.fechaVenta) as ultima_compra
from Cliente c left join Venta v on v.idCliente = c.idCliente
group by c.idCliente, c.nombreCliente, c.tipoCliente;

create view vw_lineas_pendientes as
select v.idVenta, v.fechaVenta, v.valorTotal, v.productoOriginal, pe.sku, pe.nombrePresentacion, dv.cantidad
from DetalleVenta dv
inner join Venta v         on v.idVenta = dv.idVenta
inner join Presentacion pe on pe.idPresentacion = dv.idPresentacion
where dv.origenValor = 'Pendiente';

create view vw_gasto_detalle as
select ga.idGasto, ga.fechaGasto, co.nombreConcepto, cg.nombreCategoriaGasto, ga.valor,
       td.nombreTipoDocumento, mp.nombreMetodoPago, pv.nombreProveedor, pr.nombreProducto as productoRelacionado,
       (select group_concat(e.nombreEtiqueta order by e.nombreEtiqueta separator ', ')
          from GastoEtiqueta ge inner join Etiqueta e on e.idEtiqueta = ge.idEtiqueta
         where ge.idGasto = ga.idGasto) as etiquetas
from Gasto ga
inner join ConceptoGasto  co on co.idConcepto = ga.idConcepto
inner join CategoriaGasto cg on cg.idCategoriaGasto = co.idCategoriaGasto
inner join TipoDocumento  td on td.idTipoDocumento = ga.idTipoDocumento
inner join MetodoPago     mp on mp.idMetodoPago = ga.idMetodoPago
left  join Proveedor      pv on pv.idProveedor = ga.idProveedor
left  join Producto       pr on pr.idProducto = co.idProducto;

create view vw_gastos_por_categoria as
select cg.nombreCategoriaGasto, count(*) as gastos, sum(ga.valor) as total,
       round(sum(ga.valor) * 100 / (select sum(valor) from Gasto), 1) as porcentaje
from Gasto ga
inner join ConceptoGasto  co on co.idConcepto = ga.idConcepto
inner join CategoriaGasto cg on cg.idCategoriaGasto = co.idCategoriaGasto
group by cg.nombreCategoriaGasto;

create view vw_gastos_por_concepto as
select co.nombreConcepto, cg.nombreCategoriaGasto, count(*) as gastos, sum(ga.valor) as total,
       round(avg(ga.valor), 0) as promedio
from Gasto ga
inner join ConceptoGasto  co on co.idConcepto = ga.idConcepto
inner join CategoriaGasto cg on cg.idCategoriaGasto = co.idCategoriaGasto
group by co.nombreConcepto, cg.nombreCategoriaGasto;

-- Ingresos contra gastos por mes calendario (vista de caja)
create view vw_resultado_mensual as
select m.mes, coalesce(v.ingresos, 0) as ingresos,
       coalesce(g.operacion, 0) as gastos_operacion, coalesce(g.inventario, 0) as compras_inventario,
       coalesce(g.inversion_inicial, 0) as inversion_inicial,
       coalesce(v.ingresos, 0) - coalesce(g.total, 0) as saldo
from (select date_format(fechaVenta, '%Y-%m') as mes from Venta
      union select date_format(fechaGasto, '%Y-%m') from Gasto) m
left join (select date_format(fechaVenta, '%Y-%m') as mes, sum(valorTotal) as ingresos from Venta group by 1) v on v.mes = m.mes
left join (select date_format(ga.fechaGasto, '%Y-%m') as mes, sum(ga.valor) as total,
                  sum(case when cg.nombreCategoriaGasto = 'Operación'         then ga.valor else 0 end) as operacion,
                  sum(case when cg.nombreCategoriaGasto = 'Inventario'        then ga.valor else 0 end) as inventario,
                  sum(case when cg.nombreCategoriaGasto = 'Inversión inicial' then ga.valor else 0 end) as inversion_inicial
           from Gasto ga
           inner join ConceptoGasto  co on co.idConcepto = ga.idConcepto
           inner join CategoriaGasto cg on cg.idCategoriaGasto = co.idCategoriaGasto
           group by 1) g on g.mes = m.mes;

-- Lo comprado de cada producto contra lo vendido (solo compras enlazadas a un producto)
create view vw_compras_vs_ventas_producto as
select pr.nombreProducto,
       (select sum(ga.valor) from Gasto ga inner join ConceptoGasto co on co.idConcepto = ga.idConcepto
         where co.idProducto = pr.idProducto) as valor_comprado,
       (select coalesce(sum(dv.cantidad), 0) from DetalleVenta dv
          inner join Presentacion pe on pe.idPresentacion = dv.idPresentacion
         where pe.idProducto = pr.idProducto) as unidades_vendidas,
       (select coalesce(sum(dv.valorLinea), 0) from DetalleVenta dv
          inner join Presentacion pe on pe.idPresentacion = dv.idPresentacion
         where pe.idProducto = pr.idProducto) as valor_vendido_exacto
from Producto pr
where pr.idProducto in (select idProducto from ConceptoGasto where idProducto is not null);

-- Fin de 01_DDL.sql. Siga con 02_DML.sql
