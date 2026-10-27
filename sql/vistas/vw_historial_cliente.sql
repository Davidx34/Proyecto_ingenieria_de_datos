-- Vista: vw_historial_cliente
-- Vista de consulta de la base liwi_flor_eterna.
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

drop view if exists vw_historial_cliente;
create view vw_historial_cliente as
select c.idCliente, c.nombreCliente, c.tipoCliente, count(v.idVenta) as ventas,
       coalesce(sum(v.valorTotal), 0) as total_comprado, min(v.fechaVenta) as primera_compra,
       max(v.fechaVenta) as ultima_compra
from Cliente c left join Venta v on v.idCliente = c.idCliente
group by c.idCliente, c.nombreCliente, c.tipoCliente;
