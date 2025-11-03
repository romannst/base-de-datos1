-- PUNTO 1
-- 1) Creación de la Base de Datos
CREATE DATABASE club_aficionados;
-- Seleccionar la base de datos a utilizar
USE club_aficionados;
-- Crear la tabla Hobbies primero, ya que la tabla Aficiones la referenciará
-- Tabla Hobbies
-- PK: nombre
CREATE TABLE Hobbies (
    nombre VARCHAR(100) NOT NULL,
    PRIMARY KEY (nombre)
);

-- Crear la tabla Personas

-- Tabla Personas
-- PK: dni
-- El atributo 'dni' en el diagrama está subrayado, indicando que es la clave.
CREATE TABLE Personas (
    dni VARCHAR(15) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE, -- El email suele ser único
    PRIMARY KEY (dni)
);

-- Crear la tabla Aficiones (Tabla de enlace o de relación M:N)
-- PK: (dni, hobby)
-- FKs: dni y hobby
CREATE TABLE Aficiones (
    dni VARCHAR(15) NOT NULL,
    hobby VARCHAR(100) NOT NULL,
    PRIMARY KEY (dni , hobby),
    FOREIGN KEY (dni)
        REFERENCES Personas (dni)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (hobby)
        REFERENCES Hobbies (nombre)
        ON DELETE CASCADE ON UPDATE CASCADE
);
-- Nota: Se eligieron los tipos VARCHAR y se agregaron las cláusulas ON DELETE/UPDATE CASCADE 
-- para mantener la integridad referencial de forma robusta.

-- PUNTO 2
INSERT INTO Hobbies (nombre) VALUES
('Cine'),
('Lectura'),
('Fotografía'),
('Arte'),
('Senderismo'),
('Ajedrez'),
('Teatro');
INSERT INTO Personas (dni, nombre, apellido, email) VALUES
('1234', 'Ana', 'Pérez', 'ana@mail.com'),
('1356', 'Pedro', 'González', 'pedro_gonza@dominio.com'),
('1358', 'Joaquín', 'Ramírez', 'joaquin_ramirez@mail.com'),
('1354', 'Luisa', 'Pereira', 'Luisa@dominio.com'),
('1543', 'Clara', 'Hernández', 'clara@otromail.com'),
('1528', 'Franco', 'Gómez', 'franco@supermail.com');
INSERT INTO Aficiones (dni, hobby) VALUES
('1234', 'Cine'),
('1356', 'Lectura'),
('1358', 'Fotografía'),
('1234', 'Arte'),
('1543', 'Senderismo'),
('1528', 'Ajedrez'),
('1358', 'Teatro'),
('1528', 'Arte'),
('1356', 'Teatro'),
-- Aficiones de Luisa (DNI 1354), que practica todos los hobbies:
('1354', 'Cine'),
('1354', 'Lectura'),
('1354', 'Fotografía'),
('1354', 'Arte'),
('1354', 'Senderismo'),
('1354', 'Ajedrez'),
('1354', 'Teatro');

-- PUNTO 3
SELECT nombre FROM Hobbies;
SELECT nombre,apellido,email FROM Personas;
SELECT dni,nombre,apellido FROM Personas WHERE apellido LIKE 'G%';
SELECT dni,nombre,apellido FROM Personas WHERE dni > 1400;
SELECT nombre FROM Hobbies WHERE nombre LIKE '%a';
SELECT nombre,apellido,email FROM Personas WHERE email LIKE '%dominio.com';
SELECT P.nombre,P.apellido,A.hobby FROM Personas AS P
JOIN Aficiones AS A ON P.dni = A.dni;
SELECT P.nombre,P.apellido FROM Personas AS P 
LEFT JOIN Aficiones AS A ON P.dni = A.dni WHERE A.dni IS NULL;
SELECT P.nombre,P.apellido FROM Personas AS P
JOIN Aficiones AS A ON P.dni = A.dni
GROUP BY P.dni,P.nombre,P.apellido 
HAVING COUNT(A.hobby) = (SELECT COUNT(*) FROM Hobbies);
SELECT P.nombre,P.apellido FROM Personas AS P
JOIN Aficiones AS A ON P.dni = A.dni
GROUP BY P.dni,P.nombre,P.apellido 
HAVING COUNT(A.hobby) > 1;
SELECT P.nombre,P.apellido FROM Personas AS P
JOIN Aficiones AS A ON P.dni = A.dni
GROUP BY P.dni,P.nombre,P.apellido 
HAVING COUNT(A.hobby) = 3;
SELECT A.hobby, COUNT(A.dni) AS Total_Personas
FROM Aficiones AS A
GROUP BY A.hobby
HAVING COUNT(A.dni) > 2;
SELECT P.nombre,P.apellido,A.hobby FROM Personas AS P
JOIN Aficiones AS A ON P.dni = A.dni
ORDER BY P.apellido ASC, P.nombre ASC;
SELECT A.hobby,CONCAT(P.apellido,' ',P.nombre) AS Nombre_Completo FROM Aficiones AS A
JOIN Personas AS P ON A.dni = P.dni
ORDER BY A.hobby DESC, Nombre_Completo ASC;
SELECT H.nombre AS Hobby, COUNT(A.dni) AS Cantidad_Personas
FROM Hobbies AS H
LEFT JOIN Aficiones AS A ON H.nombre = A.hobby
GROUP BY H.nombre ORDER BY Cantidad_Personas DESC, H.nombre ASC;