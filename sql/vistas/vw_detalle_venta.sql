-- Vista: vw_detalle_venta
-- Vista de consulta de la base liwi_flor_eterna.
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

drop view if exists vw_detalle_venta;
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
