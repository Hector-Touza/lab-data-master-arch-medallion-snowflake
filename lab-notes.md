# Documentar los pasos: #
### ¿Qué datos se descartaron en Bronze? ###
Nada, se vuelcan tal cual los datos.
### ¿Qué validaciones se aplicaron en Silver? ###
Se hacen más descriptivos los nombres de los atributos
Se asegura que ID sea un integer
Se asegura que fecha_pedido sea una fecha
Se asegura que cliente_id sea un integer
Se asegura que producto_id sea un integer
Se asegura que cantidad sea un integer
### ¿Qué lógica de negocio se usó en Gold? ###
Se muestra, agrupado por clientes, cuantos pedidos tiene cada cliente y el total de unidades pedidas

