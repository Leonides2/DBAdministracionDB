USE master;
GO

CREATE DATABASE DW_SaludPlus 
ON PRIMARY
(
    NAME = 'DW_SaludPlus_Data',
    FILENAME = 'C:\SQL\Data\DW_SaludPlus_Data.mdf',
    SIZE = 2000MB,
    MAXSIZE = 5000MB,
    FILEGROWTH = 500MB
)
LOG ON
(
    NAME = 'DW_SaludPlus_Log',
    FILENAME = 'C:\SQL\Log\DW_SaludPlus_Log.ldf',
    SIZE = 1000MB,
    MAXSIZE = 2000MB,
    FILEGROWTH = 200MB
);
GO


------TABLAS DE DIMENSIONES, ESTAS CAPTURAN LOS ATRIBUTOS IMPORTANTES 
USE DW_SaludPlus;
GO
CREATE TABLE DimPaciente (
    ID_Paciente INT PRIMARY KEY,
    Nombre_Paciente VARCHAR(50),
	Apellido1_Paciente VARCHAR(50),
	Apellido2_Paciente VARCHAR(50),
	Telefono_Paciente VARCHAR(50),
    Fecha_Nacimiento DATE,
    Direccion_Paciente VARCHAR(150),
    Cedula VARCHAR(12)
);
GO

CREATE TABLE DimMedico (
    ID_Medico INT PRIMARY KEY,
    Nombre1_Medico VARCHAR(50),
    Nombre2_Medico VARCHAR(50),
    Apellido1_Medico VARCHAR(50),
    Apellido2_Medico VARCHAR(50),
    Telefono_Medico VARCHAR(50),
    ID_Especialidad INT,
	Especialidad VARCHAR(50)
);
GO

CREATE TABLE DimEspecialidad (
    ID_Especialidad INT PRIMARY KEY,
    Nombre_Especialidad VARCHAR(50)
);
GO

CREATE TABLE DimSala (
    ID_Sala INT PRIMARY KEY,
    Nombre_Sala VARCHAR(50),
    Capacidad_Sala INT,
    ID_Tipo_Sala INT
);
GO

CREATE TABLE DimFecha (
    ID_Fecha DATE PRIMARY KEY,
    Fecha DATE,
    Dia INT,
    Mes INT,
    Anio INT,
    Trimestre INT,
    Nombre_Dia VARCHAR(20),
    Nombre_Mes VARCHAR(20)
);
GO

CREATE TABLE DimRecursoMedico (
    ID_Recurso_Medico INT PRIMARY KEY,
    Nombre_Recurso VARCHAR(50),
    Lote VARCHAR(50),
    Cantidad_Stock_Total INT,
    Ubicacion_Recurso VARCHAR(150),
    ID_Tipo_Recurso INT,
	ID_Estado_Recurso_Medico INT
);
GO

CREATE TABLE DimEstadoCita (
    ID_Estado_Cita INT PRIMARY KEY,
    Estado VARCHAR(50)
);
GO

CREATE TABLE DimTipoPago (
    ID_Tipo_Pago INT PRIMARY KEY,
    Descripcion_Tipo_Pago VARCHAR(50)
);
GO
CREATE TABLE DimProcedimiento (
    ID_Procedimiento INT PRIMARY KEY,
    Descripcion_Procedimiento VARCHAR(150),
    Monto_Procedimiento MONEY,
    ID_Tipo_Procedimiento INT
);
GO
------- TABLAS DE HECHOS, ESTAS ALMACENAN EVENTOS O MÉTRICAS CUANTIFICABLES
CREATE TABLE Hecho_Cita (
    ID_Cita INT PRIMARY KEY,
    ID_Fecha DATE,
	Fecha Date,
    Hora TIME,
    ID_Paciente INT,
    ID_Medico INT,
    ID_Especialidad INT,
    ID_Sala INT,
    ID_Estado_Cita INT,
    Tiempo_Espera INT, 
    Duracion_Consulta INT, 
    FOREIGN KEY (ID_Paciente) REFERENCES DimPaciente(ID_Paciente),
    FOREIGN KEY (ID_Medico) REFERENCES DimMedico(ID_Medico),
    FOREIGN KEY (ID_Especialidad) REFERENCES DimEspecialidad(ID_Especialidad),
    FOREIGN KEY (ID_Sala) REFERENCES DimSala(ID_Sala),
    FOREIGN KEY (ID_Estado_Cita) REFERENCES DimEstadoCita(ID_Estado_Cita),
	FOREIGN KEY (ID_Fecha) REFERENCES DimFecha(ID_Fecha)
);
GO

CREATE TABLE Hecho_Satisfaccion_Paciente (
    ID_Satisfaccion INT PRIMARY KEY,
    ID_Fecha DATE,
    ID_Cita INT,
    Calificacion INT CHECK (Calificacion BETWEEN 1 AND 5),
    FOREIGN KEY (ID_Cita) REFERENCES Hecho_Cita(ID_Cita),
	FOREIGN KEY (ID_Fecha) REFERENCES DimFecha(ID_Fecha)
);
GO
CREATE TABLE Hecho_Factura (
    ID_Factura INT PRIMARY KEY,
    ID_Fecha DATE,
    Monto_Total MONEY,
    ID_Paciente INT,
    ID_Cita INT,
    ID_Tipo_Pago INT,
    FOREIGN KEY (ID_Paciente) REFERENCES DimPaciente(ID_Paciente),
    FOREIGN KEY (ID_Cita) REFERENCES Hecho_Cita(ID_Cita),
    FOREIGN KEY (ID_Tipo_Pago) REFERENCES DimTipoPago(ID_Tipo_Pago),
    FOREIGN KEY (ID_Fecha) REFERENCES DimFecha(ID_Fecha)
);
GO
CREATE TABLE Hecho_Procedimiento (
    ID_Procedimiento INT PRIMARY KEY,
    ID_Fecha DATE,
    Hora TIME,
    Monto MONEY,
    ID_Sala INT,
    ID_Tipo_Procedimiento INT,
	ID_Recurso_Medico INT,
    ID_Cita INT,
    FOREIGN KEY (ID_Sala) REFERENCES DimSala(ID_Sala),
    FOREIGN KEY (ID_Tipo_Procedimiento) REFERENCES DimProcedimiento(ID_Procedimiento),
    FOREIGN KEY (ID_Cita) REFERENCES Hecho_Cita(ID_Cita),
    FOREIGN KEY (ID_Fecha) REFERENCES DimFecha(ID_Fecha),
    FOREIGN KEY (ID_Recurso_Medico) REFERENCES DimRecursoMedico(ID_Recurso_Medico)
);
GO

CREATE TABLE Hecho_Capacidad_Clinica (
    ID_Capacidad INT PRIMARY KEY,
    ID_Fecha DATE,
    ID_Sala INT,
    Capacidad_Disponible INT,
    FOREIGN KEY (ID_Sala) REFERENCES DimSala(ID_Sala),
    FOREIGN KEY (ID_Fecha) REFERENCES DimFecha(ID_Fecha)
);
GO


----------ETL PROCEDIMIENTOS Y FUNCIONES


----PROCEDIMIENTOS DE CARGA EN LAS TABLAS
USE DW_SaludPlus;
GO


CREATE PROCEDURE SP_CargarDimPaciente
AS
BEGIN
    INSERT INTO DimPaciente (ID_Paciente, Nombre_Paciente, Apellido1_Paciente, Apellido2_Paciente, 
	Telefono_Paciente, Fecha_Nacimiento, Direccion_Paciente, Cedula)

    SELECT ID_Paciente, Nombre_Paciente, Apellido1_Paciente, Apellido2_Paciente, 
	Telefono_Paciente, Fecha_Nacimiento, Direccion_Paciente, Cedula

    FROM SaludPlus.dbo.Paciente;
END;
GO


CREATE PROCEDURE SP_CargarDimMedico
AS
BEGIN
    INSERT INTO DimMedico (ID_Medico, Nombre1_Medico, Nombre2_Medico, Apellido1_Medico, Apellido2_Medico, Telefono_Medico, ID_Especialidad, Especialidad)
    SELECT M.ID_Medico, M.Nombre1_Medico, M.Nombre2_Medico, M.Apellido1_Medico, M.Apellido2_Medico, M.Telefono_Medico, M.ID_Especialidad, E.Nombre_Especialidad
    FROM SaludPlus.dbo.Medico M
    JOIN SaludPlus.dbo.Especialidad E ON M.ID_Especialidad = E.ID_Especialidad;
END;
GO


CREATE PROCEDURE SP_CargarDimEspecialidad
AS
BEGIN
    INSERT INTO DimEspecialidad (ID_Especialidad, Nombre_Especialidad)
    SELECT ID_Especialidad, Nombre_Especialidad
    FROM SaludPlus.dbo.Especialidad;
END;
GO

CREATE PROCEDURE SP_CargarDimSala
AS
BEGIN
    INSERT INTO DimSala (ID_Sala, Nombre_Sala, Capacidad_Sala, ID_Tipo_Sala)
    SELECT ID_Sala, Nombre_Sala, Capacidad_Sala, ID_Tipo_Sala
    FROM SaludPlus.dbo.Sala;
END;
GO

CREATE PROCEDURE SP_CargarDimFecha
AS
BEGIN
    INSERT INTO DimFecha (ID_Fecha, Dia, Mes, Anio, Trimestre, Nombre_Dia, Nombre_Mes)
    SELECT DISTINCT 
        CAST(Fecha_Cita AS DATE) AS ID_Fecha,
        DAY(Fecha_Cita) AS Dia,
        MONTH(Fecha_Cita) AS Mes,
        YEAR(Fecha_Cita) AS Anio,
        DATEPART(QUARTER, Fecha_Cita) AS Trimestre,
        DATENAME(WEEKDAY, Fecha_Cita) AS Nombre_Dia,
        DATENAME(MONTH, Fecha_Cita) AS Nombre_Mes
    FROM SaludPlus.dbo.Cita;
END;
GO

CREATE PROCEDURE SP_CargarDimRecursoMedico
AS
BEGIN
    INSERT INTO DimRecursoMedico (ID_Recurso_Medico, Nombre_Recurso, Lote, Cantidad_Stock_Total, Ubicacion_Recurso, ID_Tipo_Recurso)
    SELECT ID_Recurso_Medico, Nombre_Recurso, Lote, Cantidad_Stock_Total, Ubicacion_Recurso, ID_Tipo_Recurso
    FROM SaludPlus.dbo.Recurso_Medico;
END;
GO

CREATE PROCEDURE SP_CargarDimEstadoCita
AS
BEGIN
    INSERT INTO DimEstadoCita (ID_Estado_Cita, Estado)
    SELECT ID_Estado_Cita, Estado
    FROM SaludPlus.dbo.Estado_Cita;
END;
GO

CREATE PROCEDURE SP_CargarDimTipoPago
AS
BEGIN
    INSERT INTO DimTipoPago (ID_Tipo_Pago, Descripcion_Tipo_Pago)
    SELECT ID_Tipo_Pago, Descripcion_Tipo_Pago
    FROM SaludPlus.dbo.Tipo_Pago;
END;
GO

CREATE PROCEDURE SP_CargarDimProcedimiento
AS
BEGIN
    INSERT INTO DimProcedimiento (ID_Procedimiento, Descripcion_Procedimiento, Monto_Procedimiento, ID_Tipo_Procedimiento)
    SELECT ID_Procedimiento, Descripcion_Procedimiento, Monto_Procedimiento, ID_Tipo_Procedimiento
    FROM SaludPlus.dbo.Procedimiento;
END;
GO


-- 1. Hecho_Cita
CREATE PROCEDURE SP_CargarHechoCita
AS
BEGIN
    INSERT INTO Hecho_Cita (
        ID_Cita, Hora, ID_Paciente, ID_Medico, ID_Especialidad, ID_Sala, 
        ID_Estado_Cita, Tiempo_Espera, Duracion_Consulta
    )
    SELECT 
        C.ID_Cita,
        --C.Fecha_Cita AS Fecha,
        C.Hora_Cita AS Hora,
        C.ID_Paciente,
        C.ID_Medico,
        M.ID_Especialidad,
        P.ID_Sala,
        C.ID_Estado_Cita,
        DATEDIFF(MINUTE, C.Hora_Cita, P.Hora_Procedimiento) AS Tiempo_Espera, 
        DATEDIFF(MINUTE, P.Hora_Procedimiento, DATEADD(HOUR, 1, P.Hora_Procedimiento)) AS Duracion_Consulta
    FROM SaludPlus.dbo.Cita C
    JOIN SaludPlus.dbo.Medico M ON C.ID_Medico = M.ID_Medico
    LEFT JOIN SaludPlus.dbo.Procedimiento P ON P.ID_Cita = C.ID_Cita;
END;
GO


-- 2. Hecho_Satisfaccion_Paciente
CREATE PROCEDURE SP_CargarHechoSatisfaccionPaciente
AS
BEGIN
    INSERT INTO Hecho_Satisfaccion_Paciente (ID_Satisfaccion, ID_Cita, Calificacion)
    SELECT 
        ID_Satisfaccion,
        --Fecha_Evaluacion AS Fecha,
        ID_Cita,
        Calificacion_Satisfaccion AS Calificacion
    FROM SaludPlus.dbo.Satisfaccion_Paciente;
END;
GO

-- 3. Hecho_Factura
CREATE PROCEDURE SP_CargarHechoFactura
AS
BEGIN
    INSERT INTO Hecho_Factura (ID_Factura, Monto_Total, ID_Paciente, ID_Cita, ID_Tipo_Pago)
    SELECT 
        F.ID_Factura,
        --F.Fecha_Factura AS Fecha,
        F.Monto_Total,
        F.ID_Paciente,
        F.ID_Cita,
        F.ID_Tipo_Pago
    FROM SaludPlus.dbo.Factura F;
END;
GO

-- 4. Hecho_Procedimiento
CREATE PROCEDURE SP_CargarHechoProcedimiento
AS
BEGIN
    INSERT INTO Hecho_Procedimiento (ID_Procedimiento,  Hora, Monto, ID_Sala, ID_Tipo_Procedimiento, ID_Cita)
    SELECT 
        P.ID_Procedimiento,
        --P.Fecha_Procedimiento AS Fecha,
        P.Hora_Procedimiento AS Hora,
        P.Monto_Procedimiento AS Monto,
        P.ID_Sala,
        P.ID_Tipo_Procedimiento,
        P.ID_Cita
    FROM SaludPlus.dbo.Procedimiento P;
END;
GO

-- 5. Hecho_Capacidad_Clinica
CREATE PROCEDURE SP_CargarHechoCapacidadClinica
AS
BEGIN
    INSERT INTO Hecho_Capacidad_Clinica ( ID_Sala, Capacidad_Disponible)
    SELECT 
        --ROW_NUMBER() OVER (ORDER BY Fecha) AS ID_Capacidad,
        S.ID_Sala,
        Capacidad_Sala AS Capacidad_Disponible
    FROM SaludPlus.dbo.Planificacion_Recurso PR
    JOIN SaludPlus.dbo.Sala S ON PR.ID_Sala = S.ID_Sala;
END;
GO



------PROCEDIMIENTO PARA VALIDAR LA CALIDAD DE LOS DATOS
USE DW_SaludPlus;
GO

CREATE PROCEDURE SP_ValidarCalidadDatos
AS
BEGIN
    DECLARE @ErrorMsg NVARCHAR(1000);

    -- 1. Validación de NULLs en campos clave de cada tabla de hechos
    -- Validación en Hecho_Cita
    IF EXISTS (SELECT 1 FROM Hecho_Cita WHERE ID_Paciente IS NULL OR ID_Medico IS NULL OR ID_Especialidad IS NULL OR ID_Sala IS NULL OR ID_Estado_Cita IS NULL)
    BEGIN
        SET @ErrorMsg = 'Error: Campos clave nulos en Hecho_Cita.';
        RAISERROR(@ErrorMsg, 16, 1);
        RETURN;
    END
   
    IF EXISTS (SELECT 1 FROM Hecho_Satisfaccion_Paciente WHERE ID_Cita IS NULL OR Calificacion IS NULL)
    BEGIN
        SET @ErrorMsg = 'Error: Campos clave nulos en Hecho_Satisfaccion_Paciente.';
        RAISERROR(@ErrorMsg, 16, 1);
        RETURN;
    END
    
    IF EXISTS (SELECT 1 FROM Hecho_Factura WHERE ID_Paciente IS NULL OR ID_Cita IS NULL OR ID_Tipo_Pago IS NULL)
    BEGIN
        SET @ErrorMsg = 'Error: Campos clave nulos en Hecho_Factura.';
        RAISERROR(@ErrorMsg, 16, 1);
        RETURN;
    END
    
    IF EXISTS (SELECT 1 FROM Hecho_Procedimiento WHERE ID_Sala IS NULL OR ID_Tipo_Procedimiento IS NULL OR ID_Cita IS NULL)
    BEGIN
        SET @ErrorMsg = 'Error: Campos clave nulos en Hecho_Procedimiento.';
        RAISERROR(@ErrorMsg, 16, 1);
        RETURN;
    END
   
    IF EXISTS (SELECT 1 FROM Hecho_Capacidad_Clinica WHERE ID_Sala IS NULL OR Capacidad_Disponible IS NULL)
    BEGIN
        SET @ErrorMsg = 'Error: Campos clave nulos en Hecho_Capacidad_Clinica.';
        RAISERROR(@ErrorMsg, 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Hecho_Cita H WHERE NOT EXISTS (SELECT 1 FROM DimPaciente D WHERE H.ID_Paciente = D.ID_Paciente))
    BEGIN
        SET @ErrorMsg = 'Error: Inconsistencias de Paciente entre Hecho_Cita y DimPaciente.';
        RAISERROR(@ErrorMsg, 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM Hecho_Cita H WHERE NOT EXISTS (SELECT 1 FROM DimMedico D WHERE H.ID_Medico = D.ID_Medico))
    BEGIN
        SET @ErrorMsg = 'Error: Inconsistencias de Medico entre Hecho_Cita y DimMedico.';
        RAISERROR(@ErrorMsg, 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM Hecho_Cita H WHERE NOT EXISTS (SELECT 1 FROM DimEspecialidad D WHERE H.ID_Especialidad = D.ID_Especialidad))
    BEGIN
        SET @ErrorMsg = 'Error: Inconsistencias de Especialidad entre Hecho_Cita y DimEspecialidad.';
        RAISERROR(@ErrorMsg, 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM Hecho_Cita H WHERE NOT EXISTS (SELECT 1 FROM DimSala D WHERE H.ID_Sala = D.ID_Sala))
    BEGIN
        SET @ErrorMsg = 'Error: Inconsistencias de Sala entre Hecho_Cita y DimSala.';
        RAISERROR(@ErrorMsg, 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM Hecho_Cita H WHERE NOT EXISTS (SELECT 1 FROM DimEstadoCita D WHERE H.ID_Estado_Cita = D.ID_Estado_Cita))
    BEGIN
        SET @ErrorMsg = 'Error: Inconsistencias de Estado de Cita entre Hecho_Cita y DimEstadoCita.';
        RAISERROR(@ErrorMsg, 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Hecho_Satisfaccion_Paciente H WHERE NOT EXISTS (SELECT 1 FROM Hecho_Cita C WHERE H.ID_Cita = C.ID_Cita))
    BEGIN
        SET @ErrorMsg = 'Error: Inconsistencias de Cita entre Hecho_Satisfaccion_Paciente y Hecho_Cita.';
        RAISERROR(@ErrorMsg, 16, 1);
        RETURN;
    END

    
    IF EXISTS (SELECT 1 FROM Hecho_Factura H WHERE NOT EXISTS (SELECT 1 FROM DimPaciente D WHERE H.ID_Paciente = D.ID_Paciente))
    BEGIN
        SET @ErrorMsg = 'Error: Inconsistencias de Paciente entre Hecho_Factura y DimPaciente.';
        RAISERROR(@ErrorMsg, 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM Hecho_Factura H WHERE NOT EXISTS (SELECT 1 FROM Hecho_Cita C WHERE H.ID_Cita = C.ID_Cita))
    BEGIN
        SET @ErrorMsg = 'Error: Inconsistencias de Cita entre Hecho_Factura y Hecho_Cita.';
        RAISERROR(@ErrorMsg, 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM Hecho_Factura H WHERE NOT EXISTS (SELECT 1 FROM DimTipoPago D WHERE H.ID_Tipo_Pago = D.ID_Tipo_Pago))
    BEGIN
        SET @ErrorMsg = 'Error: Inconsistencias de Tipo de Pago entre Hecho_Factura y DimTipoPago.';
        RAISERROR(@ErrorMsg, 16, 1);
        RETURN;
    END

    
    IF EXISTS (SELECT 1 FROM Hecho_Procedimiento H WHERE NOT EXISTS (SELECT 1 FROM DimSala D WHERE H.ID_Sala = D.ID_Sala))
    BEGIN
        SET @ErrorMsg = 'Error: Inconsistencias de Sala entre Hecho_Procedimiento y DimSala.';
        RAISERROR(@ErrorMsg, 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM Hecho_Procedimiento H WHERE NOT EXISTS (SELECT 1 FROM DimProcedimiento D WHERE H.ID_Tipo_Procedimiento = D.ID_Procedimiento))
    BEGIN
        SET @ErrorMsg = 'Error: Inconsistencias de Tipo de Procedimiento entre Hecho_Procedimiento y DimProcedimiento.';
        RAISERROR(@ErrorMsg, 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM Hecho_Procedimiento H WHERE NOT EXISTS (SELECT 1 FROM Hecho_Cita C WHERE H.ID_Cita = C.ID_Cita))
    BEGIN
        SET @ErrorMsg = 'Error: Inconsistencias de Cita entre Hecho_Procedimiento y Hecho_Cita.';
        RAISERROR(@ErrorMsg, 16, 1);
        RETURN;
    END

    
    IF EXISTS (SELECT 1 FROM Hecho_Capacidad_Clinica H WHERE NOT EXISTS (SELECT 1 FROM DimSala D WHERE H.ID_Sala = D.ID_Sala))
    BEGIN
        SET @ErrorMsg = 'Error: Inconsistencias de Sala entre Hecho_Capacidad_Clinica y DimSala.';
        RAISERROR(@ErrorMsg, 16, 1);
        RETURN;
    END

    
    PRINT 'Validación de calidad de datos completada exitosamente. Todos los datos son consistentes.';
END;
GO


CREATE PROCEDURE SP_CargarDWCompleto
AS
BEGIN
    
    EXEC SP_CargarDimPaciente;
    EXEC SP_CargarDimMedico;
    EXEC SP_CargarDimEspecialidad;
    EXEC SP_CargarDimSala;
    EXEC SP_CargarDimFecha;
    EXEC SP_CargarDimRecursoMedico;
	EXEC SP_CargarDimEstadoCita;
	EXEC SP_CargarDimTipoPago;
	EXEC SP_CargarDimProcedimiento;
    
    EXEC SP_CargarHechoCita;
    EXEC SP_CargarHechoSatisfaccionPaciente;
    EXEC SP_CargarHechoFactura;
    EXEC SP_CargarHechoProcedimiento;
    EXEC SP_CargarHechoCapacidadClinica;

    
    EXEC SP_ValidarCalidadDatos;

    PRINT 'Carga de Data Warehouse completada exitosamente.';
END;
GO



----Calcula la satisfacción promedio por cita
CREATE FUNCTION FN_SatisfaccionPromedioPorCita (@ID_Cita INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    RETURN (
        SELECT AVG(CAST(Calificacion AS DECIMAL(5,2)))
        FROM Hecho_Satisfaccion_Paciente
        WHERE ID_Cita = @ID_Cita
    );
END;
Go

----Calcula el tiempo promedio de espera por especialidad
CREATE FUNCTION FN_TiempoEsperaPromedioPorEspecialidad(@ID_Especialidad INT)
RETURNS INT
AS
BEGIN
    DECLARE @promedio INT;
    SELECT @promedio = AVG(Tiempo_Espera)
    FROM Hecho_Cita
    WHERE ID_Especialidad = @ID_Especialidad;
    RETURN @promedio;
END;
GO
/*
----Calcula citas por periodo
CREATE PROCEDURE SP_CantidadCitasPorPeriodo (@Periodo VARCHAR(10))
AS
BEGIN
    IF @Periodo = 'DIA'
        SELECT Fecha, COUNT(*) AS Cantidad_Citas FROM Hecho_Cita GROUP BY Fecha;
    ELSE IF @Periodo = 'SEMANA'
        SELECT DATEPART(WEEK, Fecha) AS Semana, COUNT(*) AS Cantidad_Citas FROM Hecho_Cita GROUP BY DATEPART(WEEK, Fecha);
    ELSE IF @Periodo = 'MES'
        SELECT DATEPART(MONTH, Fecha) AS Mes, COUNT(*) AS Cantidad_Citas FROM Hecho_Cita GROUP BY DATEPART(MONTH, Fecha);
END;
*/
CREATE PROCEDURE SP_UtilizacionRecursoPorSala
AS
BEGIN
    SELECT S.Nombre_Sala, RM.Nombre_Recurso, COUNT(*) AS Cantidad_Usos
    FROM DimSala S
    JOIN Hecho_Procedimiento P ON P.ID_Sala = S.ID_Sala
    JOIN DimRecursoMedico RM ON RM.ID_Recurso_Medico = P.ID_Procedimiento
    GROUP BY S.Nombre_Sala, RM.Nombre_Recurso;
END;
GO
/*
CREATE PROCEDURE SP_FacturacionPorMesYAno
AS
BEGIN
    SELECT DATEPART(YEAR, Fecha) AS Año, DATEPART(MONTH, Fecha) AS Mes, SUM(Monto_Total) AS Monto_Mensual
    FROM Hecho_Factura
    GROUP BY DATEPART(YEAR, Fecha), DATEPART(MONTH, Fecha)
    ORDER BY Año, Mes;
END;
*/
CREATE FUNCTION FN_StockActualRecursoMedico(@ID_Recurso_Medico INT)
RETURNS INT
AS
BEGIN
    DECLARE @stock INT;
    SELECT @stock = SUM(Cantidad_Stock_Total)
    FROM DimRecursoMedico
    WHERE ID_Recurso_Medico = @ID_Recurso_Medico;
    RETURN ISNULL(@stock, 0);
END;
GO

-----indices para mejorar el redimiento de las consultas
-- Hecho_Cita
CREATE INDEX IX_Hecho_Cita_Paciente ON Hecho_Cita (ID_Paciente);
CREATE INDEX IX_Hecho_Cita_Medico ON Hecho_Cita (ID_Medico);
CREATE INDEX IX_Hecho_Cita_Especialidad ON Hecho_Cita (ID_Especialidad);
CREATE INDEX IX_Hecho_Cita_Sala ON Hecho_Cita (ID_Sala);
CREATE INDEX IX_Hecho_Cita_Fecha ON Hecho_Cita (ID_Fecha);

-- Hecho_Factura
CREATE INDEX IX_Hecho_Factura_Paciente ON Hecho_Factura (ID_Paciente);
CREATE INDEX IX_Hecho_Factura_TipoPago ON Hecho_Factura (ID_Tipo_Pago);
CREATE INDEX IX_Hecho_Factura_Fecha ON Hecho_Factura (ID_Fecha);

-- Hecho_Procedimiento
CREATE INDEX IX_Hecho_Procedimiento_Sala ON Hecho_Procedimiento (ID_Sala);
CREATE INDEX IX_Hecho_Procedimiento_TipoProcedimiento ON Hecho_Procedimiento (ID_Tipo_Procedimiento);
CREATE INDEX IX_Hecho_Procedimiento_Fecha ON Hecho_Procedimiento (ID_Fecha);

-- Hecho_Satisfaccion_Paciente
CREATE INDEX IX_Hecho_Satisfaccion_Cita ON Hecho_Satisfaccion_Paciente (ID_Cita);
CREATE INDEX IX_Hecho_Satisfaccion_Fecha ON Hecho_Satisfaccion_Paciente (ID_Fecha);
GO


EXEC SP_CargarDWCompleto
Go


/*



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



*/