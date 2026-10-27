-- Vista: vw_gastos_por_concepto
-- Vista de consulta de la base liwi_flor_eterna.
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

drop view if exists vw_gastos_por_concepto;
create view vw_gastos_por_concepto as
select co.nombreConcepto, cg.nombreCategoriaGasto, count(*) as gastos, sum(ga.valor) as total,
       round(avg(ga.valor), 0) as promedio
from Gasto ga
inner join ConceptoGasto  co on co.idConcepto = ga.idConcepto
inner join CategoriaGasto cg on cg.idCategoriaGasto = co.idCategoriaGasto
group by co.nombreConcepto, cg.nombreCategoriaGasto;
