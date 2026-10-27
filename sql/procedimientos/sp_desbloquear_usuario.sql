-- Procedimiento: sp_desbloquear_usuario
-- Rutina almacenada de la base liwi_flor_eterna.
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

delimiter $$
drop procedure if exists sp_desbloquear_usuario$$
create procedure sp_desbloquear_usuario(in p_idSocio int, in p_idUsuario int)
begin
    declare v_rol varchar(15);
    select rol into v_rol from Usuario where idUsuario = p_idSocio and bloqueado = 0;
    if v_rol is null or v_rol <> 'Socio' then
        signal sqlstate '45000' set message_text = 'Solo un socio activo puede desbloquear una cuenta';
    end if;
    if not exists (select 1 from Usuario where idUsuario = p_idUsuario) then
        signal sqlstate '45000' set message_text = 'El usuario no existe';
    end if;
    update Usuario set bloqueado = 0, intentosFallidos = 0 where idUsuario = p_idUsuario;
    select idUsuario, bloqueado, intentosFallidos from Usuario where idUsuario = p_idUsuario;
end$$
delimiter ;
