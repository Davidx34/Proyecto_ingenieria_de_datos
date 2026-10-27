-- ============================================================
-- Liwi Flor Eterna - Entregable 2 - Consultas de evidencia
-- Se ejecuta DESPUES de 01_DDL.sql y 02_DML.sql
-- ============================================================
use liwi_flor_eterna;

-- ------------------------------------------------------------
-- C. CONSULTAS POR TABLA (8 por tabla, 21 tablas)
-- ------------------------------------------------------------
-- AliasConcepto 1/8 : Consulta básica
select * from AliasConcepto limit 10;

-- AliasConcepto 2/8 : Filtro por concepto
select idAliasConcepto, textoAlias from AliasConcepto where idConcepto = 3;

-- AliasConcepto 3/8 : LIKE sobre el texto
select textoAlias, idConcepto from AliasConcepto where textoAlias like '%ompra%' order by textoAlias limit 10;

-- AliasConcepto 4/8 : Agrupación: variantes por concepto
select idConcepto, count(*) as variantes from AliasConcepto group by idConcepto order by variantes desc limit 10;

-- AliasConcepto 5/8 : HAVING: conceptos con 3 o más escrituras
select idConcepto, count(*) as variantes from AliasConcepto group by idConcepto having count(*) >= 3;

-- AliasConcepto 6/8 : Cálculo: longitud promedio del texto
select round(avg(char_length(textoAlias)),1) as largo_promedio, max(char_length(textoAlias)) as largo_maximo from AliasConcepto;

-- AliasConcepto 7/8 : Orden y rango de ids
select idAliasConcepto, textoAlias from AliasConcepto where idAliasConcepto between 10 and 20 order by textoAlias;

-- AliasConcepto 8/8 : DISTINCT con LIMIT
select distinct idConcepto from AliasConcepto order by idConcepto limit 8;

-- AliasProducto 1/8 : Consulta básica
select * from AliasProducto limit 10;

-- AliasProducto 2/8 : Filtro por presentación
select idAlias, textoAlias from AliasProducto where idPresentacion = 1;

-- AliasProducto 3/8 : LIKE sobre el texto
select textoAlias, idPresentacion from AliasProducto where textoAlias like '%vino%' or textoAlias like '%Vino%';

-- AliasProducto 4/8 : Agrupación por origen
select origen, count(*) as alias from AliasProducto group by origen;

-- AliasProducto 5/8 : HAVING: presentaciones con varias escrituras
select idPresentacion, count(*) as escrituras from AliasProducto group by idPresentacion having count(*) >= 2 order by escrituras desc;

-- AliasProducto 6/8 : Cálculo: totales de alias
select count(*) as total_alias, count(distinct idPresentacion) as presentaciones_cubiertas from AliasProducto;

-- AliasProducto 7/8 : Orden y rango de ids
select idAlias, textoAlias from AliasProducto where idAlias between 5 and 15 order by textoAlias;

-- AliasProducto 8/8 : DISTINCT con LIMIT
select distinct origen from AliasProducto limit 5;

-- Categoria 1/8 : Consulta básica
select * from Categoria;

-- Categoria 2/8 : Filtro por id
select * from Categoria where idCategoria = 4;

-- Categoria 3/8 : LIKE sobre el nombre
select * from Categoria where nombreCategoria like '%as%';

-- Categoria 4/8 : Agrupación: productos por categoría
select c.nombreCategoria, count(p.idProducto) as productos from Categoria c left join Producto p on p.idCategoria = c.idCategoria group by c.idCategoria, c.nombreCategoria;

-- Categoria 5/8 : HAVING: categorías con más de un producto
select c.nombreCategoria, count(*) as productos from Categoria c join Producto p on p.idCategoria = c.idCategoria group by c.idCategoria, c.nombreCategoria having count(*) > 1;

-- Categoria 6/8 : Cálculo: cantidad de categorías
select count(*) as categorias, max(char_length(nombreCategoria)) as nombre_mas_largo from Categoria;

-- Categoria 7/8 : Orden alfabético
select nombreCategoria from Categoria order by nombreCategoria;

-- Categoria 8/8 : DISTINCT con LIMIT
select distinct left(nombreCategoria, 1) as inicial from Categoria order by inicial limit 6;

-- CategoriaGasto 1/8 : Consulta básica
select * from CategoriaGasto;

-- CategoriaGasto 2/8 : Filtro por nombre
select * from CategoriaGasto where nombreCategoriaGasto = 'Inventario';

-- CategoriaGasto 3/8 : LIKE sobre el nombre
select * from CategoriaGasto where nombreCategoriaGasto like '%ión%';

-- CategoriaGasto 4/8 : Agrupación: conceptos por categoría
select cg.nombreCategoriaGasto, count(co.idConcepto) as conceptos from CategoriaGasto cg left join ConceptoGasto co on co.idCategoriaGasto = cg.idCategoriaGasto group by cg.idCategoriaGasto, cg.nombreCategoriaGasto;

-- CategoriaGasto 5/8 : HAVING: categorías con más de 5 conceptos
select cg.nombreCategoriaGasto, count(*) as conceptos from CategoriaGasto cg join ConceptoGasto co on co.idCategoriaGasto = cg.idCategoriaGasto group by cg.idCategoriaGasto, cg.nombreCategoriaGasto having count(*) > 5;

-- CategoriaGasto 6/8 : Cálculo: total de categorías
select count(*) as categorias from CategoriaGasto;

-- CategoriaGasto 7/8 : Orden descendente por id
select idCategoriaGasto, nombreCategoriaGasto from CategoriaGasto order by idCategoriaGasto desc;

-- CategoriaGasto 8/8 : DISTINCT con LIMIT
select distinct nombreCategoriaGasto from CategoriaGasto limit 2;

-- CierreFinanciero 1/8 : Consulta básica
select * from CierreFinanciero;

-- CierreFinanciero 2/8 : Filtro por periodo
select idCierre, fechaInicio, fechaFin, totalIngresos from CierreFinanciero where fechaInicio >= '2026-09-01';

-- CierreFinanciero 3/8 : LIKE sobre la fecha de inicio
select idCierre, fechaInicio from CierreFinanciero where fechaInicio like '2026-08%';

-- CierreFinanciero 4/8 : Agrupación por socio que cerró
select idUsuario, count(*) as cierres from CierreFinanciero group by idUsuario;

-- CierreFinanciero 5/8 : HAVING: cierres con ingresos altos
select idUsuario, sum(totalIngresos) as ingresos from CierreFinanciero group by idUsuario having sum(totalIngresos) > 5000000;

-- CierreFinanciero 6/8 : Cálculo: saldo de cada cierre
select idCierre, totalIngresos - totalOperacion - totalInventario - totalInversion as saldo from CierreFinanciero;

-- CierreFinanciero 7/8 : Orden por ingresos
select idCierre, totalIngresos from CierreFinanciero order by totalIngresos desc;

-- CierreFinanciero 8/8 : DISTINCT con LIMIT
select distinct idUsuario from CierreFinanciero limit 3;

-- Ciudad 1/8 : Consulta básica
select * from Ciudad;

-- Ciudad 2/8 : Filtro por nombre
select * from Ciudad where nombreCiudad = 'Bogotá';

-- Ciudad 3/8 : LIKE sobre el nombre
select * from Ciudad where nombreCiudad like '%í%';

-- Ciudad 4/8 : Agrupación: ventas por ciudad
select c.nombreCiudad, count(v.idVenta) as ventas from Ciudad c left join Venta v on v.idCiudad = c.idCiudad group by c.idCiudad, c.nombreCiudad;

-- Ciudad 5/8 : HAVING: ciudades con más de 100 ventas
select c.nombreCiudad, count(*) as ventas from Ciudad c join Venta v on v.idCiudad = c.idCiudad group by c.idCiudad, c.nombreCiudad having count(*) > 100;

-- Ciudad 6/8 : Cálculo: valor vendido por ciudad
select c.nombreCiudad, sum(v.valorTotal) as vendido from Ciudad c join Venta v on v.idCiudad = c.idCiudad group by c.idCiudad, c.nombreCiudad;

-- Ciudad 7/8 : Orden alfabético
select nombreCiudad from Ciudad order by nombreCiudad;

-- Ciudad 8/8 : DISTINCT con LIMIT
select distinct length(nombreCiudad) as largo from Ciudad limit 3;

-- Cliente 1/8 : Consulta básica
select * from Cliente;

-- Cliente 2/8 : Filtro por tipo
select idCliente, nombreCliente from Cliente where tipoCliente = 'Floristería';

-- Cliente 3/8 : LIKE sobre el nombre
select idCliente, nombreCliente from Cliente where nombreCliente like '%sin registro%';

-- Cliente 4/8 : Agrupación por tipo
select tipoCliente, count(*) as clientes from Cliente group by tipoCliente;

-- Cliente 5/8 : HAVING: tipos con más de un cliente
select tipoCliente, count(*) as clientes from Cliente group by tipoCliente having count(*) > 1;

-- Cliente 6/8 : Cálculo: clientes activos
select sum(activo) as activos, count(*) as total from Cliente;

-- Cliente 7/8 : Orden alfabético
select nombreCliente, tipoCliente from Cliente order by nombreCliente;

-- Cliente 8/8 : DISTINCT con LIMIT
select distinct tipoCliente from Cliente limit 5;

-- ConceptoGasto 1/8 : Consulta básica
select * from ConceptoGasto limit 10;

-- ConceptoGasto 2/8 : Filtro por categoría de gasto
select idConcepto, nombreConcepto from ConceptoGasto where idCategoriaGasto = 2;

-- ConceptoGasto 3/8 : LIKE sobre el nombre
select idConcepto, nombreConcepto from ConceptoGasto where nombreConcepto like 'Compra de%' order by nombreConcepto;

-- ConceptoGasto 4/8 : Agrupación por categoría
select idCategoriaGasto, count(*) as conceptos from ConceptoGasto group by idCategoriaGasto;

-- ConceptoGasto 5/8 : HAVING: categorías con más de 10 conceptos
select idCategoriaGasto, count(*) as conceptos from ConceptoGasto group by idCategoriaGasto having count(*) > 10;

-- ConceptoGasto 6/8 : Cálculo: conceptos ligados a un producto
select count(*) as total, count(idProducto) as con_producto, sum(asociadoLocal) as del_local from ConceptoGasto;

-- ConceptoGasto 7/8 : Orden y rango de ids
select idConcepto, nombreConcepto from ConceptoGasto where idConcepto between 11 and 16 order by idConcepto desc;

-- ConceptoGasto 8/8 : DISTINCT con LIMIT
select distinct idProducto from ConceptoGasto where idProducto is not null order by idProducto limit 5;

-- DetalleVenta 1/8 : Consulta básica
select * from DetalleVenta limit 10;

-- DetalleVenta 2/8 : Filtro por origen del valor
select idDetalle, idVenta, cantidad from DetalleVenta where origenValor = 'Pendiente' limit 10;

-- DetalleVenta 3/8 : LIKE sobre el origen
select origenValor, count(*) as lineas from DetalleVenta where origenValor like 'Exa%' group by origenValor;

-- DetalleVenta 4/8 : Agrupación por presentación
select idPresentacion, sum(cantidad) as unidades from DetalleVenta group by idPresentacion order by unidades desc limit 10;

-- DetalleVenta 5/8 : HAVING: presentaciones con más de 50 unidades
select idPresentacion, sum(cantidad) as unidades from DetalleVenta group by idPresentacion having sum(cantidad) > 50;

-- DetalleVenta 6/8 : Cálculo: valor de líneas con precio
select count(valorLinea) as lineas_con_valor, sum(valorLinea) as suma, round(avg(valorLinea),0) as promedio from DetalleVenta;

-- DetalleVenta 7/8 : Orden y rango de cantidades
select idDetalle, idVenta, cantidad, valorLinea from DetalleVenta where cantidad between 10 and 30 order by cantidad desc limit 10;

-- DetalleVenta 8/8 : DISTINCT con LIMIT
select distinct cantidad from DetalleVenta order by cantidad limit 10;

-- Etiqueta 1/8 : Consulta básica
select * from Etiqueta;

-- Etiqueta 2/8 : Filtro por nombre
select * from Etiqueta where nombreEtiqueta = 'LIWI';

-- Etiqueta 3/8 : LIKE sobre el nombre
select * from Etiqueta where nombreEtiqueta like 'A%';

-- Etiqueta 4/8 : Agrupación: gastos por etiqueta
select e.nombreEtiqueta, count(ge.idGasto) as gastos from Etiqueta e left join GastoEtiqueta ge on ge.idEtiqueta = e.idEtiqueta group by e.idEtiqueta, e.nombreEtiqueta;

-- Etiqueta 5/8 : HAVING: etiquetas con más de 20 gastos
select e.nombreEtiqueta, count(*) as gastos from Etiqueta e join GastoEtiqueta ge on ge.idEtiqueta = e.idEtiqueta group by e.idEtiqueta, e.nombreEtiqueta having count(*) > 20;

-- Etiqueta 6/8 : Cálculo: total de etiquetas
select count(*) as etiquetas from Etiqueta;

-- Etiqueta 7/8 : Orden alfabético
select nombreEtiqueta from Etiqueta order by nombreEtiqueta;

-- Etiqueta 8/8 : DISTINCT con LIMIT
select distinct nombreEtiqueta from Etiqueta limit 3;

-- Gasto 1/8 : Consulta básica
select * from Gasto limit 10;

-- Gasto 2/8 : Filtro por concepto y rango de valor
select idGasto, fechaGasto, valor from Gasto where idConcepto = 1 and valor > 20000 limit 10;

-- Gasto 3/8 : LIKE sobre el texto original
select idGasto, conceptoOriginal, valor from Gasto where conceptoOriginal like '%ransporte%' limit 10;

-- Gasto 4/8 : Agrupación por mes
select date_format(fechaGasto, '%Y-%m') as mes, count(*) as gastos, sum(valor) as total from Gasto group by mes order by mes;

-- Gasto 5/8 : HAVING: conceptos con gasto acumulado alto
select idConcepto, sum(valor) as total from Gasto group by idConcepto having sum(valor) > 1000000 order by total desc;

-- Gasto 6/8 : Cálculo: promedio y máximo
select count(*) as gastos, sum(valor) as total, round(avg(valor),0) as promedio, max(valor) as maximo from Gasto;

-- Gasto 7/8 : Orden y rango de fechas
select idGasto, fechaGasto, valor from Gasto where fechaGasto between '2026-09-01' and '2026-09-15' order by valor desc limit 10;

-- Gasto 8/8 : DISTINCT con LIMIT
select distinct idMetodoPago from Gasto order by idMetodoPago limit 5;

-- GastoEtiqueta 1/8 : Consulta básica
select * from GastoEtiqueta limit 10;

-- GastoEtiqueta 2/8 : Filtro por etiqueta
select idGasto from GastoEtiqueta where idEtiqueta = 1 limit 10;

-- GastoEtiqueta 3/8 : LIKE sobre el texto del gasto asociado
select ge.idGasto, g.conceptoOriginal from GastoEtiqueta ge join Gasto g on g.idGasto = ge.idGasto where g.conceptoOriginal like '%ompra%' limit 10;

-- GastoEtiqueta 4/8 : Agrupación por etiqueta
select idEtiqueta, count(*) as gastos from GastoEtiqueta group by idEtiqueta;

-- GastoEtiqueta 5/8 : HAVING: gastos con más de una etiqueta
select idGasto, count(*) as etiquetas from GastoEtiqueta group by idGasto having count(*) > 1 limit 10;

-- GastoEtiqueta 6/8 : Cálculo: relaciones y gastos distintos
select count(*) as relaciones, count(distinct idGasto) as gastos_distintos from GastoEtiqueta;

-- GastoEtiqueta 7/8 : Orden y rango de gastos
select idGasto, idEtiqueta from GastoEtiqueta where idGasto between 1 and 40 order by idGasto desc limit 10;

-- GastoEtiqueta 8/8 : DISTINCT con LIMIT
select distinct idEtiqueta from GastoEtiqueta limit 5;

-- MetodoPago 1/8 : Consulta básica
select * from MetodoPago;

-- MetodoPago 2/8 : Filtro por nombre
select * from MetodoPago where nombreMetodoPago = 'Nequi';

-- MetodoPago 3/8 : LIKE sobre el nombre
select * from MetodoPago where nombreMetodoPago like '%a%';

-- MetodoPago 4/8 : Agrupación: ventas por método
select m.nombreMetodoPago, count(v.idVenta) as ventas from MetodoPago m left join Venta v on v.idMetodoPago = m.idMetodoPago group by m.idMetodoPago, m.nombreMetodoPago;

-- MetodoPago 5/8 : HAVING: métodos con más de 50 ventas
select m.nombreMetodoPago, count(*) as ventas from MetodoPago m join Venta v on v.idMetodoPago = m.idMetodoPago group by m.idMetodoPago, m.nombreMetodoPago having count(*) > 50;

-- MetodoPago 6/8 : Cálculo: valor vendido por método
select m.nombreMetodoPago, sum(v.valorTotal) as vendido from MetodoPago m join Venta v on v.idMetodoPago = m.idMetodoPago group by m.idMetodoPago, m.nombreMetodoPago order by vendido desc;

-- MetodoPago 7/8 : Orden alfabético
select nombreMetodoPago from MetodoPago order by nombreMetodoPago;

-- MetodoPago 8/8 : DISTINCT con LIMIT
select distinct length(nombreMetodoPago) as largo from MetodoPago limit 4;

-- Presentacion 1/8 : Consulta básica
select * from Presentacion limit 10;

-- Presentacion 2/8 : Filtro por producto
select sku, nombrePresentacion from Presentacion where idProducto = 1;

-- Presentacion 3/8 : LIKE sobre el SKU
select sku, nombrePresentacion from Presentacion where sku like 'VIN-%';

-- Presentacion 4/8 : Agrupación: presentaciones por producto
select idProducto, count(*) as presentaciones from Presentacion group by idProducto order by presentaciones desc;

-- Presentacion 5/8 : HAVING: productos con más de 2 presentaciones
select idProducto, count(*) as presentaciones from Presentacion group by idProducto having count(*) > 2;

-- Presentacion 6/8 : Cálculo: presentaciones por revisar
select count(*) as total, sum(requiereRevision) as por_revisar from Presentacion;

-- Presentacion 7/8 : Orden y rango de ids
select idPresentacion, sku from Presentacion where idPresentacion between 10 and 20 order by sku;

-- Presentacion 8/8 : DISTINCT con LIMIT
select distinct idProducto from Presentacion order by idProducto limit 6;

-- Producto 1/8 : Consulta básica
select * from Producto;

-- Producto 2/8 : Filtro por categoría
select idProducto, nombreProducto from Producto where idCategoria = 4;

-- Producto 3/8 : LIKE sobre el nombre
select idProducto, nombreProducto from Producto where nombreProducto like '%a%' order by nombreProducto;

-- Producto 4/8 : Agrupación por categoría
select idCategoria, count(*) as productos from Producto group by idCategoria;

-- Producto 5/8 : HAVING: categorías con más de un producto
select idCategoria, count(*) as productos from Producto group by idCategoria having count(*) > 1;

-- Producto 6/8 : Cálculo: productos activos
select count(*) as productos, sum(activo) as activos from Producto;

-- Producto 7/8 : Orden alfabético
select nombreProducto from Producto order by nombreProducto;

-- Producto 8/8 : DISTINCT con LIMIT
select distinct idCategoria from Producto order by idCategoria limit 5;

-- Proveedor 1/8 : Consulta básica
select * from Proveedor;

-- Proveedor 2/8 : Filtro por nombre
select * from Proveedor where nombreProveedor = 'DIDI';

-- Proveedor 3/8 : LIKE sobre el nombre
select * from Proveedor where nombreProveedor like 'D%';

-- Proveedor 4/8 : Agrupación: gastos por proveedor
select p.nombreProveedor, count(g.idGasto) as gastos from Proveedor p left join Gasto g on g.idProveedor = p.idProveedor group by p.idProveedor, p.nombreProveedor;

-- Proveedor 5/8 : HAVING: proveedores con gastos
select p.nombreProveedor, count(*) as gastos from Proveedor p join Gasto g on g.idProveedor = p.idProveedor group by p.idProveedor, p.nombreProveedor having count(*) >= 1;

-- Proveedor 6/8 : Cálculo: valor pagado al proveedor
select p.nombreProveedor, sum(g.valor) as pagado from Proveedor p join Gasto g on g.idProveedor = p.idProveedor group by p.idProveedor, p.nombreProveedor;

-- Proveedor 7/8 : Orden alfabético
select nombreProveedor from Proveedor order by nombreProveedor;

-- Proveedor 8/8 : DISTINCT con LIMIT
select distinct nombreProveedor from Proveedor limit 3;

-- PuntoVenta 1/8 : Consulta básica
select * from PuntoVenta;

-- PuntoVenta 2/8 : Filtro por ciudad
select idPuntoVenta, nombrePuntoVenta from PuntoVenta where ciudad = 'Bogotá';

-- PuntoVenta 3/8 : LIKE sobre el nombre
select * from PuntoVenta where nombrePuntoVenta like 'Local%';

-- PuntoVenta 4/8 : Agrupación: ventas del local y fuera del local
select if(idPuntoVenta is null, 'Fuera del local', 'Local Bogotá') as lugar, count(*) as ventas from Venta group by lugar;

-- PuntoVenta 5/8 : HAVING: puntos con más de 100 ventas
select p.nombrePuntoVenta, count(*) as ventas from PuntoVenta p join Venta v on v.idPuntoVenta = p.idPuntoVenta group by p.idPuntoVenta, p.nombrePuntoVenta having count(*) > 100;

-- PuntoVenta 6/8 : Cálculo: valor vendido en el local
select p.nombrePuntoVenta, sum(v.valorTotal) as vendido from PuntoVenta p join Venta v on v.idPuntoVenta = p.idPuntoVenta group by p.idPuntoVenta, p.nombrePuntoVenta;

-- PuntoVenta 7/8 : Orden por nombre
select nombrePuntoVenta, ciudad from PuntoVenta order by nombrePuntoVenta;

-- PuntoVenta 8/8 : DISTINCT con LIMIT
select distinct ciudad from PuntoVenta limit 3;

-- TipoDocumento 1/8 : Consulta básica
select * from TipoDocumento;

-- TipoDocumento 2/8 : Filtro por nombre
select * from TipoDocumento where nombreTipoDocumento = 'Recibo';

-- TipoDocumento 3/8 : LIKE sobre el nombre
select * from TipoDocumento where nombreTipoDocumento like '%o%';

-- TipoDocumento 4/8 : Agrupación: gastos por tipo de documento
select t.nombreTipoDocumento, count(g.idGasto) as gastos from TipoDocumento t left join Gasto g on g.idTipoDocumento = t.idTipoDocumento group by t.idTipoDocumento, t.nombreTipoDocumento;

-- TipoDocumento 5/8 : HAVING: tipos con más de 50 gastos
select t.nombreTipoDocumento, count(*) as gastos from TipoDocumento t join Gasto g on g.idTipoDocumento = t.idTipoDocumento group by t.idTipoDocumento, t.nombreTipoDocumento having count(*) > 50;

-- TipoDocumento 6/8 : Cálculo: valor por tipo de documento
select t.nombreTipoDocumento, sum(g.valor) as total from TipoDocumento t join Gasto g on g.idTipoDocumento = t.idTipoDocumento group by t.idTipoDocumento, t.nombreTipoDocumento order by total desc;

-- TipoDocumento 7/8 : Orden alfabético
select nombreTipoDocumento from TipoDocumento order by nombreTipoDocumento;

-- TipoDocumento 8/8 : DISTINCT con LIMIT
select distinct length(nombreTipoDocumento) as largo from TipoDocumento limit 5;

-- Usuario 1/8 : Consulta básica
select idUsuario, nombre, correo, rol, bloqueado, idPuntoVenta from Usuario;

-- Usuario 2/8 : Filtro por rol
select idUsuario, nombre from Usuario where rol = 'Socio';

-- Usuario 3/8 : LIKE sobre el correo
select nombre, correo from Usuario where correo like 'd%@liwifloreterna.co';

-- Usuario 4/8 : Agrupación por rol
select rol, count(*) as usuarios from Usuario group by rol;

-- Usuario 5/8 : HAVING: roles con 3 usuarios
select rol, count(*) as usuarios from Usuario group by rol having count(*) = 3;

-- Usuario 6/8 : Cálculo: usuarios bloqueados e intentos
select sum(bloqueado) as bloqueados, max(intentosFallidos) as max_intentos from Usuario;

-- Usuario 7/8 : Orden por fecha de registro
select nombre, rol, fechaRegistro from Usuario order by fechaRegistro, idUsuario;

-- Usuario 8/8 : DISTINCT con LIMIT
select distinct rol from Usuario limit 3;

-- Venta 1/8 : Consulta básica
select * from Venta limit 10;

-- Venta 2/8 : Filtro: ventas del local con factura
select idVenta, fechaVenta, valorTotal from Venta where idPuntoVenta is not null and facturada = 1 limit 10;

-- Venta 3/8 : LIKE sobre el texto original
select idVenta, productoOriginal, valorTotal from Venta where productoOriginal like '%vino%' limit 10;

-- Venta 4/8 : Agrupación por mes
select date_format(fechaVenta, '%Y-%m') as mes, count(*) as ventas, sum(valorTotal) as total from Venta group by mes order by mes;

-- Venta 5/8 : HAVING: clientes que más compran
select idCliente, count(*) as ventas, sum(valorTotal) as total from Venta group by idCliente having count(*) > 50 order by total desc;

-- Venta 6/8 : Cálculo: totales y promedio
select count(*) as ventas, sum(valorTotal) as total, round(avg(valorTotal),0) as promedio, max(valorTotal) as maxima from Venta;

-- Venta 7/8 : Orden y rango de fechas
select idVenta, fechaVenta, valorTotal from Venta where fechaVenta between '2026-09-01' and '2026-09-07' order by valorTotal desc limit 10;

-- Venta 8/8 : DISTINCT con LIMIT
select distinct idMetodoPago, idCiudad from Venta order by idMetodoPago, idCiudad limit 10;

-- ------------------------------------------------------------
-- D. MODIFICACION Y ELIMINACION (se ejecutan de verdad)
-- ------------------------------------------------------------
-- UPDATE 1: Corregir el método de pago de ventas de cliente final registradas como efectivo
update Venta set idMetodoPago = 2 where idCliente = 1 and idMetodoPago = 1 and fechaVenta between '2026-08-18' and '2026-08-19';

-- UPDATE 2: Marcar como facturadas las ventas de una fecha
update Venta set facturada = 1 where fechaVenta = '2026-08-20' and facturada = 0;

-- UPDATE 3: Pasar a efectivo los gastos de transporte de la primera semana
update Gasto set idMetodoPago = 1 where idConcepto = 1 and idMetodoPago = 2 and fechaGasto < '2026-08-25';

-- UPDATE 4: Dejar constancia en el origen de un alias de producto
update AliasProducto set origen = 'Escrito en el libro (revisado)' where idAlias = 2;

-- UPDATE 5: Registrar el último acceso de una administradora
update Usuario set ultimoAcceso = now() where idUsuario = 4;

-- INSERT de apoyo: Registrar un gasto de prueba para poder eliminarlo
insert into Gasto (fechaGasto, idConcepto, valor, idTipoDocumento, idMetodoPago, conceptoOriginal) values ('2026-10-15', 1, 1000.00, 3, 1, 'Gasto de prueba');

-- DELETE: Eliminar el gasto de prueba (el trigger deja el rastro)
delete from Gasto where conceptoOriginal = 'Gasto de prueba';

-- ------------------------------------------------------------
-- C. BitacoraCambio (despues de las modificaciones)
-- ------------------------------------------------------------
-- BitacoraCambio 1/8 : Consulta básica
select * from BitacoraCambio limit 10;

-- BitacoraCambio 2/8 : Filtro por acción
select idBitacora, tablaAfectada, idRegistro, accion from BitacoraCambio where accion = 'MODIFICA';

-- BitacoraCambio 3/8 : LIKE sobre el valor anterior
select idBitacora, tablaAfectada, valorAnterior from BitacoraCambio where valorAnterior like '%pago=1%';

-- BitacoraCambio 4/8 : Agrupación por tabla y acción
select tablaAfectada, accion, count(*) as cambios from BitacoraCambio group by tablaAfectada, accion;

-- BitacoraCambio 5/8 : HAVING: tablas con más de un cambio
select tablaAfectada, count(*) as cambios from BitacoraCambio group by tablaAfectada having count(*) > 1;

-- BitacoraCambio 6/8 : Cálculo: primer y último cambio
select count(*) as cambios, min(fechaCambio) as primero, max(fechaCambio) as ultimo from BitacoraCambio;

-- BitacoraCambio 7/8 : Orden por fecha descendente
select idBitacora, tablaAfectada, idRegistro, accion from BitacoraCambio order by idBitacora desc limit 10;

-- BitacoraCambio 8/8 : DISTINCT con LIMIT
select distinct usuarioBD from BitacoraCambio limit 5;

-- ------------------------------------------------------------
-- E. CONSULTAS AVANZADAS
-- ------------------------------------------------------------
-- JOIN 1/8 : Ventas con cliente, ciudad y método de pago
select v.idVenta, v.fechaVenta, c.nombreCliente, ci.nombreCiudad, m.nombreMetodoPago, v.valorTotal from Venta v join Cliente c on c.idCliente = v.idCliente join Ciudad ci on ci.idCiudad = v.idCiudad join MetodoPago m on m.idMetodoPago = v.idMetodoPago order by v.valorTotal desc limit 10;

-- JOIN 2/8 : Líneas de venta con producto, presentación y SKU
select d.idDetalle, d.idVenta, p.nombreProducto, pr.nombrePresentacion, pr.sku, d.cantidad, d.valorLinea from DetalleVenta d join Presentacion pr on pr.idPresentacion = d.idPresentacion join Producto p on p.idProducto = pr.idProducto where d.valorLinea is not null order by d.valorLinea desc limit 10;

-- JOIN 3/8 : Gastos con concepto, categoría y tipo de documento
select g.idGasto, g.fechaGasto, co.nombreConcepto, cg.nombreCategoriaGasto, t.nombreTipoDocumento, g.valor from Gasto g join ConceptoGasto co on co.idConcepto = g.idConcepto join CategoriaGasto cg on cg.idCategoriaGasto = co.idCategoriaGasto join TipoDocumento t on t.idTipoDocumento = g.idTipoDocumento order by g.valor desc limit 10;

-- JOIN 4/8 : Gastos con sus etiquetas (relación N:M)
select g.idGasto, g.fechaGasto, e.nombreEtiqueta, g.valor from Gasto g join GastoEtiqueta ge on ge.idGasto = g.idGasto join Etiqueta e on e.idEtiqueta = ge.idEtiqueta order by g.valor desc limit 10;

-- JOIN 5/8 : Productos con su categoría y cantidad de presentaciones (LEFT JOIN)
select p.nombreProducto, c.nombreCategoria, count(pr.idPresentacion) as presentaciones from Producto p join Categoria c on c.idCategoria = p.idCategoria left join Presentacion pr on pr.idProducto = p.idProducto group by p.idProducto, p.nombreProducto, c.nombreCategoria order by presentaciones desc;

-- JOIN 6/8 : Conceptos de compra ligados a un producto
select co.nombreConcepto, p.nombreProducto, cat.nombreCategoria from ConceptoGasto co join Producto p on p.idProducto = co.idProducto join Categoria cat on cat.idCategoria = p.idCategoria order by p.nombreProducto;

-- JOIN 7/8 : Alias de producto con presentación y producto
select a.textoAlias, pr.sku, p.nombreProducto from AliasProducto a join Presentacion pr on pr.idPresentacion = a.idPresentacion join Producto p on p.idProducto = pr.idProducto order by p.nombreProducto, a.textoAlias limit 10;

-- JOIN 8/8 : Cierres financieros con el socio que los hizo
select cf.idCierre, cf.fechaInicio, cf.fechaFin, u.nombre as socio, cf.totalIngresos from CierreFinanciero cf join Usuario u on u.idUsuario = cf.idUsuario order by cf.idCierre;

-- SUBCONSULTA 1/8 : Ventas por encima del promedio
select idVenta, fechaVenta, valorTotal from Venta where valorTotal > (select avg(valorTotal) from Venta) order by valorTotal desc limit 10;

-- SUBCONSULTA 2/8 : Clientes que han comprado más de 60 veces
select nombreCliente, tipoCliente from Cliente where idCliente in (select idCliente from Venta group by idCliente having count(*) > 60);

-- SUBCONSULTA 3/8 : Productos que tienen alguna línea de venta sin precio
select nombreProducto from Producto p where exists (select 1 from Presentacion pr join DetalleVenta d on d.idPresentacion = pr.idPresentacion where pr.idProducto = p.idProducto and d.origenValor = 'Pendiente') order by nombreProducto;

-- SUBCONSULTA 4/8 : Presentaciones sin ninguna línea con precio exacto
select sku, nombrePresentacion from Presentacion where idPresentacion not in (select idPresentacion from DetalleVenta where origenValor = 'Exacto');

-- SUBCONSULTA 5/8 : Conceptos cuyo gasto total supera el promedio por concepto
select co.nombreConcepto, sum(g.valor) as total from Gasto g join ConceptoGasto co on co.idConcepto = g.idConcepto group by co.idConcepto, co.nombreConcepto having sum(g.valor) > (select avg(t) from (select sum(valor) as t from Gasto group by idConcepto) x) order by total desc;

-- SUBCONSULTA 6/8 : Gastos mayores al promedio de su misma categoría
select g.idGasto, co.nombreConcepto, g.valor from Gasto g join ConceptoGasto co on co.idConcepto = g.idConcepto where g.valor > (select avg(g2.valor) from Gasto g2 join ConceptoGasto c2 on c2.idConcepto = g2.idConcepto where c2.idCategoriaGasto = co.idCategoriaGasto) order by g.valor desc limit 10;

-- SUBCONSULTA 7/8 : Día de mayor venta
select fechaVenta, sum(valorTotal) as total from Venta group by fechaVenta having sum(valorTotal) = (select max(t) from (select sum(valorTotal) as t from Venta group by fechaVenta) x);

-- SUBCONSULTA 8/8 : Gastos con más de una etiqueta
select g.idGasto, g.fechaGasto, g.valor from Gasto g where (select count(*) from GastoEtiqueta ge where ge.idGasto = g.idGasto) > 1 limit 10;
