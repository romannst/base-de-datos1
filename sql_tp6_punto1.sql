CREATE DATABASE banco;
USE banco;
CREATE TABLE clientes(
numero_cliente INT PRIMARY KEY NOT NULL,
dni INT NOT NULL,
apellido VARCHAR(60) NOT NULL,
nombre VARCHAR(60) NOT NULL
);
CREATE TABLE cuentas(
numero_cuenta INT PRIMARY KEY NOT NULL,
numero_cliente INT NOT NULL,
saldo DECIMAL(10,2) NOT NULL,
CONSTRAINT fk_num_cliente FOREIGN KEY (numero_cliente) REFERENCES clientes(numero_cliente)
);
CREATE TABLE movimientos(
numero_movimiento INT PRIMARY KEY NOT NULL,
numero_cuenta INT NOT NULL,
fecha DATE NOT NULL,
tipo ENUM('CREDITO','DEBITO') NOT NULL,
importe DECIMAL(10,2) NOT NULL,
CONSTRAINT fk_num_cuenta FOREIGN KEY (numero_cuenta) REFERENCES cuentas(numero_cuenta)
);
ALTER TABLE movimientos MODIFY numero_movimiento INT AUTO_INCREMENT;
CREATE TABLE historial_movimientos(
id INT PRIMARY KEY NOT NULL,
numero_cuenta INT NOT NULL,
numero_movimiento INT NOT NULL,
saldo_anterior DECIMAL(10,2) NOT NULL,
saldo_actual DECIMAL(10,2) NOT NULL,
CONSTRAINT fk2_num_cuenta FOREIGN KEY (numero_cuenta) REFERENCES cuentas(numero_cuenta),
CONSTRAINT fk_num_movimiento FOREIGN KEY (numero_movimiento) REFERENCES movimientos(numero_movimiento)
);

SELECT * FROM movimientos;
SELECT * FROM cuentas;
SELECT * FROM clientes;
SELECT Cu.numero_cuenta AS Numero_Cuenta, CONCAT(Cl.nombre," ",Cl.apellido) AS Nombre_Cliente, Cu.saldo AS Saldo
FROM cuentas AS Cu JOIN clientes AS Cl
ON Cu.numero_cliente = Cl.numero_cliente;
SELECT Cu.numero_cuenta AS Numero_Cuenta, CONCAT(Cl.nombre," ",Cl.apellido) AS Nombre_Cliente, Cu.saldo AS Saldo
FROM cuentas AS Cu JOIN clientes AS Cl
ON Cu.numero_cliente = Cl.numero_cliente WHERE Cu.saldo > limite;
SELECT COUNT(M.numero_movimiento) AS Total_Movimientos FROM movimientos AS M WHERE M.numero_cuenta = 1005 AND YEAR(CURDATE()) = YEAR(M.fecha);