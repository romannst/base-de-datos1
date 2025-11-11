CREATE DATABASE actividades_universidad;
USE actividades_universidad;

#CREACION DE LAS TABLAS
CREATE TABLE Departamentos(
codigo INT PRIMARY KEY NOT NULL,
nombre VARCHAR(100) NOT NULL
);
CREATE TABLE Profesores(
dni INT PRIMARY KEY NOT NULL,
nombre VARCHAR(100) NOT NULL,
apellido VARCHAR(100) NOT NULL,
email VARCHAR(100) UNIQUE NOT NULL,
departamento_codigo INT NOT NULL,
CONSTRAINT fk_departamento_codigo FOREIGN KEY (departamento_codigo) REFERENCES Departamentos (codigo)
);
CREATE TABLE Actividades(
codigo INT PRIMARY KEY NOT NULL,
titulo VARCHAR(100) NOT NULL,
tipo ENUM('Seminario','Taller','Conferencia') NOT NULL,
cupo INT NOT NULL CHECK(cupo > 0),
cupo_disponible INT NOT NULL CHECK(cupo_disponible >= 0),
profesor_dni INT  NOT NULL,
CONSTRAINT fk_profesor_dni FOREIGN KEY (profesor_dni) REFERENCES Profesores (dni)
);
CREATE TABLE Estudiantes(
dni INT PRIMARY KEY NOT NULL,
nombre VARCHAR(100) NOT NULL,
apellido VARCHAR(100) NOT NULL,
email VARCHAR(120) UNIQUE NOT NULL
);
CREATE TABLE Inscripciones(
estudiante_dni INT,
actividad_codigo INT,
fecha_inscripcion DATE NOT NULL,
CONSTRAINT pk_inscripciones PRIMARY KEY (estudiante_dni,actividad_codigo),
CONSTRAINT fk_estudiante_dni FOREIGN KEY (estudiante_dni) REFERENCES Estudiantes (dni),
CONSTRAINT fk_actividad_codigo FOREIGN KEY (actividad_codigo) REFERENCES Actividades (codigo)
);

#INSERTS A LAS TABLAS
#Departamentos
INSERT INTO Departamentos (codigo,nombre) VALUES (10,"Ciencias Sociales");
INSERT INTO Departamentos (codigo,nombre) VALUES (20,"Arte y Cultura");
INSERT INTO Departamentos (codigo,nombre) VALUES (30,"Humanidades");
#Profesores
INSERT INTO Profesores (dni,nombre,apellido,email,departamento_codigo) VALUES (1001,"Ana","Torres","ana.torres@uni.edu",10);
INSERT INTO Profesores (dni,nombre,apellido,email,departamento_codigo) VALUES
(1002,"Pablo","Gimenez","pablo.gimenez@uni.edu",20),
(1003,"Lucia","Paredes","lucia.paredes@uni.edu",20);
#Actividades
INSERT INTO Actividades (codigo,titulo,tipo,cupo,cupo_disponible,profesor_dni) VALUES
(501,"Historia del Teatro","Seminario",30,27,1003),
(502,"Introducción a la Fotografía","Taller",15,13,1002),
(503,"Pensamiento Contemporáneo","Conferencia",100,99,1001);
#Estudiantes
INSERT INTO Estudiantes (dni,nombre,apellido,email) VALUES
(2010,"Jorge","Acosta","jorge.acosta@mail.com"),
(2011,"Sofia","Ruiz","sofia.ruiz@mail.com"),
(2012,"Marcos","López","marcos.lopez@mail.com"),
(2013,"Ana","García","ana.garcia@mail.com");
#Inscripciones
INSERT INTO Inscripciones (estudiante_dni,actividad_codigo,fecha_inscripcion) VALUES
(2010,501,'2025-04-01'),
(2010,502,'2025-04-10'),
(2011,502,'2025-04-12'),
(2012,501,'2025-05-03'),
(2013,503,'2025-05-05'),
(2013,501,'2025-05-14');

#CONSULTAS A LAS TABLAS
#Básicas
SELECT * FROM Departamentos;
SELECT CONCAT(P.nombre," ",P.apellido) AS Nombre_Completo FROM Profesores AS P;
SELECT * FROM Actividades AS A WHERE A.tipo = "Taller";
SELECT * FROM Estudiantes AS E WHERE E.apellido LIKE "G%";
#Intermedias
SELECT CONCAT(E.nombre," ",E.apellido) AS Nombre_Completo,I.actividad_codigo,A.titulo AS Actividad FROM Estudiantes AS E
JOIN Inscripciones AS I ON E.dni = I.estudiante_dni
JOIN Actividades AS A ON I.actividad_codigo = A.codigo;
SELECT CONCAT(P.nombre," ",P.apellido) AS Nombre_Completo,D.nombre AS Departamento FROM Profesores AS P
JOIN Departamentos AS D ON P.departamento_codigo = D.codigo;
SELECT A.titulo AS Actividad,CONCAT(P.nombre," ",P.apellido) AS Profesor_Responsable FROM Actividades AS A JOIN Profesores AS P ON A.profesor_dni = P.dni;
SELECT E.dni AS Estudiante_DNI,CONCAT(E.nombre," ",E.apellido) AS Nombre_Completo, COUNT(I.actividad_codigo) AS Cantidad_Actividades FROM Estudiantes AS E
JOIN Inscripciones AS I ON E.dni = I.estudiante_dni GROUP BY E.dni HAVING Cantidad_Actividades > 1;
#Complejas
SELECT D.nombre AS Departamento,COUNT(P.departamento_codigo) AS Cantidad_Profesores FROM Profesores AS P
JOIN Departamentos AS D ON P.departamento_codigo = D.codigo GROUP BY D.codigo;
SELECT A.titulo AS Actividad,COUNT(I.estudiante_dni) AS Cantidad_Estudiantes FROM Inscripciones AS I
JOIN Actividades AS A ON I.actividad_codigo = A.codigo GROUP BY A.codigo HAVING Cantidad_Estudiantes > 2;
SELECT tipo AS Tipo_Actividad, CONCAT(FORMAT(AVG(cupo),2),"%") AS Cupo_Promedio FROM Actividades GROUP BY tipo;
SELECT E.* FROM Estudiantes AS E
JOIN Inscripciones AS I ON E.dni = I.estudiante_dni
JOIN Actividades AS A ON A.codigo = I.actividad_codigo WHERE A.profesor_dni = 1003;
SELECT A.* FROM Actividades AS A
WHERE cupo > (
SELECT COUNT(*) FROM Inscripciones AS I WHERE I.actividad_codigo = A.codigo GROUP BY I.actividad_codigo
);
SELECT DISTINCT E.* FROM Estudiantes AS E
JOIN Inscripciones AS I ON E.dni = I.estudiante_dni
JOIN Actividades AS A ON A.codigo = I.actividad_codigo
JOIN Profesores AS P ON A.profesor_dni = P.dni
JOIN Departamentos AS D ON P.departamento_codigo = D.codigo WHERE D.nombre = "Arte y Cultura" AND E.dni NOT IN (
SELECT DISTINCT E.dni FROM Estudiantes AS E
JOIN Inscripciones AS I ON E.dni = I.estudiante_dni
JOIN Actividades AS A ON A.codigo = I.actividad_codigo
JOIN Profesores AS P ON A.profesor_dni = P.dni
JOIN Departamentos AS D ON P.departamento_codigo = D.codigo WHERE D.nombre <> "Arte y Cultura"
);
/*INSERT INTO Inscripciones (estudiante_dni,actividad_codigo,fecha_inscripcion) VALUES (2010,503,'2025-04-01');*/
SELECT P.*, COUNT(A.codigo) AS Cantidad_Actividades FROM Profesores AS P
JOIN Actividades AS A ON P.dni = A.profesor_dni GROUP BY P.dni HAVING Cantidad_Actividades >  1;
SELECT A.* FROM Actividades AS A WHERE A.cupo_disponible = A.cupo;
SELECT E.* FROM Estudiantes AS E
JOIN Inscripciones AS I ON E.dni = I.estudiante_dni GROUP BY E.dni
HAVING COUNT(I.actividad_codigo) = (SELECT COUNT(A.codigo) FROM Actividades AS A);
SELECT P.*,COUNT(A.codigo) AS Cantidad_Actividades,COUNT(E.dni) AS Cantidad_Inscriptos FROM Profesores AS P
JOIN Actividades AS A ON P.dni = A.profesor_dni
JOIN Inscripciones AS I ON A.codigo = I.actividad_codigo
JOIN Estudiantes AS E ON E.dni = I.estudiante_dni GROUP BY P.dni ORDER BY Cantidad_Inscriptos DESC LIMIT 1;
SELECT D.*,COUNT(I.estudiante_dni) AS Cantidad_Inscriptos FROM Departamentos AS D
JOIN Profesores AS P ON D.codigo = P.departamento_codigo
JOIN Actividades AS A ON P.dni = A.profesor_dni
JOIN Inscripciones AS I ON A.codigo = I.actividad_codigo GROUP BY D.codigo ORDER BY Cantidad_Inscriptos DESC LIMIT 1;
SELECT A.titulo,CONCAT(A.cupo-A.cupo_disponible," / ",A.cupo) AS Cupo_Actual,CONCAT(FORMAT((((A.cupo-A.cupo_disponible)/cupo)*100),2),"%") AS Cupo_Ocupado FROM Actividades AS A;

#SERIALIZABILIDAD
/*
TRANSCACCIONES
cupo_501 = 30
T1:
Leer(cupo_501)
cupo_501 := cupo_501 - 1
Escribir(cupo_501)
T2:
Leer(cupo_501)
cupo_501 := cupo_501 - 1
Escribir(cupo_501)

Ejecución serial de las transacciones: T1 -> T2 = T2 -> T1
T1
cupo_501 = 30
cupo_501 = 30 - 1
cupo_501 = 29
T2
cupo_501 = 29
cupo_501 = 29 - 1
cupo_501 = 28
--> Resulta cupo_501 = 28

Planificación concurrente
T1
cupo_501 = 30
T2
cupo_501 = 30
T1
cupo_501 = 30 - 1
cupo_501 = 29
cupo_501 = 30 - 1
cupo_501 = 29
--> Resulta cupo_501 = 29

La planificación no es serializable, porque no coincide con la ejecución en serie de T1 y T2 (29 != 28).
*/

