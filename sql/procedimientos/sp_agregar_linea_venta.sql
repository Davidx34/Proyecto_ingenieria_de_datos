-- Procedimiento: sp_agregar_linea_venta
-- Rutina almacenada de la base liwi_flor_eterna.
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

delimiter $$
drop procedure if exists sp_agregar_linea_venta$$
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
delimiter ;
