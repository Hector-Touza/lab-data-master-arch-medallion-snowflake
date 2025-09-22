// limpiar datos para GOLD
CREATE OR REPLACE TABLE GOLD_VENTAS_POR_CLIENTE AS
SELECT
  ClienteID,
  COUNT(*) AS TotalPedidos,
  SUM(Cantidad) AS TotalUnidades
FROM SILVER_PEDIDOS_LIMPIOS
GROUP BY ClienteID;

// sanity check de gold
SELECT * FROM GOLD_VENTAS_POR_CLIENTE ORDER BY TotalUnidades DESC;
