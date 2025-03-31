-- SQL SERVER AGENT
use Empresa_DB
backup database Empresa_DB
to disk='C:\Users\Usuario\backup\respaldo_31032025.bak'
with format, 
     medianame='RespaldoSQL',
     NAME='Full Backup de Empresa_DB'

create or alter procedure realizarrespaldobasedatos
as 
Begin
   set nocount on;
   declare @fechahora nvarchar(100)=
    replace(convert(nvarchar(30), getdate(), 121), ':', '-')


   declare @rutarespaldo nvarchar(200)=
    'C:\respaldos\Empresa_DB_'+@fechahora+'.bak'

   Backup database Empresa_DB
   to disk = @rutarespaldo
   with init,
     name='Respaldo con fecha y hora completa'
end;

execute realizarrespaldobasedatos

Backup database Empresa_db
to disk = @rutarespaldo
with differential,
init, 
name='Respaldo con fecha y hora completa'

-- restaurar la base de datos
create or alter procedure restaurarbasedatos	@rutaarchivo nvarchar(200),	@nombrebase nvarchar(100)asBegin	set nocount on;	if exists (Select name from sys.databases where name=@nombrebase)	Begin		declare @sqlsingle nvarchar(max) =			'alter database ['+ @nombrebase +'] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;' 		EXEC(@sqlsingle)	end	declare @sqlrestore nvarchar(max)='		restore database ['+ @nombrebase + ']		from disk = N'''+@rutaarchivo + '''		with replace,		recovery;'	execute(@sqlrestore)		--Devolver base de datos a modo multiuser	declare @sqlmulti nvarchar(max) =		'alter database [' +@nombrebase +'] set multi_user;'	exec(@sqlmulti)end;

exec restaurarbasedatos
    @rutaarchivo = 'C:\respaldos\Empresa_DB_2025-03-31 09-42-07.113.bak',
    @nombrebase = 'Empresa_DB';

   /*Select * from sys.databases order by name*/

--- Triggers de 

/* 
-- Programar en BD
-- Bloques anónimos
-- Procedimientos almacenados sin parámetros y con parametros
-- Funciones, tipos de funciones
-- Triggers
-- Es programación que se ejecutará antes o despues de realizar
-- las acciones insert, delete, update en una tabla de la base de 
-- datos
Restricciones
===========
1-No puede realizar commit o rollback
2-Debe tener cuidado con los triggers recursivos o infinitivo
3-Tienen impacto en el rendimiento, puede hacer más lenta una operación
4-No puede midificar algunas estructuras, no puede hacer Alter Table, Drop, Create
5- Se limita a los dml(insert, delete, update)
6-No se pueden utilizar directamente para controlar acceso (permisos de usuario)
7-No siempre se pueden utilizar con vistas
8-limitaciones de los triggers INSTEAD OF, se usan con vistas para reemplazar una
operación, pero no pueden coexistir con triggers AFTER O BEFORE
9-Es díficil darle siguimiento a un error en triggers.
10-En algunos SGBD no se puede garantizar el orden de ejecución si ha varios
triggers (after insert) corriendo al mismo tiempo en la misma tabla.
*/

create database inventario
use inventario

create table producto (
productoid int primary key,
descripcion varchar(100),
precio decimal (10,2),
stock int
)

create table ventas (
ventaid int primary key,
productoid int,
cantidadvendida int,
fechaventa datetime,
constraint fk_productoventa foreign key(productoid)
references producto(productoid)
)

create or alter trigger tr_actualizarinventario
on Ventas
after insert
as
Begin
    if exists(select 1 from inserted) and not exists
	(select 1 from deleted)
	begin
	    update p
		set p.stock = p.stock - i.cantidadvendida
		from producto p
		inner join inserted i on p.productoid = i.productoid

		if exists (select 1 from producto where stock < 0 )
		begin
		     Raiserror ('No hay suficiente stock disponible', 16, 1)
			 Rollback transaction
		end
	end
end;

/*
--Combinación de tablas temporales para triggers
Hay datos en las tablas
--Deleted e Inserted estamos realizando un update
--Inserted estamos realizando un insert
--Deleted estamos realizando un delete

*/

insert into producto values(3, 'Monitor', 300.00,15)

select * from producto
select * from ventas
insert into ventas values(1,3,7,GETDATE())
insert into ventas values(2,3,5,GETDATE())
insert into ventas values(3,3,3,GETDATE())
insert into ventas values(4,3,3,GETDATE())