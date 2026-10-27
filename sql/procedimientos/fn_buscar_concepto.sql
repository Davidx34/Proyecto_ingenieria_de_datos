-- Función: fn_buscar_concepto
-- Rutina almacenada de la base liwi_flor_eterna.
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

delimiter $$
drop function if exists fn_buscar_concepto$$
create function fn_buscar_concepto(p_texto varchar(80))
returns int
reads sql data
begin
    declare v_id int;
    select idConcepto into v_id from AliasConcepto where textoAlias = trim(p_texto) limit 1;
    return v_id;
end$$
delimiter ;
