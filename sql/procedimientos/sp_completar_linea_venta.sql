-- Procedimiento: sp_completar_linea_venta
-- Rutina almacenada de la base liwi_flor_eterna.
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

delimiter $$
drop procedure if exists sp_completar_linea_venta$$
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
