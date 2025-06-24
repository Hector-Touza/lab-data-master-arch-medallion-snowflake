![logo\_ironhack\_blue 7](https://user-images.githubusercontent.com/23629340/40541063-a07a0a8a-601a-11e8-91b5-2f13e4e6b441.png)

# Lab | Arquitectura Medallion en Snowflake – Día 1 (Parte 2)

## Introducción

Has completado la construcción inicial de un modelo relacional con datos de clientes, productos y pedidos. Ahora, como arquitecto de datos, se te ha encargado implementar una arquitectura moderna que garantice escalabilidad, trazabilidad y calidad: la arquitectura **Medallion**.

En este laboratorio aprenderás a simular el flujo de datos desde una capa Bronze (datos crudos) hacia Silver (datos limpios) y luego hacia Gold (datos listos para análisis de negocio). Se utilizará Snowflake como plataforma principal.

## Requisitos

* Haz un ***fork*** de este repositorio.
* Clona este repositorio.

## Entrega

- Haz Commit y Push
- Crea un Pull Request (PR)
- Copia el enlace a tu PR (con tu solución) y pégalo en el campo de entrega del portal del estudiante – solo así se considerará entregado el lab

## Desafío 1 – Simular el flujo Bronze ➝ Silver ➝ Gold

### Objetivo general

Construir un pipeline de datos en Snowflake que siga la estructura de capas Medallion:

1. **Bronze**: datos sin transformar, crudos.
2. **Silver**: limpieza y tipado correcto.
3. **Gold**: agregaciones y vistas analíticas.

### Esquema propuesto:

* `bronze.pedidos_raw`
* `silver.pedidos_limpios`
* `gold.ventas_por_cliente`

> ✅ Entregable: captura del esquema final en la interfaz de Snowflake.

## Desafío 2 – Capa Bronze: tabla cruda

### 1. Crear esquema y tabla `bronze`

```sql
CREATE SCHEMA IF NOT EXISTS ecommerce_lab.bronze;

CREATE OR REPLACE TABLE ecommerce_lab.bronze.pedidos_raw (
  ID STRING,
  FECHA_PEDIDO STRING,
  CLIENTE_ID STRING,
  PRODUCTO_ID STRING,
  CANTIDAD STRING
);
```

### 2. Insertar datos sucios (errores, tipos incorrectos, nulos) *** PREPARARA DATASET

```sql
INSERT INTO ecommerce_lab.bronze.pedidos_raw VALUES
('1', '2024-06-01', '1', '100', '2'),
('2', '2024-06-02', NULL, '101', '1'),
('3', 'INVALID_DATE', '3', '102', 'X'),
('4', '2024-06-03', '2', 'ERROR', '3'),
('5', '2024-06-04', '3', '102', '1');
```

> ❗Observa: hay valores no numéricos, fechas inválidas y campos nulos.

## Desafío 3 – Capa Silver: datos limpios y validados

### 1. Crear esquema `silver` y tabla `pedidos_limpios`

```sql
CREATE SCHEMA IF NOT EXISTS ecommerce_lab.silver;

CREATE OR REPLACE TABLE ecommerce_lab.silver.pedidos_limpios AS
SELECT
  TO_NUMBER(ID) AS PedidoID,
  TRY_TO_DATE(FECHA_PEDIDO, 'YYYY-MM-DD') AS FechaPedido,
  TO_NUMBER(CLIENTE_ID) AS ClienteID,
  TO_NUMBER(PRODUCTO_ID) AS ProductoID,
  TO_NUMBER(CANTIDAD) AS Cantidad
FROM ecommerce_lab.bronze.pedidos_raw
WHERE
  IS_NUMBER(ID)
  AND TRY_TO_DATE(FECHA_PEDIDO, 'YYYY-MM-DD') IS NOT NULL
  AND IS_NUMBER(CLIENTE_ID)
  AND IS_NUMBER(PRODUCTO_ID)
  AND IS_NUMBER(CANTIDAD);
```

### 2. Validar registros limpios

```sql
SELECT * FROM ecommerce_lab.silver.pedidos_limpios;
```

> ✅ Resultado: tabla con sólo las filas válidas del raw.

## Desafío 4 – Capa Gold: agregación por cliente

### 1. Crear esquema `gold` y tabla `ventas_por_cliente`

```sql
CREATE SCHEMA IF NOT EXISTS ecommerce_lab.gold;

CREATE OR REPLACE TABLE ecommerce_lab.gold.ventas_por_cliente AS
SELECT
  ClienteID,
  COUNT(*) AS TotalPedidos,
  SUM(Cantidad) AS TotalUnidades
FROM ecommerce_lab.silver.pedidos_limpios
GROUP BY ClienteID;
```

### 2. Consultar resultados

```sql
SELECT * FROM ecommerce_lab.gold.ventas_por_cliente ORDER BY TotalUnidades DESC;
```

> ✅ Resultado: resumen listo para dashboard de Power BI, Tableau o Looker.

## Desafío 5 – Documentación y Gobernanza

### Documentar los pasos:

* ¿Qué datos se descartaron en Bronze?
* ¿Qué validaciones se aplicaron en Silver?
* ¿Qué lógica de negocio se usó en Gold?

### Bonus:

* Crear vistas sobre Gold para segmentar por región, producto o semana.
* Agregar metadatos con comentarios:

```sql
COMMENT ON TABLE ecommerce_lab.gold.ventas_por_cliente IS 'Tabla resumen de ventas agregadas por cliente (Gold Layer)';
```

<!-- ## Entregables

* `bronze.sql`, `silver.sql`, `gold.sql`: scripts por capa.
* Capturas de pantalla de cada tabla creada.
* Explicación del flujo aplicado en un archivo README.

## Entrega

1. Crea una carpeta llamada `lab-snowflake-medallion`.
2. Añade los archivos `.sql` y `README.md` explicativo.
3. Sube al repositorio personal de GitHub.
4. Crea una PR con título `[lab-snowflake-medallion] Tu Nombre`. -->

## Entregables

Dentro de tu repositorio forkeado, asegúrate de añadir los siguientes archivos:

* `bronze.sql` – Esquema y datos de la capa cruda (Bronze)
* `silver.sql` – Transformación con datos limpios y validados (Silver)
* `gold.sql` – Agregaciones para análisis de negocio (Gold)
* `lab-notes.md` – Documento con la explicación del flujo de transformación Bronze ➝ Silver ➝ Gold
* *(Opcional)* Carpeta `screenshots/` con capturas de pantalla de Snowflake

## Conclusión

Has implementado por primera vez una arquitectura de datos moderna basada en el patrón Medallion. A través de Snowflake, estructuraste los datos en capas, validaste errores, transformaste tipos y generaste una vista agregada lista para análisis.

Este patrón te servirá en proyectos futuros donde se requiere gobernanza, calidad y trazabilidad desde la ingestión hasta el consumo.

¡Gran trabajo!