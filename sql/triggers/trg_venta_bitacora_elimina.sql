-- Trigger: trg_venta_bitacora_elimina
-- Trigger de la base liwi_flor_eterna (se crean al final de la carga para no dispararse durante ella).
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

delimiter $$
drop trigger if exists trg_venta_bitacora_elimina$$
create trigger trg_venta_bitacora_elimina
after delete on Venta
for each row
begin
    insert into BitacoraCambio (fechaCambio, usuarioBD, tablaAfectada, idRegistro, accion, valorAnterior, valorNuevo)
    values (now(), user(), 'Venta', old.idVenta, 'ELIMINA',
            concat('fecha=', old.fechaVenta, '; cliente=', old.idCliente, '; total=', old.valorTotal, '; pago=', old.idMetodoPago), null);
end$$
delimiter ;
