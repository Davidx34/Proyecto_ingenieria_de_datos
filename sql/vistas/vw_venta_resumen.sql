-- Vista: vw_venta_resumen
-- Vista de consulta de la base liwi_flor_eterna.
-- Se ejecuta después de 01_DDL.sql y 02_DML.sql.

use liwi_flor_eterna;

drop view if exists vw_venta_resumen;
create view vw_venta_resumen as
select v.idVenta, v.fechaVenta, c.nombreCliente, c.tipoCliente,
       if(c.tipoCliente = 'Cliente final', 'B2C', 'B2B') as canal,
       ci.nombreCiudad, mp.nombreMetodoPago, v.facturada,
       if(v.idPuntoVenta is null, 'Fuera del local', pv.nombrePuntoVenta) as lugar,
       v.valorTotal,
       (select count(*) from DetalleVenta d where d.idVenta = v.idVenta) as lineas
from Venta v
inner join Cliente    c  on c.idCliente = v.idCliente
inner join Ciudad     ci on ci.idCiudad = v.idCiudad
inner join MetodoPago mp on mp.idMetodoPago = v.idMetodoPago
left  join PuntoVenta pv on pv.idPuntoVenta = v.idPuntoVenta;
