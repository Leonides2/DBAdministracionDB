use master
go

create database SaludPlus 
on Primary
(
name = 'SaludPlus_Data',
Filename ='C:\SQL\Data\SaludPlus_Data.mdf',
 SIZE = 500MB, -- 5000MB  
 MAXSIZE = 1000MB, --100000MB
 FILEGROWTH = 500MB 
)
log on 
(
name = 'SaludPlus',
Filename ='C:\SQL\Log\SaludPlus_Log.ldf',
SIZE = 200MB, --2000MB
MAXSIZE = 500MB,-- 5000MB
FILEGROWTH = 200MB
)

exec sp_helpdb SaludPlus
GO
/*  borrar la base de datos
USE master;
GO
-- Ver todas las conexiones activas a la base de datos
SELECT session_id
FROM sys.dm_exec_sessions
WHERE database_id = DB_ID('SaludPlus');
GO
-- Cerrar todas las conexiones activas a la base de datos
DECLARE @session_id INT;
DECLARE cur CURSOR FOR
SELECT session_id
FROM sys.dm_exec_sessions
WHERE database_id = DB_ID('SaludPlus');

OPEN cur;
FETCH NEXT FROM cur INTO @session_id;

WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC('KILL ' + @session_id);
    FETCH NEXT FROM cur INTO @session_id;
END;

CLOSE cur;
DEALLOCATE cur;
GO
DROP DATABASE SaludPlus;
go
*/
-------------------------------Creacion de FileGroup--------------
use master
go
alter database SaludPlus
add filegroup Recursos
go

Use master 
go 
alter database SaludPlus 
add filegroup Facturacion
go
-------------------------archivos dentro del filegroup
use master
go
alter database SaludPlus
add file
(
    NAME = 'Facturacion_Data',
    FILENAME = 'C:\SQL\Data\Facturacion_Data.ndf',
    SIZE = 200MB, -- 2000MB
    MAXSIZE = 500MB, -- 5000MB
    FILEGROWTH = 200MB
) to filegroup Facturacion
-------------------------------
use Master
go
alter database SaludPlus
add file
(
    NAME = 'Recursos_Data',
    FILENAME = 'C:\SQL\Data\Recursos_Data.ndf',
    SIZE = 200MB, --2000MB
    MAXSIZE = 500MB, --5000MB
    FILEGROWTH = 200MB
)to FILEGROUP Recursos
-------------------------
go
------------------------------creacion de tablas--------------
use SaludPlus
go
create table Cita
( 
ID_Cita int not null,
Fecha_Cita date not null,
Hora_Cita time not null,
ID_Estado_Cita int not null,
ID_Paciente int not null,
ID_Medico int not null,
CONSTRAINT PK_Cita 
PRIMARY KEY CLUSTERED (ID_Cita )
) on 'Facturacion'
go
---------------------------
use SaludPlus
go
create table Estado_Cita
( 
ID_Estado_Cita int not null,
Estado varchar(50) not null,
CONSTRAINT PK_Estado_Cita 
PRIMARY KEY CLUSTERED (ID_Estado_Cita )
) on 'Facturacion'
go
--------------------------
use SaludPlus
go
create table Factura
( 
ID_Factura int not null,
Fecha_Factura date not null,
Monto_Total money not null,
ID_Paciente int not null,
ID_Cita int not null,
ID_Tipo_Pago int not null,
CONSTRAINT PK_Factura 
PRIMARY KEY CLUSTERED (ID_Factura )
) on 'Facturacion'
go
-------------------------
use SaludPlus
go
create table Tipo_Pago
( 
ID_Tipo_Pago int not null,
Descripcion_Tipo_Pago varchar(50) not null,
CONSTRAINT PK_Tipo_Pago
PRIMARY KEY CLUSTERED (ID_Tipo_Pago )
) on 'Facturacion'
go
--------------------------
use SaludPlus
go
create table Paciente
( 
ID_Paciente int not null,
Nombre_Paciente varchar(50) not null,
Apellido1_Paciente varchar(50) not null,
Apellido2_Paciente varchar(50) not null,
Telefono_Paciente varchar(50) not null,
Fecha_Nacimiento date null,
Direccion_Paciente varchar(150) not null,
Cedula varchar(12) not null,
CONSTRAINT PK_Paciente 
PRIMARY KEY CLUSTERED (ID_Paciente )
) on 'Facturacion'
go
---------------------------
use SaludPlus
go
create table Procedimiento
( 
ID_Procedimiento int not null,
Descripcion_Procedimiento varchar(150) not null,
Fecha_Procedimiento date not null,
Hora_Procedimiento time not null,
Monto_Procedimiento money not null,
Receta varchar (150) not null,
ID_Sala int not null,
ID_Historial_Medico int not null,
ID_Cita int not null,
ID_Tipo_Procedimiento int not null,
CONSTRAINT PK_Procedimiento
PRIMARY KEY CLUSTERED (ID_Procedimiento )
) on 'Facturacion'
go
----------------------
use SaludPlus
go
create table Tipo_Procedimiento
( 
ID_Tipo_Procedimiento int not null,
Nombre_Procedimiento varchar(50) not null,
CONSTRAINT PK_Tipo_Procedimiento
PRIMARY KEY CLUSTERED (ID_Tipo_Procedimiento )
) on 'Facturacion'
go
----------------------
use SaludPlus
go
create table Historial_Medico
( 
ID_Historial_Medico int not null,
Fecha_Registro date not null,
ID_Paciente int not null,
CONSTRAINT PK_Historial_Medico
PRIMARY KEY CLUSTERED (ID_Historial_Medico )
) 
go
-------------------
use SaludPlus
go
create table Recurso_Medico
( 
ID_Recurso_Medico int not null,
Nombre_Recurso varchar(50) not null,
Lote varchar(50) not null,
Cantidad_Stock_Total int  null,
Ubicacion_Recurso varchar(150) not null,
ID_Tipo_Recurso int not null,
ID_Estado_Recurso_Medico INT NOT NULL,
CONSTRAINT PK_Recurso_Medico
PRIMARY KEY CLUSTERED (ID_Recurso_Medico )
) on 'Recursos'
go
------------------

use SaludPlus
go
create table Estado_Recurso_Medico
( 
ID_Estado_Recurso_Medico int not null,
Estado_Recurso varchar(50) not null,
CONSTRAINT PK_Estado_Recurso_Medico
PRIMARY KEY CLUSTERED (ID_Estado_Recurso_Medico)
) on 'Recursos'
go
-----------------
use SaludPlus
go
create table Tipo_Recurso
( 
ID_Tipo_Recurso int not null,
Titulo_Recurso varchar(50) not null,
CONSTRAINT PK_Tipo_Recurso
PRIMARY KEY CLUSTERED (ID_Tipo_Recurso)
) on 'Recursos'
go
-----------------
use SaludPlus
go
create table Sala
( 
ID_Sala int not null,
Nombre_Sala varchar(50) not null,
Capacidad_Sala int  not null,
ID_Tipo_Sala int not null,
ID_Estado_Sala int not null,
CONSTRAINT PK_Sala
PRIMARY KEY CLUSTERED (ID_Sala)
) on 'Recursos'
go
-----------------
use SaludPlus
go
create table Estado_Sala
( 
ID_Estado_Sala int not null,
Nombre varchar(50) not null,
CONSTRAINT PK_Estado_Sala
PRIMARY KEY CLUSTERED (ID_Estado_Sala)
) on 'Recursos'
go
------------------
use SaludPlus
go
create table Tipo_Sala
( 
ID_Tipo_Sala int not null,
Descripcion_Tipo_Sala varchar(50) not null,
CONSTRAINT PK_Tipo_Sala
PRIMARY KEY CLUSTERED (ID_Tipo_Sala)
) on 'Recursos'
go
----------------
use SaludPlus
go
create table Recurso_Medico_Sala
( 
ID_Recurso_Medico_Sala int not null,
Fecha date  not null,
Descripcion varchar (150) not null,
ID_Recurso_Medico int not null,
ID_Sala int not null,
CONSTRAINT PK_Recurso_Medico_Sala
PRIMARY KEY CLUSTERED (ID_Recurso_Medico_Sala)
) on 'Recursos'
go
-------------------
use SaludPlus
go
create table Planificacion_Recurso
( 
ID_Planificacion int not null,
Descripcion_Planificacion varchar(150) not null,
Fecha_Planificacion date not null,
ID_Sala int not null,
ID_Horario_Trabajo int not null,
CONSTRAINT PK_Planificacion
PRIMARY KEY CLUSTERED (ID_Planificacion)
) on 'Recursos'
go
-------------------
use SaludPlus
go
create table Medico
( 
ID_Medico int not null,
Nombre1_Medico varchar(50) not null,
Nombre2_Medico varchar(50) null,
Apellido1_Medico varchar(50) not null,
Apellido2_Medico varchar(50) not null,
Telefono_Medico varchar(50)  not null, 
ID_Especialidad int not null,
CONSTRAINT PK_Medico
PRIMARY KEY CLUSTERED (ID_Medico)
) 
go
--------------------
use SaludPlus
go
create table Especialidad
( 
ID_Especialidad int not null,
Nombre_Especialidad varchar(50) not null,
CONSTRAINT PK_Especialidad
PRIMARY KEY CLUSTERED (ID_Especialidad)
) 
go
-------------------

use SaludPlus
go
create table Horario_Trabajo
( 
ID_Horario_Trabajo int not null,
Nombre_Horario varchar(50) not null,
Hora_Inicio time not null,
Hora_Fin time  not null,
CONSTRAINT PK_Horario_Trabajo
PRIMARY KEY CLUSTERED (ID_Horario_Trabajo)
) 
go
---------------------
use SaludPlus
go
create table Medico_Planificacion_Recurso
( 
ID_Medico_Planificacion_Recurso int not null,
Fecha_Planificacion_Personal date not null,
ID_Planificacion int not null,
ID_Medico int not null,
CONSTRAINT PK_Medico_Planificacion_Recurso
PRIMARY KEY CLUSTERED (ID_Medico_Planificacion_Recurso)
) 
go


------------------
use SaludPlus
go
create table Satisfaccion_Paciente
( 
ID_Satisfaccion int not null,
Fecha_Evaluacion date not null,
Calificacion_Satisfaccion int not null, --del 1 al 5
ID_Cita int not null,
CONSTRAINT PK_Satisfaccion_Paciente
PRIMARY KEY CLUSTERED (ID_Satisfaccion)
) 
go
------------------------
use SaludPlus
go
create table Usuario
( 
ID_Usuario int not null,
Nombre_Usuario varchar(50) not null,
Correo_Usuario varchar(50) not null, 
Contraseña_Usuario varchar(50) not null,
ID_Rol int not null, 
CONSTRAINT PK_Usuario
PRIMARY KEY CLUSTERED (ID_Usuario)
) 
go
-------------------------------
use SaludPlus
go
create table Rol
( 
ID_Rol int not null,
Nombre_Rol varchar(50) not null,
CONSTRAINT PK_Rol
PRIMARY KEY CLUSTERED (ID_Rol)
) 
go
----------------------------
use SaludPlus
go
create table  Permiso
( 
ID_Permiso int not null,
Nombre_Permiso varchar(50) not null,
CONSTRAINT PK_Permiso
PRIMARY KEY CLUSTERED (ID_Permiso)
) 
go
--------------------------
use SaludPlus
go
create table Rol_Permiso
( 
ID_Rol_Permiso int not null,
ID_Rol int not null,
ID_Permiso int not null,
CONSTRAINT PK_Rol_Permiso
PRIMARY KEY CLUSTERED (ID_Rol_Permiso)
) 
go
-----------------------------agregar las FK----------
use SaludPlus
go
-- Tabla Cita
alter table Cita
add  
    constraint FK_Cita_Paciente foreign key (ID_Paciente) references Paciente(ID_Paciente),
    constraint FK_Cita_Medico foreign key (ID_Medico) references Medico(ID_Medico),
	constraint FK_Cita_Estado_Cita foreign key (ID_Estado_Cita) references Estado_Cita(ID_Estado_Cita)

go

-- Tabla Factura
alter table Factura
add 
    constraint FK_Factura_Paciente foreign key (ID_Paciente) references Paciente(ID_Paciente),
	constraint FK_Factura_Cita foreign key (ID_Cita) references Cita(ID_Cita),
	constraint FK_Factura_Tipo_Pago foreign key (ID_Tipo_Pago) references Tipo_Pago(ID_Tipo_Pago)

go

-- Tabla Procedimiento
alter table Procedimiento
add
    constraint FK_Procedimiento_Sala foreign key (ID_Sala) references Sala(ID_Sala),
    constraint FK_Procedimiento_Historial_Medico foreign key (ID_Historial_Medico) references Historial_Medico(ID_Historial_Medico),
    constraint FK_Procedimiento_Cita foreign key (ID_Cita) references Cita(ID_Cita),
	constraint FK_Procedimiento_Tipo_Procedimiento foreign key (ID_Tipo_Procedimiento ) references Tipo_Procedimiento (ID_Tipo_Procedimiento )

go


-- Tabla Historial_Medico
alter table Historial_Medico
add  
    constraint FK_Historial_Medico_Paciente foreign key (ID_Paciente) references Paciente(ID_Paciente)
go

-- Tabla Sala
alter table Sala
add
    constraint FK_Sala_Tipo_Sala foreign key (ID_Tipo_Sala) references Tipo_Sala(ID_Tipo_Sala),
    constraint FK_Sala_Estado_Sala foreign key (ID_Estado_Sala) references Estado_Sala(ID_Estado_Sala)

go
-- Tabla Recurso_Medico
alter table Recurso_Medico
add 
    constraint FK_Recurso_Medico_Tipo_Recurso foreign key (ID_Tipo_Recurso) references Tipo_Recurso(ID_Tipo_Recurso),
    constraint FK_Recurso_Estado_Recurso_Medico foreign key (ID_Estado_Recurso_Medico) references Estado_Recurso_Medico(ID_Estado_Recurso_Medico)	
go

-- Tabla Recurso_Medico_Sala
alter table Recurso_Medico_Sala
add 
    constraint FK_Recurso_Medico_Sala_Recurso_Medico foreign key (ID_Recurso_Medico) references Recurso_Medico(ID_Recurso_Medico),
    constraint FK_Recurso_Medico_Sala_Sala foreign key (ID_Sala) references Sala(ID_Sala)
go

-- Tabla Planificacion_Recurso
alter table Planificacion_Recurso
add 
    constraint FK_Planificacion_Recurso_Sala foreign key (ID_Sala) references Sala(ID_Sala),
    constraint FK_Planificacion_Recurso_Horario_Trabajo foreign key (ID_Horario_Trabajo) references Horario_Trabajo(ID_Horario_Trabajo)
go

-- Tabla Medico_Planificacion_Recurso
alter table Medico_Planificacion_Recurso
add 
    constraint FK_Medico_Planificacion_Recurso_Planificacion_Recurso foreign key (ID_Planificacion) references Planificacion_Recurso(ID_Planificacion),
    constraint FK_Medico_Planificacion_Recurso_Medico foreign key (ID_Medico) references Medico(ID_Medico)
go

-- Tabla Satisfaccion_Paciente
alter table Satisfaccion_Paciente
add 
    constraint FK_Satisfaccion_Cita foreign key (ID_Cita) references Cita(ID_Cita) 
go

-- Tabla Usuario
alter table Usuario
add 
    constraint FK_Usuario_Rol foreign key (ID_Rol) references Rol(ID_Rol) 
go

-- Tabla Rol_Permiso
alter table Rol_Permiso
add 
    constraint FK_Rol_Permiso_Rol foreign key (ID_Rol) references Rol(ID_Rol), 
	constraint FK_Rol_Permiso_Permiso foreign key (ID_Permiso) references Permiso(ID_Permiso)
go

--Medico
alter table Medico
add
	constraint FK_Especialidad foreign key(ID_Especialidad) references Especialidad(ID_Especialidad)
go
--------------------------Inserciones--------------------------------------
use SaludPlus;
go
-- Inserciones para la tabla Paciente
INSERT INTO Paciente (ID_Paciente, Nombre_Paciente, Apellido1_Paciente, Apellido2_Paciente, Telefono_Paciente, Fecha_Nacimiento, Direccion_Paciente,Cedula)
VALUES 
(1, 'Juan', 'Perez', 'Gomez', '1234567890', '1980-01-01', 'Calle 1, Ciudad A','12345698'),
(2, 'Maria', 'Lopez', 'Martinez', '2345678901', '1990-02-02', 'Calle 2, Ciudad B',' 123454322'),
(3, 'Carlos', 'Garcia', 'Rodriguez', '3456789012', '1985-03-03', 'Calle 3, Ciudad C','867905532'),
(4, 'Ana', 'Hernandez', 'Sanchez', '4567890123', '1995-04-04', 'Calle 4, Ciudad D','508975568'),
(5, 'Luis', 'Martinez', 'Diaz', '5678901234', '2000-05-05', 'Calle 5, Ciudad E', '186790004');



-- Inserciones para la tabla  Tipo Sala

INSERT INTO Tipo_Sala (ID_Tipo_Sala, Descripcion_Tipo_Sala)
VALUES 
(1, 'Emergencias'),
(2,'Cirugia'),
(3, 'Consulta General'),
(4, 'Observacion'),
(5,'Laboratorio');
go

-- Inserciones para la tabla  Estado Sala

INSERT INTO Estado_Sala(ID_Estado_Sala, Nombre)
VALUES 
(1, 'activa')
go

-- Inserciones para la tabla Sala

INSERT INTO Sala (ID_Sala, Nombre_Sala,	ID_Tipo_Sala, Capacidad_Sala,ID_Estado_Sala)
VALUES 
(1, 'Sala de Emergencias',1 ,5,1),
(2, 'Sala de Cirugía',2,10,1),
(3, 'Consulta General 1',2, 3,1),
(4, 'Sala de Observación', 4,3,1),
(5, 'Laboratorio 1',5,2,1);
go
-- Inserciones para la tabla Especialidad
INSERT INTO Especialidad (ID_Especialidad, Nombre_Especialidad)
VALUES 
(1, 'Cardiología'),
(2, 'Dermatología'),
(3, 'Radioloía'),
(4, 'Pediatría'),
(5, 'Cirugía');
go



-- Inserciones para la tabla Medico
INSERT INTO Medico (ID_Medico, Nombre1_Medico, Nombre2_Medico, Apellido1_Medico, Apellido2_Medico, Telefono_Medico,ID_Especialidad)
VALUES 
(1, 'Pedro', 'Jose', 'Ramirez', 'Fernandez', '6789012345',1),
(2, 'Laura', 'Maria', 'Gonzalez', 'Lopez', '7890123456',2),
(3, 'Miguel', 'Angel', 'Torres', 'Perez', '8901234567',3),
(4, 'Sofia', 'Elena', 'Vargas', 'Garcia', '9012345678',4),
(5, 'Diego', 'Luis', 'Castro', 'Martinez', '1234567890',5);
go

-- Inserciones para la tabla Estado Cita
INSERT INTO Estado_Cita (ID_Estado_Cita, Estado)
VALUES 
(1,  'Programada'),   
(2, 'Realizada'),
(3, 'Cancelada')
go

-- Inserciones para la tabla Cita
INSERT INTO Cita (ID_Cita, Fecha_Cita, Hora_Cita, ID_Estado_Cita, ID_Paciente, ID_Medico)
VALUES 
(1, '2024-01-01', '08:00', 1, 1, 1),   
(2, '2024-02-01', '09:00', 2, 2, 2),
(3, '2024-03-01', '10:00', 3, 3, 3),
(4, '2024-04-01', '11:00', 1, 4, 4),
(5, '2024-05-01', '12:00', 2, 5, 5);
go

-- Inserciones para la tabla Tipo pago
INSERT INTO Tipo_Pago(ID_Tipo_Pago, Descripcion_Tipo_Pago)
VALUES 
(1, 'Efectivo'),
(2, 'Tarjeta de credito'),
(3, 'Tarjeta de debito'),
(4, 'Transferencia Bancaria'),
(5, 'Sinpe Movil');
go

-- Inserciones para la tabla facturas
INSERT INTO Factura (ID_Factura, Fecha_Factura, Monto_Total, ID_Paciente,ID_Cita,ID_Tipo_Pago)
VALUES 
(1, '2024-01-01', 1000.00, 1,1,1),
(2, '2024-02-01', 2000.00, 2,2,2),
(3, '2024-03-01', 3000.00, 3,3,3),
(4, '2024-04-01', 4000.00, 4,4,4),
(5, '2024-05-01', 5000.00, 5,5,5);
go



-- Inserciones para la tabla Historial_Medico
INSERT INTO Historial_Medico (ID_Historial_Medico, Fecha_Registro, ID_Paciente)
VALUES 
(1, '2024-01-01', 1),   
(2, '2024-02-01', 2),
(3, '2024-03-01', 3),
(4, '2024-04-01', 4),
(5, '2024-05-01', 5);
go

-- Inserciones para la tabla Tipo Procedimiento
INSERT INTO Tipo_Procedimiento(ID_Tipo_Procedimiento, Nombre_Procedimiento)
VALUES 
(1, 'Cita de Cirugía'),   
(2, 'Cita de Laboratorio'),
(3, 'Cita de Consulta General'),
(4, 'Emergencias'),
(5, 'Cita de Diagnostico');
go

-- Inserciones para la tabla Procedimiento
INSERT INTO Procedimiento (ID_Procedimiento, Descripcion_Procedimiento, Fecha_Procedimiento,Hora_Procedimiento,Monto_Procedimiento,Receta, ID_Sala, ID_Historial_Medico, ID_Cita,ID_Tipo_Procedimiento)
VALUES 
(1, 'Cirugía de corazon', '2024-01-01','14:00', 10000, 'Ibuprofeno cada seis horas por tres días', 1,1,1,1), 
(2, 'Entrada de emergencia por pierna lesionada', '2024-02-01','12:30', 200000, 'Ibuprofeno cada seis horas por 5 días', 2,2,2,4),
(3, 'Enfermedad de piel', '2024-03-01',' 9:00', 30000, 'Paracetamol cada ocho horas por cinco días', 3,3,3,3),
(4, 'Por dolores fuertes de cabeza', '2024-04-01','10:00', 400000, 'Paracetamol cada ocho horas por siete días', 4,4,4,3),
(5, 'Laboratorio de cardiología', '2024-05-01','15:00', 5000000, 'Ibuprofeno cada seis horas por seis días', 5,5,5,2);
go


-- Inserciones para la tabla Satisfaccion_Paciente
INSERT INTO Satisfaccion_Paciente (ID_Satisfaccion, Fecha_Evaluacion, Calificacion_Satisfaccion, ID_Cita)
VALUES 
(1, '2024-01-02', 5, 1),
(2, '2024-02-02', 4, 2),
(3, '2024-03-02', 3, 3),
(4, '2024-04-02', 2, 4),
(5, '2024-05-02', 1, 5);
go

-- Inserciones para la tabla Tipo_Recurso
insert into Tipo_Recurso (ID_Tipo_Recurso, Titulo_Recurso)
values 
(1, 'Medicamento'),
(2, 'Equipo Médico'),
(3, 'Material de Oficina'),
(4, 'Instrumento Quirúrgico'),
(5, 'Suministro Médico');
go

-- Inserciones para la tabla Estado_Recurso_Medico
insert into Estado_Recurso_Medico (ID_Estado_Recurso_Medico, Estado_Recurso)
values 
(1,'Disponible'),
(2, 'Agotado')
go

-- Inserciones para la tabla Recurso_Medico
insert into Recurso_Medico (ID_Recurso_Medico, Nombre_Recurso, Lote, Cantidad_Stock_Total, Ubicacion_Recurso, ID_Tipo_Recurso,ID_Estado_Recurso_Medico)
values 
(1, 'Recurso 1', 'Lote 1', 100, 'Almacén 1', 1, 1),
(2, 'Recurso 2', 'Lote 2', 200, 'Almacén 2', 2, 2),
(3, 'Recurso 3', 'Lote 3', 300, 'Almacén 3', 3, 1),
(4, 'Recurso 4', 'Lote 4', 400,  'Almacén 4', 4, 2),
(5, 'Recurso 5', 'Lote 5', 500,'Almacén 5', 5, 1);
go

-- Inserciones para la tabla Horario_Trabajo
insert into Horario_Trabajo (ID_Horario_Trabajo, Nombre_Horario, Hora_Inicio, Hora_Fin)
values 
(1, 'Mañana', '08:00', '12:00'),
(2, 'Tarde', '13:00', '17:00'),
(3, 'Noche', '18:00', '22:00'),
(4, 'Madrugada', '23:00', '03:00'),
(5, 'Completo', '08:00', '17:00');
go 

-- Inserciones para la tabla Planificacion_Recurso
insert into Planificacion_Recurso (ID_Planificacion, Descripcion_Planificacion, Fecha_Planificacion, ID_Sala, ID_Horario_Trabajo)
values 
(1, 'Planificación 1', '2024-01-01',  1, 1),
(2, 'Planificación 2', '2024-02-01', 2, 2),
(3, 'Planificación 3', '2024-03-01',  3, 3),
(4, 'Planificación 4', '2024-04-01',  4, 4),
(5, 'Planificación 5', '2024-05-01', 5, 5);
go


--- Inserciones de la tabla Medico_Planificacion_Recurso
insert into Medico_Planificacion_Recurso (ID_Medico_Planificacion_Recurso,Fecha_Planificacion_Personal,ID_Medico,ID_Planificacion)
VALUES
(1,'2024-01-01',1,1),
(2,'2024-01-01',2,2),
(3,'2024-01-01',3,3),
(4,'2024-01-01',4,4),
(5,'2024-01-01',5,5);
GO

-- Inserciones para la tabla Recurso_Medico_Sala
insert into Recurso_Medico_Sala (ID_Recurso_Medico_Sala, Fecha, Descripcion, ID_Recurso_Medico, ID_Sala)
values 
(1,'2024-01-01', 'Sala tiene 20 recursos',1, 1),
(2,'2024-01-01', 'Sala tiene 30 recursos',2, 2),
(3, '2024-01-01','Sala tiene 40 recursos', 3, 3),
(4, '2024-01-01','Sala tiene 50 recursos', 4, 4),
(5, '2024-01-01','Sala tiene 60 recursos', 5, 5);
go

----Inserciones de Rol
INSERT INTO Rol (ID_Rol, Nombre_Rol) 
VALUES
(1, 'Administrador'),
(2, 'Médico'),
(3, 'Recepcionista');
go

------------Insercion para el Usuario
INSERT INTO Usuario (ID_Usuario, Nombre_Usuario, Correo_Usuario, Contraseña_Usuario, ID_Rol) 
VALUES
(1, 'Juan Pérez', 'juan.perez@saludplus.com', 'contraseña123', 1),  
(2, 'María Gómez', 'maria.gomez@saludplus.com', 'contraseña456', 2),  
(3, 'Carlos López', 'carlos.lopez@saludplus.com', 'contraseña789', 3);
go

--------Inserciones de permisos
INSERT INTO Permiso (ID_Permiso, Nombre_Permiso) 
VALUES 
(1, 'Crear Citas'),
(2, 'Ver Citas'),
(3, 'Modificar Citas'),
(4, 'Eliminar Citas'),
(5, 'Acceso a Historial Médico'),
(6, 'Gestionar Pacientes');
go

------------- Rol_Permisos
INSERT INTO Rol_Permiso (ID_Rol_Permiso, ID_Rol, ID_Permiso) 
VALUES 
(1, 1, 1),  -- Administrador puede crear citas
(2, 1, 2),  -- Administrador puede ver citas
(3, 1, 3),  -- Administrador puede modificar citas
(4, 1, 4),  -- Administrador puede eliminar citas
(5, 1, 5),  -- Administrador puede acceder a historial médico
(6, 1, 6);  -- Administrador puede gestionar pacientes
go


--------------------------------------------------Procedimientos almacenados INSERT------------------------------
---------------------Registrar Paciente
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarPaciente
(
    @ID_Paciente INT,
    @Nombre_Paciente VARCHAR(50),
    @Apellido1_Paciente VARCHAR(50),
    @Apellido2_Paciente VARCHAR(50),
    @Telefono_Paciente VARCHAR(50),
    @Fecha_Nacimiento DATE,
    @Direccion_Paciente VARCHAR(150),
    @Cedula VARCHAR(12)
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO Paciente (ID_Paciente, Nombre_Paciente, Apellido1_Paciente, Apellido2_Paciente, Telefono_Paciente, Fecha_Nacimiento, Direccion_Paciente, Cedula)
        VALUES (@ID_Paciente, @Nombre_Paciente, @Apellido1_Paciente, @Apellido2_Paciente, @Telefono_Paciente, @Fecha_Nacimiento, @Direccion_Paciente, @Cedula);

        PRINT 'El paciente se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el paciente: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

USE SaludPlus
GO

-- Insertar paciente 1
EXEC Sp_RegistrarPaciente @ID_Paciente = 6, @Nombre_Paciente = 'Pedro', @Apellido1_Paciente = 'Fernandez', @Apellido2_Paciente = 'Torres',
    @Telefono_Paciente = '5678901122',@Fecha_Nacimiento = '1988-06-06',@Direccion_Paciente = 'Calle 6, Ciudad F',@Cedula = '987654321';
	go

-- Insertar paciente 2
EXEC Sp_RegistrarPaciente @ID_Paciente = 7, @Nombre_Paciente = 'Lucia', @Apellido1_Paciente = 'Cruz',@Apellido2_Paciente = 'Mendez', 
    @Telefono_Paciente = '6789012233',@Fecha_Nacimiento = '1992-07-07',@Direccion_Paciente = 'Calle 7, Ciudad G',@Cedula = '456789012';
	go

-- Insertar paciente 3
EXEC Sp_RegistrarPaciente @ID_Paciente = 8,@Nombre_Paciente = 'Fernando',@Apellido1_Paciente = 'Ramirez',@Apellido2_Paciente = 'Soto', 
    @Telefono_Paciente = '7890123344',@Fecha_Nacimiento = '1982-08-08',@Direccion_Paciente = 'Calle 8, Ciudad H',@Cedula = '654321789';
	go

-- Insertar paciente 4
EXEC Sp_RegistrarPaciente @ID_Paciente = 9,@Nombre_Paciente = 'Isabella',@Apellido1_Paciente = 'Alvarez',@Apellido2_Paciente = 'Paredes', 
    @Telefono_Paciente = '8901234455',@Fecha_Nacimiento = '1995-09-09',@Direccion_Paciente = 'Calle 9, Ciudad I',@Cedula = '321654987';
	go

------------Registrar Especialidad
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarEspecialidad
(
    @ID_Especialidad INT,
    @Nombre_Especialidad VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
	 -- Verificar si el nombre de la especialidad ya existe
    IF EXISTS (SELECT 1 FROM Especialidad WHERE Nombre_Especialidad = @Nombre_Especialidad)
    BEGIN
        RAISERROR('El nombre de la especialidad ya existe.', 16, 1);
        RETURN;
    END
    BEGIN TRY
        INSERT INTO Especialidad (ID_Especialidad, Nombre_Especialidad)
        VALUES (@ID_Especialidad, @Nombre_Especialidad);

        PRINT 'La especialidad se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar la especialidad: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Insertar especialidad 1
EXEC Sp_RegistrarEspecialidad @ID_Especialidad = 6,@Nombre_Especialidad = 'Ginecología';
go

-- Insertar especialidad 2
EXEC Sp_RegistrarEspecialidad @ID_Especialidad = 7,@Nombre_Especialidad = 'Psiquiatría';
go

------------------------Registrar Medico
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarMedico
(
    @ID_Medico INT,
    @Nombre1_Medico VARCHAR(50),
    @Nombre2_Medico VARCHAR(50),
    @Apellido1_Medico VARCHAR(50),
    @Apellido2_Medico VARCHAR(50),
    @Telefono_Medico VARCHAR(50),
    @ID_Especialidad INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si la especialidad existe
    IF NOT EXISTS (SELECT 1 FROM Especialidad WHERE ID_Especialidad = @ID_Especialidad)
    BEGIN
        RAISERROR('El ID de especialidad no existe.', 16, 1);
        RETURN;
    END
	-- Verificar si el médico ya tiene una especialidad asignada
    IF EXISTS (SELECT 1 FROM Medico WHERE ID_Medico = @ID_Medico AND ID_Especialidad IS NOT NULL)
    BEGIN
        RAISERROR('El médico ya tiene una especialidad asignada.', 16, 1);
        RETURN;
    END
    BEGIN TRY
        INSERT INTO Medico (ID_Medico, Nombre1_Medico, Nombre2_Medico, Apellido1_Medico, Apellido2_Medico, Telefono_Medico, ID_Especialidad)
        VALUES (@ID_Medico, @Nombre1_Medico, @Nombre2_Medico, @Apellido1_Medico, @Apellido2_Medico, @Telefono_Medico, @ID_Especialidad);

        PRINT 'El médico se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el médico: ' + ERROR_MESSAGE();
    END CATCH
END;
GO



-- Insertar médico 1
EXEC Sp_RegistrarMedico @ID_Medico = 6,@Nombre1_Medico = 'Antonio',@Nombre2_Medico = 'Luis',@Apellido1_Medico = 'Salazar',@Apellido2_Medico = 'Jimenez', 
    @Telefono_Medico = '2345678901',@ID_Especialidad = 1; -- Cardiología
	go

-- Insertar médico 2
EXEC Sp_RegistrarMedico @ID_Medico = 7,@Nombre1_Medico = 'Carmen',@Nombre2_Medico = 'Teresa',@Apellido1_Medico = 'Ruiz',@Apellido2_Medico = 'Mena', 
    @Telefono_Medico = '3456789012',@ID_Especialidad = 2; -- Dermatología
	go
-- Insertar médico 3
EXEC Sp_RegistrarMedico @ID_Medico = 8,@Nombre1_Medico = 'Francisco',@Nombre2_Medico = 'Javier',@Apellido1_Medico = 'Hernandez',@Apellido2_Medico = 'Bermudez', 
    @Telefono_Medico = '4567890123',@ID_Especialidad = 3; -- Radiología
	go

-- Insertar médico 4
EXEC Sp_RegistrarMedico @ID_Medico = 9,@Nombre1_Medico = 'Elena',@Nombre2_Medico = 'Cristina',@Apellido1_Medico = 'Alvarez',@Apellido2_Medico = 'Luna', 
    @Telefono_Medico = '5678901234',@ID_Especialidad = 4; -- Pediatría
	go

-- Insertar médico 5
EXEC Sp_RegistrarMedico @ID_Medico = 10,@Nombre1_Medico = 'Ricardo',@Nombre2_Medico = 'Andrés',@Apellido1_Medico = 'Morales',@Apellido2_Medico = 'Santos', 
    @Telefono_Medico = '6789012345',@ID_Especialidad = 5; -- Cirugía
	go

-------Registrar Estado de la cita
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarEstadoCita
(
    @ID_Estado_Cita INT,
    @Estado VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
	-- Verificar si el estado ya existe
    IF EXISTS (SELECT 1 FROM Estado_Cita WHERE Estado = @Estado)
    BEGIN
        RAISERROR('El estado de cita ya existe.', 16, 1);
        RETURN;
    END
    BEGIN TRY
        INSERT INTO Estado_Cita (ID_Estado_Cita, Estado)
        VALUES (@ID_Estado_Cita, @Estado);

        PRINT 'El estado de cita se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el estado de cita: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Insertar estado de cita 1
EXEC Sp_RegistrarEstadoCita @ID_Estado_Cita = 4, @Estado = 'En Espera';
go

-- Insertar estado de cita 2
EXEC Sp_RegistrarEstadoCita @ID_Estado_Cita = 5,@Estado = 'No Asistió';
go
-- Insertar estado de cita 3
EXEC Sp_RegistrarEstadoCita @ID_Estado_Cita = 6, @Estado = 'Finalizada';
go

---------------Registrar Cita
Use SaludPlus
go
CREATE PROCEDURE Sp_RegistrarCita
(
    @ID_cita INT,
	@Fecha_Cita DATE,
    @Hora_Cita TIME,
    @ID_Paciente INT,
    @ID_Medico INT,
	@ID_Estado_Cita  INT
)
AS
BEGIN
 IF NOT EXISTS (SELECT 1 FROM Paciente WHERE ID_Paciente = @ID_Paciente)
        BEGIN
            RAISERROR('El ID de paciente no existe.', 16, 1);
            RETURN;
        END

    IF NOT EXISTS (SELECT 1 FROM Medico WHERE ID_Medico = @ID_Medico)
        BEGIN
            RAISERROR('El ID de la especialidad médico no existe.', 16, 2);
            RETURN;
        END
		IF NOT EXISTS (SELECT 1 FROM Estado_Cita WHERE ID_Estado_Cita = @ID_Estado_Cita)
        BEGIN
            RAISERROR('El ID del estado de la cita no existe.', 16, 2);
            RETURN;
	END
	 -- Verificar si el paciente ya tiene una cita a la misma hora y fecha
    IF EXISTS (SELECT 1 FROM Cita WHERE ID_Paciente = @ID_Paciente AND Fecha_Cita = @Fecha_Cita AND Hora_Cita = @Hora_Cita)
    BEGIN
        RAISERROR('El paciente ya tiene una cita a la misma hora y fecha.', 16, 3);
        RETURN;
    END
	BEGIN TRY
    INSERT INTO Cita (ID_Cita,Fecha_Cita, Hora_Cita, ID_Paciente, ID_Medico, ID_Estado_Cita)
    VALUES (@ID_cita,@Fecha_Cita, @Hora_Cita, @ID_Paciente, @ID_Medico,@ID_Estado_Cita);

	PRINT 'La cita se ha registrado correctamente';
	END TRY
    BEGIN CATCH
    PRINT 'Error al registrar la cita: ' + ERROR_MESSAGE();
    END CATCH
	END;
GO

-- Insertar cita 2

execute Sp_RegistrarCita @ID_cita= 6, @Fecha_Cita= '2024-01-01',  @Hora_Cita= '08:00', @ID_Paciente=5 , @ID_Medico=1, @ID_Estado_Cita =1
go
-- Insertar cita 2
EXEC Sp_RegistrarCita @ID_cita = 6,@Fecha_Cita = '2024-06-01',@Hora_Cita = '08:30',@ID_Paciente = 2,@ID_Medico = 2,@ID_Estado_Cita = 1;
go
-- Insertar cita 3
EXEC Sp_RegistrarCita  @ID_cita = 7,@Fecha_Cita = '2024-07-01',@Hora_Cita = '09:30',@ID_Paciente = 2,@ID_Medico = 3,@ID_Estado_Cita = 2;
go
-- Insertar cita 4
EXEC Sp_RegistrarCita @ID_cita = 8,@Fecha_Cita = '2024-08-01',@Hora_Cita = '10:30',@ID_Paciente = 3,@ID_Medico = 4,@ID_Estado_Cita = 3;
go
-- Insertar cita 5
EXEC Sp_RegistrarCita @ID_cita = 9,@Fecha_Cita = '2024-09-01',@Hora_Cita = '11:30', @ID_Paciente = 6,@ID_Medico = 5,@ID_Estado_Cita = 1;
go
-- Insertar cita 6
EXEC Sp_RegistrarCita @ID_cita = 10,@Fecha_Cita = '2024-09-01',@Hora_Cita = '14:30',@ID_Paciente = 7,@ID_Medico = 7,@ID_Estado_Cita = 2;
go

-----------------Tipo de Pago
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarTipoPago
(
    @ID_Tipo_Pago INT,
    @Descripcion_Tipo_Pago VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
	-- Verificar si el tipo de pago ya existe
    IF EXISTS (SELECT 1 FROM Tipo_Pago WHERE Descripcion_Tipo_Pago = @Descripcion_Tipo_Pago)
    BEGIN
        RAISERROR('El tipo de pago ya existe.', 16, 1);
        RETURN;
    END
    BEGIN TRY
        INSERT INTO Tipo_Pago (ID_Tipo_Pago, Descripcion_Tipo_Pago)
        VALUES (@ID_Tipo_Pago, @Descripcion_Tipo_Pago);

        PRINT 'El tipo de pago se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el tipo de pago: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
--------------Registrar Factura
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarFactura
(
    @ID_Factura INT,
	@Fecha_Factura DATE,
    @Monto_Total MONEY,
    @ID_Paciente INT,
    @ID_Cita INT,
	@ID_Tipo_Pago INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el paciente existe
    IF NOT EXISTS (SELECT 1 FROM Paciente WHERE ID_Paciente = @ID_Paciente)
        BEGIN
            RAISERROR('El ID de paciente no existe.', 16, 1);
            RETURN;
        END
		 -- Verificar si la cita existe
    IF NOT EXISTS (SELECT 1 FROM Cita WHERE ID_Cita = @ID_Cita)
        BEGIN
            RAISERROR('El ID de cita no existe.', 16, 1);
            RETURN;
        END
		 
		 -- Verificar si el tipo de pago existe
    IF NOT EXISTS (SELECT 1 FROM	Tipo_Pago WHERE ID_Tipo_Pago = @ID_Tipo_Pago)
        BEGIN
            RAISERROR('El ID del tipo de pago no existe.', 16, 1);
            RETURN;
        END
    BEGIN TRY
        INSERT INTO Factura (ID_Factura,Fecha_Factura, Monto_Total, ID_Paciente, ID_Cita,ID_Tipo_Pago)
        VALUES (@ID_Factura,@Fecha_Factura, @Monto_Total, @ID_Paciente, @ID_Cita,@ID_Tipo_Pago);

        PRINT 'La factura se ha registrado correctamente.'
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar la factura: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Insertar factura 1
EXEC Sp_RegistrarFactura @ID_Factura = 6, @Fecha_Factura = '2024-06-01', @Monto_Total = 1500.00,@ID_Paciente = 1,@ID_Cita = 1,@ID_Tipo_Pago = 1;
go
-- Insertar factura 2
EXEC Sp_RegistrarFactura @ID_Factura = 7,@Fecha_Factura = '2024-07-01',@Monto_Total = 2500.00,@ID_Paciente = 2,@ID_Cita = 2, @ID_Tipo_Pago = 2;
go
-- Insertar factura 3
EXEC Sp_RegistrarFactura @ID_Factura = 8,@Fecha_Factura = '2024-08-01',@Monto_Total = 3500.00,@ID_Paciente = 3,@ID_Cita = 3,@ID_Tipo_Pago = 3;
go
-- Insertar factura 4
EXEC Sp_RegistrarFactura @ID_Factura = 9,@Fecha_Factura = '2024-09-01',@Monto_Total = 4500.00,@ID_Paciente = 4,@ID_Cita = 4,@ID_Tipo_Pago = 4;
go
-- Insertar factura 5
EXEC Sp_RegistrarFactura @ID_Factura = 10,@Fecha_Factura = '2024-10-01',@Monto_Total = 5500.00,@ID_Paciente = 5,@ID_Cita = 5,@ID_Tipo_Pago = 5;
go

--------------------Insertar Historial Medico
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarHistorialMedico
(
    @ID_Historial_Medico INT,
    @Fecha_Registro DATE,
    @ID_Paciente INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el paciente existe
    IF NOT EXISTS (SELECT 1 FROM Paciente WHERE ID_Paciente = @ID_Paciente)
    BEGIN
        RAISERROR('El ID de paciente no existe.', 16, 1);
        RETURN;
    END
	IF EXISTS (SELECT 1 FROM Historial_Medico WHERE ID_Paciente = @ID_Paciente)
    BEGIN
        RAISERROR('El paciente ya tiene un historial médico registrado.', 16, 2);
        RETURN;
    END

    BEGIN TRY
        INSERT INTO Historial_Medico (ID_Historial_Medico, Fecha_Registro, ID_Paciente)
        VALUES (@ID_Historial_Medico, @Fecha_Registro, @ID_Paciente);

        PRINT 'El historial médico se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el historial médico: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


-- Insertar historial médico 1
EXEC Sp_RegistrarHistorialMedico @ID_Historial_Medico = 6,@Fecha_Registro = '2024-06-01',@ID_Paciente = 6;
go
-- Insertar historial médico 2
EXEC Sp_RegistrarHistorialMedico @ID_Historial_Medico = 7,@Fecha_Registro = '2024-07-01',@ID_Paciente = 7;
go
-- Insertar historial médico 3
EXEC Sp_RegistrarHistorialMedico @ID_Historial_Medico = 8,@Fecha_Registro = '2024-08-01',@ID_Paciente = 8;
go
-- Insertar historial médico 4
EXEC Sp_RegistrarHistorialMedico @ID_Historial_Medico = 9,@Fecha_Registro = '2024-09-01',@ID_Paciente = 9;
go


-----------Insertar Estado de la Sala
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarEstadoSala
(
    @ID_Estado_Sala INT,
    @Nombre VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
	-- Verificar si el nombre del estado de sala ya existe
    IF EXISTS (SELECT 1 FROM Estado_Sala WHERE Nombre = @Nombre)
    BEGIN
        RAISERROR('El nombre del estado de sala ya existe.', 16, 1);
        RETURN;
    END
    BEGIN TRY
        INSERT INTO Estado_Sala (ID_Estado_Sala, Nombre)
        VALUES (@ID_Estado_Sala, @Nombre);

        PRINT 'El estado de sala se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el estado de sala: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Insertar estado de sala 1
EXEC Sp_RegistrarEstadoSala @ID_Estado_Sala = 2,@Nombre = 'inactiva';
go
-- Insertar estado de sala 2
EXEC Sp_RegistrarEstadoSala @ID_Estado_Sala = 3,@Nombre = 'en mantenimiento';
go
-- Insertar estado de sala 3
EXEC Sp_RegistrarEstadoSala @ID_Estado_Sala = 4,@Nombre = 'cerrada';
go

------------------Registrar Tipo de Sala
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarTipoSala
(
    @ID_Tipo_Sala INT,
    @Descripcion_Tipo_Sala VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
	-- Verificar si la descripción del tipo de sala ya existe
    IF EXISTS (SELECT 1 FROM Tipo_Sala WHERE Descripcion_Tipo_Sala = @Descripcion_Tipo_Sala)
    BEGIN
        RAISERROR('La descripción del tipo de sala ya existe.', 16, 1);
        RETURN;
    END
    BEGIN TRY
        INSERT INTO Tipo_Sala (ID_Tipo_Sala, Descripcion_Tipo_Sala)
        VALUES (@ID_Tipo_Sala, @Descripcion_Tipo_Sala);

        PRINT 'El tipo de sala se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el tipo de sala: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Insertar tipo de sala 1
EXEC Sp_RegistrarTipoSala @ID_Tipo_Sala = 6,@Descripcion_Tipo_Sala = 'Ginecología';
go
-- Insertar tipo de sala 2
EXEC Sp_RegistrarTipoSala @ID_Tipo_Sala = 7,@Descripcion_Tipo_Sala = 'Traumatología';
go
-- Insertar tipo de sala 3
EXEC Sp_RegistrarTipoSala @ID_Tipo_Sala = 8,@Descripcion_Tipo_Sala = 'Cardiología';
go
-- Insertar tipo de sala 5
EXEC Sp_RegistrarTipoSala @ID_Tipo_Sala = 9,@Descripcion_Tipo_Sala = 'Oncología';
go

-------------------Insertar Sala  
Use SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarSala
(
    @ID_Sala INT,
    @Nombre_Sala VARCHAR(50),
    @Capacidad_Sala INT,
    @ID_Tipo_Sala INT,
    @ID_Estado_Sala INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el tipo y estado de sala existen
    IF NOT EXISTS (SELECT 1 FROM Tipo_Sala WHERE ID_Tipo_Sala = @ID_Tipo_Sala)
    BEGIN
        RAISERROR('El ID de tipo de sala no existe.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Estado_Sala WHERE ID_Estado_Sala = @ID_Estado_Sala)
    BEGIN
        RAISERROR('El ID de estado de sala no existe.', 16, 1);
        RETURN;
    END
	-- Verificar si el nombre de la sala ya existe
    IF EXISTS (SELECT 1 FROM Sala WHERE Nombre_Sala = @Nombre_Sala)
    BEGIN
        RAISERROR('El nombre de la sala ya existe.', 16, 1);
        RETURN;
    END
    BEGIN TRY
        INSERT INTO Sala (ID_Sala, Nombre_Sala, Capacidad_Sala, ID_Tipo_Sala, ID_Estado_Sala)
        VALUES (@ID_Sala, @Nombre_Sala, @Capacidad_Sala, @ID_Tipo_Sala, @ID_Estado_Sala);

        PRINT 'La sala se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar la sala: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Insertar sala 1
EXEC Sp_RegistrarSala @ID_Sala = 6,@Nombre_Sala = 'Sala de Ginecología',@Capacidad_Sala = 4,@ID_Tipo_Sala = 2,@ID_Estado_Sala = 3;
go
-- Insertar sala 2
EXEC Sp_RegistrarSala @ID_Sala = 7,@Nombre_Sala = 'Sala de Traumatología',@Capacidad_Sala = 5,@ID_Tipo_Sala = 3,@ID_Estado_Sala = 2;
go
-- Insertar sala 3
EXEC Sp_RegistrarSala @ID_Sala = 8,@Nombre_Sala = 'Sala de Cardiología',@Capacidad_Sala = 3,@ID_Tipo_Sala = 4,@ID_Estado_Sala = 1;
go


------------------Registrar Tipo de Procedimiento 
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarTipoProcedimiento
(
    @ID_Tipo_Procedimiento INT,
    @Nombre_Procedimiento VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
	-- Verificar si el nombre del tipo de procedimiento ya existe
    IF EXISTS (SELECT 1 FROM Tipo_Procedimiento WHERE Nombre_Procedimiento = @Nombre_Procedimiento)
    BEGIN
        RAISERROR('El nombre del tipo de procedimiento ya existe.', 16, 1);
        RETURN;
    END
    BEGIN TRY
        INSERT INTO Tipo_Procedimiento (ID_Tipo_Procedimiento, Nombre_Procedimiento)
        VALUES (@ID_Tipo_Procedimiento, @Nombre_Procedimiento);

        PRINT 'El tipo de procedimiento se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el tipo de procedimiento: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
-- Insertar tipo de procedimiento 1
EXEC Sp_RegistrarTipoProcedimiento @ID_Tipo_Procedimiento = 6,@Nombre_Procedimiento = 'Cita de Ginecología';
go
-- Insertar tipo de procedimiento 2
EXEC Sp_RegistrarTipoProcedimiento  @ID_Tipo_Procedimiento = 7,@Nombre_Procedimiento = 'Cita de Traumatología';
go
-- Insertar tipo de procedimiento 3
EXEC Sp_RegistrarTipoProcedimiento @ID_Tipo_Procedimiento = 8,@Nombre_Procedimiento = 'Cita de Cardiología';
go

---------------------Registrar Procedimiento
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarProcedimiento
(
    @ID_Procedimiento INT,
    @Descripcion_Procedimiento VARCHAR(150),
    @Fecha_Procedimiento DATE,
    @Hora_Procedimiento TIME,
    @Monto_Procedimiento MONEY,
    @Receta VARCHAR(150),
    @ID_Sala INT,
    @ID_Historial_Medico INT,
    @ID_Cita INT,
    @ID_Tipo_Procedimiento INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificaciones para ID_Sala, ID_Historial_Medico, ID_Cita y ID_Tipo_Procedimiento
    IF NOT EXISTS (SELECT 1 FROM Sala WHERE ID_Sala = @ID_Sala)
    BEGIN
        RAISERROR('El ID de sala no existe.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Historial_Medico WHERE ID_Historial_Medico = @ID_Historial_Medico)
    BEGIN
        RAISERROR('El ID de historial médico no existe.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Cita WHERE ID_Cita = @ID_Cita)
    BEGIN
        RAISERROR('El ID de cita no existe.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Tipo_Procedimiento WHERE ID_Tipo_Procedimiento = @ID_Tipo_Procedimiento)
    BEGIN
        RAISERROR('El ID de tipo de procedimiento no existe.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        INSERT INTO Procedimiento (ID_Procedimiento, Descripcion_Procedimiento, Fecha_Procedimiento, Hora_Procedimiento, Monto_Procedimiento, Receta, ID_Sala, ID_Historial_Medico, ID_Cita, ID_Tipo_Procedimiento)
        VALUES (@ID_Procedimiento, @Descripcion_Procedimiento, @Fecha_Procedimiento, @Hora_Procedimiento, @Monto_Procedimiento, @Receta, @ID_Sala, @ID_Historial_Medico, @ID_Cita, @ID_Tipo_Procedimiento);

        PRINT 'El procedimiento se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el procedimiento: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC Sp_RegistrarProcedimiento @ID_Procedimiento = 6,@Descripcion_Procedimiento = 'Consulta de medicina interna',@Fecha_Procedimiento = '2024-08-01', 
    @Hora_Procedimiento = '11:00',@Monto_Procedimiento = 5000,@Receta = 'Reposo y seguimiento',@ID_Sala = 1,@ID_Historial_Medico = 6,@ID_Cita = 6,@ID_Tipo_Procedimiento = 1;
	go
EXEC Sp_RegistrarProcedimiento @ID_Procedimiento = 7,@Descripcion_Procedimiento = 'Examen de laboratorio',@Fecha_Procedimiento = '2024-08-15',
    @Hora_Procedimiento = '09:30',@Monto_Procedimiento = 1500,@Receta = 'Ninguna',@ID_Sala = 2,@ID_Historial_Medico = 7,@ID_Cita = 7,@ID_Tipo_Procedimiento = 2;
	go
EXEC Sp_RegistrarProcedimiento @ID_Procedimiento = 8,@Descripcion_Procedimiento = 'Radiografía de abdomen',@Fecha_Procedimiento = '2024-08-20',
    @Hora_Procedimiento = '13:00',@Monto_Procedimiento = 2000,@Receta = 'Ninguna',@ID_Sala = 3,@ID_Historial_Medico = 8,@ID_Cita = 8,@ID_Tipo_Procedimiento = 2;
	go
EXEC Sp_RegistrarProcedimiento @ID_Procedimiento = 9,@Descripcion_Procedimiento = 'Consulta pediátrica',@Fecha_Procedimiento = '2024-09-01',@Hora_Procedimiento = '10:00',
     @Monto_Procedimiento = 6000,@Receta = 'Paracetamol si es necesario',@ID_Sala = 4,@ID_Historial_Medico = 5,@ID_Cita = 2,@ID_Tipo_Procedimiento = 3;
	 go
EXEC Sp_RegistrarProcedimiento @ID_Procedimiento = 10,@Descripcion_Procedimiento = 'Consulta de ortopedia',@Fecha_Procedimiento = '2024-09-10', 
    @Hora_Procedimiento = '14:30',@Monto_Procedimiento = 7000,@Receta = 'Hielo y descanso',@ID_Sala = 5,@ID_Historial_Medico =1,@ID_Cita = 10,@ID_Tipo_Procedimiento = 7;
	go

-------------Registrar Estado del Recurso Medico
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarEstadoRecursoMedico
(
    @ID_Estado_Recurso_Medico INT,
    @Estado_Recurso VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
    -- Verificar si el estado del recurso médico ya existe
    IF EXISTS (SELECT 1 FROM Estado_Recurso_Medico WHERE Estado_Recurso = @Estado_Recurso)
    BEGIN
        RAISERROR('El estado del recurso médico ya existe.', 16, 1);
        RETURN;
    END
    BEGIN TRY
        INSERT INTO Estado_Recurso_Medico (ID_Estado_Recurso_Medico, Estado_Recurso)
        VALUES (@ID_Estado_Recurso_Medico, @Estado_Recurso);

        PRINT 'El estado de recurso médico se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el estado de recurso médico: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC Sp_RegistrarEstadoRecursoMedico @ID_Estado_Recurso_Medico = 3,@Estado_Recurso = 'En mantenimiento';
go
EXEC Sp_RegistrarEstadoRecursoMedico @ID_Estado_Recurso_Medico = 4,@Estado_Recurso = 'Reparación necesaria';
go
EXEC Sp_RegistrarEstadoRecursoMedico @ID_Estado_Recurso_Medico = 5,@Estado_Recurso = 'Fuera de servicio';
go
EXEC Sp_RegistrarEstadoRecursoMedico @ID_Estado_Recurso_Medico = 6,@Estado_Recurso = 'Reservado';
go
--------------------Registrar Tipo de Recurso
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarTipoRecurso
(
    @ID_Tipo_Recurso INT,
    @Titulo_Recurso VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
	-- Verificar si el tipo de recurso ya existe
    IF EXISTS (SELECT 1 FROM Tipo_Recurso WHERE Titulo_Recurso = @Titulo_Recurso)
    BEGIN
        RAISERROR('El tipo de recurso ya existe.', 16, 1);
        RETURN;
    END
    BEGIN TRY
        INSERT INTO Tipo_Recurso (ID_Tipo_Recurso, Titulo_Recurso)
        VALUES (@ID_Tipo_Recurso, @Titulo_Recurso);

        PRINT 'El tipo de recurso se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el tipo de recurso: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC Sp_RegistrarTipoRecurso @ID_Tipo_Recurso = 6,@Titulo_Recurso = 'Recurso de Diagnóstico';
go
EXEC Sp_RegistrarTipoRecurso @ID_Tipo_Recurso = 7,@Titulo_Recurso = 'Equipos de Protección Personal';
go
EXEC Sp_RegistrarTipoRecurso @ID_Tipo_Recurso = 8,@Titulo_Recurso = 'Suministros de Emergencia';
go
EXEC Sp_RegistrarTipoRecurso @ID_Tipo_Recurso = 9,@Titulo_Recurso = 'Material de Curación';
go

---------------Insertar Recurso Medico
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarRecursoMedico
(
    @ID_Recurso_Medico INT,
    @Nombre_Recurso VARCHAR(50),
    @Lote VARCHAR(50),
    @Cantidad_Stock_Total INT,
    @Ubicacion_Recurso VARCHAR(150),
    @ID_Tipo_Recurso INT,
    @ID_Estado_Recurso_Medico INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el tipo de recurso y el estado existen
    IF NOT EXISTS (SELECT 1 FROM Tipo_Recurso WHERE ID_Tipo_Recurso = @ID_Tipo_Recurso)
    BEGIN
        RAISERROR('El ID de tipo de recurso no existe.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Estado_Recurso_Medico WHERE ID_Estado_Recurso_Medico = @ID_Estado_Recurso_Medico)
    BEGIN
        RAISERROR('El ID de estado de recurso médico no existe.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        INSERT INTO Recurso_Medico (ID_Recurso_Medico, Nombre_Recurso, Lote, Cantidad_Stock_Total, Ubicacion_Recurso, ID_Tipo_Recurso, ID_Estado_Recurso_Medico)
        VALUES (@ID_Recurso_Medico, @Nombre_Recurso, @Lote, @Cantidad_Stock_Total, @Ubicacion_Recurso, @ID_Tipo_Recurso, @ID_Estado_Recurso_Medico);

        PRINT 'El recurso médico se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el recurso médico: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC Sp_RegistrarRecursoMedico @ID_Recurso_Medico = 6, @Nombre_Recurso = 'Recurso 6',@Lote = 'Lote 6',@Cantidad_Stock_Total = 150,@Ubicacion_Recurso = 'Almacén 6', 
    @ID_Tipo_Recurso = 1,@ID_Estado_Recurso_Medico = 4;
	go
EXEC Sp_RegistrarRecursoMedico @ID_Recurso_Medico = 7,@Nombre_Recurso = 'Recurso 7',@Lote = 'Lote 7',@Cantidad_Stock_Total = 250,@Ubicacion_Recurso = 'Almacén 7', 
    @ID_Tipo_Recurso = 2,@ID_Estado_Recurso_Medico = 6;
	go
EXEC Sp_RegistrarRecursoMedico @ID_Recurso_Medico = 8,@Nombre_Recurso = 'Recurso 8',@Lote = 'Lote 8',@Cantidad_Stock_Total = 350,@Ubicacion_Recurso = 'Almacén 8', 
    @ID_Tipo_Recurso = 3,@ID_Estado_Recurso_Medico = 5;
	go
EXEC Sp_RegistrarRecursoMedico @ID_Recurso_Medico = 9,@Nombre_Recurso = 'Recurso 9',@Lote = 'Lote 9',@Cantidad_Stock_Total = 450,@Ubicacion_Recurso = 'Almacén 9', 
    @ID_Tipo_Recurso = 6,@ID_Estado_Recurso_Medico = 2;


------------Insertar Recurso_Medico Sala

USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarRecursoMedicoSala
(
    @ID_Recurso_Medico_Sala INT,
    @Fecha DATE,
    @Descripcion VARCHAR(150),
    @ID_Recurso_Medico INT,
    @ID_Sala INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el recurso médico existe
    IF NOT EXISTS (SELECT 1 FROM Recurso_Medico WHERE ID_Recurso_Medico = @ID_Recurso_Medico)
    BEGIN
        RAISERROR('El ID de recurso médico no existe.', 16, 1);
        RETURN;
    END

    -- Verificar si la sala existe
    IF NOT EXISTS (SELECT 1 FROM Sala WHERE ID_Sala = @ID_Sala)
    BEGIN
        RAISERROR('El ID de sala no existe.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        INSERT INTO Recurso_Medico_Sala (ID_Recurso_Medico_Sala, Fecha, Descripcion, ID_Recurso_Medico, ID_Sala)
        VALUES (@ID_Recurso_Medico_Sala, @Fecha, @Descripcion, @ID_Recurso_Medico, @ID_Sala);

        PRINT 'El recurso médico en sala se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el recurso médico en sala: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC Sp_RegistrarRecursoMedicoSala @ID_Recurso_Medico_Sala = 6,@Fecha = '2024-02-01',@Descripcion = 'Sala tiene 25 recursos',@ID_Recurso_Medico = 1,@ID_Sala = 1;
go
EXEC Sp_RegistrarRecursoMedicoSala @ID_Recurso_Medico_Sala = 7,@Fecha = '2024-02-02',@Descripcion = 'Sala tiene 35 recursos',@ID_Recurso_Medico = 2,@ID_Sala = 2;
go
EXEC Sp_RegistrarRecursoMedicoSala @ID_Recurso_Medico_Sala = 8,@Fecha = '2024-02-03',@Descripcion = 'Sala tiene 45 recursos',@ID_Recurso_Medico = 6,@ID_Sala = 3;
go
EXEC Sp_RegistrarRecursoMedicoSala @ID_Recurso_Medico_Sala = 9,@Fecha = '2024-02-04',@Descripcion = 'Sala tiene 55 recursos',@ID_Recurso_Medico = 7,@ID_Sala = 8;
go



------------- insertar Horario de trabajo
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarHorarioTrabajo
(
    @ID_Horario_Trabajo INT,
    @Nombre_Horario VARCHAR(50),
    @Hora_Inicio TIME,
    @Hora_Fin TIME
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO Horario_Trabajo (ID_Horario_Trabajo, Nombre_Horario, Hora_Inicio, Hora_Fin)
        VALUES (@ID_Horario_Trabajo, @Nombre_Horario, @Hora_Inicio, @Hora_Fin);

        PRINT 'El horario de trabajo se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el horario de trabajo: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC Sp_RegistrarHorarioTrabajo @ID_Horario_Trabajo = 6,@Nombre_Horario = 'Turno de fin de semana', @Hora_Inicio = '09:00',@Hora_Fin = '13:00';
go
EXEC Sp_RegistrarHorarioTrabajo @ID_Horario_Trabajo = 7,@Nombre_Horario = 'Turno de tarde extendido',@Hora_Inicio = '14:00',@Hora_Fin = '18:30';
go
EXEC Sp_RegistrarHorarioTrabajo @ID_Horario_Trabajo = 8,@Nombre_Horario = 'Turno nocturno',@Hora_Inicio = '20:00', @Hora_Fin = '00:00';
go
EXEC Sp_RegistrarHorarioTrabajo @ID_Horario_Trabajo = 9,@Nombre_Horario = 'Horario de consultas especiales',@Hora_Inicio = '10:00',@Hora_Fin = '14:00';
go
------------------------------Registrar Planificacion de Recurso
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarPlanificacionRecurso
(
    @ID_Planificacion INT,
    @Descripcion_Planificacion VARCHAR(150),
    @Fecha_Planificacion DATE,
    @ID_Sala INT,
    @ID_Horario_Trabajo INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si la sala y el horario existen
    IF NOT EXISTS (SELECT 1 FROM Sala WHERE ID_Sala = @ID_Sala)
    BEGIN
        RAISERROR('El ID de sala no existe.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Horario_Trabajo WHERE ID_Horario_Trabajo = @ID_Horario_Trabajo)
    BEGIN
        RAISERROR('El ID de horario de trabajo no existe.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        INSERT INTO Planificacion_Recurso (ID_Planificacion, Descripcion_Planificacion, Fecha_Planificacion, ID_Sala, ID_Horario_Trabajo)
        VALUES (@ID_Planificacion, @Descripcion_Planificacion, @Fecha_Planificacion, @ID_Sala, @ID_Horario_Trabajo);

        PRINT 'La planificación de recurso se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar la planificación de recurso: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC Sp_RegistrarPlanificacionRecurso @ID_Planificacion = 6,@Descripcion_Planificacion = 'Planificación 6',@Fecha_Planificacion = '2024-06-01',@ID_Sala = 1, 
    @ID_Horario_Trabajo = 1;
	go
EXEC Sp_RegistrarPlanificacionRecurso @ID_Planificacion = 7,@Descripcion_Planificacion = 'Planificación 7',@Fecha_Planificacion = '2024-07-01',@ID_Sala = 2, 
    @ID_Horario_Trabajo = 2;
	go
EXEC Sp_RegistrarPlanificacionRecurso @ID_Planificacion = 8,@Descripcion_Planificacion = 'Planificación 8',@Fecha_Planificacion = '2024-08-01',@ID_Sala = 8, 
    @ID_Horario_Trabajo = 5;
	go
EXEC Sp_RegistrarPlanificacionRecurso @ID_Planificacion = 9,@Descripcion_Planificacion = 'Planificación 9',@Fecha_Planificacion = '2024-09-01',@ID_Sala = 3, 
    @ID_Horario_Trabajo = 9;
	go

----------- insertar Medico Planificacion de Recursos
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarMedicoPlanificacionRecurso
(
    @ID_Medico_Planificacion_Recurso INT,
    @Fecha_Planificacion_Personal DATE,
    @ID_Planificacion INT,
    @ID_Medico INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el médico y la planificación existen
    IF NOT EXISTS (SELECT 1 FROM Medico WHERE ID_Medico = @ID_Medico)
    BEGIN
        RAISERROR('El ID de médico no existe.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Planificacion_Recurso WHERE ID_Planificacion = @ID_Planificacion)
    BEGIN
        RAISERROR('El ID de planificación no existe.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        INSERT INTO Medico_Planificacion_Recurso (ID_Medico_Planificacion_Recurso, Fecha_Planificacion_Personal, ID_Planificacion, ID_Medico)
        VALUES (@ID_Medico_Planificacion_Recurso, @Fecha_Planificacion_Personal, @ID_Planificacion, @ID_Medico);

        PRINT 'La planificación del médico se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar la planificación del médico: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC Sp_RegistrarMedicoPlanificacionRecurso @ID_Medico_Planificacion_Recurso = 6,@Fecha_Planificacion_Personal = '2024-02-01',@ID_Planificacion = 1,@ID_Medico = 1;
go
EXEC Sp_RegistrarMedicoPlanificacionRecurso @ID_Medico_Planificacion_Recurso = 7,@Fecha_Planificacion_Personal = '2024-02-01',@ID_Planificacion = 2,@ID_Medico = 2;
go
EXEC Sp_RegistrarMedicoPlanificacionRecurso @ID_Medico_Planificacion_Recurso = 8,@Fecha_Planificacion_Personal = '2024-02-01',@ID_Planificacion = 3,@ID_Medico = 3;
go
EXEC Sp_RegistrarMedicoPlanificacionRecurso @ID_Medico_Planificacion_Recurso = 9,@Fecha_Planificacion_Personal = '2024-02-01',@ID_Planificacion = 4, @ID_Medico = 10;
go
---------Insertar Satiscaccion de Paciente
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarSatisfaccionPaciente
(
    @ID_Satisfaccion INT,
    @Fecha_Evaluacion DATE,
    @Calificacion_Satisfaccion INT,
    @ID_Cita INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si la cita existe
    IF NOT EXISTS (SELECT 1 FROM Procedimiento WHERE ID_Cita = @ID_Cita)
    BEGIN
        RAISERROR('El ID de cita no existe.', 16, 1);
        RETURN;
    END
	-- Verificar que la calificación esté entre 1 y 5
    IF @Calificacion_Satisfaccion < 1 OR @Calificacion_Satisfaccion > 5
    BEGIN
        RAISERROR('La calificación de satisfacción debe estar entre 1 y 5.', 16, 1);
        RETURN;
    END
    BEGIN TRY
        INSERT INTO Satisfaccion_Paciente (ID_Satisfaccion, Fecha_Evaluacion, Calificacion_Satisfaccion, ID_Cita)
        VALUES (@ID_Satisfaccion, @Fecha_Evaluacion, @Calificacion_Satisfaccion, @ID_Cita);

        PRINT 'La satisfacción del paciente se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar la satisfacción del paciente: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC Sp_RegistrarSatisfaccionPaciente @ID_Satisfaccion = 6,@Fecha_Evaluacion = '2024-06-02',@Calificacion_Satisfaccion = 5,@ID_Cita = 1;
go
EXEC Sp_RegistrarSatisfaccionPaciente @ID_Satisfaccion = 7,@Fecha_Evaluacion = '2024-06-03',@Calificacion_Satisfaccion = 4,@ID_Cita = 2;
go
EXEC Sp_RegistrarSatisfaccionPaciente @ID_Satisfaccion = 8,@Fecha_Evaluacion = '2024-06-04',@Calificacion_Satisfaccion = 3,@ID_Cita = 3;
go
EXEC Sp_RegistrarSatisfaccionPaciente @ID_Satisfaccion = 9,@Fecha_Evaluacion = '2024-06-05',@Calificacion_Satisfaccion = 2,@ID_Cita = 4;
go
-----------Insertar Rol
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarRol
(
    @ID_Rol INT,
    @Nombre_Rol VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
	-- Verificar si el nombre del rol ya existe
    IF EXISTS (SELECT 1 FROM Rol WHERE Nombre_Rol = @Nombre_Rol)
    BEGIN
        RAISERROR('El nombre del rol ya existe.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        INSERT INTO Rol (ID_Rol, Nombre_Rol)
        VALUES (@ID_Rol, @Nombre_Rol);

        PRINT 'El rol se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el rol: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
-------Registrar Usuario
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarUsuario
(
    @ID_Usuario INT,
    @Nombre_Usuario VARCHAR(50),
    @Correo_Usuario VARCHAR(50),
    @Contraseña_Usuario VARCHAR(50),
    @ID_Rol INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el rol existe
    IF NOT EXISTS (SELECT 1 FROM Rol WHERE ID_Rol = @ID_Rol)
    BEGIN
        RAISERROR('El ID de rol no existe.', 16, 1);
        RETURN;
    END
	-- Verificar si el usuario ya tiene un rol asignado
    IF EXISTS (SELECT 1 FROM Usuario WHERE ID_Usuario = @ID_Usuario AND ID_Rol IS NOT NULL)
    BEGIN
        RAISERROR('El usuario ya tiene un rol asignado.', 16, 1);
        RETURN;
    END
	-- Verificar si el correo del usuario ya existe
    IF EXISTS (SELECT 1 FROM Usuario WHERE Correo_Usuario = @Correo_Usuario)
    BEGIN
        RAISERROR('El correo del usuario ya existe.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        INSERT INTO Usuario (ID_Usuario, Nombre_Usuario, Correo_Usuario, Contraseña_Usuario, ID_Rol)
        VALUES (@ID_Usuario, @Nombre_Usuario, @Correo_Usuario, @Contraseña_Usuario, @ID_Rol);

                PRINT 'El usuario se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el usuario: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC Sp_RegistrarUsuario @ID_Usuario = 4,@Nombre_Usuario = 'Ana Torres',@Correo_Usuario = 'ana.torres@saludplus.com',@Contraseña_Usuario = 'contraseña101',@ID_Rol = 1;
go
EXEC Sp_RegistrarUsuario @ID_Usuario = 5,@Nombre_Usuario = 'Luis Fernández',@Correo_Usuario = 'luis.fernandez@saludplus.com',@Contraseña_Usuario = 'contraseña202', 
    @ID_Rol = 2;
	go
EXEC Sp_RegistrarUsuario @ID_Usuario = 6,@Nombre_Usuario = 'Elena Ruiz',@Correo_Usuario = 'elena.ruiz@saludplus.com',@Contraseña_Usuario = 'contraseña303', 
    @ID_Rol = 3;
	go
EXEC Sp_RegistrarUsuario @ID_Usuario = 7,@Nombre_Usuario = 'Fernando Martínez',@Correo_Usuario = 'fernando.martinez@saludplus.com',@Contraseña_Usuario = 'contraseña404', 
    @ID_Rol = 1;
	go
---------Registrar Permiso
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarPermiso
(
    @ID_Permiso INT,
    @Nombre_Permiso VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
	-- Verificar si el nombre del permiso ya existe
    IF EXISTS (SELECT 1 FROM Permiso WHERE Nombre_Permiso = @Nombre_Permiso)
    BEGIN
        RAISERROR('El nombre del permiso ya existe.', 16, 1);
        RETURN;
    END
    BEGIN TRY
        INSERT INTO Permiso (ID_Permiso, Nombre_Permiso)
        VALUES (@ID_Permiso, @Nombre_Permiso);

        PRINT 'El permiso se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el permiso: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC Sp_RegistrarPermiso @ID_Permiso = 7,@Nombre_Permiso = 'Ver Informes';
go
EXEC Sp_RegistrarPermiso @ID_Permiso = 8,@Nombre_Permiso = 'Modificar Informes';
go
EXEC Sp_RegistrarPermiso @ID_Permiso = 9,@Nombre_Permiso = 'Eliminar Informes';
go
EXEC Sp_RegistrarPermiso @ID_Permiso = 10,@Nombre_Permiso = 'Gestionar Recursos Médicos';
go

-----------Registrar Rol Permiso
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarRolPermiso
(
    @ID_Rol_Permiso INT,
    @ID_Rol INT,
    @ID_Permiso INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el rol existe
    IF NOT EXISTS (SELECT 1 FROM Rol WHERE ID_Rol = @ID_Rol)
    BEGIN
        RAISERROR('El ID de rol no existe.', 16, 1);
        RETURN;
    END

    -- Verificar si el permiso existe
    IF NOT EXISTS (SELECT 1 FROM Permiso WHERE ID_Permiso = @ID_Permiso)
    BEGIN
        RAISERROR('El ID de permiso no existe.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        INSERT INTO Rol_Permiso (ID_Rol_Permiso, ID_Rol, ID_Permiso)
        VALUES (@ID_Rol_Permiso, @ID_Rol, @ID_Permiso);

        PRINT 'El permiso ha sido asignado al rol correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al asignar el permiso al rol: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC Sp_RegistrarRolPermiso @ID_Rol_Permiso = 7,@ID_Rol = 2,@ID_Permiso = 2;  -- Médico puede ver citas
go
EXEC Sp_RegistrarRolPermiso @ID_Rol_Permiso = 8,@ID_Rol = 2,@ID_Permiso = 5;  -- Médico puede acceder a historial médico
go
EXEC Sp_RegistrarRolPermiso @ID_Rol_Permiso = 9,@ID_Rol = 3,@ID_Permiso = 6;  -- Recepcionista puede gestionar pacientes
go
EXEC Sp_RegistrarRolPermiso @ID_Rol_Permiso = 10,@ID_Rol = 3,@ID_Permiso = 1;  -- Recepcionista puede crear citas
go

------------------------------------------------Procedimientos Amacenados para DELETE
----------------------Eliminar Rol Permisos
Use SaludPlus
go
CREATE PROCEDURE EliminarRolPermiso
    @ID_Rol_Permiso INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Rol_Permiso WHERE ID_Rol_Permiso = @ID_Rol_Permiso)
    BEGIN
        PRINT 'No existe la relación Rol-Permiso con ID_Rol_Permiso = ' + CAST(@ID_Rol_Permiso AS VARCHAR)
        RETURN
    END

    DELETE FROM Rol_Permiso WHERE ID_Rol_Permiso = @ID_Rol_Permiso
END
go
-----------------------Eliminar Usuario
Use SaludPlus
go
CREATE PROCEDURE EliminarUsuario
    @ID_Usuario INT
AS
BEGIN
IF NOT EXISTS (SELECT 1 FROM Usuario WHERE ID_Usuario = @ID_Usuario)
    BEGIN
        PRINT 'No existe el Usuario con ID_Usuario = ' + CAST(@ID_Usuario AS VARCHAR)
        RETURN
    END
    DELETE FROM Usuario WHERE ID_Usuario = @ID_Usuario
END
go
-----------------------Eliminar Rol
Use SaludPlus
go
CREATE PROCEDURE EliminarRol
    @ID_Rol INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Rol WHERE ID_Rol = @ID_Rol)
    BEGIN
        PRINT 'No existe el Rol con ID_Rol = ' + CAST(@ID_Rol AS VARCHAR)
        RETURN
    END

    IF EXISTS (SELECT 1 FROM Usuario WHERE ID_Rol = @ID_Rol) OR
       EXISTS (SELECT 1 FROM Rol_Permiso WHERE ID_Rol = @ID_Rol)
    BEGIN
        PRINT 'No se puede eliminar el Rol. Existen usuarios o permisos asociados.'
        RETURN
    END

    DELETE FROM Rol WHERE ID_Rol = @ID_Rol
END
go
-----------------------Eliminar Permiso
Use SaludPlus
go
CREATE PROCEDURE sp_EliminarPermiso
    @ID_Permiso INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Permiso WHERE ID_Permiso = @ID_Permiso)
    BEGIN
        PRINT 'No existe el Permiso con ID_Permiso = ' + CAST(@ID_Permiso AS VARCHAR)
        RETURN
    END

    IF EXISTS (SELECT 1 FROM Rol_Permiso WHERE ID_Permiso = @ID_Permiso)
    BEGIN
        PRINT 'No se puede eliminar el Permiso, tiene roles asociados.'
        RETURN
    END

    DELETE FROM Permiso WHERE ID_Permiso = @ID_Permiso
END
GO
-----------------------Eliminar satisfaccion Paciente
Use SaludPlus
go
CREATE PROCEDURE EliminarSatisfaccionPaciente
    @ID_Satisfaccion INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Satisfaccion_Paciente WHERE ID_Satisfaccion = @ID_Satisfaccion)
    BEGIN
        PRINT 'No existe la Satisfacción del Paciente con ID_Satisfaccion = ' + CAST(@ID_Satisfaccion AS VARCHAR)
        RETURN
    END
    DELETE FROM Satisfaccion_Paciente WHERE ID_Satisfaccion = @ID_Satisfaccion
END
go
------------------ Procedimiento para eliminar Medico_Planificacion_RecursoUse SaludPlus
go
CREATE PROCEDURE sp_EliminarMedicoPlanificacionRecurso
    @ID_Medico_Planificacion_Recurso INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Medico_Planificacion_Recurso WHERE ID_Medico_Planificacion_Recurso = @ID_Medico_Planificacion_Recurso)
    BEGIN
        PRINT 'No existe la planificación de recurso médico con ID_Medico_Planificacion_Recurso = ' + CAST(@ID_Medico_Planificacion_Recurso AS VARCHAR)
        RETURN
    END

    DELETE FROM Medico_Planificacion_Recurso WHERE ID_Medico_Planificacion_Recurso = @ID_Medico_Planificacion_Recurso
END
GO

-- Procedimiento para eliminar Paciente
Use SaludPlus
go
CREATE PROCEDURE sp_EliminarPaciente
    @ID_Paciente INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Paciente WHERE ID_Paciente = @ID_Paciente)
    BEGIN
        PRINT 'No existe el Paciente con ID_Paciente = ' + CAST(@ID_Paciente AS VARCHAR)
        RETURN
    END

    IF EXISTS (SELECT 1 FROM Historial_Medico WHERE ID_Paciente = @ID_Paciente)
    BEGIN
        PRINT 'No se puede eliminar el Paciente, tiene historial médico asociado.'
        RETURN
    END

    IF EXISTS (SELECT 1 FROM Cita WHERE ID_Paciente = @ID_Paciente)
    BEGIN
        PRINT 'No se puede eliminar el Paciente, tiene citas asociadas.'
        RETURN
    END

    IF EXISTS (SELECT 1 FROM Factura WHERE ID_Paciente = @ID_Paciente)
    BEGIN
        PRINT 'No se puede eliminar el Paciente, tiene facturas asociadas.'
        RETURN
    END

    DELETE FROM Paciente WHERE ID_Paciente = @ID_Paciente
END
GO
----------------- Procedimiento para eliminar Cita
Use SaludPlus
go
CREATE PROCEDURE sp_EliminarCita
    @ID_Cita INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Cita WHERE ID_Cita = @ID_Cita)
    BEGIN
        PRINT 'No existe la Cita con ID_Cita = ' + CAST(@ID_Cita AS VARCHAR)
        RETURN
    END

    IF EXISTS (SELECT 1 FROM Factura WHERE ID_Cita = @ID_Cita)
    BEGIN
        PRINT 'No se puede eliminar la Cita, tiene facturas asociadas.'
        RETURN
    END

    IF EXISTS (SELECT 1 FROM Satisfaccion_Paciente WHERE ID_Cita = @ID_Cita)
    BEGIN
        PRINT 'No se puede eliminar la Cita, tiene satisfacción asociada.'
        RETURN
    END

    DELETE FROM Cita WHERE ID_Cita = @ID_Cita
END
GO
---------------------Procedimiento para eliminar Estado_Cita
Use SaludPlus
go
CREATE PROCEDURE sp_EliminarEstadoCita
    @ID_Estado_Cita INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Estado_Cita WHERE ID_Estado_Cita = @ID_Estado_Cita)
    BEGIN
        PRINT 'No existe el Estado de Cita con ID_Estado_Cita = ' + CAST(@ID_Estado_Cita AS VARCHAR)
        RETURN
    END

    IF EXISTS (SELECT 1 FROM Cita WHERE ID_Estado_Cita = @ID_Estado_Cita)
    BEGIN
        PRINT 'No se puede eliminar el Estado de Cita, hay citas asociadas.'
        RETURN
    END

    DELETE FROM Estado_Cita WHERE ID_Estado_Cita = @ID_Estado_Cita
END
GO

------------ Procedimiento para eliminar Factura
Use SaludPlus
go
CREATE PROCEDURE sp_EliminarFactura
    @ID_Factura INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Factura WHERE ID_Factura = @ID_Factura)
    BEGIN
        PRINT 'No existe la Factura con ID_Factura = ' + CAST(@ID_Factura AS VARCHAR)
        RETURN
    END

    IF EXISTS (SELECT 1 FROM Cita WHERE ID_Cita IN (SELECT ID_Cita FROM Factura WHERE ID_Factura = @ID_Factura))
    BEGIN
        PRINT 'No se puede eliminar la Factura, tiene citas asociadas.'
        RETURN
    END

    DELETE FROM Factura WHERE ID_Factura = @ID_Factura
END
GO
---------------- Procedimiento para eliminar Tipo_Pago
Use SaludPlus
go
CREATE PROCEDURE sp_EliminarTipoPago
    @ID_Tipo_Pago INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Tipo_Pago WHERE ID_Tipo_Pago = @ID_Tipo_Pago)
    BEGIN
        PRINT 'No existe el Tipo de Pago con ID_Tipo_Pago = ' + CAST(@ID_Tipo_Pago AS VARCHAR)
        RETURN
    END

    IF EXISTS (SELECT 1 FROM Factura WHERE ID_Tipo_Pago = @ID_Tipo_Pago)
    BEGIN
        PRINT 'No se puede eliminar el Tipo de Pago, tiene facturas asociadas.'
        RETURN
    END

    DELETE FROM Tipo_Pago WHERE ID_Tipo_Pago = @ID_Tipo_Pago
END
GO
------------------------- Procedimiento para eliminar Tipo_Procedimiento

Use SaludPlus
go
CREATE PROCEDURE sp_EliminarTipoProcedimiento
    @ID_Tipo_Procedimiento INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Tipo_Procedimiento WHERE ID_Tipo_Procedimiento = @ID_Tipo_Procedimiento)
    BEGIN
        PRINT 'No existe el Tipo de Procedimiento con ID_Tipo_Procedimiento = ' + CAST(@ID_Tipo_Procedimiento AS VARCHAR)
        RETURN
    END

    IF EXISTS (SELECT 1 FROM Procedimiento WHERE ID_Tipo_Procedimiento = @ID_Tipo_Procedimiento)
    BEGIN
        PRINT 'No se puede eliminar el Tipo de Procedimiento, tiene procedimientos asociados.'
        RETURN
    END

    DELETE FROM Tipo_Procedimiento WHERE ID_Tipo_Procedimiento = @ID_Tipo_Procedimiento
END
GO
------------------------- Procedimiento para eliminar Historial_Medico
Use SaludPlus
go
CREATE PROCEDURE sp_EliminarHistorialMedico
    @ID_Historial_Medico INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Historial_Medico WHERE ID_Historial_Medico = @ID_Historial_Medico)
    BEGIN
        PRINT 'No existe el Historial Médico con ID_Historial_Medico = ' + CAST(@ID_Historial_Medico AS VARCHAR)
        RETURN
    END

    IF EXISTS (SELECT 1 FROM Procedimiento WHERE ID_Historial_Medico = @ID_Historial_Medico)
    BEGIN
        PRINT 'No se puede eliminar el Historial Médico, tiene procedimientos asociados.'
        RETURN
    END

    DELETE FROM Historial_Medico WHERE ID_Historial_Medico = @ID_Historial_Medico
END
GO
------------------------- Procedimiento para eliminar Recurso_Medico
Use SaludPlus
go
CREATE PROCEDURE sp_EliminarRecursoMedico
    @ID_Recurso_Medico INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Recurso_Medico WHERE ID_Recurso_Medico = @ID_Recurso_Medico)
    BEGIN
        PRINT 'No existe el Recurso Médico con ID_Recurso_Medico = ' + CAST(@ID_Recurso_Medico AS VARCHAR)
        RETURN
    END

    IF EXISTS (SELECT 1 FROM Recurso_Medico_Sala WHERE ID_Recurso_Medico = @ID_Recurso_Medico)
    BEGIN
        PRINT 'No se puede eliminar el Recurso Médico, tiene asignaciones a salas.'
        RETURN
    END

    DELETE FROM Recurso_Medico WHERE ID_Recurso_Medico = @ID_Recurso_Medico
END
GO
------------------------- Procedimiento para eliminar Sala
Use SaludPlus
go
CREATE PROCEDURE sp_EliminarSala
    @ID_Sala INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Sala WHERE ID_Sala = @ID_Sala)
    BEGIN
        PRINT 'No existe la Sala con ID_Sala = ' + CAST(@ID_Sala AS VARCHAR)
        RETURN
    END

    IF EXISTS (SELECT 1 FROM Recurso_Medico_Sala WHERE ID_Sala = @ID_Sala)
    BEGIN
        PRINT 'No se puede eliminar la Sala, tiene recursos médicos asociados.'
        RETURN
    END

    IF EXISTS (SELECT 1 FROM Planificacion_Recurso WHERE ID_Sala = @ID_Sala)
    BEGIN
        PRINT 'No se puede eliminar la Sala, tiene planificación de recursos asociada.'
        RETURN
    END

    DELETE FROM Sala WHERE ID_Sala = @ID_Sala
END
GO
-------------------------Procedimiento para eliminar Estado_Recurso_Medico
Use SaludPlus
go
CREATE PROCEDURE sp_EliminarEstadoRecursoMedico
    @ID_Estado_Recurso_Medico INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Estado_Recurso_Medico WHERE ID_Estado_Recurso_Medico = @ID_Estado_Recurso_Medico)
    BEGIN
        PRINT 'No existe el Estado de Recurso Médico con ID_Estado_Recurso_Medico = ' + CAST(@ID_Estado_Recurso_Medico AS VARCHAR)
        RETURN
    END

    IF EXISTS (SELECT 1 FROM Recurso_Medico WHERE ID_Estado_Recurso_Medico = @ID_Estado_Recurso_Medico)
    BEGIN
        PRINT 'No se puede eliminar el Estado de Recurso Médico, tiene recursos médicos asociados.'
        RETURN
    END

    DELETE FROM Estado_Recurso_Medico WHERE ID_Estado_Recurso_Medico = @ID_Estado_Recurso_Medico
END
GO
-------------------------Procedimiento para eliminar Tipo_Recurso
Use SaludPlus
go
CREATE PROCEDURE sp_EliminarTipoRecurso
    @ID_Tipo_Recurso INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Tipo_Recurso WHERE ID_Tipo_Recurso = @ID_Tipo_Recurso)
    BEGIN
        PRINT 'No existe el Tipo de Recurso con ID_Tipo_Recurso = ' + CAST(@ID_Tipo_Recurso AS VARCHAR)
        RETURN
    END

    IF EXISTS (SELECT 1 FROM Recurso_Medico WHERE ID_Tipo_Recurso = @ID_Tipo_Recurso)
    BEGIN
        PRINT 'No se puede eliminar el Tipo de Recurso, tiene recursos médicos asociados.'
        RETURN
    END

    DELETE FROM Tipo_Recurso WHERE ID_Tipo_Recurso = @ID_Tipo_Recurso
END
GO
-----------------------
Use SaludPlus
go
-- Procedimiento para eliminar Estado_Sala
CREATE PROCEDURE sp_EliminarEstadoSala
    @ID_Estado_Sala INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Estado_Sala WHERE ID_Estado_Sala = @ID_Estado_Sala)
    BEGIN
        PRINT 'No existe el Estado de Sala con ID_Estado_Sala = ' + CAST(@ID_Estado_Sala AS VARCHAR)
        RETURN
    END

    IF EXISTS (SELECT 1 FROM Sala WHERE ID_Estado_Sala = @ID_Estado_Sala)
    BEGIN
        PRINT 'No se puede eliminar el Estado de Sala, tiene salas asociadas.'
        RETURN
    END

    DELETE FROM Estado_Sala WHERE ID_Estado_Sala = @ID_Estado_Sala
END
GO
-------------------------Procedimiento para eliminar Tipo_Sala

Use SaludPlus
go
CREATE PROCEDURE sp_EliminarTipoSala
    @ID_Tipo_Sala INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Tipo_Sala WHERE ID_Tipo_Sala = @ID_Tipo_Sala)
    BEGIN
        PRINT 'No existe el Tipo de Sala con ID_Tipo_Sala = ' + CAST(@ID_Tipo_Sala AS VARCHAR)
        RETURN
    END

    IF EXISTS (SELECT 1 FROM Sala WHERE ID_Tipo_Sala = @ID_Tipo_Sala)
    BEGIN
        PRINT 'No se puede eliminar el Tipo de Sala, tiene salas asociadas.'
        RETURN
    END

    DELETE FROM Tipo_Sala WHERE ID_Tipo_Sala = @ID_Tipo_Sala
END
GO
------------------------- Procedimiento para eliminar Recurso_Medico_Sala
Use SaludPlus
go
CREATE PROCEDURE sp_EliminarRecursoMedicoSala
    @ID_Recurso_Medico_Sala INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Recurso_Medico_Sala WHERE ID_Recurso_Medico_Sala = @ID_Recurso_Medico_Sala)
    BEGIN
        PRINT 'No existe el Recurso Médico en Sala con ID_Recurso_Medico_Sala = ' + CAST(@ID_Recurso_Medico_Sala AS VARCHAR)
        RETURN
    END

    DELETE FROM Recurso_Medico_Sala WHERE ID_Recurso_Medico_Sala = @ID_Recurso_Medico_Sala
END
GO

------------------------- Procedimiento para eliminar Medico
Use SaludPlus
go
CREATE PROCEDURE sp_EliminarMedico
    @ID_Medico INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Medico WHERE ID_Medico = @ID_Medico)
    BEGIN
        PRINT 'No existe el Médico con ID_Medico = ' + CAST(@ID_Medico AS VARCHAR)
        RETURN
    END

    IF EXISTS (SELECT 1 FROM Medico_Planificacion_Recurso WHERE ID_Medico = @ID_Medico)
    BEGIN
        PRINT 'No se puede eliminar el Médico, tiene planificación de recursos asociada.'
        RETURN
    END

    DELETE FROM Medico WHERE ID_Medico = @ID_Medico
END
GO
-------------------------Procedimiento para eliminar Especialidad

Use SaludPlus
go
CREATE PROCEDURE sp_EliminarEspecialidad
    @ID_Especialidad INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Especialidad WHERE ID_Especialidad = @ID_Especialidad)
    BEGIN
        PRINT 'No existe la Especialidad con ID_Especialidad = ' + CAST(@ID_Especialidad AS VARCHAR)
        RETURN
    END

    IF EXISTS (SELECT 1 FROM Medico WHERE ID_Especialidad = @ID_Especialidad)
    BEGIN
        PRINT 'No se puede eliminar la Especialidad, tiene médicos asociados.'
        RETURN
    END

    DELETE FROM Especialidad WHERE ID_Especialidad = @ID_Especialidad
END
GO
------------------------- Procedimiento para eliminar Horario_Trabajo
Use SaludPlus
go
CREATE PROCEDURE sp_EliminarHorarioTrabajo
    @ID_Horario_Trabajo INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Horario_Trabajo WHERE ID_Horario_Trabajo = @ID_Horario_Trabajo)
    BEGIN
        PRINT 'No existe el Horario de Trabajo con ID_Horario_Trabajo = ' + CAST(@ID_Horario_Trabajo AS VARCHAR)
        RETURN
    END

    IF EXISTS (SELECT 1 FROM Planificacion_Recurso WHERE ID_Horario_Trabajo = @ID_Horario_Trabajo)
    BEGIN
        PRINT 'No se puede eliminar el Horario de Trabajo, tiene médicos asociados.'
        RETURN
    END

    DELETE FROM Horario_Trabajo WHERE ID_Horario_Trabajo = @ID_Horario_Trabajo
END
GO
------------------------- Procedimiento para eliminar Planificacion_Recurso
Use SaludPlus
go
CREATE PROCEDURE sp_EliminarPlanificacionRecurso
    @ID_Planificacion INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Planificacion_Recurso WHERE ID_Planificacion = @ID_Planificacion)
    BEGIN
        PRINT 'No existe la Planificación de Recurso con ID_Planificacion = ' + CAST(@ID_Planificacion AS VARCHAR)
        RETURN
    END

    DELETE FROM Planificacion_Recurso WHERE ID_Planificacion = @ID_Planificacion
END
GO
------------------------- Procedimiento para eliminar Procedimiento
Use SaludPlus
go
CREATE PROCEDURE sp_EliminarProcedimiento
    @ID_Procedimiento INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Procedimiento WHERE ID_Procedimiento = @ID_Procedimiento)
    BEGIN
        PRINT 'No existe el Procedimiento con ID_Procedimiento = ' + CAST(@ID_Procedimiento AS VARCHAR)
        RETURN
    END

    IF EXISTS (SELECT 1 FROM Historial_Medico WHERE ID_Historial_Medico IN (SELECT ID_Historial_Medico FROM Procedimiento WHERE ID_Procedimiento = @ID_Procedimiento))
    BEGIN
        PRINT 'No se puede eliminar el Procedimiento, tiene historial médico asociado.'
        RETURN
    END

    DELETE FROM Procedimiento WHERE ID_Procedimiento = @ID_Procedimiento
END
GO
 












 



 

















































 
 

 

 

 