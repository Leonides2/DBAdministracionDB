use master
go

create database SaludPlus 
on Primary
(
name = 'SaludPlus_Data',
Filename ='C:\SQL\Data\SaludPlus_Data.mdf',
 SIZE = 5000MB,   
 MAXSIZE = 100000MB, 
 FILEGROWTH = 500MB 
)
log on 
(
name = 'SaludPlus',
Filename ='C:\SQL\Log\SaludPlus_Log.ldf',
SIZE = 2000MB, 
MAXSIZE = 5000MB,
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
    SIZE = 2000MB, 
    MAXSIZE = 2000MB, 
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
    SIZE = 2000MB, 
    MAXSIZE = 5000MB, 
    FILEGROWTH = 200MB
)to FILEGROUP Recursos
go
-------------------------
 
 ------------------------------creacion de tablas--------------
use SaludPlus
go
create table Cita
( 
ID_Cita int not null IDENTITY(1,1),
Fecha_Cita date not null,
Hora_Cita time not null,
ID_Estado_Cita int not null,
ID_Paciente int not null,
ID_Medico int not null,
CONSTRAINT PK_Cita 
PRIMARY KEY CLUSTERED (ID_Cita)
) on 'Facturacion'
go
---------------------------
use SaludPlus
go
create table Estado_Cita
( 
ID_Estado_Cita int not null IDENTITY(1,1),
Estado varchar(50) not null,
CONSTRAINT PK_Estado_Cita 
PRIMARY KEY CLUSTERED (ID_Estado_Cita)
) on 'Facturacion'
go
--------------------------
use SaludPlus
go
create table Factura
( 
ID_Factura int not null IDENTITY(1,1),
Fecha_Factura date not null,
Monto_Total money not null,
ID_Paciente int not null,
ID_Cita int not null,
ID_Tipo_Pago int not null,
CONSTRAINT PK_Factura 
PRIMARY KEY CLUSTERED (ID_Factura)
) on 'Facturacion'
go
-------------------------
use SaludPlus
go
create table Tipo_Pago
( 
ID_Tipo_Pago int not null IDENTITY(1,1),
Descripcion_Tipo_Pago varchar(50) not null,
CONSTRAINT PK_Tipo_Pago
PRIMARY KEY CLUSTERED (ID_Tipo_Pago)
) on 'Facturacion'
go
--------------------------
use SaludPlus
go
create table Paciente
( 
ID_Paciente int not null IDENTITY(1,1),
Nombre_Paciente varchar(50) not null,
Apellido1_Paciente varchar(50) not null,
Apellido2_Paciente varchar(50) not null,
Telefono_Paciente varchar(50) not null,
Fecha_Nacimiento date null,
Direccion_Paciente varchar(150) not null,
Cedula varchar(12) not null,
CONSTRAINT PK_Paciente 
PRIMARY KEY CLUSTERED (ID_Paciente)
) on 'Facturacion'
go
---------------------------
use SaludPlus
go
create table Procedimiento
( 
ID_Procedimiento int not null IDENTITY(1,1),
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
PRIMARY KEY CLUSTERED (ID_Procedimiento)
) on 'Facturacion'
go
----------------------
use SaludPlus
go
create table Tipo_Procedimiento
( 
ID_Tipo_Procedimiento int not null IDENTITY(1,1),
Nombre_Procedimiento varchar(50) not null,
CONSTRAINT PK_Tipo_Procedimiento
PRIMARY KEY CLUSTERED (ID_Tipo_Procedimiento)
) on 'Facturacion'
go
----------------------
use SaludPlus
go
create table Historial_Medico
( 
ID_Historial_Medico int not null IDENTITY(1,1),
Fecha_Registro date not null,
ID_Paciente int not null,
CONSTRAINT PK_Historial_Medico
PRIMARY KEY CLUSTERED (ID_Historial_Medico)
) 
go
-------------------
use SaludPlus
go
create table Recurso_Medico
( 
ID_Recurso_Medico int not null IDENTITY(1,1),
Nombre_Recurso varchar(50) not null,
Lote varchar(50) not null,
Cantidad_Stock_Total int null,
Ubicacion_Recurso varchar(150) not null,
ID_Tipo_Recurso int not null,
ID_Estado_Recurso_Medico INT NOT NULL,
CONSTRAINT PK_Recurso_Medico
PRIMARY KEY CLUSTERED (ID_Recurso_Medico)
) on 'Recursos'
go
------------------

use SaludPlus
go
create table Estado_Recurso_Medico
( 
ID_Estado_Recurso_Medico int not null IDENTITY(1,1),
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
ID_Tipo_Recurso int not null IDENTITY(1,1),
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
ID_Sala int not null IDENTITY(1,1),
Nombre_Sala varchar(50) not null,
Capacidad_Sala int not null,
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
ID_Estado_Sala int not null IDENTITY(1,1),
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
ID_Tipo_Sala int not null IDENTITY(1,1),
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
ID_Recurso_Medico_Sala int not null IDENTITY(1,1),
Fecha date not null,
Cantidad_Recurso int not null,
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
ID_Planificacion int not null IDENTITY(1,1),
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
ID_Medico int not null IDENTITY(1,1),
Nombre1_Medico varchar(50) not null,
Nombre2_Medico varchar(50) null,
Apellido1_Medico varchar(50) not null,
Apellido2_Medico varchar(50) not null,
Telefono_Medico varchar(50) not null, 
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
ID_Especialidad int not null IDENTITY(1,1),
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
ID_Horario_Trabajo int not null IDENTITY(1,1),
Nombre_Horario varchar(50) not null,
Hora_Inicio time not null,
Hora_Fin time not null,
CONSTRAINT PK_Horario_Trabajo
PRIMARY KEY CLUSTERED (ID_Horario_Trabajo)
) 
go
---------------------
use SaludPlus
go
create table Medico_Planificacion_Recurso
( 
ID_Medico_Planificacion_Recurso int not null IDENTITY(1,1),
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
ID_Satisfaccion int not null IDENTITY(1,1),
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
ID_Usuario int not null IDENTITY(1,1),
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
ID_Rol int not null IDENTITY(1,1),
Nombre_Rol varchar(50) not null,
CONSTRAINT PK_Rol
PRIMARY KEY CLUSTERED (ID_Rol)
) 
go
----------------------------
use SaludPlus
go
create table Permiso
( 
ID_Permiso int not null IDENTITY(1,1),
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
ID_Rol_Permiso int not null IDENTITY(1,1),
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
---------------------------------------------------------Triggers
--------------------Tabla auditoria
Use SaludPlus
go
CREATE TABLE Auditoria
(
    ID_Auditoria INT IDENTITY(1,1) PRIMARY KEY,
    Nombre_Tabla VARCHAR(50),
    ID_Registro INT,
    Accion VARCHAR(50),
    FechaAuditoria DATETIME,
    Usuario VARCHAR(50)
);
go

---SELECT * FROM Auditoria;
 ------------------------Trigger de la tabla Cita
CREATE TRIGGER TR_Auditoria_Cita
ON Cita
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(50) = SYSTEM_USER;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
		
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Cita', ID_Cita, 'Inserción', GETDATE(), @Usuario
        FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Cita', ID_Cita, 'Eliminación', GETDATE(), @Usuario
        FROM deleted;
    END

    IF EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.ID_Cita = d.ID_Cita)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Cita', i.ID_Cita, 'Actualización', GETDATE(), @Usuario
        FROM inserted i JOIN deleted d ON i.ID_Cita = d.ID_Cita;
    END
END;
GO
----------------------------------------Trigger de Estado de Cita
Use SaludPlus
go
CREATE TRIGGER TR_Auditoria_Estado_Cita
ON Estado_Cita
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Usuario VARCHAR(50) = SYSTEM_USER;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Estado_Cita', ID_Estado_Cita, 'Inserción', GETDATE(), @Usuario
        FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Estado_Cita', ID_Estado_Cita, 'Eliminación', GETDATE(), @Usuario
        FROM deleted;
    END

    IF EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.ID_Estado_Cita = d.ID_Estado_Cita)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Estado_Cita', i.ID_Estado_Cita, 'Actualización', GETDATE(), @Usuario
        FROM inserted i JOIN deleted d ON i.ID_Estado_Cita = d.ID_Estado_Cita;
    END
END;
GO
-------------------------Trigger de Factura
Use SaludPlus
go
CREATE TRIGGER TR_Auditoria_Factura
ON Factura
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Usuario VARCHAR(50) = SYSTEM_USER;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Factura', ID_Factura, 'Inserción', GETDATE(), @Usuario
        FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Factura', ID_Factura, 'Eliminación', GETDATE(), @Usuario
        FROM deleted;
    END

    IF EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.ID_Factura = d.ID_Factura)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Factura', i.ID_Factura, 'Actualización', GETDATE(), @Usuario
        FROM inserted i JOIN deleted d ON i.ID_Factura = d.ID_Factura;
    END
END;
GO
--------------------------------Trigger de Tipo de pago
Use SaludPlus
go
CREATE TRIGGER TR_Auditoria_Tipo_Pago
ON Tipo_Pago
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Usuario VARCHAR(50) = SYSTEM_USER;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Tipo_Pago', ID_Tipo_Pago, 'Inserción', GETDATE(), @Usuario
        FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Tipo_Pago', ID_Tipo_Pago, 'Eliminación', GETDATE(), @Usuario
        FROM deleted;
    END

    IF EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.ID_Tipo_Pago = d.ID_Tipo_Pago)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Tipo_Pago', i.ID_Tipo_Pago, 'Actualización', GETDATE(), @Usuario
        FROM inserted i JOIN deleted d ON i.ID_Tipo_Pago = d.ID_Tipo_Pago;
    END
END;
GO
-------------------------------Trigger para Paciente
Use SaludPlus
go
CREATE TRIGGER TR_Auditoria_Paciente
ON Paciente
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Usuario VARCHAR(50) = SYSTEM_USER;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Paciente', ID_Paciente, 'Inserción', GETDATE(), @Usuario
        FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Paciente', ID_Paciente, 'Eliminación', GETDATE(), @Usuario
        FROM deleted;
    END

    IF EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.ID_Paciente = d.ID_Paciente)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Paciente', i.ID_Paciente, 'Actualización', GETDATE(), @Usuario
        FROM inserted i JOIN deleted d ON i.ID_Paciente = d.ID_Paciente;
    END
END;
GO
-----------------------------Trigger de Procedimiento
Use SaludPlus
go
CREATE TRIGGER TR_Auditoria_Procedimiento
ON Procedimiento
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Usuario VARCHAR(50) = SYSTEM_USER;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Procedimiento', ID_Procedimiento, 'Inserción', GETDATE(), @Usuario
        FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Procedimiento', ID_Procedimiento, 'Eliminación', GETDATE(), @Usuario
        FROM deleted;
    END

    IF EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.ID_Procedimiento = d.ID_Procedimiento)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Procedimiento', i.ID_Procedimiento, 'Actualización', GETDATE(), @Usuario
        FROM inserted i JOIN deleted d ON i.ID_Procedimiento = d.ID_Procedimiento;
    END
END;
GO
-----------------------------Trigger de Tipo de Procedimiento
Use SaludPlus
go
CREATE TRIGGER TR_Auditoria_Tipo_Procedimiento
ON Tipo_Procedimiento
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Usuario VARCHAR(50) = SYSTEM_USER;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Tipo_Procedimiento', ID_Tipo_Procedimiento, 'Inserción', GETDATE(), @Usuario
        FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Tipo_Procedimiento', ID_Tipo_Procedimiento, 'Eliminación', GETDATE(), @Usuario
        FROM deleted;
    END

    IF EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.ID_Tipo_Procedimiento = d.ID_Tipo_Procedimiento)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Tipo_Procedimiento', i.ID_Tipo_Procedimiento, 'Actualización', GETDATE(), @Usuario
        FROM inserted i JOIN deleted d ON i.ID_Tipo_Procedimiento = d.ID_Tipo_Procedimiento;
    END
END;
GO
------------------------------Trigger de Historial Medico
Use SaludPlus
go
CREATE TRIGGER TR_Auditoria_Historial_Medico
ON Historial_Medico
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Usuario VARCHAR(50) = SYSTEM_USER;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Historial_Medico', ID_Historial_Medico, 'Inserción', GETDATE(), @Usuario
        FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Historial_Medico', ID_Historial_Medico, 'Eliminación', GETDATE(), @Usuario
        FROM deleted;
    END

    IF EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.ID_Historial_Medico = d.ID_Historial_Medico)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Historial_Medico', i.ID_Historial_Medico, 'Actualización', GETDATE(), @Usuario
        FROM inserted i JOIN deleted d ON i.ID_Historial_Medico = d.ID_Historial_Medico;
    END
END;
GO
------------------------------Trigger de Recurso Medico
use SaludPlus
go
CREATE TRIGGER TR_Auditoria_Recurso_Medico
ON Recurso_Medico
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Usuario VARCHAR(50) = SYSTEM_USER;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Recurso_Medico', ID_Recurso_Medico, 'Inserción', GETDATE(), @Usuario
        FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Recurso_Medico', ID_Recurso_Medico, 'Eliminación', GETDATE(), @Usuario
        FROM deleted;
    END

    IF EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.ID_Recurso_Medico = d.ID_Recurso_Medico)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Recurso_Medico', i.ID_Recurso_Medico, 'Actualización', GETDATE(), @Usuario
        FROM inserted i JOIN deleted d ON i.ID_Recurso_Medico = d.ID_Recurso_Medico;
    END
END;
GO
---------------------Trigger de Estado del Recurso Medico
use SaludPlus
go
CREATE TRIGGER TR_Auditoria_Estado_Recurso_Medico
ON Estado_Recurso_Medico
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Usuario VARCHAR(50) = SYSTEM_USER;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Estado_Recurso_Medico', ID_Estado_Recurso_Medico, 'Inserción', GETDATE(), @Usuario
        FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Estado_Recurso_Medico', ID_Estado_Recurso_Medico, 'Eliminación', GETDATE(), @Usuario
        FROM deleted;
    END

    IF EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.ID_Estado_Recurso_Medico = d.ID_Estado_Recurso_Medico)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Estado_Recurso_Medico', i.ID_Estado_Recurso_Medico, 'Actualización', GETDATE(), @Usuario
        FROM inserted i JOIN deleted d ON i.ID_Estado_Recurso_Medico = d.ID_Estado_Recurso_Medico;
    END
END;
GO
------------------------------Trigger para Tipo de Recurso
use SaludPlus
go
CREATE TRIGGER TR_Auditoria_Tipo_Recurso
ON Tipo_Recurso
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Usuario VARCHAR(50) = SYSTEM_USER;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Tipo_Recurso', ID_Tipo_Recurso, 'Inserción', GETDATE(), @Usuario
        FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Tipo_Recurso', ID_Tipo_Recurso, 'Eliminación', GETDATE(), @Usuario
        FROM deleted;
    END

    IF EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.ID_Tipo_Recurso = d.ID_Tipo_Recurso)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Tipo_Recurso', i.ID_Tipo_Recurso, 'Actualización', GETDATE(), @Usuario
        FROM inserted i JOIN deleted d ON i.ID_Tipo_Recurso = d.ID_Tipo_Recurso;
    END
END;
GO
-----------------------------Trigger para Sala
use SaludPlus
go
CREATE TRIGGER TR_Auditoria_Sala
ON Sala
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Usuario VARCHAR(50) = SYSTEM_USER;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Sala', ID_Sala, 'Inserción', GETDATE(), @Usuario
        FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Sala', ID_Sala, 'Eliminación', GETDATE(), @Usuario
        FROM deleted;
    END

    IF EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.ID_Sala = d.ID_Sala)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Sala', i.ID_Sala, 'Actualización', GETDATE(), @Usuario
        FROM inserted i JOIN deleted d ON i.ID_Sala = d.ID_Sala;
    END
END;
GO

-----------------------------Trigger Estado de Sala
Use SaludPlus
go
 CREATE TRIGGER TR_Auditoria_Estado_Sala
ON Estado_Sala
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Usuario VARCHAR(50) = SYSTEM_USER;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Estado_Sala', ID_Estado_Sala, 'Inserción', GETDATE(), @Usuario
        FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Estado_Sala', ID_Estado_Sala, 'Eliminación', GETDATE(), @Usuario
        FROM deleted;
    END

    IF EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.ID_Estado_Sala = d.ID_Estado_Sala)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Estado_Sala', i.ID_Estado_Sala, 'Actualización', GETDATE(), @Usuario
        FROM inserted i JOIN deleted d ON i.ID_Estado_Sala = d.ID_Estado_Sala;
    END
END;
GO
---------------------------------Trigger Para Tipo de Sala
use SaludPlus
go
CREATE TRIGGER TR_Auditoria_Tipo_Sala
ON Tipo_Sala
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Usuario VARCHAR(50) = SYSTEM_USER;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Tipo_Sala', ID_Tipo_Sala, 'Inserción', GETDATE(), @Usuario
        FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Tipo_Sala', ID_Tipo_Sala, 'Eliminación', GETDATE(), @Usuario
        FROM deleted;
    END

    IF EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.ID_Tipo_Sala = d.ID_Tipo_Sala)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Tipo_Sala', i.ID_Tipo_Sala, 'Actualización', GETDATE(), @Usuario
        FROM inserted i JOIN deleted d ON i.ID_Tipo_Sala = d.ID_Tipo_Sala;
    END
END;
GO
------------------------------Trigger para Medico
use SaludPlus
go
CREATE TRIGGER TR_Auditoria_Medico
ON Medico
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Medico', ID_Medico, 'Inserción', GETDATE(), SYSTEM_USER
        FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Medico', ID_Medico, 'Eliminación', GETDATE(), SYSTEM_USER
        FROM deleted;
    END

    IF EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.ID_Medico = d.ID_Medico)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Medico', i.ID_Medico, 'Actualización', GETDATE(), SYSTEM_USER
        FROM inserted i JOIN deleted d ON i.ID_Medico = d.ID_Medico;
    END
END;
GO
-----------------------------Trigger para Especialidad
use SaludPlus
go
CREATE TRIGGER TR_Auditoria_Especialidad
ON Especialidad
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Especialidad', ID_Especialidad, 'Inserción', GETDATE(), SYSTEM_USER
        FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Especialidad', ID_Especialidad, 'Eliminación', GETDATE(), SYSTEM_USER
        FROM deleted;
    END

    IF EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.ID_Especialidad = d.ID_Especialidad)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Especialidad', i.ID_Especialidad, 'Actualización', GETDATE(), SYSTEM_USER
        FROM inserted i JOIN deleted d ON i.ID_Especialidad = d.ID_Especialidad;
    END
END;
GO
------------------------Trigger para Recurso Medico Sala
use SaludPlus
go
CREATE TRIGGER TR_Auditoria_Recurso_Medico_Sala
ON Recurso_Medico_Sala
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Recurso_Medico_Sala', ID_Recurso_Medico_Sala, 'Inserción', GETDATE(), SYSTEM_USER
        FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Recurso_Medico_Sala', ID_Recurso_Medico_Sala, 'Eliminación', GETDATE(), SYSTEM_USER
        FROM deleted;
    END

    IF EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.ID_Recurso_Medico_Sala = d.ID_Recurso_Medico_Sala)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Recurso_Medico_Sala', i.ID_Recurso_Medico_Sala, 'Actualización', GETDATE(), SYSTEM_USER
        FROM inserted i JOIN deleted d ON i.ID_Recurso_Medico_Sala = d.ID_Recurso_Medico_Sala;
    END
END;
GO
----------------------------Trigger para Horario de Trabajo
use SaludPlus
go
CREATE TRIGGER TR_Auditoria_Horario_Trabajo
ON Horario_Trabajo
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Horario_Trabajo', ID_Horario_Trabajo, 'Inserción', GETDATE(), SYSTEM_USER
        FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Horario_Trabajo', ID_Horario_Trabajo, 'Eliminación', GETDATE(), SYSTEM_USER
        FROM deleted;
    END

    IF EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.ID_Horario_Trabajo = d.ID_Horario_Trabajo)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Horario_Trabajo', i.ID_Horario_Trabajo, 'Actualización', GETDATE(), SYSTEM_USER
        FROM inserted i JOIN deleted d ON i.ID_Horario_Trabajo = d.ID_Horario_Trabajo;
    END
END;
GO
--------------------------------Trigger de Planificacion Recurso
use SaludPlus
go
CREATE TRIGGER TR_Auditoria_Planificacion_Recurso
ON Planificacion_Recurso
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Planificacion_Recurso', ID_Planificacion, 'Inserción', GETDATE(), SYSTEM_USER
        FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Planificacion_Recurso', ID_Planificacion, 'Eliminación', GETDATE(), SYSTEM_USER
        FROM deleted;
    END

    IF EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.ID_Planificacion = d.ID_Planificacion)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Planificacion_Recurso', i.ID_Planificacion, 'Actualización', GETDATE(), SYSTEM_USER
        FROM inserted i JOIN deleted d ON i.ID_Planificacion = d.ID_Planificacion;
    END
END;
GO
-------------------------------Trigger para Medico Planificacion Recurso
use SaludPlus
go
CREATE TRIGGER TR_Auditoria_Medico_Planificacion_Recurso
ON Medico_Planificacion_Recurso
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Medico_Planificacion_Recurso', ID_Medico_Planificacion_Recurso, 'Inserción', GETDATE(), SYSTEM_USER
        FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Medico_Planificacion_Recurso', ID_Medico_Planificacion_Recurso, 'Eliminación', GETDATE(), SYSTEM_USER
        FROM deleted;
    END

    IF EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.ID_Medico_Planificacion_Recurso = d.ID_Medico_Planificacion_Recurso)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Medico_Planificacion_Recurso', i.ID_Medico_Planificacion_Recurso, 'Actualización', GETDATE(), SYSTEM_USER
        FROM inserted i JOIN deleted d ON i.ID_Medico_Planificacion_Recurso = d.ID_Medico_Planificacion_Recurso;
    END
END;
GO
------------------------------Trigger para Satisfacion de Paciente
use SaludPlus
go
CREATE TRIGGER TR_Auditoria_Satisfaccion_Paciente
ON Satisfaccion_Paciente
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Satisfaccion_Paciente', ID_Satisfaccion, 'Inserción', GETDATE(), SYSTEM_USER
        FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Satisfaccion_Paciente', ID_Satisfaccion, 'Eliminación', GETDATE(), SYSTEM_USER
        FROM deleted;
    END
    IF EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.ID_Satisfaccion = d.ID_Satisfaccion)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Satisfaccion_Paciente', i.ID_Satisfaccion, 'Actualización', GETDATE(), SYSTEM_USER
        FROM inserted i JOIN deleted d ON i.ID_Satisfaccion = d.ID_Satisfaccion;
    END
END;
GO


-----------------------------Trigger para Rol
use SaludPlus
go
CREATE TRIGGER TR_Auditoria_Rol
ON Rol
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Usuario VARCHAR(50) = SYSTEM_USER;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Rol', ID_Rol, 'Inserción', GETDATE(), @Usuario
        FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Rol', ID_Rol, 'Eliminación', GETDATE(), @Usuario
        FROM deleted;
    END

    IF EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.ID_Rol = d.ID_Rol)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Rol', i.ID_Rol, 'Actualización', GETDATE(), @Usuario
        FROM inserted i JOIN deleted d ON i.ID_Rol = d.ID_Rol;
    END
END;
GO
---------------------------------Trigger para Usuario
use SaludPlus
go
CREATE TRIGGER TR_Auditoria_Usuario
ON Usuario
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Usuario VARCHAR(50) = SYSTEM_USER;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Usuario', ID_Usuario, 'Inserción', GETDATE(), @Usuario
        FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Usuario', ID_Usuario, 'Eliminación', GETDATE(), @Usuario
        FROM deleted;
    END

    IF EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.ID_Usuario = d.ID_Usuario)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Usuario', i.ID_Usuario, 'Actualización', GETDATE(), @Usuario
        FROM inserted i JOIN deleted d ON i.ID_Usuario = d.ID_Usuario;
    END
END;
GO
--------------------------Trigger para Permiso 
use SaludPlus
go
CREATE TRIGGER TR_Auditoria_Permiso
ON Permiso
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Usuario VARCHAR(50) = SYSTEM_USER;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Permiso', ID_Permiso, 'Inserción', GETDATE(), @Usuario
        FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Permiso', ID_Permiso, 'Eliminación', GETDATE(), @Usuario
        FROM deleted;
    END

    IF EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.ID_Permiso = d.ID_Permiso)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Permiso', i.ID_Permiso, 'Actualización', GETDATE(), @Usuario
        FROM inserted i JOIN deleted d ON i.ID_Permiso = d.ID_Permiso;
    END
END;
GO
-------------------Trigger para Rol Permiso
use SaludPlus
go
CREATE TRIGGER TR_Auditoria_Rol_Permiso
ON Rol_Permiso
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Usuario VARCHAR(50) = SYSTEM_USER;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Rol_Permiso', ID_Rol_Permiso, 'Inserción', GETDATE(), @Usuario
        FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Rol_Permiso', ID_Rol_Permiso, 'Eliminación', GETDATE(), @Usuario
        FROM deleted;
    END

    IF EXISTS (SELECT * FROM inserted i JOIN deleted d ON i.ID_Rol_Permiso = d.ID_Rol_Permiso)
    BEGIN
        INSERT INTO Auditoria (Nombre_Tabla, ID_Registro, Accion, FechaAuditoria, Usuario)
        SELECT 'Rol_Permiso', i.ID_Rol_Permiso, 'Actualización', GETDATE(), @Usuario
        FROM inserted i JOIN deleted d ON i.ID_Rol_Permiso = d.ID_Rol_Permiso;
    END
END;
GO


