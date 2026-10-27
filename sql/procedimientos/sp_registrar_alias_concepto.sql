-- Procedimiento: sp_registrar_alias_concepto
-- Rutina almacenada de la base liwi_flor_eterna.
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

delimiter $$
drop procedure if exists sp_registrar_alias_concepto$$
create procedure sp_registrar_alias_concepto(in p_texto varchar(80), in p_concepto varchar(50))
begin
    declare v_concepto int;
    declare v_otro     int;
    if p_texto is null or trim(p_texto) = '' then
        signal sqlstate '45000' set message_text = 'El texto del alias no puede estar vacio';
    end if;
    select idConcepto into v_concepto from ConceptoGasto where nombreConcepto = p_concepto;
    if v_concepto is null then
        signal sqlstate '45000' set message_text = 'El concepto no existe';
    end if;
    set v_otro = fn_buscar_concepto(p_texto);
    if v_otro is not null and v_otro <> v_concepto then
        signal sqlstate '45000' set message_text = 'Ese texto ya esta asociado a otro concepto';
    end if;
    if v_otro is null then
        insert into AliasConcepto (idConcepto, textoAlias) values (v_concepto, trim(p_texto));
    end if;
    select idAliasConcepto, textoAlias, idConcepto from AliasConcepto where textoAlias = trim(p_texto);
end$$
delimiter ;
