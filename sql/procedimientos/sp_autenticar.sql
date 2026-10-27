-- Procedimiento: sp_autenticar
-- Rutina almacenada de la base liwi_flor_eterna.
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

delimiter $$
drop procedure if exists sp_autenticar$$
create procedure sp_autenticar(in p_correo varchar(60), in p_contrasena varchar(100))
begin
    declare v_id    int;
    declare v_hash  varchar(64);
    declare v_bloq  boolean;
    declare v_rol   varchar(15);
    select idUsuario, contrasena, bloqueado, rol into v_id, v_hash, v_bloq, v_rol
      from Usuario where correo = p_correo;
    if v_id is null then
        signal sqlstate '45000' set message_text = 'Usuario o contrasena incorrectos';
    end if;
    if v_bloq = 1 then
        signal sqlstate '45000' set message_text = 'La cuenta esta bloqueada';
    end if;
    if sha2(p_contrasena, 256) <> v_hash then
        update Usuario set intentosFallidos = intentosFallidos + 1 where idUsuario = v_id;
        signal sqlstate '45000' set message_text = 'Usuario o contrasena incorrectos';
    end if;
    update Usuario set intentosFallidos = 0, ultimoAcceso = now() where idUsuario = v_id;
    select v_id as idUsuario, v_rol as rol;
end$$
delimiter ;
