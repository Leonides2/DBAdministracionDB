USE master;
GO

CREATE DATABASE DW_SaludPlus 
ON PRIMARY
(
    NAME = 'DW_SaludPlus_Data',
    FILENAME = 'C:\SQLData\DW_SaludPlus_Data.mdf',
    SIZE = 2000MB,
    MAXSIZE = 5000MB,
    FILEGROWTH = 500MB
)
LOG ON
(
    NAME = 'DW_SaludPlus_Log',
    FILENAME = 'C:\SQLLog\DW_SaludPlus_Log.ldf',
    SIZE = 1000MB,
    MAXSIZE = 2000MB,
    FILEGROWTH = 200MB
);
GO
---------------------creacion de tablas
USE DW_SaludPlus;
GO
CREATE TABLE DimPaciente (
    ID_Paciente INT PRIMARY KEY,
    Nombre_Paciente VARCHAR(50),
    Apellido1_Paciente VARCHAR(50)
);
GO
--------------------------
USE DW_SaludPlus;
GO
CREATE TABLE DimMedico (
    ID_Medico INT PRIMARY KEY,
    Nombre1_Medico VARCHAR(50),
    Nombre2_Medico VARCHAR(50),
    Apellido1_Medico VARCHAR(50),
    Apellido2_Medico VARCHAR(50),
    ID_Especialidad INT  
);
GO
-------------------------
USE DW_SaludPlus;
GO
CREATE TABLE DimCita (
    ID_Cita INT PRIMARY KEY,
    Fecha_Cita DATE,
    Hora_Cita TIME,
    ID_Estado_Cita INT  
);
GO
---------------------
USE DW_SaludPlus;
GO
CREATE TABLE DimFecha (
    ID_Fecha INT PRIMARY KEY IDENTITY(1,1), -- Añadido IDENTITY para generación automática
    Fecha DATE,
    Dia INT,
    Mes INT,
    Año INT
);
GO
---------------------
USE DW_SaludPlus;
GO
CREATE TABLE FactCargaMedico (
    ID_Carga INT PRIMARY KEY IDENTITY(1,1),
    ID_Medico INT,
    Fecha DATE,
    CitasAtendidas INT,
    HorasTrabajadas INT,
    FOREIGN KEY (ID_Medico) REFERENCES DimMedico(ID_Medico)
);
GO
-------------------
USE DW_SaludPlus;
GO
CREATE TABLE FactCita (
    ID_FactCita INT PRIMARY KEY IDENTITY(1,1),
    ID_Paciente INT,
    ID_Medico INT,
    ID_Cita INT,
    ID_Fecha INT,
    FOREIGN KEY (ID_Paciente) REFERENCES DimPaciente(ID_Paciente),
    FOREIGN KEY (ID_Medico) REFERENCES DimMedico(ID_Medico),
    FOREIGN KEY (ID_Cita) REFERENCES DimCita(ID_Cita),
    FOREIGN KEY (ID_Fecha) REFERENCES DimFecha(ID_Fecha)
);
GO



----------------------vistas
USE DW_SaludPlus;
GO

-- Vista para Paciente
CREATE VIEW vw_Paciente AS
SELECT ID_Paciente, Nombre_Paciente, Apellido1_Paciente
FROM SaludPlus.dbo.Paciente;
GO
 ---select *from  vw_Paciente

-- Vista para Medico
CREATE VIEW vw_Medico AS
SELECT ID_Medico, Nombre1_Medico, ID_Especialidad
FROM SaludPlus.dbo.Medico;
GO
---select *from  vw_Medico

-- Vista para Cita
CREATE VIEW vw_Cita AS
SELECT ID_Cita, Fecha_Cita, CONVERT(VARCHAR(5), Hora_Cita, 108) AS Hora_Cita, ID_Estado_Cita
FROM SaludPlus.dbo.Cita;
GO
  
---select *from  vw_Cita

-- Vista para Fecha
CREATE VIEW vw_Fecha AS
SELECT DISTINCT
    CAST(Fecha_Cita AS DATE) AS Fecha_Cita,
    DAY(Fecha_Cita) AS Dia,
    MONTH(Fecha_Cita) AS Mes,
    YEAR(Fecha_Cita) AS Año
FROM SaludPlus.dbo.Cita; 
GO
---select *from  vw_Fecha

-- Vista para Reputacion
USE DW_SaludPlus;
GO

CREATE VIEW vw_Reputacion AS
SELECT 
    S.ID_Satisfaccion,
    S.Calificacion_Satisfaccion,
    P.ID_Paciente
FROM 
    SaludPlus.dbo.Satisfaccion_Paciente S
JOIN 
    SaludPlus.dbo.Cita C ON S.ID_Cita = C.ID_Cita
JOIN 
    SaludPlus.dbo.Paciente P ON C.ID_Paciente = P.ID_Paciente;
GO
------------select *from  vw_Reputacion

-- Vista para Carga Medico
USE DW_SaludPlus;
GO

CREATE VIEW vw_CargaMedico AS
SELECT 
    ID_Medico,
    Fecha_Planificacion_Personal AS Fecha
FROM 
    SaludPlus.dbo.Medico_Planificacion_Recurso; 
GO
------------select *from  vw_CargaMedico



