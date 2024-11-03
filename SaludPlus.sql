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
Descripcion varchar(150) not null,
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

------------------------------------------------Inserciones 
USE SaludPlus;
GO
-- Inserciones para la tabla Paciente
INSERT INTO Paciente (Nombre_Paciente, Apellido1_Paciente, Apellido2_Paciente, Telefono_Paciente, Fecha_Nacimiento, Direccion_Paciente, Cedula)
VALUES 
('Juan', 'Perez', 'Gomez', '1234567890', '1980-01-01', 'Calle 1, Ciudad A', '12345698'),
('Maria', 'Lopez', 'Martinez', '2345678901', '1990-02-02', 'Calle 2, Ciudad B', '123454322'),
('Carlos', 'Garcia', 'Rodriguez', '3456789012', '1985-03-03', 'Calle 3, Ciudad C', '867905532'),
('Ana', 'Hernandez', 'Sanchez', '4567890123', '1995-04-04', 'Calle 4, Ciudad D', '508975568'),
('Luis', 'Martinez', 'Diaz', '5678901234', '2000-05-05', 'Calle 5, Ciudad E', '186790004');

-- Inserciones para la tabla Tipo Sala
INSERT INTO Tipo_Sala (Descripcion_Tipo_Sala)
VALUES 
('Emergencias'),
('Cirugia'),
('Consulta General'),
('Observacion'),
('Laboratorio');
GO

-- Inserciones para la tabla Estado Sala
INSERT INTO Estado_Sala (Nombre)
VALUES 
('activa');
GO

-- Inserciones para la tabla Sala
INSERT INTO Sala (Nombre_Sala, ID_Tipo_Sala, Capacidad_Sala, ID_Estado_Sala)
VALUES 
('Sala de Emergencias', 1, 5, 1),
('Sala de Cirugia', 2, 10, 1),
('Consulta General 1', 2, 3, 1),
('Sala de Observacion', 4, 3, 1),
('Laboratorio 1', 5, 2, 1);
GO

-- Inserciones para la tabla Especialidad
INSERT INTO Especialidad (Nombre_Especialidad)
VALUES 
('Cardiología'),
('Dermatología'),
('Radiología'),
('Pediatría'),
('Cirugía');
GO

-- Inserciones para la tabla Medico
INSERT INTO Medico (Nombre1_Medico, Nombre2_Medico, Apellido1_Medico, Apellido2_Medico, Telefono_Medico, ID_Especialidad)
VALUES 
('Pedro', 'Jose', 'Ramirez', 'Fernandez', '6789012345', 1),
('Laura', 'Maria', 'Gonzalez', 'Lopez', '7890123456', 2),
('Miguel', 'Angel', 'Torres', 'Perez', '8901234567', 3),
('Sofia', 'Elena', 'Vargas', 'Garcia', '9012345678', 4),
('Diego', 'Luis', 'Castro', 'Martinez', '1234567890', 5);
GO

-- Inserciones para la tabla Estado Cita
INSERT INTO Estado_Cita (Estado)
VALUES 
('Programada'),   
('Realizada'),
('Cancelada');
GO

-- Inserciones para la tabla Cita
INSERT INTO Cita (Fecha_Cita, Hora_Cita, ID_Estado_Cita, ID_Paciente, ID_Medico)
VALUES 
('2024-01-01', '08:00', 1, 1, 1),   
('2024-02-01', '09:00', 2, 2, 2),
('2024-03-01', '10:00', 3, 3, 3),
('2024-04-01', '11:00', 1, 4, 4),
('2024-05-01', '12:00', 2, 5, 5);
GO

-- Inserciones para la tabla Tipo Pago
INSERT INTO Tipo_Pago (Descripcion_Tipo_Pago)
VALUES 
('Efectivo'),
('Tarjeta de credito'),
('Tarjeta de debito'),
('Transferencia Bancaria'),
('Sinpe Movil');
GO

-- Inserciones para la tabla Factura
INSERT INTO Factura (Fecha_Factura, Monto_Total, ID_Paciente, ID_Cita, ID_Tipo_Pago)
VALUES 
('2024-01-01', 1000.00, 1, 1, 1),
('2024-02-01', 2000.00, 2, 2, 2),
('2024-03-01', 3000.00, 3, 3, 3),
('2024-04-01', 4000.00, 4, 4, 4),
('2024-05-01', 5000.00, 5, 5, 5);
GO

-- Inserciones para la tabla Historial_Medico
INSERT INTO Historial_Medico (Fecha_Registro, ID_Paciente)
VALUES 
('2024-01-01', 1),   
('2024-02-01', 2),
('2024-03-01', 3),
('2024-04-01', 4),
('2024-05-01', 5);
GO

-- Inserciones para la tabla Tipo Procedimiento
INSERT INTO Tipo_Procedimiento (Nombre_Procedimiento)
VALUES 
('Cita de Cirugía'),   
('Cita de Laboratorio'),
('Cita de Consulta General'),
('Emergencias'),
('Cita de Diagnostico');
GO

-- Inserciones para la tabla Procedimiento
INSERT INTO Procedimiento (Descripcion_Procedimiento, Fecha_Procedimiento, Hora_Procedimiento, Monto_Procedimiento, Receta, ID_Sala, ID_Historial_Medico, ID_Cita, ID_Tipo_Procedimiento)
VALUES 
('Cirugía de corazon', '2024-01-01', '14:00', 10000, 'Ibuprofeno cada seis horas por tres días', 1, 1, 1, 1), 
('Entrada de emergencia por pierna lesionada', '2024-02-01', '12:30', 200000, 'Ibuprofeno cada seis horas por 5 días', 2, 2, 2, 4),
('Enfermedad de piel', '2024-03-01', '09:00', 30000, 'Paracetamol cada ocho horas por cinco días', 3, 3, 3, 3),
('Por dolores fuertes de cabeza', '2024-04-01', '10:00', 400000, 'Paracetamol cada ocho horas por siete días', 4, 4, 4, 3),
('Laboratorio de cardiología', '2024-05-01', '15:00', 5000000, 'Ibuprofeno cada seis horas por seis días', 5, 5, 5, 2);
GO

-- Inserciones para la tabla Satisfaccion_Paciente
INSERT INTO Satisfaccion_Paciente (Fecha_Evaluacion, Calificacion_Satisfaccion, ID_Cita)
VALUES 
('2024-01-02', 5, 1),
('2024-02-02', 4, 2),
('2024-03-02', 3, 3),
('2024-04-02', 2, 4),
('2024-05-02', 1, 5);
GO

-- Inserciones para la tabla Tipo_Recurso
INSERT INTO Tipo_Recurso (Titulo_Recurso)
VALUES 
('Medicamento'),
('Equipo Médico'),
('Material de Oficina'),
('Instrumento Quirúrgico'),
('Suministro Médico');
GO

-- Inserciones para la tabla Estado_Recurso_Medico
INSERT INTO Estado_Recurso_Medico (Estado_Recurso)
VALUES 
('Disponible'),
('Agotado');
GO

-- Inserciones para la tabla Recurso_Medico
INSERT INTO Recurso_Medico (Nombre_Recurso, Lote, Cantidad_Stock_Total, Ubicacion_Recurso, ID_Tipo_Recurso, ID_Estado_Recurso_Medico)
VALUES 
('Recurso 1', 'Lote 1', 100, 'Almacén 1', 1, 1),
('Recurso 2', 'Lote 2', 200, 'Almacén 2', 2, 2),
('Recurso 3', 'Lote 3', 300, 'Almacén 3', 3, 1),
('Recurso 4', 'Lote 4', 400, 'Almacén 4', 4, 2),
('Recurso 5', 'Lote 5', 500, 'Almacén 5', 5, 1);
GO

-- Inserciones para la tabla Horario_Trabajo
INSERT INTO Horario_Trabajo (Nombre_Horario, Hora_Inicio, Hora_Fin)
VALUES 
('Mañana', '08:00', '12:00'),
('Tarde', '13:00', '17:00'),
('Noche', '18:00', '22:00'),
('Madrugada', '23:00', '03:00'),
('Completo', '08:00', '17:00');
GO 

-- Inserciones para la tabla Planificacion_Recurso
INSERT INTO Planificacion_Recurso (Descripcion_Planificacion, Fecha_Planificacion, ID_Sala, ID_Horario_Trabajo)
VALUES 
('Planificación 1', '2024-01-01', 1, 1),
('Planificación 2', '2024-02-01', 2, 2),
('Planificación 3', '2024-03-01', 3, 3),
('Planificación 4', '2024-04-01', 4, 4),
('Planificación 5', '2024-05-01', 5, 5);
GO

-- Inserciones de la tabla Medico_Planificacion_Recurso
INSERT INTO Medico_Planificacion_Recurso (Fecha_Planificacion_Personal, ID_Medico, ID_Planificacion)
VALUES
('2024-01-01', 1, 1),
('2024-01-01', 2, 2),
('2024-01-01', 3, 3),
('2024-01-01', 4, 4),
('2024-01-01', 5, 5);
GO

-- Inserciones para la tabla Recurso_Medico_Sala
INSERT INTO Recurso_Medico_Sala (Fecha, Descripcion, ID_Recurso_Medico, ID_Sala)
VALUES 
('2024-01-01', 'Sala tiene 20 recursos', 1, 1),
('2024-01-01', 'Sala tiene 30 recursos', 2, 2),
('2024-01-01', 'Sala tiene 40 recursos', 3, 3),
('2024-01-01', 'Sala tiene 50 recursos', 4, 4),
('2024-01-01', 'Sala tiene 60 recursos', 5, 5);
GO

-- Inserciones de Rol
INSERT INTO Rol (Nombre_Rol) 
VALUES
('Administrador'),
('Médico'),
('Recepcionista');
GO

-- Inserciones para el Usuario
INSERT INTO Usuario (Nombre_Usuario, Correo_Usuario, Contraseña_Usuario, ID_Rol) 
VALUES
('Juan Pérez', 'juan.perez@saludplus.com', 'contraseña123', 1),  
('María Gómez', 'maria.gomez@saludplus.com', 'contraseña456', 2),  
('Carlos López', 'carlos.lopez@saludplus.com', 'contraseña789', 3);
GO

-- Inserciones de permisos
INSERT INTO Permiso (Nombre_Permiso) 
VALUES 
('Crear Citas'),
('Ver Citas'),
('Modificar Citas'),
('Eliminar Citas'),
('Acceso a Historial Médico'),
('Gestionar Pacientes');
GO

-- Inserciones de Rol_Permisos
INSERT INTO Rol_Permiso (ID_Rol, ID_Permiso) 
VALUES 
(1, 1),  -- Administrador puede crear citas
(1, 2),  -- Administrador puede ver citas
(1, 3),  -- Administrador puede modificar citas
(1, 4),  -- Administrador puede eliminar citas
(1, 5),  -- Administrador puede acceder a historial médico
(1, 6);  -- Administrador puede gestionar pacientes
GO



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
        INSERT INTO Paciente (  Nombre_Paciente, Apellido1_Paciente, Apellido2_Paciente, Telefono_Paciente, Fecha_Nacimiento, Direccion_Paciente, Cedula)
        VALUES ( @Nombre_Paciente, @Apellido1_Paciente, @Apellido2_Paciente, @Telefono_Paciente, @Fecha_Nacimiento, @Direccion_Paciente, @Cedula);

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
EXEC Sp_RegistrarPaciente   @Nombre_Paciente = 'Pedro', @Apellido1_Paciente = 'Fernandez', @Apellido2_Paciente = 'Torres',
    @Telefono_Paciente = '5678901122',@Fecha_Nacimiento = '1988-06-06',@Direccion_Paciente = 'Calle 6, Ciudad F',@Cedula = '987654321';
	go

-- Insertar paciente 2
EXEC Sp_RegistrarPaciente  @Nombre_Paciente = 'Lucia', @Apellido1_Paciente = 'Cruz',@Apellido2_Paciente = 'Mendez', 
    @Telefono_Paciente = '6789012233',@Fecha_Nacimiento = '1992-07-07',@Direccion_Paciente = 'Calle 7, Ciudad G',@Cedula = '456789012';
	go

-- Insertar paciente 3
EXEC Sp_RegistrarPaciente  @Nombre_Paciente = 'Fernando',@Apellido1_Paciente = 'Ramirez',@Apellido2_Paciente = 'Soto', 
    @Telefono_Paciente = '7890123344',@Fecha_Nacimiento = '1982-08-08',@Direccion_Paciente = 'Calle 8, Ciudad H',@Cedula = '654321789';
	go

-- Insertar paciente 4
EXEC Sp_RegistrarPaciente  @Nombre_Paciente = 'Isabella',@Apellido1_Paciente = 'Alvarez',@Apellido2_Paciente = 'Paredes', 
    @Telefono_Paciente = '8901234455',@Fecha_Nacimiento = '1995-09-09',@Direccion_Paciente = 'Calle 9, Ciudad I',@Cedula = '321654987';
	go

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
	 -- Verificar si el nombre de la especialidad ya existe
    IF EXISTS (SELECT 1 FROM Especialidad WHERE Nombre_Especialidad = @Nombre_Especialidad)
    BEGIN
        RAISERROR('El nombre de la especialidad ya existe.', 16, 1);
        RETURN;
    END
    BEGIN TRY
        INSERT INTO Especialidad (  Nombre_Especialidad)
        VALUES ( @Nombre_Especialidad);

        PRINT 'La especialidad se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar la especialidad: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Insertar especialidad 1
EXEC Sp_RegistrarEspecialidad  @Nombre_Especialidad = 'Ginecología';
go

-- Insertar especialidad 2
EXEC Sp_RegistrarEspecialidad  @Nombre_Especialidad = 'Psiquiatría';
go

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
    BEGIN TRY
        INSERT INTO Medico (  Nombre1_Medico, Nombre2_Medico, Apellido1_Medico, Apellido2_Medico, Telefono_Medico, ID_Especialidad)
        VALUES (@Nombre1_Medico, @Nombre2_Medico, @Apellido1_Medico, @Apellido2_Medico, @Telefono_Medico, @ID_Especialidad);

        PRINT 'El medico se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el medico: ' + ERROR_MESSAGE();
    END CATCH
END;
GO



-- Insertar m�dico 1
EXEC Sp_RegistrarMedico  @Nombre1_Medico = 'Antonio',@Nombre2_Medico = 'Luis',@Apellido1_Medico = 'Salazar',@Apellido2_Medico = 'Jimenez', 
    @Telefono_Medico = '2345678901',@ID_Especialidad = 1; -- Cardiología
	go

-- Insertar m�dico 2
EXEC Sp_RegistrarMedico  @Nombre1_Medico = 'Carmen',@Nombre2_Medico = 'Teresa',@Apellido1_Medico = 'Ruiz',@Apellido2_Medico = 'Mena', 
    @Telefono_Medico = '3456789012',@ID_Especialidad = 2; -- Dermatología
	go
-- Insertar m�dico 3
EXEC Sp_RegistrarMedico  @Nombre1_Medico = 'Francisco',@Nombre2_Medico = 'Javier',@Apellido1_Medico = 'Hernandez',@Apellido2_Medico = 'Bermudez', 
    @Telefono_Medico = '4567890123',@ID_Especialidad = 3; -- Radiología
	go

-- Insertar m�dico 4
EXEC Sp_RegistrarMedico  @Nombre1_Medico = 'Elena',@Nombre2_Medico = 'Cristina',@Apellido1_Medico = 'Alvarez',@Apellido2_Medico = 'Luna', 
    @Telefono_Medico = '5678901234',@ID_Especialidad = 4; -- Pediatría
	go

-- Insertar m�dico 5
EXEC Sp_RegistrarMedico @Nombre1_Medico = 'Ricardo',@Nombre2_Medico = 'Andr�s',@Apellido1_Medico = 'Morales',@Apellido2_Medico = 'Santos', 
    @Telefono_Medico = '6789012345',@ID_Especialidad = 5; -- Cirugía
	go

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
	-- Verificar si el estado ya existe
    IF EXISTS (SELECT 1 FROM Estado_Cita WHERE Estado = @Estado)
    BEGIN
        RAISERROR('El estado de cita ya existe.', 16, 1);
        RETURN;
    END
    BEGIN TRY
        INSERT INTO Estado_Cita (  Estado)
        VALUES (  @Estado);

        PRINT 'El estado de cita se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el estado de cita: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Insertar estado de cita 1
EXEC Sp_RegistrarEstadoCita   @Estado = 'En Espera';
go

-- Insertar estado de cita 2
EXEC Sp_RegistrarEstadoCita  @Estado = 'No Asistió';
go
-- Insertar estado de cita 3
EXEC Sp_RegistrarEstadoCita   @Estado = 'Finalizada';
go

---------------Registrar Cita
Use SaludPlus
go
CREATE PROCEDURE Sp_RegistrarCita
(
    
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
    INSERT INTO Cita ( Fecha_Cita, Hora_Cita, ID_Paciente, ID_Medico, ID_Estado_Cita)
    VALUES ( @Fecha_Cita, @Hora_Cita, @ID_Paciente, @ID_Medico,@ID_Estado_Cita);

	PRINT 'La cita se ha registrado correctamente';
	END TRY
    BEGIN CATCH
    PRINT 'Error al registrar la cita: ' + ERROR_MESSAGE();
    END CATCH
	END;
GO

-- Insertar cita 2

execute Sp_RegistrarCita   @Fecha_Cita= '2024-01-01',  @Hora_Cita= '08:00', @ID_Paciente=5 , @ID_Medico=1, @ID_Estado_Cita =1
go
-- Insertar cita 2
EXEC Sp_RegistrarCita  @Fecha_Cita = '2024-06-01',@Hora_Cita = '08:30',@ID_Paciente = 2,@ID_Medico = 2,@ID_Estado_Cita = 1;
go
-- Insertar cita 3
EXEC Sp_RegistrarCita   @Fecha_Cita = '2024-07-01',@Hora_Cita = '09:30',@ID_Paciente = 2,@ID_Medico = 3,@ID_Estado_Cita = 2;
go
-- Insertar cita 4
EXEC Sp_RegistrarCita  @Fecha_Cita = '2024-08-01',@Hora_Cita = '10:30',@ID_Paciente = 3,@ID_Medico = 4,@ID_Estado_Cita = 3;
go
-- Insertar cita 5
EXEC Sp_RegistrarCita  @Fecha_Cita = '2024-09-01',@Hora_Cita = '11:30', @ID_Paciente = 6,@ID_Medico = 5,@ID_Estado_Cita = 1;
go
-- Insertar cita 6
EXEC Sp_RegistrarCita  @Fecha_Cita = '2024-09-01',@Hora_Cita = '14:30',@ID_Paciente = 7,@ID_Medico = 7,@ID_Estado_Cita = 2;
go

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
	-- Verificar si el tipo de pago ya existe
    IF EXISTS (SELECT 1 FROM Tipo_Pago WHERE Descripcion_Tipo_Pago = @Descripcion_Tipo_Pago)
    BEGIN
        RAISERROR('El tipo de pago ya existe.', 16, 1);
        RETURN;
    END
    BEGIN TRY
        INSERT INTO Tipo_Pago (  Descripcion_Tipo_Pago)
        VALUES ( @Descripcion_Tipo_Pago);

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
        INSERT INTO Factura ( Fecha_Factura, Monto_Total, ID_Paciente, ID_Cita,ID_Tipo_Pago)
        VALUES ( @Fecha_Factura, @Monto_Total, @ID_Paciente, @ID_Cita,@ID_Tipo_Pago);

        PRINT 'La factura se ha registrado correctamente.'
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar la factura: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Insertar factura 1
EXEC Sp_RegistrarFactura   @Fecha_Factura = '2024-06-01', @Monto_Total = 1500.00,@ID_Paciente = 1,@ID_Cita = 1,@ID_Tipo_Pago = 1;
go
-- Insertar factura 2
EXEC Sp_RegistrarFactura  @Fecha_Factura = '2024-07-01',@Monto_Total = 2500.00,@ID_Paciente = 2,@ID_Cita = 2, @ID_Tipo_Pago = 2;
go
-- Insertar factura 3
EXEC Sp_RegistrarFactura  @Fecha_Factura = '2024-08-01',@Monto_Total = 3500.00,@ID_Paciente = 3,@ID_Cita = 3,@ID_Tipo_Pago = 3;
go
-- Insertar factura 4
EXEC Sp_RegistrarFactura  @Fecha_Factura = '2024-09-01',@Monto_Total = 4500.00,@ID_Paciente = 4,@ID_Cita = 4,@ID_Tipo_Pago = 4;
go
-- Insertar factura 5
EXEC Sp_RegistrarFactura  @Fecha_Factura = '2024-10-01',@Monto_Total = 5500.00,@ID_Paciente = 5,@ID_Cita = 5,@ID_Tipo_Pago = 5;
go

--------------------Insertar Historial Medico
USE SaludPlus
GO
CREATE PROCEDURE Sp_RegistrarHistorialMedico
(
    
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
        RAISERROR('El paciente ya tiene un historial medico registrado.', 16, 2);
        RETURN;
    END

    BEGIN TRY
        INSERT INTO Historial_Medico (  Fecha_Registro, ID_Paciente)
        VALUES (  @Fecha_Registro, @ID_Paciente);

        PRINT 'El historial médico se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el historial médico: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


-- Insertar historial m�dico 1
EXEC Sp_RegistrarHistorialMedico  @Fecha_Registro = '2024-06-01',@ID_Paciente = 6;
go
-- Insertar historial m�dico 2
EXEC Sp_RegistrarHistorialMedico  @Fecha_Registro = '2024-07-01',@ID_Paciente = 7;
go
-- Insertar historial m�dico 3
EXEC Sp_RegistrarHistorialMedico  @Fecha_Registro = '2024-08-01',@ID_Paciente = 8;
go
-- Insertar historial m�dico 4
EXEC Sp_RegistrarHistorialMedico  @Fecha_Registro = '2024-09-01',@ID_Paciente = 9;
go


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
    @Descripcion VARCHAR(150),
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
        INSERT INTO Recurso_Medico_Sala (  Fecha, Descripcion, ID_Recurso_Medico, ID_Sala)
        VALUES (  @Fecha, @Descripcion, @ID_Recurso_Medico, @ID_Sala);

        PRINT 'El recurso médico en sala se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el recurso médico en sala: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC Sp_RegistrarRecursoMedicoSala  @Fecha = '2024-02-01',@Descripcion = 'Sala tiene 25 recursos',@ID_Recurso_Medico = 1,@ID_Sala = 1;
go
EXEC Sp_RegistrarRecursoMedicoSala  @Fecha = '2024-02-02',@Descripcion = 'Sala tiene 35 recursos',@ID_Recurso_Medico = 2,@ID_Sala = 2;
go
EXEC Sp_RegistrarRecursoMedicoSala  @Fecha = '2024-02-03',@Descripcion = 'Sala tiene 45 recursos',@ID_Recurso_Medico = 6,@ID_Sala = 3;
go
EXEC Sp_RegistrarRecursoMedicoSala  @Fecha = '2024-02-04',@Descripcion = 'Sala tiene 55 recursos',@ID_Recurso_Medico = 7,@ID_Sala = 8;
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
