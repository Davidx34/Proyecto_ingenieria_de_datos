-- Función: fn_buscar_presentacion
-- Rutina almacenada de la base liwi_flor_eterna.
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

delimiter $$
drop function if exists fn_buscar_presentacion$$
create function fn_buscar_presentacion(p_texto varchar(120))
returns int
reads sql data
begin
    declare v_id int;
    select idPresentacion into v_id from AliasProducto where textoAlias = trim(p_texto) limit 1;
    return v_id;
end$$
delimiter ;
