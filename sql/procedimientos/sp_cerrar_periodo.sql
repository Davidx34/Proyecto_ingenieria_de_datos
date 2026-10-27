-- Procedimiento: sp_cerrar_periodo
-- Rutina almacenada de la base liwi_flor_eterna.
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

delimiter $$
drop procedure if exists sp_cerrar_periodo$$
create procedure sp_cerrar_periodo(in p_inicio date, in p_fin date, in p_idUsuario int)
begin
    declare v_rol  varchar(15);
    declare v_ing  decimal(14,2);
    declare v_op   decimal(14,2);
    declare v_inv  decimal(14,2);
    declare v_ini  decimal(14,2);

    select rol into v_rol from Usuario where idUsuario = p_idUsuario and bloqueado = 0;
    if v_rol is null or v_rol <> 'Socio' then
        signal sqlstate '45000' set message_text = 'Solo un socio activo puede cerrar un periodo';
    end if;
    if p_fin < p_inicio then
        signal sqlstate '45000' set message_text = 'La fecha final es anterior a la inicial';
    end if;
    if exists (select 1 from CierreFinanciero where fechaInicio <= p_fin and fechaFin >= p_inicio) then
        signal sqlstate '45000' set message_text = 'El periodo se cruza con un cierre ya hecho';
    end if;

    select coalesce(sum(valorTotal), 0) into v_ing from Venta where fechaVenta between p_inicio and p_fin;
    select coalesce(sum(case when cg.nombreCategoriaGasto = 'Operación'         then ga.valor end), 0),
           coalesce(sum(case when cg.nombreCategoriaGasto = 'Inventario'        then ga.valor end), 0),
           coalesce(sum(case when cg.nombreCategoriaGasto = 'Inversión inicial' then ga.valor end), 0)
      into v_op, v_inv, v_ini
      from Gasto ga
      inner join ConceptoGasto  co on co.idConcepto = ga.idConcepto
      inner join CategoriaGasto cg on cg.idCategoriaGasto = co.idCategoriaGasto
     where ga.fechaGasto between p_inicio and p_fin;

    insert into CierreFinanciero (fechaInicio, fechaFin, totalIngresos, totalOperacion, totalInventario,
                                  totalInversion, fechaCierre, idUsuario)
    values (p_inicio, p_fin, v_ing, v_op, v_inv, v_ini, now(), p_idUsuario);

    select idCierre, fechaInicio, fechaFin, totalIngresos,
           totalOperacion + totalInventario + totalInversion as totalEgresos,
           totalIngresos - (totalOperacion + totalInventario + totalInversion) as saldo
      from CierreFinanciero where idCierre = last_insert_id();
end$$
delimiter ;
