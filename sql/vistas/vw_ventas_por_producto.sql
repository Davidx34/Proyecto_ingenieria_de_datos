-- Vista: vw_ventas_por_producto
-- Vista de consulta de la base liwi_flor_eterna.
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

drop view if exists vw_ventas_por_producto;
create view vw_ventas_por_producto as
select pr.nombreProducto, sum(dv.cantidad) as unidades, count(distinct dv.idVenta) as ventas,
       coalesce(sum(dv.valorLinea), 0) as valor_exacto, sum(dv.origenValor = 'Pendiente') as lineas_sin_valor
from DetalleVenta dv
inner join Presentacion pe on pe.idPresentacion = dv.idPresentacion
inner join Producto     pr on pr.idProducto = pe.idProducto
group by pr.nombreProducto;
