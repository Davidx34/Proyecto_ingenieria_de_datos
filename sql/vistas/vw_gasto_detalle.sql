-- Vista: vw_gasto_detalle
-- Vista de consulta de la base liwi_flor_eterna.
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

drop view if exists vw_gasto_detalle;
create view vw_gasto_detalle as
select ga.idGasto, ga.fechaGasto, co.nombreConcepto, cg.nombreCategoriaGasto, ga.valor,
       td.nombreTipoDocumento, mp.nombreMetodoPago, pv.nombreProveedor, pr.nombreProducto as productoRelacionado,
       (select group_concat(e.nombreEtiqueta order by e.nombreEtiqueta separator ', ')
          from GastoEtiqueta ge inner join Etiqueta e on e.idEtiqueta = ge.idEtiqueta
         where ge.idGasto = ga.idGasto) as etiquetas
from Gasto ga
inner join ConceptoGasto  co on co.idConcepto = ga.idConcepto
inner join CategoriaGasto cg on cg.idCategoriaGasto = co.idCategoriaGasto
inner join TipoDocumento  td on td.idTipoDocumento = ga.idTipoDocumento
inner join MetodoPago     mp on mp.idMetodoPago = ga.idMetodoPago
left  join Proveedor      pv on pv.idProveedor = ga.idProveedor
left  join Producto       pr on pr.idProducto = co.idProducto;
