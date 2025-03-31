create database practica_no2;
use practica_no2;

CREATE TABLE Empleados (
 id INT PRIMARY KEY IDENTITY(1,1),
 nombre NVARCHAR(100),
 puesto NVARCHAR(100),
 salario DECIMAL(10, 2)
);