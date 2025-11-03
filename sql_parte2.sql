CREATE DATABASE tech_solutions;
USE tech_solutions;

CREATE TABLE empleados(
dni INT PRIMARY KEY,
nombre VARCHAR(100),
apellido VARCHAR(100),
fecha_nacimiento DATE,
direccion VARCHAR(150),
salario DECIMAL(10,2),
dni_jefe INT,
departamento_codigo INT,
FOREIGN KEY (departamento_codigo) REFERENCES departamentos (codigo) # ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE empleados ADD CONSTRAINT fk_jefe FOREIGN KEY (dni_jefe) REFERENCES empleados (dni);

CREATE TABLE departamentos(
codigo INT PRIMARY KEY,
nombre VARCHAR(60),
dni_director INT,
fecha_inicio_director DATE
);

ALTER TABLE departamentos ADD CONSTRAINT fk_director FOREIGN KEY (dni_director) REFERENCES empleados(dni);

CREATE TABLE proyectos(
numero INT PRIMARY KEY,
nombre VARCHAR(100),
lugar VARCHAR(100),
departamento_codigo INT NOT NULL,
FOREIGN KEY (departamento_codigo) REFERENCES departamentos (codigo)
);

CREATE TABLE trabaja_en(
dni_empleado INT,
proyecto_numero INT,
horas INT,
PRIMARY KEY (dni_empleado, proyecto_numero),
FOREIGN KEY (dni_empleado) REFERENCES empleados (dni),
FOREIGN KEY (proyecto_numero) REFERENCES proyectos (numero)
);

CREATE TABLE familiares(
dni_empleado INT,
nombre_familiar VARCHAR(100),
fecha_nacimiento DATE NOT NULL,
parentesco VARCHAR(150) NOT NULL,
PRIMARY KEY (dni_empleado, nombre_familiar),
FOREIGN KEY (dni_empleado) REFERENCES empleados (dni)
);

INSERT INTO departamentos (codigo,nombre) VALUES (1, "Recursos Humanos"), (2,"Sistemas"), (3,"Finanzas"), (4,"Administración"), (5,"Logística");
UPDATE departamentos AS d SET d.dni_director = (SELECT e.dni FROM empleados AS e WHERE e.nombre = "Carlos" AND e.apellido = "Pereira") ,d.fecha_inicio_director = CURDATE() WHERE d.nombre = "Recursos Humanos";
UPDATE departamentos AS d SET d.dni_director = (SELECT e.dni FROM empleados AS e WHERE e.nombre = "Laura" AND e.apellido = "Lopez") ,d.fecha_inicio_director = CURDATE() WHERE d.nombre = "Sistemas";
UPDATE departamentos AS d SET d.dni_director = (SELECT e.dni FROM empleados AS e WHERE e.nombre = "Martin" AND e.apellido = "Ramirez") ,d.fecha_inicio_director = CURDATE() WHERE d.nombre = "Finanzas";

SELECT * FROM departamentos;
#SELECT e.nombre,e.apellido FROM empleados AS e JOIN departamentos AS d ON e.dni = d.dni_director;
SELECT * FROM empleados;
SELECT E.nombre,E.apellido FROM empleados AS E;
SELECT E.nombre,E.apellido,round(E.salario) AS salario FROM empleados AS E WHERE E.salario > 3000;
SELECT P.nombre FROM proyectos AS P WHERE P.lugar = "La Plata";
SELECT D.nombre FROM departamentos AS D WHERE NOT D.dni_director IS NULL;
SELECT CONCAT(E.nombre," ",E.Apellido) AS Nombre_Completo FROM empleados AS E WHERE E.dni_jefe IS NULL;
SELECT * FROM empleados AS E WHERE YEAR(fecha_nacimiento) > 1990;
SELECT CONCAT(E.nombre," ",E.Apellido) AS Nombre_Completo FROM empleados AS E WHERE E.apellido LIKE "G%";
SELECT * FROM familiares;
SELECT F.nombre_familiar AS Nombre,F.parentesco AS Parentesco FROM familiares AS F WHERE F.parentesco LIKE "hij%";
SELECT CONCAT(E.nombre," ",E.apellido) AS Nombre_Completo,D.nombre AS Departamento FROM empleados AS E JOIN departamentos AS D ON E.departamento_codigo = D.codigo;
SELECT P.nombre AS Proyecto,D.nombre AS Departamento FROM proyectos AS P JOIN departamentos AS D ON P.departamento_codigo = D.codigo;
SELECT P.nombre AS Proyecto,D.nombre AS Departamento FROM proyectos AS P JOIN departamentos AS D ON P.departamento_codigo = D.codigo WHERE D.nombre = "Sistemas";
SELECT CONCAT(E.nombre," ",E.apellido) AS Nombre_Completo,P.nombre AS Proyecto FROM empleados AS E JOIN trabaja_en AS T ON E.dni = T.dni_empleado JOIN proyectos AS P ON T.proyecto_numero = P.numero;
SELECT E.nombre AS Empleado,CONCAT(F.parentesco," - ",F.nombre_familiar) AS Relacion_Familiar FROM empleados AS E JOIN familiares AS F ON E.dni = F.dni_empleado;
SELECT E.nombre AS Empleado,CONCAT(F.parentesco," - ",F.nombre_familiar) AS Relacion_Familiar FROM empleados AS E JOIN familiares AS F ON E.dni = F.dni_empleado WHERE F.parentesco LIKE "espos%";
SELECT CONCAT(E.nombre," ", E.apellido) AS Nombre_Completo,COUNT(T.proyecto_numero) AS Total_Proyectos FROM empleados AS E JOIN trabaja_en AS T ON E.dni = T.dni_empleado GROUP BY E.dni, Nombre_Completo HAVING Total_Proyectos > 1 ORDER BY Nombre_Completo;
SELECT CONCAT(E.nombre," ",E.apellido) AS Nombre_Completo,T.horas AS Horas_Dedicadas FROM empleados AS E JOIN trabaja_en AS T ON E.dni = T.dni_empleado;
SELECT P.nombre AS Proyecto,CONCAT("$",ROUND(E.salario)) AS Salario_Mayor FROM proyectos AS P JOIN trabaja_en AS T ON P.numero = T.proyecto_numero JOIN empleados AS E ON T.dni_empleado = E.dni WHERE E.salario > 3000;
SELECT CONCAT("$",TRUNCATE(AVG(E.salario),2)) AS Salario_Promedio FROM empleados AS E;
SELECT COUNT(F.dni_empleado) AS Total_Familiares FROM familiares AS F;
SELECT E.dni AS Empleado_DNI,COUNT(T.proyecto_numero) AS Cantidad_Proyectos FROM empleados AS E LEFT JOIN trabaja_en AS T ON E.dni = T.dni_empleado GROUP BY E.dni, Empleado_DNI ORDER BY Cantidad_Proyectos DESC, Empleado_DNI ASC;
SELECT D.nombre AS Departamento,COUNT(E.dni) AS Cantidad_Empleados FROM departamentos AS D LEFT JOIN empleados AS E ON D.codigo = E.departamento_codigo GROUP BY D.nombre, Departamento ORDER BY Cantidad_Empleados DESC;
SELECT P.nombre AS Proyecto,COALESCE(SUM(T.horas),0) AS Horas_Trabajadas FROM proyectos AS P LEFT JOIN trabaja_en AS T ON P.numero = T.proyecto_numero GROUP BY P.numero ORDER BY Horas_Trabajadas DESC;
SELECT D.nombre AS Departamento,CONCAT("$",COALESCE(TRUNCATE(AVG(E.salario),2),0)) AS Salario_Promedio FROM departamentos AS D LEFT JOIN empleados AS E ON D.codigo = E.departamento_codigo GROUP BY D.codigo ORDER BY Salario_Promedio DESC;
SELECT F.parentesco AS Parentesco,COUNT(F.parentesco) AS Cantidad_Familiares FROM familiares AS F GROUP BY F.parentesco;
SELECT D.nombre AS Departamento,COUNT(E.dni) AS Cantidad_Empleados FROM departamentos AS D JOIN empleados AS E ON D.codigo = E.departamento_codigo GROUP BY D.nombre, Departamento HAVING Cantidad_Empleados > 4 ORDER BY Cantidad_Empleados ASC;
SELECT P.nombre AS Proyecto,COALESCE(SUM(T.horas),0) AS Horas_Trabajadas FROM proyectos AS P LEFT JOIN trabaja_en AS T ON P.numero = T.proyecto_numero GROUP BY P.numero HAVING Horas_Trabajadas > 1000 ORDER BY Horas_Trabajadas DESC;
SELECT E.dni AS Empleado_DNI,COUNT(T.proyecto_numero) AS Cantidad_Proyectos FROM empleados AS E LEFT JOIN trabaja_en AS T ON E.dni = T.dni_empleado GROUP BY E.dni, Empleado_DNI HAVING Cantidad_Proyectos > 2 ORDER BY Cantidad_Proyectos DESC, Empleado_DNI ASC;
SELECT F.parentesco AS Parentesco,COUNT(F.parentesco) AS Cantidad_Familiares FROM familiares AS F GROUP BY F.parentesco HAVING Cantidad_Familiares > 3;