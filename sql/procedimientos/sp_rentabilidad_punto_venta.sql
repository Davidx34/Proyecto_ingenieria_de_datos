-- Procedimiento: sp_rentabilidad_punto_venta
-- Rutina almacenada de la base liwi_flor_eterna.
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

delimiter $$
drop procedure if exists sp_rentabilidad_punto_venta$$
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
delimiter ;
