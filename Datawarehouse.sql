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
    ID_Paciente INT PRIMARY KEY Clustered,
    Nombre_Paciente VARCHAR(50),
	Apellido1_Paciente VARCHAR(50),
	Apellido2_Paciente VARCHAR(50),
	Telefono_Paciente VARCHAR(12),
    Fecha_Nacimiento DATE,
    Direccion_Paciente VARCHAR(150),
    Cedula VARCHAR(12)
);
GO

USE DW_SaludPlus;
GO
CREATE TABLE DimMedico (
    ID_Medico INT PRIMARY KEY Clustered,
    Nombre1_Medico VARCHAR(50),
    Nombre2_Medico VARCHAR(50),
    Apellido1_Medico VARCHAR(50),
    Apellido2_Medico VARCHAR(50),
    Telefono_Medico VARCHAR(50),
    ID_Especialidad INT,
	Especialidad VARCHAR(50)
);
GO

USE DW_SaludPlus;
GO
CREATE TABLE DimEspecialidad (
    ID_Especialidad INT PRIMARY KEY Clustered,
    Nombre_Especialidad VARCHAR(50)
);
GO

USE DW_SaludPlus;
GO
CREATE TABLE DimSala (
    ID_Sala INT PRIMARY KEY Clustered,
    Nombre_Sala VARCHAR(50),
    Capacidad_Sala INT,
    ID_Tipo_Sala INT,
	Tipo_Sala VARCHAR(50)
);
GO
 

USE DW_SaludPlus;
GO
CREATE TABLE DimFecha (
    ID_Fecha INT PRIMARY KEY Clustered IDENTITY(1,1) ,
    Fecha DATE,
    Dia INT,
    Mes INT,
    Año INT,
    Trimestre INT,
    Nombre_Dia VARCHAR(20),
    Nombre_Mes VARCHAR(20)
);
 


USE DW_SaludPlus;
GO
CREATE TABLE DimRecursoMedico (
    ID_Recurso_Medico INT PRIMARY KEY Clustered,
    Nombre_Recurso VARCHAR(50),
    Lote VARCHAR(50),
    Cantidad_Stock_Total INT,
    Ubicacion_Recurso VARCHAR(150),
    Tipo_Recurso VARCHAR(50),
	Estado_Recurso_Medico VARCHAR(50)
);
GO

USE DW_SaludPlus;
GO
CREATE TABLE DimEstadoCita (
    ID_Estado_Cita INT PRIMARY KEY Clustered,
    Estado VARCHAR(50)
);
GO

USE DW_SaludPlus;
GO
CREATE TABLE DimTipoPago (
    ID_Tipo_Pago INT PRIMARY KEY Clustered,
    Descripcion_Tipo_Pago VARCHAR(50)
);
GO

USE DW_SaludPlus;
GO
CREATE TABLE DimProcedimiento (
    ID_Procedimiento INT PRIMARY KEY Clustered,
    Descripcion_Procedimiento VARCHAR(150),
    Monto_Procedimiento MONEY,
    ID_Tipo_Procedimiento INT,
	Tipo_Procedimiento VARCHAR(50)
);
GO

 


------- TABLAS DE HECHOS, ESTAS ALMACENAN EVENTOS Y contienen medidas numéricas 

---se puede obtener el número de citas por médico, especialidad, sala, y por día usando ID_Fecha
----------Se puede saber la carga del medico con las catidad de citas
USE DW_SaludPlus;
GO
CREATE TABLE Hecho_Cita (
    ID_Cita INT PRIMARY KEY Clustered,
    ID_Fecha INT,
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

USE DW_SaludPlus;
GO
CREATE TABLE Hecho_Satisfaccion_Paciente (
    ID_Satisfaccion INT PRIMARY KEY Clustered,
    ID_Fecha INT,
    ID_Cita INT,
    Calificacion INT CHECK (Calificacion BETWEEN 1 AND 5),
    FOREIGN KEY (ID_Cita) REFERENCES Hecho_Cita(ID_Cita),
	FOREIGN KEY (ID_Fecha) REFERENCES DimFecha(ID_Fecha)
);
GO

USE DW_SaludPlus;
GO
CREATE TABLE Hecho_Factura (
    ID_Factura INT PRIMARY KEY Clustered,
    ID_Fecha INT,
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

USE DW_SaludPlus;
GO
CREATE TABLE Hecho_Procedimiento (
    ID_Procedimiento INT PRIMARY KEY Clustered,
    ID_Fecha INT,
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

USE DW_SaludPlus;
GO
CREATE TABLE Hecho_Capacidad_Clinica (
    ID_Capacidad INT IDENTITY(1,1) PRIMARY KEY Clustered,
    ID_Fecha INT,
    ID_Sala INT,
    Capacidad_Disponible INT,
    FOREIGN KEY (ID_Sala) REFERENCES DimSala(ID_Sala),
    FOREIGN KEY (ID_Fecha) REFERENCES DimFecha(ID_Fecha)
);
GO

USE DW_SaludPlus;
GO
CREATE TABLE Hecho_Carga_Medico (
    ID_Capacidad INT IDENTITY(1,1) PRIMARY KEY Clustered,
    ID_Fecha INT,
    ID_Medico INT,
    Carga INT,
    FOREIGN KEY (ID_Medico) REFERENCES DimMedico(ID_Medico),
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
exec SP_CargarDimPaciente
--------SELECT TOP 10 * FROM DimPaciente;

USE DW_SaludPlus;
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
exec SP_CargarDimMedico
go
--------SELECT TOP 10 * FROM DimMedico;

USE DW_SaludPlus;
GO
CREATE PROCEDURE SP_CargarDimEspecialidad
AS
BEGIN
    INSERT INTO DimEspecialidad (ID_Especialidad, Nombre_Especialidad)
    SELECT ID_Especialidad, Nombre_Especialidad
    FROM SaludPlus.dbo.Especialidad;
END;
GO
exec SP_CargarDimEspecialidad
go
--------SELECT TOP 10 * FROM DimEspecialidad;


USE DW_SaludPlus;
GO
CREATE PROCEDURE SP_CargarDimSala
AS
BEGIN
    INSERT INTO DimSala (ID_Sala, Nombre_Sala, Capacidad_Sala, ID_Tipo_Sala, Tipo_Sala)
    SELECT 
        Sala.ID_Sala, 
        Sala.Nombre_Sala, 
        Sala.Capacidad_Sala, 
        Sala.ID_Tipo_Sala,
        Tipo_Sala.Descripcion_Tipo_Sala
    FROM SaludPlus.dbo.Sala Sala
    INNER JOIN SaludPlus.dbo.Tipo_Sala Tipo_Sala
     ON Sala.ID_Tipo_Sala = Tipo_Sala.ID_Tipo_Sala;
END;
GO
exec SP_CargarDimSala
go
--------SELECT TOP 10 * FROM DimSala;

USE DW_SaludPlus;
GO
CREATE PROCEDURE SP_CargarDimFecha
AS
BEGIN
    
	Declare @Fecha Date;

	Declare DimFechaCursor Cursor for
	Select Fecha_Cita from SaludPlus.dbo.Cita;

	Open DimFechaCursor

	fetch DimFechaCursor into @Fecha

	while(@@FETCH_STATUS = 0)
	Begin
		IF not exists (Select Fecha from DimFecha where Fecha = @Fecha)
		begin
			INSERT INTO DimFecha (Fecha, Dia, Mes, Año, Trimestre, Nombre_Dia, Nombre_Mes)
			SELECT DISTINCT 
				Fecha_Cita AS Fecha,
				DAY(Fecha_Cita) AS Dia,
				MONTH(Fecha_Cita) AS Mes,
				YEAR(Fecha_Cita) AS Año,
				DATEPART(QUARTER, Fecha_Cita) AS Trimestre,
				DATENAME(WEEKDAY, Fecha_Cita) AS Nombre_Dia,
				DATENAME(MONTH, Fecha_Cita) AS Nombre_Mes
			FROM SaludPlus.dbo.Cita
		end
		fetch DimFechaCursor into @Fecha
	End

	Close DimFechaCursor
	Deallocate DimFechaCursor

	Declare DimFechaCursor1 Cursor for
	Select Fecha_Evaluacion from SaludPlus.dbo.Satisfaccion_Paciente;


	Open DimFechaCursor1
	fetch DimFechaCursor1 into @Fecha

	While (@@FETCH_STATUS = 0)
	Begin
		IF not exists (Select Fecha from DimFecha where Fecha = @Fecha)
			INSERT INTO DimFecha (Fecha, Dia, Mes, Año, Trimestre, Nombre_Dia, Nombre_Mes)
			SELECT DISTINCT 
				Fecha_Evaluacion AS Fecha,
				DAY(Fecha_Evaluacion) AS Dia,
				MONTH(Fecha_Evaluacion) AS Mes,
				YEAR(Fecha_Evaluacion) AS Año,
				DATEPART(QUARTER, Fecha_Evaluacion) AS Trimestre,
				DATENAME(WEEKDAY, Fecha_Evaluacion) AS Nombre_Dia,
				DATENAME(MONTH, Fecha_Evaluacion) AS Nombre_Mes
			FROM SaludPlus.dbo.Satisfaccion_Paciente ;
		fetch DimFechaCursor1 into @Fecha
	End

	Close DimFechaCursor1
	Deallocate DimFechaCursor1

	Declare DimFechaCursor2 Cursor for
	Select Fecha_Factura from SaludPlus.dbo.Factura;

	Open DimFechaCursor2
	fetch DimFechaCursor2 into @Fecha

	While (@@FETCH_STATUS = 0)
	Begin
		IF not exists (Select Fecha from DimFecha where Fecha = @Fecha)
			INSERT INTO DimFecha (Fecha, Dia, Mes, Año, Trimestre, Nombre_Dia, Nombre_Mes)
			SELECT DISTINCT 
				Fecha_Factura AS Fecha,
				DAY(Fecha_Factura) AS Dia,
				MONTH(Fecha_Factura) AS Mes,
				YEAR(Fecha_Factura) AS Año,
				DATEPART(QUARTER, Fecha_Factura) AS Trimestre,
				DATENAME(WEEKDAY, Fecha_Factura) AS Nombre_Dia,
				DATENAME(MONTH, Fecha_Factura) AS Nombre_Mes
			FROM SaludPlus.dbo.Factura ;
		fetch DimFechaCursor2 into @Fecha
	End

	Close DimFechaCursor2
	Deallocate DimFechaCursor2
END;
GO
exec SP_CargarDimFecha
go
--------SELECT TOP 10 * FROM DimFecha;

USE DW_SaludPlus;
GO
CREATE PROCEDURE SP_CargarDimRecursoMedico
AS
BEGIN
    INSERT INTO DimRecursoMedico (ID_Recurso_Medico, Nombre_Recurso, Lote, Cantidad_Stock_Total, Ubicacion_Recurso, Tipo_Recurso, Estado_Recurso_Medico)
     SELECT 
        Recurso_Medico.ID_Recurso_Medico, 
        Recurso_Medico.Nombre_Recurso, 
        Recurso_Medico.Lote, 
        Recurso_Medico.Cantidad_Stock_Total,
        Recurso_Medico.Ubicacion_Recurso,
        Tipo_Recurso.Titulo_Recurso, 
        Estado_Recurso_Medico.Estado_Recurso
    FROM 
	SaludPlus.dbo.Recurso_Medico
    INNER JOIN 
        SaludPlus.dbo.Tipo_Recurso ON Recurso_Medico.ID_Tipo_Recurso = Tipo_Recurso.ID_Tipo_Recurso
    INNER JOIN 
        SaludPlus.dbo.Estado_Recurso_Medico ON Recurso_Medico.ID_Estado_Recurso_Medico = Estado_Recurso_Medico.ID_Estado_Recurso_Medico;
END;
GO
exec SP_CargarDimRecursoMedico
go
--------SELECT TOP 10 * FROM DimRecursoMedico;

USE DW_SaludPlus;
GO
CREATE PROCEDURE SP_CargarDimEstadoCita
AS
BEGIN
    INSERT INTO DimEstadoCita (ID_Estado_Cita, Estado)
    SELECT ID_Estado_Cita, Estado
    FROM SaludPlus.dbo.Estado_Cita;
END;
GO
exec SP_CargarDimEstadoCita
go
--------SELECT TOP 10 * FROM DimEstadoCita;

USE DW_SaludPlus;
GO
CREATE PROCEDURE SP_CargarDimTipoPago
AS
BEGIN
    INSERT INTO DimTipoPago (ID_Tipo_Pago, Descripcion_Tipo_Pago)
    SELECT ID_Tipo_Pago, Descripcion_Tipo_Pago
    FROM SaludPlus.dbo.Tipo_Pago;
END;
GO
exec SP_CargarDimTipoPago
go
--------SELECT TOP 10 * FROM DimTipoPago;

USE DW_SaludPlus;
GO
CREATE PROCEDURE SP_CargarDimProcedimiento
AS
BEGIN
    INSERT INTO DimProcedimiento (ID_Procedimiento, Descripcion_Procedimiento, Monto_Procedimiento, ID_Tipo_Procedimiento, Tipo_Procedimiento)
     SELECT 
        Procedimiento.ID_Procedimiento,
        Procedimiento.Descripcion_Procedimiento, 
        Procedimiento.Monto_Procedimiento, 
        Tipo_Procedimiento.ID_Tipo_Procedimiento, 
        Tipo_Procedimiento.Nombre_Procedimiento
    FROM 
        SaludPlus.dbo.Procedimiento
    INNER JOIN 
        SaludPlus.dbo.Tipo_Procedimiento ON Procedimiento.ID_Tipo_Procedimiento = Tipo_Procedimiento.ID_Tipo_Procedimiento;
END;
GO
exec SP_CargarDimProcedimiento
go
--------SELECT TOP 10 * FROM DimProcedimiento;


-- 1. Hecho_Cita  
USE DW_SaludPlus;
GO
CREATE PROCEDURE SP_CargarHechoCita
AS
BEGIN
    INSERT INTO Hecho_Cita (
        ID_Cita,ID_Fecha, Fecha, Hora, ID_Paciente, ID_Medico, ID_Especialidad, ID_Sala, 
        ID_Estado_Cita, Tiempo_Espera, Duracion_Consulta
    )
    SELECT 
        C.ID_Cita,
		F.ID_Fecha,
        C.Fecha_Cita AS Fecha,
        C.Hora_Cita,
        C.ID_Paciente,
        C.ID_Medico,
        M.ID_Especialidad,
        P.ID_Sala,
        C.ID_Estado_Cita,
        DATEDIFF(MINUTE, C.Hora_Cita, P.Hora_Procedimiento) AS Tiempo_Espera, 
		---Como no existe hora de finalizacion asume que son 60 siempre
        DATEDIFF(MINUTE, P.Hora_Procedimiento, DATEADD(HOUR, 1, P.Hora_Procedimiento)) AS Duracion_Consulta
    FROM SaludPlus.dbo.Cita C
    JOIN SaludPlus.dbo.Medico M ON C.ID_Medico = M.ID_Medico
    LEFT JOIN SaludPlus.dbo.Procedimiento P ON P.ID_Cita = C.ID_Cita
    JOIN DimFecha F ON C.Fecha_Cita = F.Fecha
    WHERE C.ID_Paciente IN (SELECT ID_Paciente FROM DimPaciente)
	AND NOT EXISTS (SELECT 1 FROM Hecho_Cita HC WHERE HC.ID_Cita = C.ID_Cita);
END;
GO
exec SP_CargarHechoCita
go
--------SELECT TOP 10 * FROM Hecho_Cita;


 

 
  

-- 2. Hecho_Satisfaccion_Paciente
USE DW_SaludPlus;
GO
CREATE PROCEDURE SP_CargarHechoSatisfaccionPaciente
AS
BEGIN
    INSERT INTO Hecho_Satisfaccion_Paciente (ID_Satisfaccion, ID_Fecha ,ID_Cita, Calificacion)
    SELECT 
        S.ID_Satisfaccion,
		F.ID_Fecha,
        S.ID_Cita,
        S.Calificacion_Satisfaccion AS Calificacion
    FROM SaludPlus.dbo.Satisfaccion_Paciente S JOIN DimFecha F ON F.Fecha = S.Fecha_Evaluacion;
END;
GO
exec SP_CargarHechoSatisfaccionPaciente
go
 --------SELECT TOP 10 * FROM Hecho_Satisfaccion_Paciente;



-- 3. Hecho_Factura
USE DW_SaludPlus;
GO
CREATE PROCEDURE SP_CargarHechoFactura
AS
BEGIN
    INSERT INTO Hecho_Factura (ID_Factura, ID_Fecha, Monto_Total, ID_Paciente, ID_Cita, ID_Tipo_Pago)
    SELECT 
        F.ID_Factura,
		H.ID_Fecha,
        F.Monto_Total,
        F.ID_Paciente,
        F.ID_Cita,
        F.ID_Tipo_Pago
    FROM SaludPlus.dbo.Factura F JOIN DimFecha H ON F.Fecha_Factura = H.Fecha;
END;
GO
exec SP_CargarHechoFactura
go
--------SELECT TOP 10 * FROM Hecho_Factura;


-- 4. Hecho_Procedimiento
USE DW_SaludPlus;
GO
 CREATE PROCEDURE SP_CargarHechoProcedimiento
AS
BEGIN
    INSERT INTO Hecho_Procedimiento (ID_Procedimiento,  Hora, Monto, ID_Sala, ID_Tipo_Procedimiento, ID_Cita)
    SELECT 
        P.ID_Procedimiento,
        P.Hora_Procedimiento AS Hora,
        P.Monto_Procedimiento AS Monto,
        P.ID_Sala,
        P.ID_Tipo_Procedimiento,
        P.ID_Cita
    FROM SaludPlus.dbo.Procedimiento P  JOIN DimFecha H ON P.Fecha_Procedimiento = H.Fecha;
END;
GO
exec SP_CargarHechoProcedimiento
go
--------SELECT TOP 10 * FROM Hecho_Procedimiento;

-- 5. Hecho_Capacidad_Clinica
USE DW_SaludPlus;
GO
CREATE PROCEDURE SP_CargarHechoCapacidadClinica
AS
BEGIN
    INSERT INTO Hecho_Capacidad_Clinica ( ID_Sala, ID_Fecha, Capacidad_Disponible)
    SELECT 
        --ROW_NUMBER() OVER (ORDER BY Fecha) AS ID_Capacidad,
        S.ID_Sala,
		H.ID_Fecha,
        Capacidad_Sala AS Capacidad_Disponible
    FROM SaludPlus.dbo.Planificacion_Recurso PR
    JOIN SaludPlus.dbo.Sala S ON PR.ID_Sala = S.ID_Sala JOIN DimFecha H ON PR.Fecha_Planificacion = H.Fecha;;
END;
GO
exec SP_CargarHechoCapacidadClinica
go


USE DW_SaludPlus;
GO
CREATE PROCEDURE SP_CargarCargaMedico
AS
BEGIN
    -- Inserta en Hecho_Carga_Medico si no existe un registro para esa combinación de ID_Fecha y ID_Medico
    INSERT INTO Hecho_Carga_Medico (ID_Fecha, ID_Medico, Carga)
    SELECT 
        H.ID_Fecha,
        PR.ID_Medico,
        COUNT(*) AS Carga -- Cuenta las citas o planificaciones para cada médico en cada fecha
    FROM SaludPlus.dbo.Medico PR
    JOIN SaludPlus.dbo.Medico_Planificacion_Recurso S ON PR.ID_Medico = S.ID_Medico
    JOIN SaludPlus.dbo.Cita C ON C.ID_Medico = PR.ID_Medico
    JOIN DimFecha H ON S.Fecha_Planificacion_Personal = H.Fecha OR C.Fecha_Cita = H.Fecha
    GROUP BY H.ID_Fecha, PR.ID_Medico
    HAVING NOT EXISTS (
        SELECT 1 
        FROM Hecho_Carga_Medico HCM
        WHERE HCM.ID_Fecha = H.ID_Fecha AND HCM.ID_Medico = PR.ID_Medico
    );
END;
GO
exec SP_CargarCargaMedico
go
--------SELECT TOP 10 * FROM Hecho_Capacidad_Clinica;





------PROCEDIMIENTO PARA VALIDAR LA CALIDAD DE LOS DATOS
USE DW_SaludPlus;
GO

CREATE PROCEDURE SP_ValidarCalidadDatos
AS
BEGIN
    DECLARE @ErrorMsg NVARCHAR(1000);

    -- 1. Validaci�n de NULLs en campos clave de cada tabla de hechos
    -- Validaci�n en Hecho_Cita
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

    
    PRINT 'Validaci�n de calidad de datos completada exitosamente. Todos los datos son consistentes.';
END;
GO

EXEC SP_ValidarCalidadDatos
Go

USE DW_SaludPlus;
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



----Calcula la satisfacci�n promedio por cita
USE DW_SaludPlus;
GO
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
-------SELECT dbo.FN_SatisfaccionPromedioPorCita(1) AS SatisfaccionPromedio;


----Calcula el tiempo promedio de espera por especialidad
USE DW_SaludPlus;
GO
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
-------SELECT dbo.FN_TiempoEsperaPromedioPorEspecialidad(1) AS SatisfaccionPromedio;


----Calcula citas por periodo
USE DW_SaludPlus;
GO
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
go
--EXEC SP_CantidadCitasPorPeriodo 'MES';




use DW_SaludPlus
go
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
--EXEC SP_UtilizacionRecursoPorSala;




use DW_SaludPlus
go
CREATE PROCEDURE SP_FacturacionPorMesYAño
AS
BEGIN
    SELECT DATEPART(YEAR, Fecha) AS Año, DATEPART(MONTH, Fecha) AS Mes, SUM(Monto_Total) AS Monto_Mensual
    FROM Hecho_Factura Join DimFecha on Hecho_Factura.ID_Factura = DimFecha.ID_Fecha
    GROUP BY DATEPART(YEAR, Fecha), DATEPART(MONTH, Fecha)
    ORDER BY Año, Mes;
END;
go

Exec SP_FacturacionPorMesYAño
Go


use DW_SaludPlus
go
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

SELECT dbo.FN_StockActualRecursoMedico(1) AS StockActual;
Go

/*
EXEC SP_CargarDWCompleto
Go
*/


------------------------------------vistas


-- Vista para Paciente
USE DW_SaludPlus;
GO
CREATE VIEW vw_Paciente AS
SELECT ID_Paciente, Nombre_Paciente, Apellido1_Paciente
FROM DimPaciente;
GO
 ---select *from  vw_Paciente
 

-- Vista para Medico
USE DW_SaludPlus;
GO
CREATE VIEW vw_Medico AS
SELECT ID_Medico, Nombre1_Medico, ID_Especialidad
FROM DimMedico;
GO
---select *from  vw_Medico

-- Vista para Fecha
USE DW_SaludPlus;
GO
CREATE VIEW vw_Fecha AS
SELECT DISTINCT
    CAST(Fecha AS DATE) AS Fecha_Cita,
    DAY(Fecha) AS Dia,
    MONTH(Fecha) AS Mes,
    YEAR(Fecha) AS Año
FROM DimFecha; 
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

