DELIMITER $$
CREATE PROCEDURE VerCuentas()
BEGIN
SELECT Cu.numero_cuenta AS Numero_Cuenta, CONCAT(Cl.nombre," ",Cl.apellido) AS Nombre_Cliente, Cu.saldo AS Saldo
FROM cuentas AS Cu JOIN clientes AS Cl
ON Cu.numero_cliente = Cl.numero_cliente;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE CuentasConSaldoMayorQue(IN limite DECIMAL(10,2))
BEGIN
SELECT Cu.numero_cuenta AS Numero_Cuenta, CONCAT(Cl.nombre," ",Cl.apellido) AS Nombre_Cliente, Cu.saldo AS Saldo
FROM cuentas AS Cu JOIN clientes AS Cl
ON Cu.numero_cliente = Cl.numero_cliente WHERE Cu.saldo > limite;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE TotalMovimientosDelMes(IN cuenta INT, OUT total DECIMAL(10,2))
BEGIN
SELECT SUM(M.importe) INTO total FROM movimientos AS M WHERE M.numero_cuenta = cuenta AND M.tipo = 'CREDITO'
AND MONTH(M.fecha) = MONTH(CURDATE())
AND YEAR(M.fecha) = YEAR(CURDATE());
SELECT SUM(M.importe) INTO total FROM movimientos AS M WHERE M.numero_cuenta = cuenta AND M.tipo = 'DEBITO'
AND MONTH(M.fecha) = MONTH(CURDATE())
AND YEAR(M.fecha) = YEAR(CURDATE());
END $$
DELIMITER ;
DROP PROCEDURE IF EXISTS TotalMovimientosDelMes;
SET @total_movimientos = 0.00;
-- 2. Llamar al procedimiento, pasando el número de cuenta (1005) y la variable (@total_movimientos)
CALL TotalMovimientosDelMes(1005, @total_movimientos);
-- 3. Mostrar el resultado almacenado en la variable
SELECT @total_movimientos AS SaldoNetoDelMes;

DELIMITER $$
CREATE PROCEDURE Depositar(IN cuenta INT, IN monto DECIMAL(10,2))
Begin
DECLARE saldo_anterior DECIMAL(10,2);
if monto > 0 then
	UPDATE cuentas AS C SET saldo = saldo + monto WHERE C.numero_cuenta = cuenta;
    INSERT INTO movimientos(numero_cuenta,fecha,tipo,importe) VALUES(cuenta,CURDATE(),'CREDITO',monto);
	SELECT saldo INTO saldo_anterior FROM cuentas WHERE numero_cuenta = cuenta;
	INSERT INTO historial_movimientos(numero_cuenta, numero_movimiento, saldo_anterior, saldo_actual) VALUES (cuenta, LAST_INSERT_ID(), saldo_anterior, saldo_anterior + monto);
end if;
END $$
DELIMITER ;
CALL Depositar(1002, 1500.50);
SELECT * FROM cuentas;

DELIMITER $$
CREATE PROCEDURE Extraer(IN cuenta INT, IN monto DECIMAL(10,2))
BEGIN
DECLARE saldo_anterior DECIMAL(10,2);
DECLARE saldo_nuevo DECIMAL(10,2);
SELECT saldo INTO saldo_anterior FROM cuentas WHERE cuentas.numero_cuenta = cuenta;
IF monto <= saldo_anterior THEN
	SET saldo_nuevo = saldo_anterior - monto;
    UPDATE cuentas SET saldo = saldo_nuevo WHERE cuentas.numero_cuenta = cuenta;
		-- Insertar movimiento
        INSERT INTO movimientos (numero_cuenta, fecha, tipo, importe)
        VALUES (cuenta, CURDATE(), 'DEBITO', monto);
        -- Registrar historial
        INSERT INTO historial_movimientos (numero_cuenta, numero_movimiento, saldo_anterior, saldo_actual)
        VALUES (cuenta, LAST_INSERT_ID(), saldo_anterior, saldo_nuevo);
END IF;
END $$
DELIMITER ;
CALL Extraer(1002,1500.50);
DROP PROCEDURE IF EXISTS Extraer;

DELIMITER $$
CREATE TRIGGER actualizar_saldo_nuevo_movimiento
AFTER INSERT ON movimientos
FOR EACH ROW
BEGIN
DECLARE saldo_actual DECIMAL(10,2);
-- Obtener el saldo actual de la cuenta
SELECT saldo INTO saldo_actual FROM cuentas WHERE numero_cuenta = NEW.numero_cuenta;
-- Verificar si el movimiento es un CREDITO o un DEBITO
IF NEW.tipo = 'CREDITO' THEN
	-- Si es un CREDITO, sumamos el importe al saldo
	UPDATE cuentas SET saldo = saldo_actual + NEW.importe WHERE numero_cuenta = NEW.numero_cuenta;
ELSEIF NEW.tipo = 'DEBITO' THEN
	-- Si es un DEBITO, restamos el importe al saldo
	UPDATE cuentas SET saldo = saldo_actual - NEW.importe WHERE numero_cuenta = NEW.numero_cuenta;
END IF;
END $$
DELIMITER ;
INSERT INTO movimientos (numero_cuenta, fecha, tipo, importe)
VALUES (1001, CURDATE(), 'CREDITO', 500.00);
INSERT INTO movimientos (numero_cuenta, fecha, tipo, importe)
VALUES (1001, CURDATE(), 'DEBITO', 200.00);
SELECT numero_cuenta, saldo
FROM cuentas
WHERE numero_cuenta = 1001;
DROP TRIGGER IF EXISTS actualizar_saldo_nuevo_movimiento;

DELIMITER $$
CREATE TRIGGER actualizar_saldo_nuevo_movimiento_registrar_historial
AFTER INSERT ON movimientos
FOR EACH ROW
BEGIN
DECLARE saldo_anterior DECIMAL(10,2);
DECLARE saldo_actual DECIMAL(10,2);
-- Obtener el saldo actual de la cuenta
SELECT saldo INTO saldo_anterior FROM cuentas WHERE numero_cuenta = NEW.numero_cuenta;

-- Verificar si el movimiento es un CREDITO o un DEBITO
IF NEW.tipo = 'CREDITO' THEN
	-- Si es un CREDITO, sumamos el importe al saldo
	SET saldo_actual = saldo_anterior + NEW.importe;
	UPDATE cuentas SET saldo = saldo_actual WHERE numero_cuenta = NEW.numero_cuenta;
ELSEIF NEW.tipo = 'DEBITO' THEN
	-- Si es un DEBITO, restamos el importe al saldo
	SET saldo_actual = saldo_anterior - NEW.importe;
	UPDATE cuentas SET saldo = saldo_actual WHERE numero_cuenta = NEW.numero_cuenta;
END IF;
INSERT INTO historial_movimientos(numero_cuenta, numero_movimiento, saldo_anterior, saldo_actual) VALUES (NEW.numero_cuenta, NEW.numero_movimiento, saldo_anterior, saldo_actual);
END $$
DELIMITER ;
INSERT INTO movimientos (numero_cuenta, fecha, tipo, importe)
VALUES (1001, CURDATE(), 'CREDITO', 500.00);
INSERT INTO movimientos (numero_cuenta, fecha, tipo, importe)
VALUES (1001, CURDATE(), 'DEBITO', 200.00);
SELECT * FROM historial_movimientos
WHERE numero_cuenta = 1001;