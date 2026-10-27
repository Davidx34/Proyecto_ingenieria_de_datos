-- Procedimiento: sp_registrar_alias
-- Rutina almacenada de la base liwi_flor_eterna.
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

delimiter $$
drop procedure if exists sp_registrar_alias$$
create procedure sp_registrar_alias(in p_texto varchar(120), in p_sku varchar(10))
begin
    declare v_pres int;
    declare v_otra int;
    if p_texto is null or trim(p_texto) = '' then
        signal sqlstate '45000' set message_text = 'El texto del alias no puede estar vacio';
    end if;
    select idPresentacion into v_pres from Presentacion where sku = p_sku;
    if v_pres is null then
        signal sqlstate '45000' set message_text = 'El SKU no existe';
    end if;
    set v_otra = fn_buscar_presentacion(p_texto);
    if v_otra is not null and v_otra <> v_pres then
        signal sqlstate '45000' set message_text = 'Ese texto ya esta asociado a otra presentacion';
    end if;
    if v_otra is null then
        insert into AliasProducto (idPresentacion, textoAlias, origen)
        values (v_pres, trim(p_texto), 'Registrado despues de la carga');
    end if;
    select idAlias, textoAlias, idPresentacion from AliasProducto where textoAlias = trim(p_texto);
end$$
delimiter ;
