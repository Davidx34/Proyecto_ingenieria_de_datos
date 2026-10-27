-- Vista: vw_compras_vs_ventas_producto
-- Vista de consulta de la base liwi_flor_eterna.
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

drop view if exists vw_compras_vs_ventas_producto;
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
