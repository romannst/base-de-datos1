USE tech_solutions;
-- Deben haberse insertado los departamentos antes de ejecutar este archivo SQL
-- Jefes (uno por departamento)
INSERT INTO empleados (dni, nombre, apellido, fecha_nacimiento, direccion, salario, dni_jefe, departamento_codigo)
VALUES (100, 'Carlos', 'Pereira', '1980-05-20', 'Zapiola 456', 4000.00, NULL, 1);

INSERT INTO empleados (dni, nombre, apellido, fecha_nacimiento, direccion, salario, dni_jefe, departamento_codigo)
VALUES (200, 'Laura', 'Lopez', '1978-09-15', '9 de Julio 456', 4000.00, NULL, 2);

INSERT INTO empleados (dni, nombre, apellido, fecha_nacimiento, direccion, salario, dni_jefe, departamento_codigo)
VALUES (300, 'Martin', 'Ramirez', '1985-03-10', 'San Martin 123', 4000.00, NULL, 3);

-- Subordinados en departamento 1
INSERT INTO empleados (dni, nombre, apellido, fecha_nacimiento, direccion, salario, dni_jefe, departamento_codigo)
VALUES (101, 'Ana', 'Martinez', '1990-07-12', 'Belgrano 321', 2200.00, 100, 1);

INSERT INTO empleados (dni, nombre, apellido, fecha_nacimiento, direccion, salario, dni_jefe, departamento_codigo)
VALUES (102, 'Diego', 'Fernandez', '1992-11-05', 'Rivadavia 654', 2100.00, 100, 1);

INSERT INTO empleados (dni, nombre, apellido, fecha_nacimiento, direccion, salario, dni_jefe, departamento_codigo)
VALUES (404, 'Jorge', 'López', '1980-01-15', 'Rivadavia 950', 4100.00, 300, 1);

-- Subordinados en departamento 2
INSERT INTO empleados (dni, nombre, apellido, fecha_nacimiento, direccion, salario, dni_jefe, departamento_codigo)
VALUES (201, 'Sofia', 'Gomez', '1988-02-18', 'Av. Colon 111', 2500.00, 200, 2);

INSERT INTO empleados (dni, nombre, apellido, fecha_nacimiento, direccion, salario, dni_jefe, departamento_codigo)
VALUES (202, 'Juan', 'Rodriguez', '1995-12-30', 'Mitre 222', 2300.00, 200, 2);

INSERT INTO empleados (dni, nombre, apellido, fecha_nacimiento, direccion, salario, dni_jefe, departamento_codigo)
VALUES (401, 'María', 'González', '1990-03-12', 'Mitre 1200', 3200.00, 300, 2);

INSERT INTO empleados (dni, nombre, apellido, fecha_nacimiento, direccion, salario, dni_jefe, departamento_codigo)
VALUES (402, 'Carlos', 'Pérez', '1985-07-25', 'Belgrano 850', 2800.00, 300, 2);

-- Subordinados en departamento 3
INSERT INTO empleados (dni, nombre, apellido, fecha_nacimiento, direccion, salario, dni_jefe, departamento_codigo)
VALUES (301, 'Camila', 'Diaz', '1993-04-08', 'Italia 333', 2400.00, 300, 3);

INSERT INTO empleados (dni, nombre, apellido, fecha_nacimiento, direccion, salario, dni_jefe, departamento_codigo)
VALUES (302, 'Luis', 'Alvarez', '1987-10-19', 'España 444', 2600.00, 300, 3);

INSERT INTO empleados (dni, nombre, apellido, fecha_nacimiento, direccion, salario, dni_jefe, departamento_codigo)
VALUES (303, 'Valeria', 'Suarez', '1991-01-25', 'Chile 555', 2450.00, 300, 3);

INSERT INTO empleados (dni, nombre, apellido, salario, departamento_codigo)
VALUES (304, 'Cecilia', 'Perez', 2800, 3);

INSERT INTO empleados (dni, nombre, apellido, fecha_nacimiento, direccion, salario, dni_jefe, departamento_codigo)
VALUES (403, 'Ana', 'Martínez', '1992-11-03', 'San Martín 200', 2400.00, 401, 3);

INSERT INTO empleados (dni, nombre, apellido, fecha_nacimiento, direccion, salario, dni_jefe, departamento_codigo)
VALUES (405, 'Sofía', 'Ramírez', '1995-09-30', 'Sarmiento 333', 2200.00, 401, 3);

INSERT INTO empleados (dni, nombre, apellido, salario, departamento_codigo)
VALUES (504, 'Sofia', 'Suarez', 3000, 3);

INSERT INTO empleados (dni, nombre, apellido, salario, departamento_codigo)
VALUES (505, 'Renata', 'Alvarez', 3100, 3);

INSERT INTO empleados (dni, nombre, apellido, salario, departamento_codigo)
VALUES (506, 'Gonzalo', 'Rodríguez', 2900, 3);

INSERT INTO empleados (dni, nombre, apellido, salario, departamento_codigo)
VALUES (507, 'Franco', 'Suarez', 2700, 3);

-- INSERTS para PROYECTOS
-- Proyectos del departamento 1 (Recursos Humanos)
INSERT INTO proyectos (numero, nombre, lugar, departamento_codigo)
VALUES (10, 'Capacitación Interna', 'La Plata', 1);

INSERT INTO proyectos (numero, nombre, lugar, departamento_codigo)
VALUES (11, 'Reclutamiento IT', 'Buenos Aires', 1);

-- Proyectos del departamento 2 (Sistemas)
INSERT INTO proyectos (numero, nombre, lugar, departamento_codigo)
VALUES (20, 'Migración a la Nube', 'La Plata', 2);

INSERT INTO proyectos (numero, nombre, lugar, departamento_codigo)
VALUES (21, 'Aplicación Móvil', 'Buenos Aires', 2);

-- Proyectos del departamento 3 (Finanzas)
INSERT INTO proyectos (numero, nombre, lugar, departamento_codigo)
VALUES (30, 'Auditoría Interna', 'La Plata', 3);

INSERT INTO proyectos (numero, nombre, lugar, departamento_codigo)
VALUES (31, 'Automatización de Reportes', 'Córdoba', 3);

-- proyectos del departamento 4 (Administración)
INSERT INTO proyectos (numero, nombre, lugar, departamento_codigo)
VALUES(41, 'Análisis satisfacción laboral', 'Tandil', 4);
-- proyectos del departamento 5 (Logística)
INSERT INTO proyectos (numero, nombre, lugar, departamento_codigo)
VALUES (52, 'Optimización de entregas', 'Bahia Blanca', 5);

-- INSERTS para TRABAJA_EN
-- Departamento 1: Empleados 100, 101, 102, 404
INSERT INTO trabaja_en (dni_empleado, proyecto_numero, horas) VALUES (100, 10, 15);
INSERT INTO trabaja_en (dni_empleado, proyecto_numero, horas) VALUES (101, 10, 20);
INSERT INTO trabaja_en (dni_empleado, proyecto_numero, horas) VALUES (102, 11, 18);
INSERT INTO trabaja_en (dni_empleado, proyecto_numero, horas) VALUES (404, 11, 25);

-- Departamento 2: Empleados 200, 201, 202, 401, 402
INSERT INTO trabaja_en (dni_empleado, proyecto_numero, horas) VALUES (200, 20, 25);
INSERT INTO trabaja_en (dni_empleado, proyecto_numero, horas) VALUES (201, 20, 12);
INSERT INTO trabaja_en (dni_empleado, proyecto_numero, horas) VALUES (202, 21, 30);
INSERT INTO trabaja_en (dni_empleado, proyecto_numero, horas) VALUES (401, 21, 15);

-- Departamento 3: Empleados 300, 301, 302, 303, 304, 403, 404, 405, 504
INSERT INTO trabaja_en (dni_empleado, proyecto_numero, horas) VALUES (300, 30, 40);
INSERT INTO trabaja_en (dni_empleado, proyecto_numero, horas) VALUES (301, 30, 16);
INSERT INTO trabaja_en (dni_empleado, proyecto_numero, horas) VALUES (302, 31, 20);
INSERT INTO trabaja_en (dni_empleado, proyecto_numero, horas) VALUES (303, 31, 22);
INSERT INTO trabaja_en (dni_empleado, proyecto_numero, horas) VALUES (304, 31, 12);
INSERT INTO trabaja_en (dni_empleado, proyecto_numero, horas) VALUES (403, 31, 12);
INSERT INTO trabaja_en (dni_empleado, proyecto_numero, horas) VALUES (405, 30, 10);

-- Familiares
INSERT INTO familiares (dni_empleado, nombre_familiar, fecha_nacimiento, parentesco) VALUES 
(200, 'Clara', '2000-05-26', 'hija'), 
(200, 'Franco', '2003-08-21', 'hijo');

INSERT INTO familiares (dni_empleado, nombre_familiar, fecha_nacimiento, parentesco) VALUES
(301, 'Lucía',  '2010-04-15', 'hija'),
(301, 'Mateo',  '2012-11-02', 'hijo');

INSERT INTO familiares (dni_empleado, nombre_familiar, fecha_nacimiento, parentesco) VALUES
(302, 'Valeria', '1980-09-18', 'esposa'),
(302, 'Tomás',   '2008-07-05', 'hijo'),
(302, 'Sofía',   '2011-01-23', 'hija');

INSERT INTO familiares (dni_empleado, nombre_familiar, fecha_nacimiento, parentesco) VALUES
(401, 'Carlos',  '1975-03-09', 'esposo'),
(401, 'Micaela', '2005-12-30', 'hija');

INSERT INTO familiares (dni_empleado, nombre_familiar, fecha_nacimiento, parentesco) VALUES
(402, 'Andrea',   '1983-06-20', 'esposa'),
(402, 'Julián',   '2014-09-14', 'hijo'),
(402, 'Martina',  '2017-02-28', 'hija');

INSERT INTO familiares (dni_empleado, nombre_familiar, fecha_nacimiento, parentesco) VALUES
(201, 'Nicolás',  '2007-10-11', 'hijo'),
(201, 'Paula',    '2010-03-04', 'hija');

INSERT INTO familiares (dni_empleado, nombre_familiar, fecha_nacimiento, parentesco) VALUES
(404, 'Gabriela', '1986-08-25', 'esposa'),
(404, 'Ignacio',  '2012-12-12', 'hijo'),
(404, 'Camila',   '2015-05-09', 'hija');
																											