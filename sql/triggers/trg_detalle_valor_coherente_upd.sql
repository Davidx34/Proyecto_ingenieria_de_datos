-- Trigger: trg_detalle_valor_coherente_upd
-- Trigger de la base liwi_flor_eterna (se crean al final de la carga para no dispararse durante ella).
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

delimiter $$
drop trigger if exists trg_detalle_valor_coherente_upd$$
create trigger trg_detalle_valor_coherente_upd
before update on DetalleVenta
for each row
begin
    declare v_total decimal(12,2);
    if new.valorLinea is not null then
        select valorTotal into v_total from Venta where idVenta = new.idVenta;
        if new.valorLinea > v_total then
            signal sqlstate '45000' set message_text = 'El valor de la linea supera el total de la venta';
        end if;
    end if;
end$$
delimiter ;
