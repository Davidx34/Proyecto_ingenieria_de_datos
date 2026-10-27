-- Trigger: trg_gasto_bitacora_elimina
-- Trigger de la base liwi_flor_eterna (se crean al final de la carga para no dispararse durante ella).
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

delimiter $$
drop trigger if exists trg_gasto_bitacora_elimina$$
create trigger trg_gasto_bitacora_elimina
after delete on Gasto
for each row
begin
    insert into BitacoraCambio (fechaCambio, usuarioBD, tablaAfectada, idRegistro, accion, valorAnterior, valorNuevo)
    values (now(), user(), 'Gasto', old.idGasto, 'ELIMINA',
            concat('fecha=', old.fechaGasto, '; concepto=', old.idConcepto, '; valor=', old.valor), null);
end$$
delimiter ;
