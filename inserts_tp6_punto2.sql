USE banco;
#insets - tabla clientes
INSERT INTO clientes (numero_cliente, dni, apellido, nombre)
VALUES
(1, 12345678, 'García', 'Ana'),
(2, 23456789, 'Pérez', 'Juan'),
(3, 34567890, 'López', 'María'),
(4, 45678901, 'Martínez', 'Carlos'),
(5, 56789012, 'Rodríguez', 'Lucía'),
(6, 67890123, 'Sánchez', 'Diego');
#inserts - tabla cuentas
INSERT INTO cuentas (numero_cuenta, numero_cliente, saldo)
VALUES
(1001, 1, 14500.00),
(1002, 2, 8500.00),
(1003, 3, 23000.50),
(1004, 4, 5000.00),
(1005, 5, 12000.00),
(1006, 6, 7600.00);
#inserts - tabla movimientos
INSERT INTO movimientos (numero_movimiento, numero_cuenta, fecha, tipo, importe)
VALUES
(5001, 1001, '2025-11-01', 'CREDITO', 2000.00),
(5002, 1001, '2025-11-03', 'DEBITO', 500.00),
(5003, 1002, '2025-11-02', 'CREDITO', 1000.00),
(5004, 1003, '2025-11-04', 'DEBITO', 200.00),
(5005, 1004, '2025-11-05', 'CREDITO', 2500.00),
(5006, 1004, '2025-11-06', 'DEBITO', 300.00),
(5007, 1005, '2025-11-03', 'CREDITO', 500.00),
(5008, 1005, '2025-11-06', 'CREDITO', 700.00),
(5009, 1006, '2025-11-01', 'DEBITO', 400.00),
(5010, 1006, '2025-11-05', 'CREDITO', 1200.00);
#inserts - tabla historial_movimientos
INSERT INTO historial_movimientos (id, numero_cuenta, numero_movimiento, saldo_anterior, saldo_actual)
VALUES
-- Ana García
(1, 1001, 5001, 13000.00, 15000.00),
(2, 1001, 5002, 15000.00, 14500.00),
-- Juan Pérez
(3, 1002, 5003, 7500.00, 8500.00),
-- María López
(4, 1003, 5004, 23200.50, 23000.50),
-- Carlos Martínez
(5, 1004, 5005, 2500.00, 5000.00),
(6, 1004, 5006, 5000.00, 4700.00),
-- Lucía Rodríguez
(7, 1005, 5007, 11500.00, 12000.00),
(8, 1005, 5008, 12000.00, 12700.00),
-- Diego Sánchez
(9, 1006, 5009, 8000.00, 7600.00),
(10, 1006, 5010, 7600.00, 8800.00);