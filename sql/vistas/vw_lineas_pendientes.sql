-- Vista: vw_lineas_pendientes
-- Vista de consulta de la base liwi_flor_eterna.
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

drop view if exists vw_lineas_pendientes;
create view vw_lineas_pendientes as
select v.idVenta, v.fechaVenta, v.valorTotal, v.productoOriginal, pe.sku, pe.nombrePresentacion, dv.cantidad
from DetalleVenta dv
inner join Venta v         on v.idVenta = dv.idVenta
inner join Presentacion pe on pe.idPresentacion = dv.idPresentacion
where dv.origenValor = 'Pendiente';
