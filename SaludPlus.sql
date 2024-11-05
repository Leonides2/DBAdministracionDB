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

-------------------------------------------------Seguridad-------------------------------------------------------

use SaludPlus
go
CREATE SCHEMA Administrador
go
CREATE SCHEMA Médico
go
CREATE SCHEMA Recepcionista
go





--- INSERCIONES EN EL SCRIPT DE INSERCIONES

--------------------------------------------------Vistas---------------------------------------------------------


CREATE VIEW vw_Paciente AS
SELECT 
ID_Paciente,
Nombre_Paciente ,
Apellido1_Paciente, 
Apellido2_Paciente, 
Telefono_Paciente, 
Fecha_Nacimiento, 
Direccion_Paciente, 
Cedula
FROM Paciente;
GO

/*
Select * from vw_Paciente
go
*/

CREATE VIEW vw_Medico AS
SELECT 
Medico.Nombre1_Medico, 
Medico.Nombre2_Medico, 
Medico.Apellido1_Medico, 
Medico.Apellido2_Medico, 
Medico.Telefono_Medico,
Especialidad.Nombre_Especialidad
FROM Medico inner join Especialidad on Especialidad.ID_Especialidad = Medico.ID_Especialidad;
GO

/*
Select * from vw_Medico
go
*/

CREATE VIEW vw_Cita AS
SELECT 
Cita.Fecha_Cita,
Cita.Hora_Cita,
Cita.ID_Medico, 
Estado_Cita.Estado, 
Paciente.Cedula
FROM Cita inner join Paciente on Cita.ID_Paciente = Paciente.ID_Paciente
left join Estado_Cita on Cita.ID_Estado_Cita = Estado_Cita.ID_Estado_Cita;
GO

/*
Select * from vw_Cita
go
*/
CREATE VIEW vw_Factura AS
SELECT 
Factura.Fecha_Factura,
Factura.Monto_Total,
Paciente.Cedula, 
Tipo_Pago.Descripcion_Tipo_Pago
FROM Factura inner join Paciente on Factura.ID_Paciente = Paciente.ID_Paciente
left join Tipo_Pago on Tipo_Pago.ID_Tipo_Pago = Factura.ID_Tipo_Pago;
GO

/*
	Select * from vw_Factura
	go
*/

CREATE VIEW vw_Recurso_Medico_Sala AS
SELECT 
Recurso_Medico_Sala.Fecha,
Recurso_Medico_Sala.Cantidad_Recurso,
Recurso_Medico.Lote, 
Sala.Nombre_Sala
FROM Recurso_Medico_Sala inner join Recurso_Medico on Recurso_Medico.ID_Recurso_Medico = Recurso_Medico_Sala.ID_Recurso_Medico
left join Sala on Sala.ID_Sala = Recurso_Medico_Sala.ID_Sala;
GO
/*
	Select * from vw_Recurso_Medico_Sala
	go
*/

--------------------------------------------------Procedimientos almacenados INSERT------------------------------
 ---------------------Registrar Paciente
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarPaciente
(
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
		
		IF LEN(@Nombre_Paciente) < 1
        BEGIN
            RAISERROR (N'Debe tener nombre', 16, 1);
            RETURN;
        END

		IF LEN(@Apellido1_Paciente) < 1
        BEGIN
            RAISERROR (N'Debe tener primer apellido', 16, 1);
            RETURN;
        END

		IF LEN(@Apellido2_Paciente) < 1
        BEGIN
            RAISERROR (N'Debe tener segundo apellido', 16, 1);
            RETURN;
        END

		IF LEN(@Direccion_Paciente) < 1
        BEGIN
            RAISERROR (N'Debe tener direccion', 16, 1);
            RETURN;
        END
		
		IF @Fecha_Nacimiento is null
		BEGIN
			RAISERROR (N'La fecha no puede ser nula', 16, 1);
            RETURN;
		END

		IF LEN(@Cedula) <> 9
        BEGIN
            RAISERROR (N'La cédula debe tener exactamente 9 dígitos', 16, 1);
            RETURN;
        END
        -- Verificar si ya existe un paciente con la misma cédula
        IF EXISTS (SELECT 1 FROM Paciente WHERE Cedula = @Cedula)
        BEGIN
            RAISERROR (N'Ya existe un usuario con esa cédula registrado', 16, 1);
            RETURN;
        END

        -- Insertar el nuevo paciente si no existe la cédula
        INSERT INTO Paciente 
        (Nombre_Paciente, Apellido1_Paciente, Apellido2_Paciente, Telefono_Paciente, Fecha_Nacimiento, Direccion_Paciente, Cedula)
        VALUES 
        (
		TRIM(@Nombre_Paciente), 
		TRIM(@Apellido1_Paciente), 
		TRIM(@Apellido2_Paciente), 
		TRIM(@Telefono_Paciente), 
		TRIM(@Fecha_Nacimiento), 
		TRIM(@Direccion_Paciente), 
		TRIM(@Cedula));

        PRINT 'El paciente se ha registrado correctamente.';

		DECLARE @Current_Usuario int = (Select ID_Paciente from Paciente Where Cedula = Cedula)

		 -- Insertar historial médico con la fecha de registro automática
        INSERT INTO Historial_Medico (Fecha_Registro, ID_Paciente)
        VALUES (CAST(GETDATE() AS DATE), @Current_Usuario);  -- Usa la fecha actual
        PRINT 'El historial médico se ha registrado correctamente.';

    END TRY
    BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);
    
		-- Capturar el mensaje de error del sistema
		SET @ErrorMessage = ERROR_MESSAGE();
    
		-- Lanzar un error
		RAISERROR (N'Error al registrar el paciente: %s', 16, 1, @ErrorMessage);
	END CATCH;
END;
GO


------------Registrar Especialidad
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarEspecialidad
(
    @Nombre_Especialidad VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
	 
	BEGIN TRY
		
		IF LEN(TRIM(@Nombre_Especialidad)) < 1
        BEGIN
            RAISERROR (N'Debe tener un nombre', 16, 1);
            RETURN;
        END
		-- Verificar si el nombre de la especialidad ya existe
		IF EXISTS (SELECT 1 FROM Especialidad WHERE Nombre_Especialidad = @Nombre_Especialidad)
		BEGIN
			RAISERROR('El nombre de la especialidad ya existe.', 16, 1);
			RETURN;
		END
    
        INSERT INTO Especialidad (  Nombre_Especialidad)
        VALUES ( TRIM(@Nombre_Especialidad));

        PRINT 'La especialidad se ha registrado correctamente.';
	END TRY
    BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);
    
		-- Capturar el mensaje de error del sistema
		SET @ErrorMessage = ERROR_MESSAGE();
    
		-- Lanzar un error
		RAISERROR (N'Error al registrar la especialidad: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO



------------------------Registrar Medico
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarMedico
(
 
    @Nombre1_Medico VARCHAR(50),
    @Nombre2_Medico VARCHAR(50),
    @Apellido1_Medico VARCHAR(50),
    @Apellido2_Medico VARCHAR(50),
    @Telefono_Medico VARCHAR(50),
    @Especialidad VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

	BEGIN TRY
    -- Verificar si la especialidad existe
    IF NOT EXISTS (SELECT 1 FROM Especialidad WHERE Nombre_Especialidad = @Especialidad)
    BEGIN
		--Sugerir opciones en el error

		DECLARE @Sugerencias NVARCHAR(1000) = ''
		DECLARE @SugeInSitu varchar(50)

		DECLARE SugerenciasMedico Cursor 
		For Select top 5 Nombre_Especialidad from Especialidad where Lower(Nombre_Especialidad) like '%'+Lower(@Especialidad)+'%'

		OPEN SugerenciasMedico 
		fetch SugerenciasMedico into @SugeInSitu
		WHILE(@@FETCH_STATUS = 0)
		BEGIN
			SET @Sugerencias =  @Sugerencias + @SugeInSitu + ', '
			fetch SugerenciasMedico into @SugeInSitu
		END
		CLOSE SugerenciasMedico
		Deallocate SugerenciasMedico

        RAISERROR('La especialidad no existe. ¿Quizo decir alguna de las siguientes? : %s', 16, 1, @Sugerencias);
        RETURN;
    END

	IF EXISTS (SELECT 1 FROM Medico Where Lower(@Nombre1_Medico+@Nombre2_Medico+@Apellido1_Medico+@Apellido2_Medico) 
	= LOWER(TRIM(@Nombre1_Medico)+ TRIM(@Nombre2_Medico)+ TRIM(@Apellido1_Medico)+ TRIM(@Apellido2_Medico)))
		BEGIN	
			
			RAISERROR('El medico ya existe.', 16, 1, @Sugerencias);
			RETURN;
		END

		Declare @ID_Especialidad int = (Select top 1 ID_Especialidad from Especialidad where Nombre_Especialidad like @Especialidad)
        INSERT INTO Medico (Nombre1_Medico, Nombre2_Medico, Apellido1_Medico, Apellido2_Medico, Telefono_Medico, ID_Especialidad)
        VALUES (
		TRIM(@Nombre1_Medico), 
		TRIM(@Nombre2_Medico), 
		TRIM(@Apellido1_Medico), 
		TRIM(@Apellido2_Medico), 
		TRIM(@Telefono_Medico), 
		@ID_Especialidad);

        PRINT 'El medico se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);
    
		-- Capturar el mensaje de error del sistema
		SET @ErrorMessage = ERROR_MESSAGE();
    
		-- Lanzar un error
		RAISERROR (N'Error al registrar el medico: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO



-------Registrar Estado de la cita
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarEstadoCita
(
    @Estado VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
		-- Verificar si el estado ya existe
		IF EXISTS (SELECT 1 FROM Estado_Cita WHERE Lower(Estado) = Lower(@Estado))
		BEGIN
			RAISERROR('El estado de cita ya existe.', 16, 1);
			RETURN;
		END
    
        INSERT INTO Estado_Cita (  Estado)
        VALUES (TRIM(@Estado));

        PRINT 'El estado de cita se ha registrado correctamente.';
    END TRY
    BEGIN CATCH

		DECLARE @ErrorMessage NVARCHAR(4000);
    
		-- Capturar el mensaje de error del sistema
		SET @ErrorMessage = ERROR_MESSAGE();
    
		-- Lanzar un error
		RAISERROR (N'Error al registrar el estado de cita: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO


---------------Registrar Cita
Use SaludPlus
go
CREATE PROCEDURE Sp_RegistrarCita
(
    
	@Fecha_Cita DATE,
    @Hora_Cita TIME,
	@ID_Medico INT,
	@Estado VARCHAR(50),
    @Cedula VARCHAR(12)
)
AS
BEGIN

	BEGIN TRY

		IF LEN(@Cedula) <> 9
        BEGIN
            RAISERROR (N'La cédula debe tener exactamente 9 dígitos', 16, 1);
            RETURN;
        END

		IF NOT EXISTS (SELECT 1 FROM Paciente WHERE Cedula = Trim(@Cedula))
			BEGIN
				RAISERROR('La cedula del paciente no existe.', 16, 1);
				RETURN;
			END

		IF NOT EXISTS (SELECT 1 FROM Medico WHERE ID_Medico = @ID_Medico)
			BEGIN
				RAISERROR('El ID del médico no existe.', 16, 2);
				RETURN;
			END

		IF NOT EXISTS (SELECT 1 FROM Estado_Cita WHERE Lower(Estado) like TRIM(lower(@Estado)))
        BEGIN
            RAISERROR('El estado de la cita no existe.', 16, 2);
            RETURN;
		END

		DECLARE @ID_Paciente int = (Select top 1 ID_Paciente from Paciente where Cedula like @Cedula)
		DECLARE @ID_Estado_Cita int = (Select top 1 ID_Estado_Cita from Estado_Cita where Lower(Estado) like Trim(Lower(@Estado)))
		

	 -- Verificar si el paciente ya tiene una cita a la misma hora y fecha
		IF EXISTS (SELECT 1 FROM Cita WHERE ID_Paciente = @ID_Paciente AND Fecha_Cita = @Fecha_Cita AND Hora_Cita = @Hora_Cita)
		BEGIN
			RAISERROR('El paciente ya tiene una cita a la misma hora y fecha.', 16, 3);
			RETURN;
		END
	
		INSERT INTO Cita ( Fecha_Cita, Hora_Cita, ID_Paciente, ID_Medico, ID_Estado_Cita)
		VALUES ( @Fecha_Cita, @Hora_Cita, @ID_Paciente, @ID_Medico,@ID_Estado_Cita);

		PRINT 'La cita se ha registrado correctamente';
	END TRY
    BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);
    
		-- Capturar el mensaje de error del sistema
		SET @ErrorMessage = ERROR_MESSAGE();
    
		-- Lanzar un error
		RAISERROR (N'Error al registrar la cita: %s', 16, 1, @ErrorMessage);
    END CATCH
	END;
GO


-----------------Tipo de Pago
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarTipoPago
(
  
    @Descripcion_Tipo_Pago VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
	-- Verificar si el tipo de pago ya existe
    IF EXISTS (SELECT 1 FROM Tipo_Pago WHERE Descripcion_Tipo_Pago = @Descripcion_Tipo_Pago)
    BEGIN
        RAISERROR('El tipo de pago ya existe.', 16, 1);
        RETURN;
    END
    
        INSERT INTO Tipo_Pago (  Descripcion_Tipo_Pago)
        VALUES ( @Descripcion_Tipo_Pago);

        PRINT 'El tipo de pago se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);
    
		-- Capturar el mensaje de error del sistema
		SET @ErrorMessage = ERROR_MESSAGE();
    
		-- Lanzar un error
		RAISERROR (N'Error al registrar el tipo de pago: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO


--------------Registrar Factura
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarFactura
(
	@Fecha_Factura DATE,
    @Monto_Total MONEY,
    @Cedula VARCHAR(12),
    @ID_Cita INT,
	@Tipo_Pago VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
    -- Verificar si el paciente existe
	IF NOT EXISTS (SELECT 1 FROM Paciente WHERE Cedula = Trim(@Cedula))
			BEGIN
				RAISERROR('La cedula del paciente no existe.', 16, 1);
				RETURN;
			END
		 -- Verificar si la cita existe
    IF NOT EXISTS (SELECT 1 FROM Cita WHERE ID_Cita = @ID_Cita)
        BEGIN
            RAISERROR('El ID de cita no existe.', 16, 1);
            RETURN;
        END

	IF NOT EXISTS (SELECT 1 FROM Tipo_Pago WHERE Lower(Descripcion_Tipo_Pago) = Trim(Lower(@Tipo_Pago)))
    BEGIN
        RAISERROR('El tipo de pago no existe.', 16, 1);
        RETURN;
    END

	DECLARE @ID_Paciente int = (Select top 1 ID_Paciente from Paciente where Cedula like @Cedula)
	DECLARE @ID_Tipo_Pago int = (Select top 1 ID_Tipo_Pago from Tipo_Pago where Lower(Descripcion_Tipo_Pago) like Trim(Lower(@Tipo_Pago)))
		
        INSERT INTO Factura ( Fecha_Factura, Monto_Total, ID_Paciente, ID_Cita,ID_Tipo_Pago)
        VALUES ( @Fecha_Factura, @Monto_Total, @ID_Paciente, @ID_Cita,@ID_Tipo_Pago);

        PRINT 'La factura se ha registrado correctamente.'
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar la factura: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

--------------------Insertar Historial Medico
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarHistorialMedico
(
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
        RAISERROR('El paciente ya tiene un historial medico registrado.', 16, 2);
        RETURN;
    END

     BEGIN TRY
        -- Insertar historial médico con la fecha de registro automática
        INSERT INTO Historial_Medico (Fecha_Registro, ID_Paciente)
        VALUES (CAST(GETDATE() AS DATE), @ID_Paciente);  -- Usa la fecha actual
        PRINT 'El historial médico se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el historial médico: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


 -- Insertar historial médico para el paciente con ID 6
EXEC Sp_RegistrarHistorialMedico @ID_Paciente = 6;
go
-- Insertar historial médico para el paciente con ID 7
EXEC Sp_RegistrarHistorialMedico @ID_Paciente = 7;
go
-- Insertar historial médico para el paciente con ID 8
EXEC Sp_RegistrarHistorialMedico @ID_Paciente = 8;
go
-- Insertar historial médico para el paciente con ID 9
EXEC Sp_RegistrarHistorialMedico @ID_Paciente = 9;
go

--------
/*
Sigo mañana


*/


-----------Insertar Estado de la Sala
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarEstadoSala
(
   
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
        INSERT INTO Estado_Sala (  Nombre)
        VALUES (  @Nombre);

        PRINT 'El estado de sala se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el estado de sala: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Insertar estado de sala 1
EXEC Sp_RegistrarEstadoSala  @Nombre = 'Inactiva';
go
-- Insertar estado de sala 2
EXEC Sp_RegistrarEstadoSala  @Nombre = 'En mantenimiento';
go
-- Insertar estado de sala 3
EXEC Sp_RegistrarEstadoSala  @Nombre = 'Cerrada';
go

------------------Registrar Tipo de Sala
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarTipoSala
(
    @Descripcion_Tipo_Sala VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
	-- Verificar si la descripci�n del tipo de sala ya existe
    IF EXISTS (SELECT 1 FROM Tipo_Sala WHERE Descripcion_Tipo_Sala = @Descripcion_Tipo_Sala)
    BEGIN
        RAISERROR('La descripción del tipo de sala ya existe.', 16, 1);
        RETURN;
    END
    BEGIN TRY
        INSERT INTO Tipo_Sala (  Descripcion_Tipo_Sala)
        VALUES (  @Descripcion_Tipo_Sala);

        PRINT 'El tipo de sala se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el tipo de sala: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Insertar tipo de sala 1
EXEC Sp_RegistrarTipoSala  @Descripcion_Tipo_Sala = 'Ginecología';
go
-- Insertar tipo de sala 2
EXEC Sp_RegistrarTipoSala  @Descripcion_Tipo_Sala = 'Traumatología';
go
-- Insertar tipo de sala 3
EXEC Sp_RegistrarTipoSala  @Descripcion_Tipo_Sala = 'Cardiología';
go
-- Insertar tipo de sala 5
EXEC Sp_RegistrarTipoSala  @Descripcion_Tipo_Sala = 'Oncología';
go

-------------------Insertar Sala  
Use SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarSala
(
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
        INSERT INTO Sala (  Nombre_Sala, Capacidad_Sala, ID_Tipo_Sala, ID_Estado_Sala)
        VALUES (  @Nombre_Sala, @Capacidad_Sala, @ID_Tipo_Sala, @ID_Estado_Sala);

        PRINT 'La sala se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar la sala: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Insertar sala 1
EXEC Sp_RegistrarSala  @Nombre_Sala = 'Sala de Ginecología',@Capacidad_Sala = 4,@ID_Tipo_Sala = 2,@ID_Estado_Sala = 3;
go
-- Insertar sala 2
EXEC Sp_RegistrarSala  @Nombre_Sala = 'Sala de Traumatología',@Capacidad_Sala = 5,@ID_Tipo_Sala = 3,@ID_Estado_Sala = 2;
go
-- Insertar sala 3
EXEC Sp_RegistrarSala  @Nombre_Sala = 'Sala de Cardiología',@Capacidad_Sala = 3,@ID_Tipo_Sala = 4,@ID_Estado_Sala = 1;
go


------------------Registrar Tipo de Procedimiento 
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarTipoProcedimiento
(
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
        INSERT INTO Tipo_Procedimiento (  Nombre_Procedimiento)
        VALUES (  @Nombre_Procedimiento);

        PRINT 'El tipo de procedimiento se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el tipo de procedimiento: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
-- Insertar tipo de procedimiento 1
EXEC Sp_RegistrarTipoProcedimiento  @Nombre_Procedimiento = 'Cita de Ginecología';
go
-- Insertar tipo de procedimiento 2
EXEC Sp_RegistrarTipoProcedimiento   @Nombre_Procedimiento = 'Cita de Traumatología';
go
-- Insertar tipo de procedimiento 3
EXEC Sp_RegistrarTipoProcedimiento  @Nombre_Procedimiento = 'Cita de Cardiología';
go

---------------------Registrar Procedimiento
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarProcedimiento
(
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
        INSERT INTO Procedimiento (  Descripcion_Procedimiento, Fecha_Procedimiento, Hora_Procedimiento, Monto_Procedimiento, Receta, ID_Sala, ID_Historial_Medico, ID_Cita, ID_Tipo_Procedimiento)
        VALUES (  @Descripcion_Procedimiento, @Fecha_Procedimiento, @Hora_Procedimiento, @Monto_Procedimiento, @Receta, @ID_Sala, @ID_Historial_Medico, @ID_Cita, @ID_Tipo_Procedimiento);

        PRINT 'El procedimiento se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el procedimiento: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC Sp_RegistrarProcedimiento  @Descripcion_Procedimiento = 'Consulta de medicina interna',@Fecha_Procedimiento = '2024-08-01', 
    @Hora_Procedimiento = '11:00',@Monto_Procedimiento = 5000,@Receta = 'Reposo y seguimiento',@ID_Sala = 1,@ID_Historial_Medico = 6,@ID_Cita = 6,@ID_Tipo_Procedimiento = 1;
	go
EXEC Sp_RegistrarProcedimiento @Descripcion_Procedimiento = 'Examen de laboratorio',@Fecha_Procedimiento = '2024-08-15',
    @Hora_Procedimiento = '09:30',@Monto_Procedimiento = 1500,@Receta = 'Ninguna',@ID_Sala = 2,@ID_Historial_Medico = 7,@ID_Cita = 7,@ID_Tipo_Procedimiento = 2;
	go
EXEC Sp_RegistrarProcedimiento  @Descripcion_Procedimiento = 'Radiografía de abdomen',@Fecha_Procedimiento = '2024-08-20',
    @Hora_Procedimiento = '13:00',@Monto_Procedimiento = 2000,@Receta = 'Ninguna',@ID_Sala = 3,@ID_Historial_Medico = 8,@ID_Cita = 8,@ID_Tipo_Procedimiento = 2;
	go
EXEC Sp_RegistrarProcedimiento  @Descripcion_Procedimiento = 'Consulta pediátrica',@Fecha_Procedimiento = '2024-09-01',@Hora_Procedimiento = '10:00',
     @Monto_Procedimiento = 6000,@Receta = 'Paracetamol si es necesario',@ID_Sala = 4,@ID_Historial_Medico = 5,@ID_Cita = 2,@ID_Tipo_Procedimiento = 3;
	 go
EXEC Sp_RegistrarProcedimiento  @Descripcion_Procedimiento = 'Consulta de ortopedia',@Fecha_Procedimiento = '2024-09-10', 
    @Hora_Procedimiento = '14:30',@Monto_Procedimiento = 7000,@Receta = 'Hielo y descanso',@ID_Sala = 5,@ID_Historial_Medico =1,@ID_Cita = 10,@ID_Tipo_Procedimiento = 7;
	go

-------------Registrar Estado del Recurso Medico
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarEstadoRecursoMedico
(
     
    @Estado_Recurso VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
    -- Verificar si el estado del recurso m�dico ya existe
    IF EXISTS (SELECT 1 FROM Estado_Recurso_Medico WHERE Estado_Recurso = @Estado_Recurso)
    BEGIN
        RAISERROR('El estado del recurso médico ya existe.', 16, 1);
        RETURN;
    END
    BEGIN TRY
        INSERT INTO Estado_Recurso_Medico (  Estado_Recurso)
        VALUES (  @Estado_Recurso);

        PRINT 'El estado de recurso médico se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el estado de recurso médico: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC Sp_RegistrarEstadoRecursoMedico  @Estado_Recurso = 'En mantenimiento';
go
EXEC Sp_RegistrarEstadoRecursoMedico  @Estado_Recurso = 'Reparación necesaria';
go
EXEC Sp_RegistrarEstadoRecursoMedico  @Estado_Recurso = 'Fuera de servicio';
go
EXEC Sp_RegistrarEstadoRecursoMedico  @Estado_Recurso = 'Reservado';
go
--------------------Registrar Tipo de Recurso
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarTipoRecurso
(
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
        INSERT INTO Tipo_Recurso (  Titulo_Recurso)
        VALUES (  @Titulo_Recurso);

        PRINT 'El tipo de recurso se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el tipo de recurso: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC Sp_RegistrarTipoRecurso  @Titulo_Recurso = 'Recurso de Diagnóstico';
go
EXEC Sp_RegistrarTipoRecurso  @Titulo_Recurso = 'Equipos de Protección Personal';
go
EXEC Sp_RegistrarTipoRecurso  @Titulo_Recurso = 'Suministros de Emergencia';
go
EXEC Sp_RegistrarTipoRecurso  @Titulo_Recurso = 'Material de Curación';
go

---------------Insertar Recurso Medico
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarRecursoMedico
(
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
        INSERT INTO Recurso_Medico (  Nombre_Recurso, Lote, Cantidad_Stock_Total, Ubicacion_Recurso, ID_Tipo_Recurso, ID_Estado_Recurso_Medico)
        VALUES (  @Nombre_Recurso, @Lote, @Cantidad_Stock_Total, @Ubicacion_Recurso, @ID_Tipo_Recurso, @ID_Estado_Recurso_Medico);

        PRINT 'El recurso médico se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el recurso médico: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC Sp_RegistrarRecursoMedico   @Nombre_Recurso = 'Recurso 6',@Lote = 'Lote 6',@Cantidad_Stock_Total = 150,@Ubicacion_Recurso = 'Almacen 6', 
    @ID_Tipo_Recurso = 1,@ID_Estado_Recurso_Medico = 4;
	go
EXEC Sp_RegistrarRecursoMedico  @Nombre_Recurso = 'Recurso 7',@Lote = 'Lote 7',@Cantidad_Stock_Total = 250,@Ubicacion_Recurso = 'Almacen 7', 
    @ID_Tipo_Recurso = 2,@ID_Estado_Recurso_Medico = 6;
	go
EXEC Sp_RegistrarRecursoMedico  @Nombre_Recurso = 'Recurso 8',@Lote = 'Lote 8',@Cantidad_Stock_Total = 350,@Ubicacion_Recurso = 'Almacen 8', 
    @ID_Tipo_Recurso = 3,@ID_Estado_Recurso_Medico = 5;
	go
EXEC Sp_RegistrarRecursoMedico  @Nombre_Recurso = 'Recurso 9',@Lote = 'Lote 9',@Cantidad_Stock_Total = 450,@Ubicacion_Recurso = 'Almacen 9', 
    @ID_Tipo_Recurso = 6,@ID_Estado_Recurso_Medico = 2;


------------Insertar Recurso_Medico Sala

USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarRecursoMedicoSala
(
    @Fecha DATE,
    @Cantidad_Recurso INT,
    @ID_Recurso_Medico INT,
    @ID_Sala INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el recurso m�dico existe
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
        INSERT INTO Recurso_Medico_Sala (  Fecha, Cantidad_Recurso, ID_Recurso_Medico, ID_Sala)
        VALUES (  @Fecha, @Cantidad_Recurso, @ID_Recurso_Medico, @ID_Sala);

        PRINT 'El recurso médico en sala se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el recurso médico en sala: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC Sp_RegistrarRecursoMedicoSala  @Fecha = '2024-02-01',@Cantidad_Recurso = 25,@ID_Recurso_Medico = 1,@ID_Sala = 1;
go
EXEC Sp_RegistrarRecursoMedicoSala  @Fecha = '2024-02-02',@Cantidad_Recurso = 35,@ID_Recurso_Medico = 2,@ID_Sala = 2;
go
EXEC Sp_RegistrarRecursoMedicoSala  @Fecha = '2024-02-03',@Cantidad_Recurso = 45,@ID_Recurso_Medico = 6,@ID_Sala = 3;
go
EXEC Sp_RegistrarRecursoMedicoSala  @Fecha = '2024-02-04',@Cantidad_Recurso =  55,@ID_Recurso_Medico = 7,@ID_Sala = 8;
go



------------- insertar Horario de trabajo
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarHorarioTrabajo
(
    @Nombre_Horario VARCHAR(50),
    @Hora_Inicio TIME,
    @Hora_Fin TIME
)
AS
BEGIN
    SET NOCOUNT ON;
	-- Validar que Hora_Fin no sea menor que Hora_Inicio
    IF @Hora_Fin < @Hora_Inicio
    BEGIN
        RAISERROR('La hora de fin no puede ser menor que la hora de inicio.', 16, 1);
        RETURN;
    END
    BEGIN TRY
        INSERT INTO Horario_Trabajo ( Nombre_Horario, Hora_Inicio, Hora_Fin)
        VALUES (  @Nombre_Horario, @Hora_Inicio, @Hora_Fin);

        PRINT 'El horario de trabajo se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el horario de trabajo: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC Sp_RegistrarHorarioTrabajo  @Nombre_Horario = 'Turno de fin de semana', @Hora_Inicio = '09:00',@Hora_Fin = '13:00';
go
EXEC Sp_RegistrarHorarioTrabajo  @Nombre_Horario = 'Turno de tarde extendido',@Hora_Inicio = '14:00',@Hora_Fin = '18:30';
go
EXEC Sp_RegistrarHorarioTrabajo  @Nombre_Horario = 'Turno nocturno',@Hora_Inicio = '20:00', @Hora_Fin = '23:00';
go
EXEC Sp_RegistrarHorarioTrabajo  @Nombre_Horario = 'Horario de consultas especiales',@Hora_Inicio = '10:00',@Hora_Fin = '14:00';
go
------------------------------Registrar Planificacion de Recurso
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarPlanificacionRecurso
(
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
        INSERT INTO Planificacion_Recurso (  Descripcion_Planificacion, Fecha_Planificacion, ID_Sala, ID_Horario_Trabajo)
        VALUES (  @Descripcion_Planificacion, @Fecha_Planificacion, @ID_Sala, @ID_Horario_Trabajo);

        PRINT 'La planificación de recurso se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar la planificación de recurso: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC Sp_RegistrarPlanificacionRecurso  @Descripcion_Planificacion = 'Planificación 6',@Fecha_Planificacion = '2024-06-01',@ID_Sala = 1, 
    @ID_Horario_Trabajo = 1;
	go
EXEC Sp_RegistrarPlanificacionRecurso  @Descripcion_Planificacion = 'Planificación 7',@Fecha_Planificacion = '2024-07-01',@ID_Sala = 2, 
    @ID_Horario_Trabajo = 2;
	go
EXEC Sp_RegistrarPlanificacionRecurso  @Descripcion_Planificacion = 'Planificación 8',@Fecha_Planificacion = '2024-08-01',@ID_Sala = 8, 
    @ID_Horario_Trabajo = 5;
	go
EXEC Sp_RegistrarPlanificacionRecurso  @Descripcion_Planificacion = 'Planificación 9',@Fecha_Planificacion = '2024-09-01',@ID_Sala = 3, 
    @ID_Horario_Trabajo = 8;
	go

----------- insertar Medico Planificacion de Recursos
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarMedicoPlanificacionRecurso
(
     
    @Fecha_Planificacion_Personal DATE,
    @ID_Planificacion INT,
    @ID_Medico INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el m�dico y la planificaci�n existen
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
        INSERT INTO Medico_Planificacion_Recurso (  Fecha_Planificacion_Personal, ID_Planificacion, ID_Medico)
        VALUES (  @Fecha_Planificacion_Personal, @ID_Planificacion, @ID_Medico);

        PRINT 'La planificación del médico se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar la planificación del médico: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC Sp_RegistrarMedicoPlanificacionRecurso  @Fecha_Planificacion_Personal = '2024-02-01',@ID_Planificacion = 1,@ID_Medico = 1;
go
EXEC Sp_RegistrarMedicoPlanificacionRecurso  @Fecha_Planificacion_Personal = '2024-02-01',@ID_Planificacion = 2,@ID_Medico = 2;
go
EXEC Sp_RegistrarMedicoPlanificacionRecurso  @Fecha_Planificacion_Personal = '2024-02-01',@ID_Planificacion = 3,@ID_Medico = 3;
go
EXEC Sp_RegistrarMedicoPlanificacionRecurso  @Fecha_Planificacion_Personal = '2024-02-01',@ID_Planificacion = 4, @ID_Medico = 10;
go
---------Insertar Satiscaccion de Paciente
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarSatisfaccionPaciente
(
     
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
	-- Verificar que la calificaci�n est� entre 1 y 5
    IF @Calificacion_Satisfaccion < 1 OR @Calificacion_Satisfaccion > 5
    BEGIN
        RAISERROR('La calificación de satisfacción debe estar entre 1 y 5.', 16, 1);
        RETURN;
    END
    BEGIN TRY
        INSERT INTO Satisfaccion_Paciente (  Fecha_Evaluacion, Calificacion_Satisfaccion, ID_Cita)
        VALUES (  @Fecha_Evaluacion, @Calificacion_Satisfaccion, @ID_Cita);

        PRINT 'La satisfacción del paciente se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar la satisfacción del paciente: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC Sp_RegistrarSatisfaccionPaciente  @Fecha_Evaluacion = '2024-06-02',@Calificacion_Satisfaccion = 5,@ID_Cita = 1;
go
EXEC Sp_RegistrarSatisfaccionPaciente  @Fecha_Evaluacion = '2024-06-03',@Calificacion_Satisfaccion = 4,@ID_Cita = 2;
go
EXEC Sp_RegistrarSatisfaccionPaciente  @Fecha_Evaluacion = '2024-06-04',@Calificacion_Satisfaccion = 3,@ID_Cita = 3;
go
EXEC Sp_RegistrarSatisfaccionPaciente  @Fecha_Evaluacion = '2024-06-05',@Calificacion_Satisfaccion = 2,@ID_Cita = 4;
go
-----------Insertar Rol
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarRol
(
   
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
        INSERT INTO Rol (  Nombre_Rol)
        VALUES (  @Nombre_Rol);

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
	-- Verificar si el correo del usuario ya existe
    IF EXISTS (SELECT 1 FROM Usuario WHERE Correo_Usuario = @Correo_Usuario)
    BEGIN
        RAISERROR('El correo del usuario ya existe.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        INSERT INTO Usuario (  Nombre_Usuario, Correo_Usuario, Contraseña_Usuario, ID_Rol)
        VALUES (  @Nombre_Usuario, @Correo_Usuario, @Contraseña_Usuario, @ID_Rol);

                PRINT 'El usuario se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el usuario: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC Sp_RegistrarUsuario @Nombre_Usuario = 'Ana Torres',@Correo_Usuario = 'ana.torres@saludplus.com',@Contraseña_Usuario = 'contraseña101',@ID_Rol = 1;
go
EXEC Sp_RegistrarUsuario  @Nombre_Usuario = 'Luis Fernández',@Correo_Usuario = 'luis.fernandez@saludplus.com',@Contraseña_Usuario = 'contraseña202', 
    @ID_Rol = 2;
	go
EXEC Sp_RegistrarUsuario  @Nombre_Usuario = 'Elena Ruiz',@Correo_Usuario = 'elena.ruiz@saludplus.com',@Contraseña_Usuario = 'contraseña303', 
    @ID_Rol = 3;
	go
EXEC Sp_RegistrarUsuario  @Nombre_Usuario = 'Fernando Martínez',@Correo_Usuario = 'fernando.martinez@saludplus.com',@Contraseña_Usuario = 'contraseña404', 
    @ID_Rol = 1;
	go
---------Registrar Permiso
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarPermiso
(

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
        INSERT INTO Permiso (  Nombre_Permiso)
        VALUES ( @Nombre_Permiso);

        PRINT 'El permiso se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el permiso: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC Sp_RegistrarPermiso  @Nombre_Permiso = 'Ver Informes';
go
EXEC Sp_RegistrarPermiso @Nombre_Permiso = 'Modificar Informes';
go
EXEC Sp_RegistrarPermiso  @Nombre_Permiso = 'Eliminar Informes';
go
EXEC Sp_RegistrarPermiso  @Nombre_Permiso = 'Gestionar Recursos Médicos';
go

-----------Registrar Rol Permiso
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarRolPermiso
(
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
        INSERT INTO Rol_Permiso (  ID_Rol, ID_Permiso)
        VALUES (  @ID_Rol, @ID_Permiso);

        PRINT 'El permiso ha sido asignado al rol correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al asignar el permiso al rol: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC Sp_RegistrarRolPermiso  @ID_Rol = 2,@ID_Permiso = 2;  -- M�dico puede ver citas
go
EXEC Sp_RegistrarRolPermiso  @ID_Rol = 2,@ID_Permiso = 5;  -- M�dico puede acceder a historial m�dico
go
EXEC Sp_RegistrarRolPermiso  @ID_Rol = 3,@ID_Permiso = 6;  -- Recepcionista puede gestionar pacientes
go
EXEC Sp_RegistrarRolPermiso  @ID_Rol = 3,@ID_Permiso = 1;  -- Recepcionista puede crear citas
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
------------------------- Procedimiento para eliminar Estado_Sala
Use SaludPlus
go
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
----------------------------------------Procedimientos para Modificar---------------------------------------------------------

------------------Modificar Paciente

CREATE PROCEDURE Sp_ModificarPaciente
(
    @ID_Paciente INT,
    @Nombre_Paciente VARCHAR(50) = NULL,
    @Apellido1_Paciente VARCHAR(50) = NULL,
    @Apellido2_Paciente VARCHAR(50) = NULL,
    @Telefono_Paciente VARCHAR(50) = NULL,
	@Fecha_Nacimiento DATE = NULL,
    @Direccion_Paciente VARCHAR(150) = NULL,
	@Cedula VARCHAR(20) = NULL
)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Paciente WHERE ID_Paciente = @ID_Paciente)
    BEGIN
        PRINT 'No existe el Paciente con ID_Paciente = ' + CAST(@ID_Paciente AS VARCHAR)
        RETURN
    END

    UPDATE Paciente
    SET 
        Nombre_Paciente = COALESCE(@Nombre_Paciente, Nombre_Paciente),
        Apellido1_Paciente = COALESCE(@Apellido1_Paciente, Apellido1_Paciente),
        Apellido2_Paciente = COALESCE(@Apellido2_Paciente, Apellido2_Paciente),
        Telefono_Paciente = COALESCE(@Telefono_Paciente, Telefono_Paciente),
		Fecha_Nacimiento = COALESCE(@Fecha_Nacimiento, Fecha_Nacimiento),
        Direccion_Paciente = COALESCE(@Direccion_Paciente, Direccion_Paciente),
		Cedula = COALESCE(@Cedula, Cedula)
    WHERE ID_Paciente = @ID_Paciente

	PRINT 'Paciente con ID_Paciente = ' + CAST(@ID_Paciente AS VARCHAR) + ' modificado exitosamente.';
END
GO

----------------Modificar Especialidad

CREATE PROCEDURE Sp_ModificarEspecialidad
(
    @ID_Especialidad INT,
    @Nombre_Especialidad VARCHAR(50) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Especialidad WHERE ID_Especialidad = @ID_Especialidad)
    BEGIN
        PRINT 'No existe una especialidad con el ID especificado.';
        RETURN;
    END

    IF @Nombre_Especialidad IS NOT NULL AND 
       EXISTS (SELECT 1 FROM Especialidad WHERE Nombre_Especialidad = @Nombre_Especialidad AND ID_Especialidad <> @ID_Especialidad)
    BEGIN
        RAISERROR('El nombre de la especialidad ya existe.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        UPDATE Especialidad
        SET Nombre_Especialidad = COALESCE(@Nombre_Especialidad, Nombre_Especialidad)
        WHERE ID_Especialidad = @ID_Especialidad;

        PRINT 'La especialidad ha sido modificada correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al modificar la especialidad: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-------------Modificar Medico

CREATE PROCEDURE Sp_ModificarMedico
(
    @ID_Medico INT,
    @Nombre1_Medico VARCHAR(50) = NULL,
    @Nombre2_Medico VARCHAR(50) = NULL,
    @Apellido1_Medico VARCHAR(50) = NULL,
    @Apellido2_Medico VARCHAR(50) = NULL,
    @Telefono_Medico VARCHAR(50) = NULL,
    @ID_Especialidad INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Medico WHERE ID_Medico = @ID_Medico)
    BEGIN
        RAISERROR('El ID del médico no existe.', 16, 1);
        RETURN;
    END

    IF @ID_Especialidad IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Especialidad WHERE ID_Especialidad = @ID_Especialidad)
    BEGIN
        RAISERROR('El ID de especialidad no existe.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        UPDATE Medico
        SET 
            Nombre1_Medico = COALESCE(@Nombre1_Medico, Nombre1_Medico),
			Nombre2_Medico = COALESCE(@Nombre2_Medico, Nombre2_Medico),
			Apellido1_Medico = COALESCE(@Apellido1_Medico, Apellido1_Medico),
			Apellido2_Medico = COALESCE(@Apellido2_Medico, Apellido2_Medico),
			Telefono_Medico = COALESCE(@Telefono_Medico, Telefono_Medico),
			ID_Especialidad = COALESCE(@ID_Especialidad, ID_Especialidad)
        WHERE ID_Medico = @ID_Medico;

        PRINT 'El médico se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al modificar el médico: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

----------Modificar Estado Cita

CREATE PROCEDURE Sp_ModificarEstadoCita
(
    @ID_Estado_Cita INT,
    @Estado VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Estado_Cita WHERE ID_Estado_Cita = @ID_Estado_Cita)
    BEGIN
        RAISERROR('El ID del estado de cita no existe.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Estado_Cita WHERE Estado = @Estado AND ID_Estado_Cita <> @ID_Estado_Cita)
    BEGIN
        RAISERROR('El estado de cita ya existe con otro ID.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        UPDATE Estado_Cita
        SET Estado = COALESCE(@Estado, Estado)
        WHERE ID_Estado_Cita = @ID_Estado_Cita;

        PRINT 'El estado de cita se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al modificar el estado de cita: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

----------Modificar Cita

CREATE PROCEDURE Sp_ModificarCita
(
    @ID_Cita INT,
    @Fecha_Cita DATE = NULL,
    @Hora_Cita TIME = NULL,
    @ID_Paciente INT = NULL,
    @ID_Medico INT = NULL,
    @ID_Estado_Cita INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Cita WHERE ID_Cita = @ID_Cita)
    BEGIN
        RAISERROR('El ID de la cita no existe.', 16, 1);
        RETURN;
    END

    IF @ID_Paciente IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Paciente WHERE ID_Paciente = @ID_Paciente)
    BEGIN
        RAISERROR('El ID de paciente no existe.', 16, 2);
        RETURN;
    END

    IF @ID_Medico IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Medico WHERE ID_Medico = @ID_Medico)
    BEGIN
        RAISERROR('El ID del médico no existe.', 16, 2);
        RETURN;
    END

    IF @ID_Estado_Cita IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Estado_Cita WHERE ID_Estado_Cita = @ID_Estado_Cita)
    BEGIN
        RAISERROR('El ID del estado de la cita no existe.', 16, 2);
        RETURN;
    END

    IF (@Fecha_Cita IS NOT NULL AND @Hora_Cita IS NOT NULL) AND EXISTS (
        SELECT 1 FROM Cita
        WHERE ID_Paciente = @ID_Paciente 
          AND Fecha_Cita = @Fecha_Cita 
          AND Hora_Cita = @Hora_Cita
          AND ID_Cita <> @ID_Cita) 
    BEGIN
        RAISERROR('El paciente ya tiene una cita a la misma hora y fecha.', 16, 3);
        RETURN;
    END

    BEGIN TRY
        UPDATE Cita
        SET 
            Fecha_Cita = COALESCE(@Fecha_Cita, Fecha_Cita),
            Hora_Cita = COALESCE(@Hora_Cita, Hora_Cita),
            ID_Paciente = COALESCE(@ID_Paciente, ID_Paciente),
            ID_Medico = COALESCE(@ID_Medico, ID_Medico),
            ID_Estado_Cita = COALESCE(@ID_Estado_Cita, ID_Estado_Cita)
        WHERE ID_Cita = @ID_Cita;

        PRINT 'La cita se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al modificar la cita: ' + ERROR_MESSAGE();
    END CATCH
END;

---------Modificar Tipo de Pago

CREATE PROCEDURE Sp_ModificarTipoPago
(
    @ID_Tipo_Pago INT,
    @Descripcion_Tipo_Pago VARCHAR(50) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Tipo_Pago WHERE ID_Tipo_Pago = @ID_Tipo_Pago)
    BEGIN
        RAISERROR('El ID del tipo de pago no existe.', 16, 1);
        RETURN;
    END

    IF @Descripcion_Tipo_Pago IS NOT NULL AND EXISTS (SELECT 1 FROM Tipo_Pago WHERE Descripcion_Tipo_Pago = @Descripcion_Tipo_Pago AND ID_Tipo_Pago <> @ID_Tipo_Pago)
    BEGIN
        RAISERROR('El tipo de pago con la descripción especificada ya existe.', 16, 2);
        RETURN;
    END

    BEGIN TRY
        UPDATE Tipo_Pago
        SET 
            Descripcion_Tipo_Pago = COALESCE(@Descripcion_Tipo_Pago, Descripcion_Tipo_Pago)
        WHERE ID_Tipo_Pago = @ID_Tipo_Pago;

        PRINT 'El tipo de pago se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al modificar el tipo de pago: ' + ERROR_MESSAGE();
    END CATCH
END;

-------------Modificar Factura

CREATE PROCEDURE Sp_ModificarFactura
(
    @ID_Factura INT,
    @Fecha_Factura DATE = NULL,
    @Monto_Total MONEY = NULL,
    @ID_Paciente INT = NULL,
    @ID_Cita INT = NULL,
    @ID_Tipo_Pago INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Factura WHERE ID_Factura = @ID_Factura)
    BEGIN
        RAISERROR('El ID de factura no existe.', 16, 1);
        RETURN;
    END

    IF @ID_Paciente IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Paciente WHERE ID_Paciente = @ID_Paciente)
    BEGIN
        RAISERROR('El ID de paciente no existe.', 16, 1);
        RETURN;
    END

    IF @ID_Cita IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Cita WHERE ID_Cita = @ID_Cita)
    BEGIN
        RAISERROR('El ID de cita no existe.', 16, 1);
        RETURN;
    END

    IF @ID_Tipo_Pago IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Tipo_Pago WHERE ID_Tipo_Pago = @ID_Tipo_Pago)
    BEGIN
        RAISERROR('El ID del tipo de pago no existe.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        UPDATE Factura
        SET 
            Fecha_Factura = COALESCE(@Fecha_Factura, Fecha_Factura),
            Monto_Total = COALESCE(@Monto_Total, Monto_Total),
            ID_Paciente = COALESCE(@ID_Paciente, ID_Paciente),
            ID_Cita = COALESCE(@ID_Cita, ID_Cita),
            ID_Tipo_Pago = COALESCE(@ID_Tipo_Pago, ID_Tipo_Pago)
        WHERE ID_Factura = @ID_Factura;

        PRINT 'La factura se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al modificar la factura: ' + ERROR_MESSAGE();
    END CATCH
END;

-----------Modificar Historial Medico

CREATE PROCEDURE Sp_ModificarHistorialMedico
(
    @ID_Historial_Medico INT,
    @Fecha_Registro DATE,
    @ID_Paciente INT
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Historial_Medico WHERE ID_Historial_Medico = @ID_Historial_Medico)
    BEGIN
        RAISERROR('El ID del historial médico no existe.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Paciente WHERE ID_Paciente = @ID_Paciente)
    BEGIN
        RAISERROR('El ID de paciente no existe.', 16, 2);
        RETURN;
    END

    BEGIN TRY
        UPDATE Historial_Medico
        SET Fecha_Registro = COALESCE(@Fecha_Registro, Fecha_Registro) -- Actualiza solo si se proporciona un nuevo valor
        WHERE ID_Historial_Medico = @ID_Historial_Medico;

        PRINT 'El historial médico se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al modificar el historial médico: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

---------Modificar Estado Sala

CREATE PROCEDURE Sp_ModificarEstadoSala
(
    @ID_Estado_Sala INT,
    @Nombre VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Estado_Sala WHERE ID_Estado_Sala = @ID_Estado_Sala)
    BEGIN
        RAISERROR('El ID del estado de sala no existe.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Estado_Sala WHERE Nombre = @Nombre AND ID_Estado_Sala <> @ID_Estado_Sala)
    BEGIN
        RAISERROR('El nombre del estado de sala ya existe.', 16, 2);
        RETURN;
    END

    BEGIN TRY
        UPDATE Estado_Sala
        SET Nombre = @Nombre
        WHERE ID_Estado_Sala = @ID_Estado_Sala;

        PRINT 'El estado de sala se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al modificar el estado de sala: ' + ERROR_MESSAGE();
    END CATCH
END;

---------------Modificar Tipo de Sala

CREATE PROCEDURE Sp_ModificarTipoSala
(
    @ID_Tipo_Sala INT,
    @Descripcion_Tipo_Sala VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Tipo_Sala WHERE ID_Tipo_Sala = @ID_Tipo_Sala)
    BEGIN
        RAISERROR('El ID del tipo de sala no existe.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Tipo_Sala WHERE Descripcion_Tipo_Sala = @Descripcion_Tipo_Sala AND ID_Tipo_Sala <> @ID_Tipo_Sala)
    BEGIN
        RAISERROR('La descripción del tipo de sala ya existe.', 16, 2);
        RETURN;
    END

    BEGIN TRY
        UPDATE Tipo_Sala
        SET Descripcion_Tipo_Sala = @Descripcion_Tipo_Sala
        WHERE ID_Tipo_Sala = @ID_Tipo_Sala;

        PRINT 'El tipo de sala se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al modificar el tipo de sala: ' + ERROR_MESSAGE();
    END CATCH
END;

---------Modificar Sala

CREATE PROCEDURE Sp_ModificarSala
(
    @ID_Sala INT,
    @Nombre_Sala VARCHAR(50) = NULL, 
    @Capacidad_Sala INT = NULL,       
    @ID_Tipo_Sala INT = NULL,         
    @ID_Estado_Sala INT = NULL        
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Sala WHERE ID_Sala = @ID_Sala)
    BEGIN
        RAISERROR('El ID de sala no existe.', 16, 1);
        RETURN;
    END

    IF @ID_Tipo_Sala IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Tipo_Sala WHERE ID_Tipo_Sala = @ID_Tipo_Sala)
    BEGIN
        RAISERROR('El ID de tipo de sala no existe.', 16, 2);
        RETURN;
    END

    IF @ID_Estado_Sala IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Estado_Sala WHERE ID_Estado_Sala = @ID_Estado_Sala)
    BEGIN
        RAISERROR('El ID de estado de sala no existe.', 16, 3);
        RETURN;
    END

    IF @Nombre_Sala IS NOT NULL AND EXISTS (SELECT 1 FROM Sala WHERE Nombre_Sala = @Nombre_Sala AND ID_Sala <> @ID_Sala)
    BEGIN
        RAISERROR('El nombre de la sala ya existe.', 16, 4);
        RETURN;
    END

    BEGIN TRY
        UPDATE Sala
        SET 
            Nombre_Sala = COALESCE(@Nombre_Sala, Nombre_Sala), 
            Capacidad_Sala = COALESCE(@Capacidad_Sala, Capacidad_Sala), 
            ID_Tipo_Sala = COALESCE(@ID_Tipo_Sala, ID_Tipo_Sala), 
            ID_Estado_Sala = COALESCE(@ID_Estado_Sala, ID_Estado_Sala) 
        WHERE ID_Sala = @ID_Sala;

        PRINT 'La sala se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al modificar la sala: ' + ERROR_MESSAGE();
    END CATCH
END;

----------Modificar Tipo de Procedimiento

CREATE PROCEDURE Sp_ModificarTipoProcedimiento
(
    @ID_Tipo_Procedimiento INT,
    @Nuevo_Nombre_Procedimiento VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Tipo_Procedimiento WHERE ID_Tipo_Procedimiento = @ID_Tipo_Procedimiento)
    BEGIN
        RAISERROR('El ID del tipo de procedimiento no existe.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Tipo_Procedimiento WHERE Nombre_Procedimiento = @Nuevo_Nombre_Procedimiento AND ID_Tipo_Procedimiento <> @ID_Tipo_Procedimiento)
    BEGIN
        RAISERROR('El nombre del tipo de procedimiento ya existe.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        UPDATE Tipo_Procedimiento
        SET Nombre_Procedimiento = @Nuevo_Nombre_Procedimiento
        WHERE ID_Tipo_Procedimiento = @ID_Tipo_Procedimiento;

        PRINT 'El tipo de procedimiento se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al modificar el tipo de procedimiento: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

---------------Modificar Procedimiento

CREATE PROCEDURE Sp_ModificarProcedimiento
(
    @ID_Procedimiento INT,
    @Descripcion_Procedimiento VARCHAR(150) = NULL,
    @Fecha_Procedimiento DATE = NULL,
    @Hora_Procedimiento TIME = NULL,
    @Monto_Procedimiento MONEY = NULL,
    @Receta VARCHAR(150) = NULL,
    @ID_Sala INT = NULL,
    @ID_Historial_Medico INT = NULL,
    @ID_Cita INT = NULL,
    @ID_Tipo_Procedimiento INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Procedimiento WHERE ID_Procedimiento = @ID_Procedimiento)
    BEGIN
        RAISERROR('El ID de procedimiento no existe.', 16, 1);
        RETURN;
    END

    IF @ID_Sala IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Sala WHERE ID_Sala = @ID_Sala)
    BEGIN
        RAISERROR('El ID de sala no existe.', 16, 1);
        RETURN;
    END

    IF @ID_Historial_Medico IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Historial_Medico WHERE ID_Historial_Medico = @ID_Historial_Medico)
    BEGIN
        RAISERROR('El ID de historial médico no existe.', 16, 1);
        RETURN;
    END

    IF @ID_Cita IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Cita WHERE ID_Cita = @ID_Cita)
    BEGIN
        RAISERROR('El ID de cita no existe.', 16, 1);
        RETURN;
    END

    IF @ID_Tipo_Procedimiento IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Tipo_Procedimiento WHERE ID_Tipo_Procedimiento = @ID_Tipo_Procedimiento)
    BEGIN
        RAISERROR('El ID de tipo de procedimiento no existe.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        UPDATE Procedimiento
        SET 
            Descripcion_Procedimiento = COALESCE(@Descripcion_Procedimiento, Descripcion_Procedimiento),
            Fecha_Procedimiento = COALESCE(@Fecha_Procedimiento, Fecha_Procedimiento),
            Hora_Procedimiento = COALESCE(@Hora_Procedimiento, Hora_Procedimiento),
            Monto_Procedimiento = COALESCE(@Monto_Procedimiento, Monto_Procedimiento),
            Receta = COALESCE(@Receta, Receta),
            ID_Sala = COALESCE(@ID_Sala, ID_Sala),
            ID_Historial_Medico = COALESCE(@ID_Historial_Medico, ID_Historial_Medico),
            ID_Cita = COALESCE(@ID_Cita, ID_Cita),
            ID_Tipo_Procedimiento = COALESCE(@ID_Tipo_Procedimiento, ID_Tipo_Procedimiento)
        WHERE ID_Procedimiento = @ID_Procedimiento;

        PRINT 'El procedimiento se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al modificar el procedimiento: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

------------Modificar Estado Recurso Medico

CREATE PROCEDURE Sp_ModificarEstadoRecursoMedico
(
    @ID_Estado_Recurso_Medico INT,
    @Estado_Recurso VARCHAR(50) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Estado_Recurso_Medico WHERE ID_Estado_Recurso_Medico = @ID_Estado_Recurso_Medico)
    BEGIN
        RAISERROR('El ID de estado de recurso médico no existe.', 16, 1);
        RETURN;
    END

	    IF @Estado_Recurso IS NOT NULL AND EXISTS (SELECT 1 FROM Estado_Recurso_Medico WHERE Estado_Recurso = @Estado_Recurso AND ID_Estado_Recurso_Medico <> @ID_Estado_Recurso_Medico)
    BEGIN
        RAISERROR('El estado de recurso médico ya existe en otro registro.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        UPDATE Estado_Recurso_Medico
        SET Estado_Recurso = COALESCE(@Estado_Recurso, Estado_Recurso)
        WHERE ID_Estado_Recurso_Medico = @ID_Estado_Recurso_Medico;

        PRINT 'El estado de recurso médico se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al modificar el estado de recurso médico: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-------------Modificar Tipo de Recurso

CREATE PROCEDURE Sp_ModificarTipoRecurso
(
    @ID_Tipo_Recurso INT,
    @Titulo_Recurso VARCHAR(50) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Tipo_Recurso WHERE ID_Tipo_Recurso = @ID_Tipo_Recurso)
    BEGIN
        RAISERROR('El ID de tipo de recurso no existe.', 16, 1);
        RETURN;
    END

	    IF @Titulo_Recurso IS NOT NULL AND EXISTS (SELECT 1 FROM Tipo_Recurso WHERE Titulo_Recurso = @Titulo_Recurso AND ID_Tipo_Recurso <> @ID_Tipo_Recurso)
    BEGIN
        RAISERROR('El título de recurso ya existe en otro registro.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        UPDATE Tipo_Recurso
        SET Titulo_Recurso = COALESCE(@Titulo_Recurso, Titulo_Recurso)
        WHERE ID_Tipo_Recurso = @ID_Tipo_Recurso;

        PRINT 'El tipo de recurso se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al modificar el tipo de recurso: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

---------------Modificar Recurso Medico

CREATE PROCEDURE Sp_ModificarRecursoMedico
(
    @ID_Recurso_Medico INT,
    @Nombre_Recurso VARCHAR(50) = NULL,
    @Lote VARCHAR(50) = NULL,
    @Cantidad_Stock_Total INT = NULL,
    @Ubicacion_Recurso VARCHAR(150) = NULL,
    @ID_Tipo_Recurso INT = NULL,
    @ID_Estado_Recurso_Medico INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Recurso_Medico WHERE ID_Recurso_Medico = @ID_Recurso_Medico)
    BEGIN
        RAISERROR('El ID de recurso médico no existe.', 16, 1);
        RETURN;
    END

    IF @ID_Tipo_Recurso IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Tipo_Recurso WHERE ID_Tipo_Recurso = @ID_Tipo_Recurso)
    BEGIN
        RAISERROR('El ID de tipo de recurso no existe.', 16, 1);
        RETURN;
    END

    IF @ID_Estado_Recurso_Medico IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Estado_Recurso_Medico WHERE ID_Estado_Recurso_Medico = @ID_Estado_Recurso_Medico)
    BEGIN
        RAISERROR('El ID de estado de recurso médico no existe.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        UPDATE Recurso_Medico
        SET 
            Nombre_Recurso = COALESCE(@Nombre_Recurso, Nombre_Recurso),
            Lote = COALESCE(@Lote, Lote),
            Cantidad_Stock_Total = COALESCE(@Cantidad_Stock_Total, Cantidad_Stock_Total),
            Ubicacion_Recurso = COALESCE(@Ubicacion_Recurso, Ubicacion_Recurso),
            ID_Tipo_Recurso = COALESCE(@ID_Tipo_Recurso, ID_Tipo_Recurso),
            ID_Estado_Recurso_Medico = COALESCE(@ID_Estado_Recurso_Medico, ID_Estado_Recurso_Medico)
        WHERE ID_Recurso_Medico = @ID_Recurso_Medico;

        PRINT 'El recurso médico se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al modificar el recurso médico: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-------------Modificar Recurso_Medico Sala

CREATE PROCEDURE Sp_ModificarRecursoMedicoSala
(
    @ID_Recurso_Medico_Sala INT,
    @Fecha DATE = NULL,
    @Cantidad_Recurso INT = NULL,
    @ID_Recurso_Medico INT = NULL,
    @ID_Sala INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Recurso_Medico_Sala WHERE ID_Recurso_Medico_Sala = @ID_Recurso_Medico_Sala)
    BEGIN
        RAISERROR('El ID de recurso médico en sala no existe.', 16, 1);
        RETURN;
    END

    IF @ID_Recurso_Medico IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Recurso_Medico WHERE ID_Recurso_Medico = @ID_Recurso_Medico)
    BEGIN
        RAISERROR('El ID de recurso médico no existe.', 16, 1);
        RETURN;
    END

    IF @ID_Sala IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Sala WHERE ID_Sala = @ID_Sala)
    BEGIN
        RAISERROR('El ID de sala no existe.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        UPDATE Recurso_Medico_Sala
        SET 
            Fecha = COALESCE(@Fecha, Fecha),
            Cantidad_Recurso = COALESCE(@Cantidad_Recurso, Cantidad_Recurso),
            ID_Recurso_Medico = COALESCE(@ID_Recurso_Medico, ID_Recurso_Medico),
            ID_Sala = COALESCE(@ID_Sala, ID_Sala)
        WHERE ID_Recurso_Medico_Sala = @ID_Recurso_Medico_Sala;

        PRINT 'El recurso médico en sala se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al modificar el recurso médico en sala: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-------------Modificar Horario Trabajo

CREATE PROCEDURE Sp_ModificarHorarioTrabajo
(
    @ID_Horario_Trabajo INT,
    @Nombre_Horario VARCHAR(50) = NULL,
    @Hora_Inicio TIME = NULL,
    @Hora_Fin TIME = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Horario_Trabajo WHERE ID_Horario_Trabajo = @ID_Horario_Trabajo)
    BEGIN
        RAISERROR('El ID de horario de trabajo no existe.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        UPDATE Horario_Trabajo
        SET 
            Nombre_Horario = COALESCE(@Nombre_Horario, Nombre_Horario),
            Hora_Inicio = COALESCE(@Hora_Inicio, Hora_Inicio),
            Hora_Fin = COALESCE(@Hora_Fin, Hora_Fin)
        WHERE ID_Horario_Trabajo = @ID_Horario_Trabajo;

        PRINT 'El horario de trabajo se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al modificar el horario de trabajo: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-----------------Modificar Planificacion de Recursos

CREATE PROCEDURE Sp_ModificarPlanificacionRecurso
(
    @ID_Planificacion INT,
    @Descripcion_Planificacion VARCHAR(150) = NULL,
    @Fecha_Planificacion DATE = NULL,
    @ID_Sala INT = NULL,
    @ID_Horario_Trabajo INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Planificacion_Recurso WHERE ID_Planificacion = @ID_Planificacion)
    BEGIN
        RAISERROR('El ID de planificación no existe.', 16, 1);
        RETURN;
    END

    IF @ID_Sala IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Sala WHERE ID_Sala = @ID_Sala)
    BEGIN
        RAISERROR('El ID de sala no existe.', 16, 1);
        RETURN;
    END

    IF @ID_Horario_Trabajo IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Horario_Trabajo WHERE ID_Horario_Trabajo = @ID_Horario_Trabajo)
    BEGIN
        RAISERROR('El ID de horario de trabajo no existe.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        UPDATE Planificacion_Recurso
        SET 
            Descripcion_Planificacion = COALESCE(@Descripcion_Planificacion, Descripcion_Planificacion),
            Fecha_Planificacion = COALESCE(@Fecha_Planificacion, Fecha_Planificacion),
            ID_Sala = COALESCE(@ID_Sala, ID_Sala),
            ID_Horario_Trabajo = COALESCE(@ID_Horario_Trabajo, ID_Horario_Trabajo)
        WHERE ID_Planificacion = @ID_Planificacion;

        PRINT 'La planificación de recurso se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al modificar la planificación de recurso: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-----------Modificar Medico Planificacion Recurso

CREATE PROCEDURE Sp_ModificarMedicoPlanificacionRecurso
(
    @ID_Medico_Planificacion_Recurso INT,
    @Fecha_Planificacion_Personal DATE = NULL,
    @ID_Planificacion INT = NULL,
    @ID_Medico INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Medico_Planificacion_Recurso WHERE ID_Medico_Planificacion_Recurso = @ID_Medico_Planificacion_Recurso)
    BEGIN
        RAISERROR('El ID de planificación del médico no existe.', 16, 1);
        RETURN;
    END

    IF @ID_Medico IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Medico WHERE ID_Medico = @ID_Medico)
    BEGIN
        RAISERROR('El ID de médico no existe.', 16, 1);
        RETURN;
    END

    IF @ID_Planificacion IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Planificacion_Recurso WHERE ID_Planificacion = @ID_Planificacion)
    BEGIN
        RAISERROR('El ID de planificación no existe.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        UPDATE Medico_Planificacion_Recurso
        SET 
            Fecha_Planificacion_Personal = COALESCE(@Fecha_Planificacion_Personal, Fecha_Planificacion_Personal),
            ID_Planificacion = COALESCE(@ID_Planificacion, ID_Planificacion),
            ID_Medico = COALESCE(@ID_Medico, ID_Medico)
        WHERE ID_Medico_Planificacion_Recurso = @ID_Medico_Planificacion_Recurso;

        PRINT 'La planificación del médico se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al modificar la planificación del médico: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

------------Modificar Satisfaccion Paciente

CREATE PROCEDURE Sp_ModificarSatisfaccionPaciente
(
    @ID_Satisfaccion INT,
    @Fecha_Evaluacion DATE = NULL,
    @Calificacion_Satisfaccion INT = NULL,
    @ID_Cita INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Satisfaccion_Paciente WHERE ID_Satisfaccion = @ID_Satisfaccion)
    BEGIN
        RAISERROR('El ID de satisfacción no existe.', 16, 1);
        RETURN;
    END

    IF @ID_Cita IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Procedimiento WHERE ID_Cita = @ID_Cita)
    BEGIN
        RAISERROR('El ID de cita no existe.', 16, 1);
        RETURN;
    END

    IF @Calificacion_Satisfaccion IS NOT NULL AND (@Calificacion_Satisfaccion < 1 OR @Calificacion_Satisfaccion > 5)
    BEGIN
        RAISERROR('La calificación de satisfacción debe estar entre 1 y 5.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        UPDATE Satisfaccion_Paciente
        SET 
            Fecha_Evaluacion = COALESCE(@Fecha_Evaluacion, Fecha_Evaluacion),
            Calificacion_Satisfaccion = COALESCE(@Calificacion_Satisfaccion, Calificacion_Satisfaccion),
            ID_Cita = COALESCE(@ID_Cita, ID_Cita)
        WHERE ID_Satisfaccion = @ID_Satisfaccion;

        PRINT 'La satisfacción del paciente se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al modificar la satisfacción del paciente: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-----------------Modificar Rol

CREATE PROCEDURE Sp_ModificarRol
(
    @ID_Rol INT,
    @Nuevo_Nombre_Rol VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Rol WHERE ID_Rol = @ID_Rol)
    BEGIN
        RAISERROR('El ID de rol no existe.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Rol WHERE Nombre_Rol = @Nuevo_Nombre_Rol AND ID_Rol <> @ID_Rol)
    BEGIN
        RAISERROR('El nuevo nombre del rol ya existe.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        UPDATE Rol
        SET Nombre_Rol = @Nuevo_Nombre_Rol
        WHERE ID_Rol = @ID_Rol;

        PRINT 'El rol se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al modificar el rol: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-----------------Modificar Usuario

CREATE PROCEDURE Sp_ModificarUsuario
(
    @ID_Usuario INT,
    @Nuevo_Nombre_Usuario VARCHAR(50) = NULL,
    @Nuevo_Correo_Usuario VARCHAR(50) = NULL,
	@Nueva_Contrasena_Usuario VARCHAR(50) = NULL,
    @Nuevo_Rol INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Usuario WHERE ID_Usuario = @ID_Usuario)
    BEGIN
        RAISERROR('El ID de usuario no existe.', 16, 1);
        RETURN;
    END

    IF @Nuevo_Rol IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Rol WHERE ID_Rol = @Nuevo_Rol)
    BEGIN
        RAISERROR('El ID de rol no existe.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        UPDATE Usuario
        SET Nombre_Usuario = COALESCE(@Nuevo_Nombre_Usuario, Nombre_Usuario),
            Correo_Usuario = COALESCE(@Nuevo_Correo_Usuario, Correo_Usuario),
			Contraseña_Usuario = COALESCE(@Nueva_Contrasena_Usuario, Contraseña_Usuario),
            ID_Rol = COALESCE(@Nuevo_Rol, ID_Rol)
        WHERE ID_Usuario = @ID_Usuario;

        PRINT 'El usuario se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al modificar el usuario: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

------------------Modificar Permiso

CREATE PROCEDURE Sp_ModificarPermiso
(
    @ID_Permiso INT,
    @Nuevo_Nombre_Permiso VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Permiso WHERE ID_Permiso = @ID_Permiso)
    BEGIN
        RAISERROR('El ID de permiso no existe.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Permiso WHERE Nombre_Permiso = @Nuevo_Nombre_Permiso AND ID_Permiso <> @ID_Permiso)
    BEGIN
        RAISERROR('El nuevo nombre del permiso ya existe.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        UPDATE Permiso
        SET Nombre_Permiso = @Nuevo_Nombre_Permiso
        WHERE ID_Permiso = @ID_Permiso;

        PRINT 'El permiso se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al modificar el permiso: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

--------------Modificar Rol Permiso

CREATE PROCEDURE Sp_ModificarRolPermiso
(
    @ID_Rol_Permiso INT,
    @Nuevo_ID_Rol INT = NULL,
    @Nuevo_ID_Permiso INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Rol_Permiso WHERE ID_Rol_Permiso = @ID_Rol_Permiso)
    BEGIN
        RAISERROR('El ID de relación rol-permiso no existe.', 16, 1);
        RETURN;
    END

    IF @Nuevo_ID_Rol IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Rol WHERE ID_Rol = @Nuevo_ID_Rol)
    BEGIN
        RAISERROR('El ID de rol no existe.', 16, 1);
        RETURN;
    END

    IF @Nuevo_ID_Permiso IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Permiso WHERE ID_Permiso = @Nuevo_ID_Permiso)
    BEGIN
        RAISERROR('El ID de permiso no existe.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        UPDATE Rol_Permiso
        SET ID_Rol = COALESCE(@Nuevo_ID_Rol, ID_Rol),
            ID_Permiso = COALESCE(@Nuevo_ID_Permiso, ID_Permiso)
        WHERE ID_Rol_Permiso = @ID_Rol_Permiso;

        PRINT 'La relación rol-permiso se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al modificar la relación rol-permiso: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

