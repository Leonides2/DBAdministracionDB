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

CREATE ROLE Administrativo;
GO
CREATE ROLE Médico
Go
CREATE ROLE Recepcionista
GO

---- Se le da acceso completo a la base de datos
GRANT SELECT, EXECUTE, INSERT, UPDATE, DELETE ON DATABASE::SaludPlus TO Administrativo;
GO

--- Se le da acceso exclusivamente a lo que puede realizar un medico
GRANT SELECT, INSERT,UPDATE ON dbo.Satisfaccion_Paciente TO Médico;
GO

GRANT SELECT, INSERT,UPDATE, DELETE ON dbo.Procedimiento TO Médico;
GO

GRANT SELECT ON dbo.Cita TO Médico;
GO

GRANT SELECT ON dbo.Paciente TO Médico;
GO

GRANT SELECT ON dbo.Historial_Medico TO Médico;
GO

GRANT SELECT, UPDATE ON dbo.Tipo_Procedimiento TO Médico;
GO

GRANT SELECT,EXECUTE ON DATABASE::SaludPlus TO Médico;
GO

--- Se le da acceso a todo lo que puede realizar un secretario 
GRANT SELECT, INSERT,UPDATE ON dbo.Cita TO Recepcionista;
GO

GRANT SELECT, INSERT,UPDATE ON dbo.Paciente TO Recepcionista;
GO

GRANT SELECT, INSERT,UPDATE ON dbo.Factura TO Recepcionista;
GO

GRANT SELECT, INSERT,UPDATE ON dbo.Recurso_Medico TO Recepcionista;
GO

GRANT SELECT,EXECUTE ON DATABASE::SaludPlus TO Recepcionista;
GO



CREATE OR ALTER PROCEDURE RegistrarUsuarioSistema
    @NombreUsuario NVARCHAR(50),
    @Contrasena NVARCHAR(50),
    @Rol NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        -- Verifica si el inicio de sesión ya existe en la instancia de SQL Server
        IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = @NombreUsuario)
        BEGIN
            -- Crea el inicio de sesión en la instancia de SQL Server
            EXEC sp_addlogin @NombreUsuario, @Contrasena;
        END

        -- Usa la base de datos deseada (asegúrate de ejecutarlo en la base de datos correcta)
        -- Verifica si el usuario ya existe en la base de datos
        IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = @NombreUsuario)
        BEGIN
            -- Crea el usuario en la base de datos, ejecutado dinámicamente
            DECLARE @sql NVARCHAR(MAX) = 'CREATE USER [' + @NombreUsuario + '] FOR LOGIN [' + @NombreUsuario + ']';
            EXEC sp_executesql @sql;
        END

        -- Asigna el rol correspondiente al usuario de forma dinámica
        IF @Rol = 'Médico'
        BEGIN
            SET @sql = 'ALTER ROLE Médico ADD MEMBER [' + @NombreUsuario + ']';
            EXEC sp_executesql @sql;
        END
        ELSE IF @Rol = 'Administrativo'
        BEGIN
            SET @sql = 'ALTER ROLE Administrativo ADD MEMBER [' + @NombreUsuario + ']';
            EXEC sp_executesql @sql;
        END
        ELSE IF @Rol = 'Recepcionista'
        BEGIN
            SET @sql = 'ALTER ROLE Recepcionista ADD MEMBER [' + @NombreUsuario + ']';
            EXEC sp_executesql @sql;
        END
        ELSE
        BEGIN
            RAISERROR ('El rol especificado no es válido.', 16, 1);
        END

    END TRY
    BEGIN CATCH
        -- Manejo de errores
        DECLARE @ERROR NVARCHAR(1000) = ERROR_MESSAGE();
        RAISERROR ('Error en el procedimiento: %s', 16, 1, @ERROR);
    END CATCH
END;
GO

/*
EXEC RegistrarUsuarioSistema 'Laura', '123456', 'Recepcionista'
go
*/

--------------------------------------------------Procedimientos de UPDATE 
 ----------------------Modificar Paciente

USE SaludPlus
GO

CREATE OR ALTER PROCEDURE Sp_ModificarPaciente
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
    SET NOCOUNT ON;
    BEGIN TRY
        -- Verificar si el paciente existe
        IF NOT EXISTS (SELECT 1 FROM Paciente WHERE ID_Paciente = @ID_Paciente)
        BEGIN
            RAISERROR(N'No existe el Paciente con ID_Paciente = %d', 16, 1, @ID_Paciente);
            RETURN;
        END

        -- Verificar si la cédula es válida y si está siendo modificada
        IF @Cedula IS NOT NULL
        BEGIN
            IF LEN(@Cedula) <> 9
            BEGIN
                RAISERROR(N'La cédula debe tener exactamente 9 dígitos.', 16, 1);
                RETURN;
            END

            -- Verificar que no exista otro paciente con la misma cédula
            IF EXISTS (SELECT 1 FROM Paciente WHERE Cedula = @Cedula AND ID_Paciente <> @ID_Paciente)
            BEGIN
                RAISERROR(N'Ya existe un paciente con esa cédula.', 16, 1);
                RETURN;
            END
        END

        -- Actualizar los datos del paciente, solo los que no son NULL
        UPDATE Paciente
        SET 
            Nombre_Paciente = COALESCE(@Nombre_Paciente, Nombre_Paciente),
            Apellido1_Paciente = COALESCE(@Apellido1_Paciente, Apellido1_Paciente),
            Apellido2_Paciente = COALESCE(@Apellido2_Paciente, Apellido2_Paciente),
            Telefono_Paciente = COALESCE(@Telefono_Paciente, Telefono_Paciente),
            Fecha_Nacimiento = COALESCE(@Fecha_Nacimiento, Fecha_Nacimiento),
            Direccion_Paciente = COALESCE(@Direccion_Paciente, Direccion_Paciente),
            Cedula = COALESCE(@Cedula, Cedula)
        WHERE ID_Paciente = @ID_Paciente;

        PRINT 'Paciente con ID_Paciente = ' + CAST(@ID_Paciente AS VARCHAR) + ' modificado exitosamente.';
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        
        -- Capturar el mensaje de error del sistema
        SET @ErrorMessage = ERROR_MESSAGE();
        
        -- Lanzar un error
        RAISERROR(N'Error al modificar el paciente: %s', 16, 1, @ErrorMessage);
    END CATCH
END
GO
------------------------Modificar Especialidad
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE Sp_ModificarEspecialidad
(
    @ID_Especialidad INT,
    @Nombre_Especialidad VARCHAR(50) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Verificar si la especialidad existe
        IF NOT EXISTS (SELECT 1 FROM Especialidad WHERE ID_Especialidad = @ID_Especialidad)
        BEGIN
            RAISERROR(N'No existe una especialidad con el ID especificado: %d', 16, 1, @ID_Especialidad);
            RETURN;
        END

        -- Verificar si el nuevo nombre de especialidad ya está en uso por otra especialidad
        IF @Nombre_Especialidad IS NOT NULL
        BEGIN
            IF EXISTS (SELECT 1 FROM Especialidad WHERE Nombre_Especialidad = @Nombre_Especialidad AND ID_Especialidad <> @ID_Especialidad)
            BEGIN
                RAISERROR(N'El nombre de la especialidad "%s" ya existe en otro registro.', 16, 1, @Nombre_Especialidad);
                RETURN;
            END
        END

        -- Actualizar la especialidad, solo los campos no nulos
        UPDATE Especialidad
        SET 
            Nombre_Especialidad = COALESCE(@Nombre_Especialidad, Nombre_Especialidad)
        WHERE ID_Especialidad = @ID_Especialidad;

        PRINT 'La especialidad ha sido modificada correctamente.';
    END TRY
    BEGIN CATCH
        -- Capturar el error y lanzar un mensaje de error detallado
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(N'Error al modificar la especialidad: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO
------------------------Modificar Medico
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE Sp_ModificarMedico
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

    BEGIN TRY
        -- Verificar si el médico existe
        IF NOT EXISTS (SELECT 1 FROM Medico WHERE ID_Medico = @ID_Medico)
        BEGIN
            RAISERROR('El médico con ID %d no existe.', 16, 1, @ID_Medico);
            RETURN;
        END

        -- Verificar si la especialidad proporcionada existe
        IF @ID_Especialidad IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Especialidad WHERE ID_Especialidad = @ID_Especialidad)
        BEGIN
            RAISERROR('La especialidad con ID %d no existe.', 16, 1, @ID_Especialidad);
            RETURN;
        END

        -- Realizar la actualización de los datos del médico
        UPDATE Medico
        SET 
            Nombre1_Medico = COALESCE(@Nombre1_Medico, Nombre1_Medico),
            Nombre2_Medico = COALESCE(@Nombre2_Medico, Nombre2_Medico),
            Apellido1_Medico = COALESCE(@Apellido1_Medico, Apellido1_Medico),
            Apellido2_Medico = COALESCE(@Apellido2_Medico, Apellido2_Medico),
            Telefono_Medico = COALESCE(@Telefono_Medico, Telefono_Medico),
            ID_Especialidad = COALESCE(@ID_Especialidad, ID_Especialidad)
        WHERE ID_Medico = @ID_Medico;

        PRINT 'El médico con ID ' + CAST(@ID_Medico AS VARCHAR) + ' ha sido modificado correctamente.';
    END TRY
    BEGIN CATCH
        -- Captura de errores con mensaje detallado
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(N'Error al modificar el médico: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO


---------------------Modificar Estado Cita
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE Sp_ModificarEstado_Cita
(
    @ID_Estado_Cita INT,
    @Estado VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validar si el ID_Estado_Cita existe
        IF NOT EXISTS (SELECT 1 FROM Estado_Cita WHERE ID_Estado_Cita = @ID_Estado_Cita)
        BEGIN
            RAISERROR('El estado de cita con ID %d no existe.', 16, 1, @ID_Estado_Cita);
            RETURN;
        END

        -- Verificar si el nuevo estado ya existe en otro registro
        IF EXISTS (SELECT 1 FROM Estado_Cita WHERE Estado = @Estado AND ID_Estado_Cita <> @ID_Estado_Cita)
        BEGIN
            RAISERROR('El estado de cita "%s" ya existe con otro ID.', 16, 1, @Estado);
            RETURN;
        END

        -- Actualizar el estado de cita si todas las validaciones pasan
        UPDATE Estado_Cita
        SET Estado = COALESCE(@Estado, Estado)
        WHERE ID_Estado_Cita = @ID_Estado_Cita;

        PRINT 'El estado de cita con ID ' + CAST(@ID_Estado_Cita AS VARCHAR) + ' ha sido modificado correctamente.';
    END TRY
    BEGIN CATCH
        -- Captura de errores con detalles
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(N'Error al modificar el estado de cita: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO

-------------------Modificar Cita
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE Sp_ModificarCita
(
    @ID_Cita INT,
    @Fecha_Cita DATE = NULL,
    @Hora_Cita TIME = NULL,
    @CEDULA VARCHAR(12) = NULL,
    @ID_Paciente INT = NULL,
    @ID_Medico INT = NULL,
    @ID_Estado_Cita INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Verificar si la cita existe
        IF NOT EXISTS (SELECT 1 FROM Cita WHERE ID_Cita = @ID_Cita)
        BEGIN
            RAISERROR('La cita con ID %d no existe.', 16, 1, @ID_Cita);
            RETURN;
        END

        -- Validar que el ID_Paciente exista si es proporcionado
        IF @ID_Paciente IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Paciente WHERE ID_Paciente = @ID_Paciente)
        BEGIN
            RAISERROR('El paciente con ID %d no existe.', 16, 2, @ID_Paciente);
            RETURN;
        END

        -- Validar que el ID_Medico exista si es proporcionado
        IF @ID_Medico IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Medico WHERE ID_Medico = @ID_Medico)
        BEGIN
            RAISERROR('El médico con ID %d no existe.', 16, 2, @ID_Medico);
            RETURN;
        END

        -- Validar que el ID_Estado_Cita exista si es proporcionado
        IF @ID_Estado_Cita IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Estado_Cita WHERE ID_Estado_Cita = @ID_Estado_Cita)
        BEGIN
            RAISERROR('El estado de cita con ID %d no existe.', 16, 2, @ID_Estado_Cita);
            RETURN;
        END

        -- Validar que no haya citas duplicadas para el paciente en la misma fecha y hora
        IF @ID_Paciente IS NOT NULL AND @Fecha_Cita IS NOT NULL AND @Hora_Cita IS NOT NULL
        BEGIN
            IF EXISTS (SELECT 1 FROM Cita 
                       WHERE ID_Paciente = @ID_Paciente 
                         AND Fecha_Cita = @Fecha_Cita 
                         AND Hora_Cita = @Hora_Cita
                         AND ID_Cita <> @ID_Cita) 
            BEGIN
                RAISERROR('El paciente ya tiene una cita programada a la misma fecha y hora.', 16, 3);
                RETURN;
            END
        END

        -- Realizar la actualización
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
        -- Capturar y mostrar el error
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(N'Error al modificar la cita: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO
------------------Modificar Tipo de Pago
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE Sp_ModificarTipo_Pago
(
    @ID_Tipo_Pago INT,
    @Descripcion_Tipo_Pago VARCHAR(50) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Verificar si el tipo de pago existe
        IF NOT EXISTS (SELECT 1 FROM Tipo_Pago WHERE ID_Tipo_Pago = @ID_Tipo_Pago)
        BEGIN
            RAISERROR('El tipo de pago con ID %d no existe.', 16, 1, @ID_Tipo_Pago);
            RETURN;
        END

        -- Validar que no exista otro tipo de pago con la misma descripción
        IF @Descripcion_Tipo_Pago IS NOT NULL AND EXISTS (SELECT 1 FROM Tipo_Pago WHERE Descripcion_Tipo_Pago = @Descripcion_Tipo_Pago AND ID_Tipo_Pago <> @ID_Tipo_Pago)
        BEGIN
            RAISERROR('Ya existe un tipo de pago con la descripción "%s".', 16, 2, @Descripcion_Tipo_Pago);
            RETURN;
        END

        -- Realizar la actualización solo si la descripción se ha proporcionado
        UPDATE Tipo_Pago
        SET 
            Descripcion_Tipo_Pago = COALESCE(@Descripcion_Tipo_Pago, Descripcion_Tipo_Pago)
        WHERE ID_Tipo_Pago = @ID_Tipo_Pago;

        PRINT 'El tipo de pago ha sido modificado correctamente.';
    END TRY
    BEGIN CATCH
        -- Capturar y mostrar el error
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(N'Error al modificar el tipo de pago: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO

------------------------Modificar Factura
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE Sp_Modificar_Factura
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

    BEGIN TRY
        -- Verificar si la factura existe
        IF NOT EXISTS (SELECT 1 FROM Factura WHERE ID_Factura = @ID_Factura)
        BEGIN
            RAISERROR('La factura con ID %d no existe.', 16, 1, @ID_Factura);
            RETURN;
        END

        -- Verificar si el paciente existe
        IF @ID_Paciente IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Paciente WHERE ID_Paciente = @ID_Paciente)
        BEGIN
            RAISERROR('El paciente con ID %d no existe.', 16, 1, @ID_Paciente);
            RETURN;
        END

        -- Verificar si la cita existe
        IF @ID_Cita IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Cita WHERE ID_Cita = @ID_Cita)
        BEGIN
            RAISERROR('La cita con ID %d no existe.', 16, 1, @ID_Cita);
            RETURN;
        END

        -- Verificar si el tipo de pago existe
        IF @ID_Tipo_Pago IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Tipo_Pago WHERE ID_Tipo_Pago = @ID_Tipo_Pago)
        BEGIN
            RAISERROR('El tipo de pago con ID %d no existe.', 16, 1, @ID_Tipo_Pago);
            RETURN;
        END

        -- Actualizar la factura solo si el ID es válido
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
        -- Capturar y mostrar el error
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(N'Error al modificar la factura: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO

-------------------Modificar Historial Medico
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE Sp_ModificarHistorial_Medico
(
    @ID_Historial_Medico INT,
    @Fecha_Registro DATE = NULL,
    @ID_Paciente INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Verificar si el historial médico existe
        IF NOT EXISTS (SELECT 1 FROM Historial_Medico WHERE ID_Historial_Medico = @ID_Historial_Medico)
        BEGIN
            RAISERROR('El historial médico con ID %d no existe.', 16, 1, @ID_Historial_Medico);
            RETURN;
        END

        -- Verificar si el paciente existe
        IF @ID_Paciente IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Paciente WHERE ID_Paciente = @ID_Paciente)
        BEGIN
            RAISERROR('El paciente con ID %d no existe.', 16, 1, @ID_Paciente);
            RETURN;
        END

        -- Actualizar el historial médico solo si se proporciona un valor válido para Fecha_Registro
        UPDATE Historial_Medico
        SET 
            Fecha_Registro = COALESCE(@Fecha_Registro, Fecha_Registro),
            ID_Paciente = COALESCE(@ID_Paciente, ID_Paciente) -- También se actualiza el paciente si se proporciona un ID de paciente
        WHERE ID_Historial_Medico = @ID_Historial_Medico;

        PRINT 'El historial médico se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        -- Capturar y mostrar el error
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(N'Error al modificar el historial médico: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO
-----------------Modificar Estado Sala
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE Sp_ModificarEstado_Sala
(
    @ID_Estado_Sala INT,
    @Nombre VARCHAR(50) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Verificar si el estado de sala existe
        IF NOT EXISTS (SELECT 1 FROM Estado_Sala WHERE ID_Estado_Sala = @ID_Estado_Sala)
        BEGIN
            RAISERROR('El estado de sala con ID %d no existe.', 16, 1, @ID_Estado_Sala);
            RETURN;
        END

        -- Verificar si el nombre ya existe para otro estado de sala
        IF @Nombre IS NOT NULL AND EXISTS (SELECT 1 FROM Estado_Sala WHERE Nombre = @Nombre AND ID_Estado_Sala <> @ID_Estado_Sala)
        BEGIN
            RAISERROR('El nombre de estado de sala "%s" ya existe.', 16, 1, @Nombre);
            RETURN;
        END

        -- Actualizar el estado de sala solo si se proporciona un valor nuevo
        UPDATE Estado_Sala
        SET 
            Nombre = COALESCE(@Nombre, Nombre) -- Solo actualiza si el valor proporcionado no es NULL
        WHERE ID_Estado_Sala = @ID_Estado_Sala;

        PRINT 'El estado de sala se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        -- Capturar el error y mostrarlo
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(N'Error al modificar el estado de sala: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO

--------------------------Modificar Tipo de Sala
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE Sp_ModificarTipo_Sala
(
    @ID_Tipo_Sala INT,
    @Descripcion_Tipo_Sala VARCHAR(50) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Verificar si el tipo de sala existe
        IF NOT EXISTS (SELECT 1 FROM Tipo_Sala WHERE ID_Tipo_Sala = @ID_Tipo_Sala)
        BEGIN
            RAISERROR('El tipo de sala con ID %d no existe.', 16, 1, @ID_Tipo_Sala);
            RETURN;
        END

        -- Verificar si la descripción proporcionada ya existe para otro tipo de sala
        IF @Descripcion_Tipo_Sala IS NOT NULL AND EXISTS (SELECT 1 FROM Tipo_Sala WHERE Descripcion_Tipo_Sala = @Descripcion_Tipo_Sala AND ID_Tipo_Sala <> @ID_Tipo_Sala)
        BEGIN
            RAISERROR('La descripción "%s" del tipo de sala ya existe para otro tipo de sala.', 16, 1, @Descripcion_Tipo_Sala);
            RETURN;
        END

        -- Actualizar la descripción del tipo de sala solo si se proporciona un nuevo valor
        UPDATE Tipo_Sala
        SET 
            Descripcion_Tipo_Sala = COALESCE(@Descripcion_Tipo_Sala, Descripcion_Tipo_Sala)
        WHERE ID_Tipo_Sala = @ID_Tipo_Sala;

        PRINT 'El tipo de sala se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        -- Capturar y mostrar el error si ocurre uno durante la actualización
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(N'Error al modificar el tipo de sala: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO

--------------------Modificar Sala
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE Sp_ModificarSala
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

    BEGIN TRY
        -- Verificar si el ID de sala existe
        IF NOT EXISTS (SELECT 1 FROM Sala WHERE ID_Sala = @ID_Sala)
        BEGIN
            RAISERROR('El ID de sala con valor %d no existe.', 16, 1, @ID_Sala);
            RETURN;
        END

        -- Verificar que el ID_Tipo_Sala existe si es proporcionado
        IF @ID_Tipo_Sala IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Tipo_Sala WHERE ID_Tipo_Sala = @ID_Tipo_Sala)
        BEGIN
            RAISERROR('El ID de tipo de sala con valor %d no existe.', 16, 2, @ID_Tipo_Sala);
            RETURN;
        END

        -- Verificar que el ID_Estado_Sala existe si es proporcionado
        IF @ID_Estado_Sala IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Estado_Sala WHERE ID_Estado_Sala = @ID_Estado_Sala)
        BEGIN
            RAISERROR('El ID de estado de sala con valor %d no existe.', 16, 3, @ID_Estado_Sala);
            RETURN;
        END

        -- Verificar que el nombre de la sala no exista ya para otro ID_Sala
        IF @Nombre_Sala IS NOT NULL AND EXISTS (SELECT 1 FROM Sala WHERE Nombre_Sala = @Nombre_Sala AND ID_Sala <> @ID_Sala)
        BEGIN
            RAISERROR('El nombre de la sala "%s" ya existe en otro registro de sala.', 16, 4, @Nombre_Sala);
            RETURN;
        END

        -- Realizar la actualización solo si es necesario (si los valores son nuevos)
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
        -- Captura y muestra cualquier error durante la ejecución
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(N'Error al modificar la sala: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO
-----------------------Modificar Tipo de Procedimiento
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE Sp_ModificarTipoProcedimiento
(
    @ID_Tipo_Procedimiento INT,
    @Nuevo_Nombre_Procedimiento VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Verificar si el ID_Tipo_Procedimiento existe
        IF NOT EXISTS (SELECT 1 FROM Tipo_Procedimiento WHERE ID_Tipo_Procedimiento = @ID_Tipo_Procedimiento)
        BEGIN
            RAISERROR('El ID del tipo de procedimiento con valor %d no existe.', 16, 1, @ID_Tipo_Procedimiento);
            RETURN;
        END

        -- Verificar si el nombre del procedimiento ya existe en otro registro
        IF EXISTS (SELECT 1 FROM Tipo_Procedimiento WHERE Nombre_Procedimiento = @Nuevo_Nombre_Procedimiento AND ID_Tipo_Procedimiento <> @ID_Tipo_Procedimiento)
        BEGIN
            RAISERROR('El nombre del tipo de procedimiento "%s" ya existe en otro registro.', 16, 2, @Nuevo_Nombre_Procedimiento);
            RETURN;
        END

        -- Realizar la actualización
        UPDATE Tipo_Procedimiento
        SET Nombre_Procedimiento = @Nuevo_Nombre_Procedimiento
        WHERE ID_Tipo_Procedimiento = @ID_Tipo_Procedimiento;

        PRINT 'El tipo de procedimiento se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        -- Captura y muestra cualquier error durante la ejecución
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(N'Error al modificar el tipo de procedimiento: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO
-----------------------Modificar Procedimiento
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE Sp_ModificarProcedimiento
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

    BEGIN TRY
        -- Verificar si el ID de procedimiento existe
        IF NOT EXISTS (SELECT 1 FROM Procedimiento WHERE ID_Procedimiento = @ID_Procedimiento)
        BEGIN
            RAISERROR('El ID de procedimiento con valor %d no existe.', 16, 1, @ID_Procedimiento);
            RETURN;
        END

        -- Verificar si el ID de sala existe
        IF @ID_Sala IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Sala WHERE ID_Sala = @ID_Sala)
        BEGIN
            RAISERROR('El ID de sala con valor %d no existe.', 16, 1, @ID_Sala);
            RETURN;
        END

        -- Verificar si el ID de historial médico existe
        IF @ID_Historial_Medico IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Historial_Medico WHERE ID_Historial_Medico = @ID_Historial_Medico)
        BEGIN
            RAISERROR('El ID de historial médico con valor %d no existe.', 16, 1, @ID_Historial_Medico);
            RETURN;
        END

        -- Verificar si el ID de cita existe
        IF @ID_Cita IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Cita WHERE ID_Cita = @ID_Cita)
        BEGIN
            RAISERROR('El ID de cita con valor %d no existe.', 16, 1, @ID_Cita);
            RETURN;
        END

        -- Verificar si el ID de tipo de procedimiento existe
        IF @ID_Tipo_Procedimiento IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Tipo_Procedimiento WHERE ID_Tipo_Procedimiento = @ID_Tipo_Procedimiento)
        BEGIN
            RAISERROR('El ID de tipo de procedimiento con valor %d no existe.', 16, 1, @ID_Tipo_Procedimiento);
            RETURN;
        END

        -- Realizar la actualización
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
        -- Captura y muestra cualquier error durante la ejecución
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(N'Error al modificar el procedimiento: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO
-----------------------Modificar Estado Recurso Medico
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE Sp_ModificarEstadoRecursoMedico
(
    @ID_Estado_Recurso_Medico INT,
    @Estado_Recurso VARCHAR(50) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Verificar si el ID de estado de recurso médico existe
        IF NOT EXISTS (SELECT 1 FROM Estado_Recurso_Medico WHERE ID_Estado_Recurso_Medico = @ID_Estado_Recurso_Medico)
        BEGIN
            RAISERROR('El ID de estado de recurso médico con valor %d no existe.', 16, 1, @ID_Estado_Recurso_Medico);
            RETURN;
        END

        -- Verificar si el estado de recurso médico ya existe
        IF @Estado_Recurso IS NOT NULL AND EXISTS (SELECT 1 FROM Estado_Recurso_Medico WHERE Estado_Recurso = @Estado_Recurso AND ID_Estado_Recurso_Medico <> @ID_Estado_Recurso_Medico)
        BEGIN
            RAISERROR('El estado de recurso médico "%s" ya existe en otro registro.', 16, 1, @Estado_Recurso);
            RETURN;
        END

        -- Actualizar el estado de recurso médico
        UPDATE Estado_Recurso_Medico
        SET 
            Estado_Recurso = COALESCE(@Estado_Recurso, Estado_Recurso)
        WHERE ID_Estado_Recurso_Medico = @ID_Estado_Recurso_Medico;

        PRINT 'El estado de recurso médico se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        -- Capturar cualquier error y mostrar el mensaje
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(N'Error al modificar el estado de recurso médico: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO

-----------------------Modificar Tipo de Recurso
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE Sp_ModificarTipoRecurso
(
    @ID_Tipo_Recurso INT,
    @Titulo_Recurso VARCHAR(50) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Verificar si el ID de tipo de recurso existe
        IF NOT EXISTS (SELECT 1 FROM Tipo_Recurso WHERE ID_Tipo_Recurso = @ID_Tipo_Recurso)
        BEGIN
            RAISERROR('El ID de tipo de recurso con valor %d no existe.', 16, 1, @ID_Tipo_Recurso);
            RETURN;
        END

        -- Verificar si el título de recurso ya existe
        IF @Titulo_Recurso IS NOT NULL AND EXISTS (SELECT 1 FROM Tipo_Recurso WHERE Titulo_Recurso = @Titulo_Recurso AND ID_Tipo_Recurso <> @ID_Tipo_Recurso)
        BEGIN
            RAISERROR('El título de recurso "%s" ya existe en otro registro.', 16, 1, @Titulo_Recurso);
            RETURN;
        END

        -- Actualizar el título de recurso
        UPDATE Tipo_Recurso
        SET 
            Titulo_Recurso = COALESCE(@Titulo_Recurso, Titulo_Recurso)
        WHERE ID_Tipo_Recurso = @ID_Tipo_Recurso;

        PRINT 'El tipo de recurso se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        -- Capturar cualquier error y mostrar el mensaje
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(N'Error al modificar el tipo de recurso: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO

--------------------Modificar Recurso Medico
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE Sp_ModificarRecursoMedico
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

    BEGIN TRY
        -- Verificar si el ID de recurso médico existe
        IF NOT EXISTS (SELECT 1 FROM Recurso_Medico WHERE ID_Recurso_Medico = @ID_Recurso_Medico)
        BEGIN
            RAISERROR('El ID de recurso médico con valor %d no existe.', 16, 1, @ID_Recurso_Medico);
            RETURN;
        END

        -- Verificar si el ID de tipo de recurso existe
        IF @ID_Tipo_Recurso IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Tipo_Recurso WHERE ID_Tipo_Recurso = @ID_Tipo_Recurso)
        BEGIN
            RAISERROR('El ID de tipo de recurso con valor %d no existe.', 16, 1, @ID_Tipo_Recurso);
            RETURN;
        END

        -- Verificar si el ID de estado de recurso médico existe
        IF @ID_Estado_Recurso_Medico IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Estado_Recurso_Medico WHERE ID_Estado_Recurso_Medico = @ID_Estado_Recurso_Medico)
        BEGIN
            RAISERROR('El ID de estado de recurso médico con valor %d no existe.', 16, 1, @ID_Estado_Recurso_Medico);
            RETURN;
        END

        -- Actualizar los datos del recurso médico
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
        -- Captura y manejo de errores
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(N'Error al modificar el recurso médico: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO
-----------------------------Modificar Recurso_Medico Sala
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE Sp_ModificarRecursoMedicoSala
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

    BEGIN TRY
        -- Verificar si el ID de recurso médico en sala existe
        IF NOT EXISTS (SELECT 1 FROM Recurso_Medico_Sala WHERE ID_Recurso_Medico_Sala = @ID_Recurso_Medico_Sala)
        BEGIN
            RAISERROR('El ID de recurso médico en sala con valor %d no existe.', 16, 1, @ID_Recurso_Medico_Sala);
            RETURN;
        END

        -- Verificar si el ID de recurso médico existe
        IF @ID_Recurso_Medico IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Recurso_Medico WHERE ID_Recurso_Medico = @ID_Recurso_Medico)
        BEGIN
            RAISERROR('El ID de recurso médico con valor %d no existe.', 16, 1, @ID_Recurso_Medico);
            RETURN;
        END

        -- Verificar si el ID de sala existe
        IF @ID_Sala IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Sala WHERE ID_Sala = @ID_Sala)
        BEGIN
            RAISERROR('El ID de sala con valor %d no existe.', 16, 1, @ID_Sala);
            RETURN;
        END

        -- Actualizar la relación de recurso médico en sala
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
        -- Manejo de errores
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(N'Error al modificar el recurso médico en sala: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO

-----------------------------Modificar Horario Trabajo
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE Sp_ModificarHorarioTrabajo
(
    @ID_Horario_Trabajo INT,
    @Nombre_Horario VARCHAR(50) = NULL,
    @Hora_Inicio TIME = NULL,
    @Hora_Fin TIME = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Verificar si el ID de horario de trabajo existe
        IF NOT EXISTS (SELECT 1 FROM Horario_Trabajo WHERE ID_Horario_Trabajo = @ID_Horario_Trabajo)
        BEGIN
            RAISERROR('El ID de horario de trabajo con valor %d no existe.', 16, 1, @ID_Horario_Trabajo);
            RETURN;
        END

        -- Actualizar los campos del horario de trabajo
        UPDATE Horario_Trabajo
        SET 
            Nombre_Horario = COALESCE(@Nombre_Horario, Nombre_Horario),
            Hora_Inicio = COALESCE(@Hora_Inicio, Hora_Inicio),
            Hora_Fin = COALESCE(@Hora_Fin, Hora_Fin)
        WHERE ID_Horario_Trabajo = @ID_Horario_Trabajo;

        PRINT 'El horario de trabajo se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        -- Capturar y mostrar cualquier error
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(N'Error al modificar el horario de trabajo: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO
-----------------------------Modificar Planificacion de Recursos
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE Sp_ModificarPlanificacionRecurso
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

    BEGIN TRY
        -- Verificar si el ID de planificación existe
        IF NOT EXISTS (SELECT 1 FROM Planificacion_Recurso WHERE ID_Planificacion = @ID_Planificacion)
        BEGIN
            RAISERROR('El ID de planificación con valor %d no existe.', 16, 1, @ID_Planificacion);
            RETURN;
        END

        -- Validar si el ID de sala existe si se proporciona un valor
        IF @ID_Sala IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Sala WHERE ID_Sala = @ID_Sala)
        BEGIN
            RAISERROR('El ID de sala con valor %d no existe.', 16, 1, @ID_Sala);
            RETURN;
        END

        -- Validar si el ID de horario de trabajo existe si se proporciona un valor
        IF @ID_Horario_Trabajo IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Horario_Trabajo WHERE ID_Horario_Trabajo = @ID_Horario_Trabajo)
        BEGIN
            RAISERROR('El ID de horario de trabajo con valor %d no existe.', 16, 1, @ID_Horario_Trabajo);
            RETURN;
        END

        -- Actualizar la planificación del recurso
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
        -- Capturar y manejar el error
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(N'Error al modificar la planificación de recurso: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO

------------------------Modificar Medico Planificacion Recurso
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE Sp_ModificarMedicoPlanificacionRecurso
(
    @ID_Medico_Planificacion_Recurso INT,
    @Fecha_Planificacion_Personal DATE = NULL,
    @ID_Planificacion INT = NULL,
    @ID_Medico INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Verificar si el ID de planificación del médico existe
        IF NOT EXISTS (SELECT 1 FROM Medico_Planificacion_Recurso WHERE ID_Medico_Planificacion_Recurso = @ID_Medico_Planificacion_Recurso)
        BEGIN
            RAISERROR('El ID de planificación del médico con valor %d no existe.', 16, 1, @ID_Medico_Planificacion_Recurso);
            RETURN;
        END

        -- Verificar si el ID de médico existe si se proporciona
        IF @ID_Medico IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Medico WHERE ID_Medico = @ID_Medico)
        BEGIN
            RAISERROR('El ID de médico con valor %d no existe.', 16, 1, @ID_Medico);
            RETURN;
        END

        -- Verificar si el ID de planificación existe si se proporciona
        IF @ID_Planificacion IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Planificacion_Recurso WHERE ID_Planificacion = @ID_Planificacion)
        BEGIN
            RAISERROR('El ID de planificación con valor %d no existe.', 16, 1, @ID_Planificacion);
            RETURN;
        END

        -- Actualizar la planificación del médico
        UPDATE Medico_Planificacion_Recurso
        SET 
            Fecha_Planificacion_Personal = COALESCE(@Fecha_Planificacion_Personal, Fecha_Planificacion_Personal),
            ID_Planificacion = COALESCE(@ID_Planificacion, ID_Planificacion),
            ID_Medico = COALESCE(@ID_Medico, ID_Medico)
        WHERE ID_Medico_Planificacion_Recurso = @ID_Medico_Planificacion_Recurso;

        PRINT 'La planificación del médico se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        -- Capturar y manejar el error
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(N'Error al modificar la planificación del médico: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO
---------------------Modificar Satisfaccion Paciente
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE Sp_ModificarSatisfaccionPaciente
(
    @ID_Satisfaccion INT,
    @Fecha_Evaluacion DATE = NULL,
    @Calificacion_Satisfaccion INT = NULL,
    @ID_Cita INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Verificar si el ID de satisfacción existe
        IF NOT EXISTS (SELECT 1 FROM Satisfaccion_Paciente WHERE ID_Satisfaccion = @ID_Satisfaccion)
        BEGIN
            RAISERROR('El ID de satisfacción con valor %d no existe.', 16, 1, @ID_Satisfaccion);
            RETURN;
        END

        -- Verificar si el ID de cita existe si se proporciona
        IF @ID_Cita IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Cita WHERE ID_Cita = @ID_Cita)
        BEGIN
            RAISERROR('El ID de cita con valor %d no existe.', 16, 1, @ID_Cita);
            RETURN;
        END

        -- Verificar que la calificación de satisfacción esté entre 1 y 5
        IF @Calificacion_Satisfaccion IS NOT NULL AND (@Calificacion_Satisfaccion < 1 OR @Calificacion_Satisfaccion > 5)
        BEGIN
            RAISERROR('La calificación de satisfacción debe estar entre 1 y 5. El valor proporcionado fue %d.', 16, 1, @Calificacion_Satisfaccion);
            RETURN;
        END

        -- Actualizar la satisfacción del paciente
        UPDATE Satisfaccion_Paciente
        SET 
            Fecha_Evaluacion = COALESCE(@Fecha_Evaluacion, Fecha_Evaluacion),
            Calificacion_Satisfaccion = COALESCE(@Calificacion_Satisfaccion, Calificacion_Satisfaccion),
            ID_Cita = COALESCE(@ID_Cita, ID_Cita)
        WHERE ID_Satisfaccion = @ID_Satisfaccion;

        PRINT 'La satisfacción del paciente se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        -- Capturar y manejar el error
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(N'Error al modificar la satisfacción del paciente: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO
---------------------------Modificar Rol
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE Sp_ModificarRol
(
    @ID_Rol INT,
    @Nuevo_Nombre_Rol VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Verificar si el ID de rol existe
        IF NOT EXISTS (SELECT 1 FROM Rol WHERE ID_Rol = @ID_Rol)
        BEGIN
            RAISERROR('El ID de rol con valor %d no existe.', 16, 1, @ID_Rol);
            RETURN;
        END

        -- Verificar si el nuevo nombre de rol ya existe en otro registro
        IF EXISTS (SELECT 1 FROM Rol WHERE Nombre_Rol = @Nuevo_Nombre_Rol AND ID_Rol <> @ID_Rol)
        BEGIN
            RAISERROR('El nuevo nombre del rol "%s" ya existe.', 16, 1, @Nuevo_Nombre_Rol);
            RETURN;
        END

        -- Actualizar el nombre del rol
        UPDATE Rol
        SET Nombre_Rol = @Nuevo_Nombre_Rol
        WHERE ID_Rol = @ID_Rol;

        PRINT 'El rol se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        -- Capturar y manejar cualquier error
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(N'Error al modificar el rol: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO

---------------------------Modificar Usuario
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE Sp_ModificarUsuario
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

    BEGIN TRY
        -- Verificar si el ID de usuario existe
        IF NOT EXISTS (SELECT 1 FROM Usuario WHERE ID_Usuario = @ID_Usuario)
        BEGIN
            RAISERROR('El ID de usuario con valor %d no existe.', 16, 1, @ID_Usuario);
            RETURN;
        END

        -- Verificar si el nuevo rol existe, si se proporcionó un nuevo rol
        IF @Nuevo_Rol IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Rol WHERE ID_Rol = @Nuevo_Rol)
        BEGIN
            RAISERROR('El ID de rol con valor %d no existe.', 16, 1, @Nuevo_Rol);
            RETURN;
        END

        -- Actualizar los datos del usuario
        UPDATE Usuario
        SET 
            Nombre_Usuario = COALESCE(@Nuevo_Nombre_Usuario, Nombre_Usuario),
            Correo_Usuario = COALESCE(@Nuevo_Correo_Usuario, Correo_Usuario),
            Contraseña_Usuario = COALESCE(@Nueva_Contrasena_Usuario, Contraseña_Usuario),
            ID_Rol = COALESCE(@Nuevo_Rol, ID_Rol)
        WHERE ID_Usuario = @ID_Usuario;

        PRINT 'El usuario se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        -- Capturar y manejar cualquier error
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(N'Error al modificar el usuario: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO
------------------------------Modificar Permiso
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE Sp_ModificarPermiso
(
    @ID_Permiso INT,
    @Nuevo_Nombre_Permiso VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Verificar si el ID de permiso existe
        IF NOT EXISTS (SELECT 1 FROM Permiso WHERE ID_Permiso = @ID_Permiso)
        BEGIN
            RAISERROR('El ID de permiso con valor %d no existe.', 16, 1, @ID_Permiso);
            RETURN;
        END

        -- Verificar si el nuevo nombre de permiso ya existe
        IF EXISTS (SELECT 1 FROM Permiso WHERE Nombre_Permiso = @Nuevo_Nombre_Permiso AND ID_Permiso <> @ID_Permiso)
        BEGIN
            RAISERROR('El nuevo nombre de permiso "%s" ya existe en otro registro.', 16, 1, @Nuevo_Nombre_Permiso);
            RETURN;
        END

        -- Actualizar el nombre del permiso
        UPDATE Permiso
        SET Nombre_Permiso = @Nuevo_Nombre_Permiso
        WHERE ID_Permiso = @ID_Permiso;

        PRINT 'El permiso se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        -- Capturar cualquier error y mostrar un mensaje
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(N'Error al modificar el permiso: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO
--------------------Modificar Rol Permiso
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE Sp_ModificarRolPermiso
(
    @ID_Rol_Permiso INT,
    @Nuevo_ID_Rol INT = NULL,
    @Nuevo_ID_Permiso INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Verificar si la relación rol-permiso existe
        IF NOT EXISTS (SELECT 1 FROM Rol_Permiso WHERE ID_Rol_Permiso = @ID_Rol_Permiso)
        BEGIN
            RAISERROR('El ID de relación rol-permiso %d no existe.', 16, 1, @ID_Rol_Permiso);
            RETURN;
        END

        -- Verificar si el nuevo ID de rol es válido
        IF @Nuevo_ID_Rol IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Rol WHERE ID_Rol = @Nuevo_ID_Rol)
        BEGIN
            RAISERROR('El ID de rol %d no existe.', 16, 1, @Nuevo_ID_Rol);
            RETURN;
        END

        -- Verificar si el nuevo ID de permiso es válido
        IF @Nuevo_ID_Permiso IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Permiso WHERE ID_Permiso = @Nuevo_ID_Permiso)
        BEGIN
            RAISERROR('El ID de permiso %d no existe.', 16, 1, @Nuevo_ID_Permiso);
            RETURN;
        END

        -- Actualizar la relación rol-permiso
        UPDATE Rol_Permiso
        SET 
            ID_Rol = COALESCE(@Nuevo_ID_Rol, ID_Rol),
            ID_Permiso = COALESCE(@Nuevo_ID_Permiso, ID_Permiso)
        WHERE ID_Rol_Permiso = @ID_Rol_Permiso;

        PRINT 'La relación rol-permiso se ha modificado correctamente.';
    END TRY
    BEGIN CATCH
        -- Manejo de errores en caso de fallos
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(N'Error al modificar la relación rol-permiso: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO
------------------------------------------------Procedimientos Almacenados para DELETE
----------------------Eliminar Rol Permisos
Use SaludPlus
go
CREATE OR ALTER PROCEDURE Sp_EliminarRol_Permiso
    @ID_Rol_Permiso INT
AS
BEGIN
	BEGIN TRY

		IF NOT EXISTS (SELECT 1 FROM Rol_Permiso WHERE ID_Rol_Permiso = @ID_Rol_Permiso)
		BEGIN
			PRINT 'No existe la relación Rol-Permiso con ID_Rol_Permiso = ' + CAST(@ID_Rol_Permiso AS VARCHAR)
			RETURN
		END

		DELETE FROM Rol_Permiso WHERE ID_Rol_Permiso = @ID_Rol_Permiso
	END TRY
	BEGIN CATCH
		DECLARE @ERROR NVARCHAR(1000)

		SET @ERROR = ERROR_MESSAGE()

		RAISERROR(N'No se pudo eliminar el Rol_Permiso por que puede tener dependencias', 16, 1);
		PRINT @ERROR

	END CATCH
END
go
-----------------------Eliminar Usuario
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE Sp_EliminarUsuario
    @ID_Usuario INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Usuario WHERE ID_Usuario = @ID_Usuario)
        BEGIN
            PRINT 'No existe el Usuario con ID_Usuario = ' + CAST(@ID_Usuario AS VARCHAR)
            RETURN
        END

        DELETE FROM Usuario WHERE ID_Usuario = @ID_Usuario
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'No se pudo eliminar el Usuario debido a posibles dependencias o un error inesperado.', 16, 1);
        PRINT @ERROR
    END CATCH
END
GO

-----------------------Eliminar Rol
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE EliminarRol
    @ID_Rol INT
AS
BEGIN
    BEGIN TRY
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
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'No se pudo eliminar el Rol debido a dependencias o un error inesperado.', 16, 1);
        PRINT @ERROR
    END CATCH
END
GO

-----------------------Eliminar Permiso
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarPermiso
    @ID_Permiso INT
AS
BEGIN
    BEGIN TRY
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
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'No se pudo eliminar el Permiso debido a dependencias o un error inesperado.', 16, 1);
        PRINT @ERROR
    END CATCH
END
GO
-----------------------Eliminar satisfaccion Paciente
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE EliminarSatisfaccionPaciente
    @ID_Satisfaccion INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Satisfaccion_Paciente WHERE ID_Satisfaccion = @ID_Satisfaccion)
        BEGIN
            PRINT 'No existe la Satisfacción del Paciente con ID_Satisfaccion = ' + CAST(@ID_Satisfaccion AS VARCHAR)
            RETURN
        END

        IF EXISTS (SELECT 1 FROM Satisfaccion_Paciente WHERE ID_Cita = @ID_Satisfaccion)
        BEGIN
            PRINT 'No se puede eliminar la Satisfacción del Paciente con ID_Satisfaccion = ' + CAST(@ID_Satisfaccion AS VARCHAR) + ' porque tiene citas asociadas.'
            RETURN
        END

        DELETE FROM Satisfaccion_Paciente WHERE ID_Satisfaccion = @ID_Satisfaccion
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'No se pudo eliminar la Satisfacción del Paciente debido a dependencias o un error inesperado.', 16, 1);
        PRINT @ERROR
    END CATCH
END
GO

------------------ Procedimiento para eliminar Medico_Planificacion_RecursoUse SaludPlus
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarMedicoPlanificacionRecurso
    @ID_Medico_Planificacion_Recurso INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Medico_Planificacion_Recurso WHERE ID_Medico_Planificacion_Recurso = @ID_Medico_Planificacion_Recurso)
        BEGIN
            PRINT 'No existe la planificación de recurso médico con ID_Medico_Planificacion_Recurso = ' + CAST(@ID_Medico_Planificacion_Recurso AS VARCHAR)
            RETURN
        END

        DELETE FROM Medico_Planificacion_Recurso WHERE ID_Medico_Planificacion_Recurso = @ID_Medico_Planificacion_Recurso
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'No se pudo eliminar la planificación de recurso médico debido a un error inesperado.', 16, 1);
        PRINT @ERROR
    END CATCH
END
GO


-- Procedimiento para eliminar Paciente
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarPaciente
    @ID_Paciente INT
AS
BEGIN
    BEGIN TRY
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
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'No se pudo eliminar el Paciente debido a un error inesperado.', 16, 1);
        PRINT @ERROR
    END CATCH
END
GO

----------------- Procedimiento para eliminar Cita
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarCita
    @ID_Cita INT
AS
BEGIN
    BEGIN TRY
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
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'No se pudo eliminar la Cita debido a un error inesperado.', 16, 1);
        PRINT @ERROR
    END CATCH
END
GO

---------------------Procedimiento para eliminar Estado_Cita
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE Sp_EliminarEstado_Cita
    @ID_Estado_Cita INT
AS
BEGIN
    BEGIN TRY
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
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'No se pudo eliminar el Estado de Cita debido a un error inesperado.', 16, 1);
        PRINT @ERROR
    END CATCH
END
GO


------------ Procedimiento para eliminar Factura
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarFactura
    @ID_Factura INT
AS
BEGIN
    BEGIN TRY
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
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'No se pudo eliminar la Factura debido a un error inesperado.', 16, 1);
        PRINT @ERROR
    END CATCH
END
GO
---------------- Procedimiento para eliminar Tipo_Pago
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarTipoPago
    @ID_Tipo_Pago INT
AS
BEGIN
    BEGIN TRY
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
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'No se pudo eliminar el Tipo de Pago debido a un error inesperado.', 16, 1);
        PRINT @ERROR
    END CATCH
END
GO

------------------------- Procedimiento para eliminar Tipo_Procedimiento

USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarTipoProcedimiento
    @ID_Tipo_Procedimiento INT
AS
BEGIN
    BEGIN TRY
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
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'No se pudo eliminar el Tipo de Procedimiento debido a un error inesperado.', 16, 1);
        PRINT @ERROR
    END CATCH
END
GO
------------------------- Procedimiento para eliminar Historial_Medico
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarHistorialMedico
    @ID_Historial_Medico INT
AS
BEGIN
    BEGIN TRY
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
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'No se pudo eliminar el Historial Médico debido a un error inesperado.', 16, 1);
        PRINT @ERROR
    END CATCH
END
GO
------------------------- Procedimiento para eliminar Recurso_Medico
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarRecursoMedico
    @ID_Recurso_Medico INT
AS
BEGIN
    BEGIN TRY
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
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'No se pudo eliminar el Recurso Médico debido a un error inesperado.', 16, 1);
        PRINT @ERROR
    END CATCH
END
GO

------------------------- Procedimiento para eliminar Sala
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarSala
    @ID_Sala INT
AS
BEGIN
    BEGIN TRY
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
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'No se pudo eliminar la Sala debido a un error inesperado.', 16, 1);
        PRINT @ERROR
    END CATCH
END
GO

-------------------------Procedimiento para eliminar Estado_Recurso_Medico
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarEstadoRecursoMedico
    @ID_Estado_Recurso_Medico INT
AS
BEGIN
    BEGIN TRY
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
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'No se pudo eliminar el Estado de Recurso Médico debido a un error inesperado.', 16, 1);
        PRINT @ERROR
    END CATCH
END
GO

-------------------------Procedimiento para eliminar Tipo_Recurso
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarTipoRecurso
    @ID_Tipo_Recurso INT
AS
BEGIN
    BEGIN TRY
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
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'No se pudo eliminar el Tipo de Recurso debido a un error inesperado.', 16, 1);
        PRINT @ERROR
    END CATCH
END
GO

------------------------- Procedimiento para eliminar Estado_Sala
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarEstadoSala
    @ID_Estado_Sala INT
AS
BEGIN
    BEGIN TRY
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
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'No se pudo eliminar el Estado de Sala debido a un error inesperado.', 16, 1);
        PRINT @ERROR
    END CATCH
END
GO

-------------------------Procedimiento para eliminar Tipo_Sala

USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarTipoSala
    @ID_Tipo_Sala INT
AS
BEGIN
    BEGIN TRY
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
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'No se pudo eliminar el Tipo de Sala debido a un error inesperado.', 16, 1);
        PRINT @ERROR
    END CATCH
END
GO
------------------------- Procedimiento para eliminar Recurso_Medico_Sala
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarRecursoMedicoSala
    @ID_Recurso_Medico_Sala INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Recurso_Medico_Sala WHERE ID_Recurso_Medico_Sala = @ID_Recurso_Medico_Sala)
        BEGIN
            PRINT 'No existe el Recurso Médico en Sala con ID_Recurso_Medico_Sala = ' + CAST(@ID_Recurso_Medico_Sala AS VARCHAR)
            RETURN
        END

        DELETE FROM Recurso_Medico_Sala WHERE ID_Recurso_Medico_Sala = @ID_Recurso_Medico_Sala
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'No se pudo eliminar el Recurso Médico en Sala debido a un error inesperado.', 16, 1);
        PRINT @ERROR
    END CATCH
END
GO

------------------------- Procedimiento para eliminar Medico
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarMedico
    @ID_Medico INT
AS
BEGIN
    BEGIN TRY
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
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'No se pudo eliminar el Médico debido a un error inesperado.', 16, 1);
        PRINT @ERROR
    END CATCH
END
GO
-------------------------Procedimiento para eliminar Especialidad

USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarEspecialidad
    @ID_Especialidad INT
AS
BEGIN
    BEGIN TRY
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
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'No se pudo eliminar la Especialidad debido a un error inesperado.', 16, 1);
        PRINT @ERROR
    END CATCH
END
GO
------------------------- Procedimiento para eliminar Horario_Trabajo
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarHorarioTrabajo
    @ID_Horario_Trabajo INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Horario_Trabajo WHERE ID_Horario_Trabajo = @ID_Horario_Trabajo)
        BEGIN
            PRINT 'No existe el Horario de Trabajo con ID_Horario_Trabajo = ' + CAST(@ID_Horario_Trabajo AS VARCHAR)
            RETURN
        END

        IF EXISTS (SELECT 1 FROM Planificacion_Recurso WHERE ID_Horario_Trabajo = @ID_Horario_Trabajo)
        BEGIN
            PRINT 'No se puede eliminar el Horario de Trabajo, tiene planificación de recursos asociada.'
            RETURN
        END

        DELETE FROM Horario_Trabajo WHERE ID_Horario_Trabajo = @ID_Horario_Trabajo
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'No se pudo eliminar el Horario de Trabajo debido a un error inesperado.', 16, 1);
        PRINT @ERROR
    END CATCH
END
GO
------------------------- Procedimiento para eliminar Planificacion_Recurso
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarPlanificacionRecurso
    @ID_Planificacion INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Planificacion_Recurso WHERE ID_Planificacion = @ID_Planificacion)
        BEGIN
            PRINT 'No existe la Planificación de Recurso con ID_Planificacion = ' + CAST(@ID_Planificacion AS VARCHAR)
            RETURN
        END

        DELETE FROM Planificacion_Recurso WHERE ID_Planificacion = @ID_Planificacion
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'No se pudo eliminar la Planificación de Recurso debido a un error inesperado.', 16, 1);
        PRINT @ERROR
    END CATCH
END
GO
------------------------- Procedimiento para eliminar Procedimiento
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarProcedimiento
    @ID_Procedimiento INT
AS
BEGIN
    BEGIN TRY
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
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'No se pudo eliminar el Procedimiento debido a un error inesperado.', 16, 1);
        PRINT @ERROR
    END CATCH
END
GO

