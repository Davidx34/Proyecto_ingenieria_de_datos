-- Vista: vw_gastos_por_categoria
-- Vista de consulta de la base liwi_flor_eterna.
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

drop view if exists vw_gastos_por_categoria;
create view vw_gastos_por_categoria as
select cg.nombreCategoriaGasto, count(*) as gastos, sum(ga.valor) as total,
       round(sum(ga.valor) * 100 / (select sum(valor) from Gasto), 1) as porcentaje
from Gasto ga
inner join ConceptoGasto  co on co.idConcepto = ga.idConcepto
inner join CategoriaGasto cg on cg.idCategoriaGasto = co.idCategoriaGasto
group by cg.nombreCategoriaGasto;
