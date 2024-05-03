show tables;

-- EJERCICIO 1.a
select * from producto where precio > 15000;

-- EJERCICIO 1.b (2 opciones)
select distinct itemfactura.cod_producto, producto.descripcion from itemfactura, producto where itemfactura.cantidad > 2 
&& itemfactura.cod_producto = producto.cod_producto order by producto.descripcion;
select itemfactura.cod_producto, descripcion from itemfactura join producto 
on itemfactura.cod_producto = producto.cod_producto
where itemfactura.cantidad > 2 order by producto.descripcion;

-- EJERCICIO 1.c
select * from cliente where nro_cliente not in (select nro_cliente from factura) 
order by apellido desc,nombre desc;

-- EJERCICIO 1.d
select * from producto where cod_producto not in (select cod_producto from itemfactura);

-- EJERCICIO 1.e
select * from cliente left join factura on cliente.nro_cliente = factura.nro_cliente;