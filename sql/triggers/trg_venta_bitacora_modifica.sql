-- Trigger: trg_venta_bitacora_modifica
-- Trigger de la base liwi_flor_eterna (se crean al final de la carga para no dispararse durante ella).
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

delimiter $$
drop trigger if exists trg_venta_bitacora_modifica$$
create trigger trg_venta_bitacora_modifica
after update on Venta
for each row
begin
    insert into BitacoraCambio (fechaCambio, usuarioBD, tablaAfectada, idRegistro, accion, valorAnterior, valorNuevo)
    values (now(), user(), 'Venta', old.idVenta, 'MODIFICA',
            concat('fecha=', old.fechaVenta, '; cliente=', old.idCliente, '; total=', old.valorTotal, '; pago=', old.idMetodoPago),
            concat('fecha=', new.fechaVenta, '; cliente=', new.idCliente, '; total=', new.valorTotal, '; pago=', new.idMetodoPago));
end$$
delimiter ;
