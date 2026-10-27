-- Trigger: trg_usuario_bloqueo_automatico
-- Trigger de la base liwi_flor_eterna (se crean al final de la carga para no dispararse durante ella).
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

delimiter $$
drop trigger if exists trg_usuario_bloqueo_automatico$$
create trigger trg_usuario_bloqueo_automatico
before update on Usuario
for each row
begin
    if new.intentosFallidos >= 3 then
        set new.bloqueado = 1;
    end if;
end$$
delimiter ;
