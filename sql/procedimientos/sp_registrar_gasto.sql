-- Procedimiento: sp_registrar_gasto
-- Rutina almacenada de la base liwi_flor_eterna.
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

delimiter $$
drop procedure if exists sp_registrar_gasto$$
create procedure sp_registrar_gasto(
    in p_fecha         date,
    in p_textoConcepto varchar(80),
    in p_valor         decimal(12,2),
    in p_tipoDocumento varchar(30),
    in p_metodoPago    varchar(30),
    in p_proveedor     varchar(60))
begin
    declare v_concepto int;
    declare v_tipo     int;
    declare v_metodo   int;
    declare v_prov     int default null;
    set v_concepto = fn_buscar_concepto(p_textoConcepto);
    if v_concepto is null then
        signal sqlstate '45000' set message_text = 'Concepto no reconocido: registre primero el alias';
    end if;
    select idTipoDocumento into v_tipo from TipoDocumento where nombreTipoDocumento = p_tipoDocumento;
    if v_tipo is null then
        signal sqlstate '45000' set message_text = 'El tipo de documento no existe';
    end if;
    select idMetodoPago into v_metodo from MetodoPago where nombreMetodoPago = p_metodoPago;
    if v_metodo is null then
        signal sqlstate '45000' set message_text = 'El metodo de pago no existe';
    end if;
    if p_proveedor is not null then
        select idProveedor into v_prov from Proveedor where nombreProveedor = p_proveedor;
        if v_prov is null then
            signal sqlstate '45000' set message_text = 'El proveedor no existe';
        end if;
    end if;
    insert into Gasto (fechaGasto, idConcepto, valor, idTipoDocumento, idMetodoPago, idProveedor, conceptoOriginal)
    values (p_fecha, v_concepto, p_valor, v_tipo, v_metodo, v_prov, trim(p_textoConcepto));
    select last_insert_id() as idGasto;
end$$
delimiter ;
