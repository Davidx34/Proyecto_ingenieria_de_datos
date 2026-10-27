-- Procedimiento: sp_rentabilidad_producto
-- Rutina almacenada de la base liwi_flor_eterna.
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

delimiter $$
drop procedure if exists sp_rentabilidad_producto$$
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
delimiter ;
