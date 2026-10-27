-- Procedimiento: sp_cambiar_contrasena
-- Rutina almacenada de la base liwi_flor_eterna.
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

delimiter $$
drop procedure if exists sp_cambiar_contrasena$$
create procedure sp_cambiar_contrasena(in p_idUsuario int, in p_actual varchar(100), in p_nueva varchar(100))
begin
    declare v_hash varchar(64);
    select contrasena into v_hash from Usuario where idUsuario = p_idUsuario;
    if v_hash is null then
        signal sqlstate '45000' set message_text = 'El usuario no existe';
    end if;
    if sha2(p_actual, 256) <> v_hash then
        signal sqlstate '45000' set message_text = 'La contrasena actual no coincide';
    end if;
    if p_nueva = p_actual then
        signal sqlstate '45000' set message_text = 'La contrasena nueva debe ser distinta de la actual';
    end if;
    if char_length(p_nueva) < 8 then
        signal sqlstate '45000' set message_text = 'La contrasena nueva debe tener al menos 8 caracteres';
    end if;
    update Usuario set contrasena = sha2(p_nueva, 256) where idUsuario = p_idUsuario;
    select p_idUsuario as idUsuario, 'Contrasena cambiada' as resultado;
end$$
delimiter ;
