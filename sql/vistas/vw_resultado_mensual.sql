-- Vista: vw_resultado_mensual
-- Vista de consulta de la base liwi_flor_eterna.
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

drop view if exists vw_resultado_mensual;
create view vw_resultado_mensual as
select m.mes, coalesce(v.ingresos, 0) as ingresos,
       coalesce(g.operacion, 0) as gastos_operacion, coalesce(g.inventario, 0) as compras_inventario,
       coalesce(g.inversion_inicial, 0) as inversion_inicial,
       coalesce(v.ingresos, 0) - coalesce(g.total, 0) as saldo
from (select date_format(fechaVenta, '%Y-%m') as mes from Venta
      union select date_format(fechaGasto, '%Y-%m') from Gasto) m
left join (select date_format(fechaVenta, '%Y-%m') as mes, sum(valorTotal) as ingresos from Venta group by 1) v on v.mes = m.mes
left join (select date_format(ga.fechaGasto, '%Y-%m') as mes, sum(ga.valor) as total,
                  sum(case when cg.nombreCategoriaGasto = 'Operación'         then ga.valor else 0 end) as operacion,
                  sum(case when cg.nombreCategoriaGasto = 'Inventario'        then ga.valor else 0 end) as inventario,
                  sum(case when cg.nombreCategoriaGasto = 'Inversión inicial' then ga.valor else 0 end) as inversion_inicial
           from Gasto ga
           inner join ConceptoGasto  co on co.idConcepto = ga.idConcepto
           inner join CategoriaGasto cg on cg.idCategoriaGasto = co.idCategoriaGasto
           group by 1) g on g.mes = m.mes;
