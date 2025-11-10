USE banco;
#nuevo rol Gerente con todos los privilegios en la bd banco
CREATE ROLE "Gerente";
GRANT ALL PRIVILEGES ON banco.* TO "Gerente";
#nuevo rol Atención al Público con el privilegio de ejecutar todos los stored procedures y seleccionar sobre todas las tablas de la bd banco
CREATE ROLE "Atención Público";
GRANT EXECUTE ON banco.* TO "Atención Público";
GRANT SELECT ON banco.* TO "Atención Público";
#nuevo rol Cajero el privilegio mas básico para poder conectarse a la bd banco y ejecutar los stored procedures para depositar y extraer dinero
CREATE ROLE "Cajero";
GRANT EXECUTE ON PROCEDURE banco.Depositar TO "Cajero";
GRANT EXECUTE ON PROCEDURE banco.Extraer TO "Cajero";
GRANT USAGE ON banco.* TO "Cajero";
#ver los privilegios de cada rol
SHOW GRANTS FOR "Gerente";
SHOW GRANTS FOR "Atención Público";
SHOW GRANTS FOR "Cajero";

#creando usuarios
CREATE USER "Laura" IDENTIFIED BY "laura123";
CREATE USER "Carlos" IDENTIFIED BY "carlos123";
CREATE USER "Sofía" IDENTIFIED BY "sofia123";
CREATE USER "Diego" IDENTIFIED BY "diego123";
CREATE USER "Luciana" IDENTIFIED BY "luciana123";

DROP USER "Luciana";
#asignar los roles para cada usuario
GRANT "Gerente" TO "Laura";
GRANT "Atención Público" TO "Carlos";
GRANT "Atención Público" TO "Sofía";
GRANT "Cajero" TO "Diego";
GRANT "Cajero" TO "Luciana";

REVOKE "Atención Público" FROM "Sofia";