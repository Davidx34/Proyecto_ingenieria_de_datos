-- Procedimiento: sp_registrar_venta
-- Rutina almacenada de la base liwi_flor_eterna.
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

delimiter $$
drop procedure if exists sp_registrar_venta$$
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
delimiter ;
