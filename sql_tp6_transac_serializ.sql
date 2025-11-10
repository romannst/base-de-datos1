#Transacción: secuencia de instrucciones (sentencias SQL) relacionadas, quedeben ser tratadas como una unidad indivisible.
# Ejemplos: transferencia de dinero de una cuenta a otra, venta de un pasaje
#Para asegurar la integridad de los datos se necesita que el sistema de base de datos mantenga las propiedades ACID
#de las transacciones: atomicidad, consistencia, aislamiento (isolation), durabilidad.
# Atomicidad: la transacción se trata como una unidad atómica, se ejecutan todas las operaciones que contiene o no se ejecuta ninguna.
# Consistencia: la ejecución aislada de la transacción (es decir, sin otra transacción que se ejecute concurrentemente)
  #conserva la consistencia de la base de datos.
# Aislamiento (isolation): Aunque se ejecuten varias transacciones concurrentemente, el sistema garantiza que para cada
  #par de transacciones Ti y Tj, se cumple que para los efectos de Ti, o bien Tj ha terminado su ejecución antes de que 
  #comience Ti, o bien que Tj ha comenzado su ejecución después de que Ti termine. De este modo, cada transacción ignora
  #al resto de las transacciones que se ejecuten concurrentemente en el sistema.
  #  T no muestra los cambios hasta que finaliza
  #  Ti nunca debe ver las fases intermedias de otra Tj
# Durabilidad: Tras la finalización con éxito de una transacción, los cambios realizados en la base de datos
  #permanecen, incluso si hay fallos en el sistema.

USE banco;
DELIMITER $$
CREATE PROCEDURE Transferir(IN cuenta_origen INT, IN cuenta_destino INT, IN monto DECIMAL(10,2))
BEGIN
DECLARE saldo_anterior_c_orig DECIMAL(10,2);
DECLARE saldo_nuevo_c_orig DECIMAL(10,2);
DECLARE saldo_anterior_c_dest DECIMAL(10,2);
DECLARE saldo_nuevo_c_dest DECIMAL(10,2);
DECLARE movimiento_c_orig INT;
DECLARE movimiento_c_dest INT;
#inicio la transacción
START TRANSACTION;
	SELECT saldo INTO saldo_anterior_c_orig FROM cuentas WHERE numero_cuenta = cuenta_origen FOR UPDATE;
    SELECT saldo INTO saldo_anterior_c_dest FROM cuentas WHERE numero_cuenta = cuenta_destino FOR UPDATE;
    #si el saldo disponible de la cuenta de origen tiene suficientes fondos entonces:
    if saldo_anterior_c_orig >= monto then
		#actualizo los saldos de la cuenta origen y destino en base al monto a transferir
		SET saldo_nuevo_c_orig = saldo_anterior_c_orig - monto;
        SET saldo_nuevo_c_dest = saldo_anterior_c_dest + monto;
        UPDATE cuentas SET saldo = saldo_nuevo_c_orig WHERE numero_cuenta = cuenta_origen;
        UPDATE cuentas SET saldo = saldo_nuevo_c_dest WHERE numero_cuenta = cuenta_destino;
        
        #agrego los movimientos (deposito y extracción) de la cuenta de origen y destino
        INSERT INTO movimientos (numero_cuenta,fecha,tipo,importe) VALUES (cuenta_origen,CURDATE(),"DEBITO",monto);
        SET movimiento_c_orig = LAST_INSERT_ID();
        INSERT INTO movimientos (numero_cuenta,fecha,tipo,importe) VALUES (cuenta_destino,CURDATE(),"CREDITO",monto);
        SET movimiento_c_dest = LAST_INSERT_ID();
        #agrego los movimientos en el historial de movimientos de la cuenta de origen y destino
        INSERT INTO historial_movimientos (numero_cuenta, numero_movimiento, saldo_anterior, saldo_actual)
        VALUES (cuenta_origen, movimiento_c_orig, saldo_anterior_c_orig, saldo_nuevo_c_orig);
        INSERT INTO historial_movimientos (numero_cuenta, numero_movimiento, saldo_anterior, saldo_actual)
        VALUES (cuenta_destino, movimiento_c_dest, saldo_anterior_c_dest, saldo_nuevo_c_dest);
		#termino la transacción
		COMMIT;
		else
			ROLLBACK;
		end if;
END $$
DELIMITER ;
DROP PROCEDURE IF EXISTS Transferir;

SELECT numero_cuenta, saldo FROM cuentas;
SELECT numero_cuenta, saldo FROM cuentas WHERE numero_cuenta IN (1002, 1006);
CALL Transferir(1002,1006,450.00);
SELECT numero_movimiento,fecha,tipo,importe FROM movimientos WHERE numero_cuenta = 1002;
SELECT H.numero_cuenta,M.fecha,H.saldo_anterior,H.saldo_actual FROM historial_movimientos AS H
JOIN movimientos AS M ON H.numero_movimiento = M.numero_movimiento
WHERE  m.numero_cuenta IN (1002, 1006) AND DAY(M.fecha) = 9;
UPDATE cuentas SET saldo = saldo - 900 WHERE numero_cuenta = 1006;

/*
Planificaciones con transacciones T1 y T2

T1 y T2 ; A = 1000, B = 500 y C = 0
Planificaciones en serie de T1 y T2
a)b) Orden T1 -> T2
T1
A = 1000
A = 1000 * 2
A = 2000
T2
C = 100
B = 500
B = 500 - 100
B = 400
A = 2000
A = 2000 + 400
A = 2400
--> Resulta A = 2400, B = 400, C = 100
a)b) Orden T2 -> T1
T2
C = 100
B = 500
B = 500 - 100
B = 400
A = 1000
A = 1000 + 400
A = 1400
T1
A = 1400
A = 1400 * 2
A = 2800
--> Resulta A = 2800, B = 400, C = 100

Planificaciones concurrentes de T1 y T2
a)
T1
A = 1000
T2
C = 100
B = 500
B = 500 - 100
B = 400
A = 1000
A = 1000 + 400
A = 1400
T1
A = 1000 * 2
A = 2000
--> T1 resulta con A = 2000, B = 500, C = 0
--> T2 resulta con A = 1400, B = 400, C = 100
b)
T1
A = 1000
T2
C = 100
B = 500
B = 500 - 100
B = 400
T1
A = 1000 * 2
A = 2000
T2
A = 2000
A = 2000 + 400
A = 2400
--> T1 resulta con A = 2000, B = 500, C = 0
--> T2 resulta con A = 2400, B = 400, C = 100
La planificación b) es serializable porque su resultado de A, B y C coincide con la ejecucion en serie T1 -> T2 con valores A = 2400, B = 400 y C = 100

Planificaciones con transacciones T1 y T2

T1 y T2 ; A = 1000, B = 500 y C = 0
Planificaciones en serie de T1 y T2
a)b) Orden T1 -> T2
T1
A = 1000
A = 1000 * 2
A = 2000
T2
C = 100
B = 500
B = 500 - 100
B = 400
A = 2000
A = 2000 + 400
A = 2400
--> Resulta A = 2400, B = 400, C = 100
a)b) Orden T2 -> T1
T2
C = 100
B = 500
B = 500 - 100
B = 400
A = 1000
A = 1000 + 400
A = 1400
T1
A = 1400
A = 1400 * 2
A = 2800
--> Resulta A = 2800, B = 400, C = 100

Planificaciones concurrentes de T1 y T2
a)
T1
A = 1000
T2
C = 100
B = 500
B = 500 - 100
B = 400
A = 1000
A = 1000 + 400
A = 1400
T1
A = 1000 * 2
A = 2000
--> T1 resulta con A = 2000, B = 500, C = 0
--> T2 resulta con A = 1400, B = 400, C = 100
b)
T1
A = 1000
T2
C = 100
B = 500
B = 500 - 100
B = 400
T1
A = 1000 * 2
A = 2000
T2
A = 2000
A = 2000 + 400
A = 2400
--> T1 resulta con A = 2000, B = 500, C = 0
--> T2 resulta con A = 2400, B = 400, C = 100
La planificación b) es serializable porque su resultado de A, B y C coincide con la ejecucion en serie T1 -> T2 con valores A = 2400, B = 400 y C = 100

Planificaciones con transacciones T1, T2 y T3
a)
T1
A = 1000 <-1
T2
C = 0
B = 500
T1
A = 1000 <-2
T2
A = 1000 <-1,2
b)
T1
A = 1000 <-1
T2
C = 0
B = 500
T1
A = 1000<-2
T2
A = 1000 <-1,2
B = 500
c)


*/