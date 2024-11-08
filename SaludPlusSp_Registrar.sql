--------------------------------------------------Procedimientos almacenados INSERT------------------------------
 ---------------------Registrar Paciente
USE SaludPlus
GO
CREATE OR ALTER PROCEDURE Sp_RegistrarPaciente
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
		@Fecha_Nacimiento, 
		TRIM(@Direccion_Paciente), 
		TRIM(@Cedula));

        PRINT 'El paciente se ha registrado correctamente.';

		DECLARE @Current_Usuario int = (Select ID_Paciente from Paciente Where Cedula = @Cedula)

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


------------------------------Registrar Especialidad
USE SaludPlus
GO
CREATE OR ALTER PROCEDURE Sp_RegistrarEspecialidad
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
CREATE OR ALTER PROCEDURE Sp_RegistrarMedico
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
CREATE OR ALTER PROCEDURE Sp_RegistrarEstado_Cita
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
CREATE OR ALTER PROCEDURE Sp_RegistrarCita
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
CREATE OR ALTER PROCEDURE Sp_RegistrarTipo_Pago
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
CREATE OR ALTER PROCEDURE Sp_RegistrarFactura
(
	@Fecha_Factura DATE,
    @Monto_Total MONEY,
    @Cedula VARCHAR(12),
    @ID_Cita INT,
	@Descripcion_Tipo_Pago VARCHAR(50)
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

	IF NOT EXISTS (SELECT 1 FROM Tipo_Pago WHERE Lower(Descripcion_Tipo_Pago) = Trim(Lower(@Descripcion_Tipo_Pago)))
    BEGIN
        RAISERROR('El tipo de pago no existe.', 16, 1);
        RETURN;
    END

	DECLARE @ID_Paciente int = (Select top 1 ID_Paciente from Paciente where Cedula like @Cedula)
	DECLARE @ID_Tipo_Pago int = (Select top 1 ID_Tipo_Pago from Tipo_Pago where Lower(Descripcion_Tipo_Pago) like Trim(Lower(@Descripcion_Tipo_Pago)))
		
        INSERT INTO Factura ( Fecha_Factura, Monto_Total, ID_Paciente, ID_Cita,ID_Tipo_Pago)
        VALUES ( @Fecha_Factura, @Monto_Total, @ID_Paciente, @ID_Cita,@ID_Tipo_Pago);

        PRINT 'La factura se ha registrado correctamente.'
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

--------------------Insertar Historial Medico
USE SaludPlus
GO
CREATE OR ALTER PROCEDURE Sp_RegistrarHistorial_Medico
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
		DECLARE @ErrorMessage NVARCHAR(4000);
    
		-- Capturar el mensaje de error del sistema
		SET @ErrorMessage = ERROR_MESSAGE();
    
		-- Lanzar un error
		RAISERROR (N'Error al registrar el historial médico: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO




 


-----------Insertar Estado de la Sala
USE SaludPlus
GO
CREATE OR ALTER PROCEDURE Sp_RegistrarEstado_Sala
(
   
    @Nombre VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
		-- Verificar si el nombre del estado de sala ya existe
		IF EXISTS (SELECT 1 FROM Estado_Sala WHERE Lower(Nombre) = Lower(@Nombre))
		BEGIN
			RAISERROR('El nombre del estado de sala ya existe.', 16, 1);
			RETURN;
		END
    
        INSERT INTO Estado_Sala (  Nombre)
        VALUES (  @Nombre);

        PRINT 'El estado de sala se ha registrado correctamente.';
    END TRY
    BEGIN CATCH

		DECLARE @ErrorMessage NVARCHAR(4000);
    
		-- Capturar el mensaje de error del sistema
		SET @ErrorMessage = ERROR_MESSAGE();
    
		-- Lanzar un error
		RAISERROR (N'Error al registrar el estado de sala: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO



------------------Registrar Tipo de Sala
USE SaludPlus
GO
CREATE OR ALTER PROCEDURE Sp_RegistrarTipo_Sala
(
    @Descripcion_Tipo_Sala VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
	-- Verificar si la descripci�n del tipo de sala ya existe
    IF EXISTS (SELECT 1 FROM Tipo_Sala WHERE Descripcion_Tipo_Sala = @Descripcion_Tipo_Sala)
    BEGIN
        RAISERROR('La descripción del tipo de sala ya existe.', 16, 1);
        RETURN;
    END
    
        INSERT INTO Tipo_Sala (  Descripcion_Tipo_Sala)
        VALUES (  @Descripcion_Tipo_Sala);

        PRINT 'El tipo de sala se ha registrado correctamente.';
    END TRY
    BEGIN CATCH

		DECLARE @ErrorMessage NVARCHAR(4000);
    
		-- Capturar el mensaje de error del sistema
		SET @ErrorMessage = ERROR_MESSAGE();
    
		-- Lanzar un error
		RAISERROR (N'Error al registrar el tipo de sala: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO



-------------------Insertar Sala  
Use SaludPlus
GO
CREATE OR ALTER PROCEDURE Sp_RegistrarSala
(
    @Nombre_Sala VARCHAR(50),
    @Capacidad_Sala INT,
    @Descripcion_Tipo_Sala VARCHAR(50),
    @Estado_Sala VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
		-- Verificar si el tipo y estado de sala existen
		IF NOT EXISTS (SELECT 1 FROM Tipo_Sala WHERE Descripcion_Tipo_Sala LIKE @Descripcion_Tipo_Sala)
		BEGIN
			RAISERROR('El tipo de sala no existe.', 16, 1);
			RETURN;
		END

		IF NOT EXISTS (SELECT 1 FROM Estado_Sala WHERE Nombre LIKE @Estado_Sala)
		BEGIN
			RAISERROR('El estado de sala no existe.', 16, 1);
			RETURN;
		END
		-- Verificar si el nombre de la sala ya existe
		IF EXISTS (SELECT 1 FROM Sala WHERE Nombre_Sala = @Nombre_Sala)
		BEGIN
			RAISERROR('El nombre de la sala ya existe.', 16, 1);
			RETURN;
		END
    
		DECLARE @ID_Tipo_Sala int = (Select top 1 ID_Tipo_Sala from Tipo_Sala where Descripcion_Tipo_Sala like @Descripcion_Tipo_Sala)
		DECLARE @ID_Estado_Sala int = (Select top 1 ID_Estado_Sala from Estado_Sala where Nombre like @Estado_Sala)



        INSERT INTO Sala (  Nombre_Sala, Capacidad_Sala, ID_Tipo_Sala, ID_Estado_Sala)
        VALUES (  @Nombre_Sala, @Capacidad_Sala, @ID_Tipo_Sala, @ID_Estado_Sala);

        PRINT 'La sala se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);
    
		-- Capturar el mensaje de error del sistema
		SET @ErrorMessage = ERROR_MESSAGE();
    
		-- Lanzar un error
		RAISERROR (N'Error al registrar la sala: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO




------------------Registrar Tipo de Procedimiento 
USE SaludPlus
GO
CREATE OR ALTER PROCEDURE Sp_RegistrarTipo_Procedimiento
(
    @Nombre_Procedimiento VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

	BEGIN TRY
	-- Verificar si el nombre del tipo de procedimiento ya existe
    IF EXISTS (SELECT 1 FROM Tipo_Procedimiento WHERE Nombre_Procedimiento = @Nombre_Procedimiento)
    BEGIN
        RAISERROR('El nombre del tipo de procedimiento ya existe.', 16, 1);
        RETURN;
    END
    
        INSERT INTO Tipo_Procedimiento (  Nombre_Procedimiento)
        VALUES (  @Nombre_Procedimiento);

        PRINT 'El tipo de procedimiento se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);
    
		-- Capturar el mensaje de error del sistema
		SET @ErrorMessage = ERROR_MESSAGE();
    
		-- Lanzar un error
		RAISERROR (N'Error al registrar el tipo de procedimiento: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO

---------------------Registrar Procedimiento
USE SaludPlus
GO
CREATE OR ALTER PROCEDURE Sp_RegistrarProcedimiento
(
    @Descripcion_Procedimiento VARCHAR(150),
    @Fecha_Procedimiento DATE,
    @Hora_Procedimiento TIME,
    @Monto_Procedimiento MONEY,
    @Receta VARCHAR(150),
    @Nombre_Sala VARCHAR(50),
    @ID_Historial_Medico INT,
    @ID_Cita INT,
    @Nombre_Procedimiento VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
		-- Verificaciones para ID_Sala, ID_Historial_Medico, ID_Cita y ID_Tipo_Procedimiento
		IF NOT EXISTS (SELECT 1 FROM Sala WHERE Nombre_Sala like @Nombre_Sala)
		BEGIN
			RAISERROR('La sala no existe.', 16, 1);
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

		IF NOT EXISTS (SELECT 1 FROM Tipo_Procedimiento WHERE Nombre_Procedimiento = @Nombre_Procedimiento)
		BEGIN
			RAISERROR('El tipo de procedimiento no existe.', 16, 1);
			RETURN;
		END

		DECLARE @ID_Sala int = (Select top 1 ID_Sala from Sala where Nombre_Sala like @Nombre_Sala)
		DECLARE @ID_Tipo_Procedimiento int = (Select top 1 ID_Tipo_Procedimiento from Tipo_Procedimiento where Nombre_Procedimiento like @Nombre_Procedimiento)

        INSERT INTO Procedimiento (  Descripcion_Procedimiento, Fecha_Procedimiento, Hora_Procedimiento, Monto_Procedimiento, Receta, ID_Sala, ID_Historial_Medico, ID_Cita, ID_Tipo_Procedimiento)
        VALUES (  @Descripcion_Procedimiento, @Fecha_Procedimiento, @Hora_Procedimiento, @Monto_Procedimiento, @Receta, @ID_Sala, @ID_Historial_Medico, @ID_Cita, @ID_Tipo_Procedimiento);

        PRINT 'El procedimiento se ha registrado correctamente.';
    END TRY
    BEGIN CATCH

		DECLARE @ErrorMessage NVARCHAR(4000);
    
		-- Capturar el mensaje de error del sistema
		SET @ErrorMessage = ERROR_MESSAGE();
    
		-- Lanzar un error
		RAISERROR (N'Error al registrar el procedimiento: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO



-------------Registrar Estado del Recurso Medico
USE SaludPlus
GO
CREATE OR ALTER PROCEDURE Sp_RegistrarEstado_Recurso_Medico
(
     
    @Estado_Recurso VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
    -- Verificar si el estado del recurso m�dico ya existe
    IF EXISTS (SELECT 1 FROM Estado_Recurso_Medico WHERE Estado_Recurso = @Estado_Recurso)
    BEGIN
        RAISERROR('El estado del recurso médico ya existe.', 16, 1);
        RETURN;
    END
        INSERT INTO Estado_Recurso_Medico (  Estado_Recurso)
        VALUES (  @Estado_Recurso);

        PRINT 'El estado de recurso médico se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);
    
		-- Capturar el mensaje de error del sistema
		SET @ErrorMessage = ERROR_MESSAGE();
    
		-- Lanzar un error
		RAISERROR (N'Error al registrar el estado de recurso médico: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO


--------------------Registrar Tipo de Recurso
USE SaludPlus
GO
CREATE OR ALTER PROCEDURE Sp_RegistrarTipo_Recurso
(
    @Titulo_Recurso VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
	-- Verificar si el tipo de recurso ya existe
    IF EXISTS (SELECT 1 FROM Tipo_Recurso WHERE Titulo_Recurso = @Titulo_Recurso)
    BEGIN
        RAISERROR('El tipo de recurso ya existe.', 16, 1);
        RETURN;
    END
    
        INSERT INTO Tipo_Recurso (  Titulo_Recurso)
        VALUES (  @Titulo_Recurso);

        PRINT 'El tipo de recurso se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);
    
		-- Capturar el mensaje de error del sistema
		SET @ErrorMessage = ERROR_MESSAGE();
    
		-- Lanzar un error
		RAISERROR (N'Error al registrar el tipo de recurso: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO



---------------Insertar Recurso Medico
USE SaludPlus
GO
CREATE OR ALTER PROCEDURE Sp_RegistrarRecurso_Medico
(
    @Nombre_Recurso VARCHAR(50),
    @Lote VARCHAR(50),
    @Cantidad_Stock_Total INT,
    @Ubicacion_Recurso VARCHAR(150),
    @Titulo_Recurso VARCHAR(50),
    @Estado_Recurso VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
    -- Verificar si el tipo de recurso y el estado existen
    IF NOT EXISTS (SELECT 1 FROM Tipo_Recurso WHERE Titulo_Recurso LIKE @Titulo_Recurso)
    BEGIN
        RAISERROR('El tipo de recurso no existe.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Estado_Recurso_Medico WHERE Estado_Recurso like @Estado_Recurso)
    BEGIN
        RAISERROR('El estado de recurso médico no existe.', 16, 1);
        RETURN;
    END

		DECLARE @ID_Tipo_Recurso int = (Select top 1 ID_Tipo_Recurso from Tipo_Recurso where Titulo_Recurso like @Titulo_Recurso)
		DECLARE @ID_Estado_Recurso_Medico int = (Select top 1 ID_Estado_Recurso_Medico from Estado_Recurso_Medico where Estado_Recurso like @Estado_Recurso)

        INSERT INTO Recurso_Medico (  Nombre_Recurso, Lote, Cantidad_Stock_Total, Ubicacion_Recurso, ID_Tipo_Recurso, ID_Estado_Recurso_Medico)
        VALUES (  @Nombre_Recurso, @Lote, @Cantidad_Stock_Total, @Ubicacion_Recurso, @ID_Tipo_Recurso, @ID_Estado_Recurso_Medico);

        PRINT 'El recurso médico se ha registrado correctamente.';
    END TRY
    BEGIN CATCH

		DECLARE @ErrorMessage NVARCHAR(4000);
    
		-- Capturar el mensaje de error del sistema
		SET @ErrorMessage = ERROR_MESSAGE();
    
		-- Lanzar un error
		RAISERROR (N'Error al registrar el recurso médico: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO


------------Insertar Recurso_Medico Sala

USE SaludPlus
GO
CREATE OR ALTER PROCEDURE Sp_RegistrarRecurso_Medico_Sala
(
    @Fecha DATE,
    @Cantidad_Recurso INT,
    @Lote varchar(50),
    @Nombre_Sala varchar(50)
)
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
    -- Verificar si el recurso m�dico existe
    IF NOT EXISTS (SELECT 1 FROM Recurso_Medico WHERE Lote like @Lote)
    BEGIN
        RAISERROR('El recurso médico no existe.', 16, 1);
        RETURN;
    END

    -- Verificar si la sala existe
    IF NOT EXISTS (SELECT 1 FROM Sala WHERE Nombre_Sala = @Nombre_Sala)
    BEGIN
        RAISERROR('La sala no existe.', 16, 1);
        RETURN;
    END

    Declare @ID_Recurso_Medico int = (SELECT ID_Recurso_Medico FROM Recurso_Medico WHERE Lote like @Lote)
	Declare @ID_Sala int = (SELECT ID_Sala FROM Sala WHERE Nombre_Sala like @Nombre_Sala)

        INSERT INTO Recurso_Medico_Sala (  Fecha, Cantidad_Recurso, ID_Recurso_Medico, ID_Sala)
        VALUES (  @Fecha, @Cantidad_Recurso, @ID_Recurso_Medico, @ID_Sala);

        PRINT 'El recurso médico en sala se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);
    
		-- Capturar el mensaje de error del sistema
		SET @ErrorMessage = ERROR_MESSAGE();
    
		-- Lanzar un error
		RAISERROR (N'Error al registrar el recurso médico en sala: %s', 16, 1, @ErrorMessage);

    END CATCH
END;
GO

------------- insertar Horario de trabajo
USE SaludPlus
GO
CREATE OR ALTER PROCEDURE Sp_RegistrarHorario_Trabajo
(
    @Nombre_Horario VARCHAR(50),
    @Hora_Inicio TIME,
    @Hora_Fin TIME
)
AS
BEGIN
    SET NOCOUNT ON;
	-- Validar que Hora_Fin no sea menor que Hora_Inicio
	BEGIN TRY
    IF @Hora_Fin < @Hora_Inicio
    BEGIN
        RAISERROR('La hora de fin no puede ser menor que la hora de inicio.', 16, 1);
        RETURN;
    END
    
        INSERT INTO Horario_Trabajo ( Nombre_Horario, Hora_Inicio, Hora_Fin)
        VALUES (  @Nombre_Horario, @Hora_Inicio, @Hora_Fin);

        PRINT 'El horario de trabajo se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);
		-- Capturar el mensaje de error del sistema
		SET @ErrorMessage = ERROR_MESSAGE();
    
		-- Lanzar un error
		RAISERROR (N'Error al registrar el horario de trabajo: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO

------------------------------Registrar Planificacion de Recurso
USE SaludPlus
GO
CREATE OR ALTER PROCEDURE Sp_RegistrarPlanificacion_Recurso
(
    @Descripcion_Planificacion VARCHAR(150),
    @Fecha_Planificacion DATE,
    @Nombre_Sala varchar(50),
    @Nombre_Horario varchar(50)
)
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY

    -- Verificar si la sala existe
    IF NOT EXISTS (SELECT 1 FROM Sala WHERE Nombre_Sala = @Nombre_Sala)
    BEGIN
        RAISERROR('La sala no existe.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Horario_Trabajo WHERE Nombre_Horario = @Nombre_Horario)
    BEGIN
        RAISERROR('El horario de trabajo no existe.', 16, 1);
        RETURN;
    END
		
		Declare @ID_Sala int = (SELECT ID_Sala FROM Sala WHERE Nombre_Sala like @Nombre_Sala)
		Declare @ID_Horario_Trabajo int = (SELECT ID_Horario_Trabajo FROM Horario_Trabajo WHERE Nombre_Horario like @Nombre_Horario)
    
        INSERT INTO Planificacion_Recurso (  Descripcion_Planificacion, Fecha_Planificacion, ID_Sala, ID_Horario_Trabajo)
        VALUES (  @Descripcion_Planificacion, @Fecha_Planificacion, @ID_Sala, @ID_Horario_Trabajo);

        PRINT 'La planificación de recurso se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);
		-- Capturar el mensaje de error del sistema
		SET @ErrorMessage = ERROR_MESSAGE();
    
		-- Lanzar un error
		RAISERROR (N'Error al registrar la planificación de recurso: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO

----------- insertar Medico Planificacion de Recursos
USE SaludPlus
GO
CREATE OR ALTER PROCEDURE Sp_RegistrarMedico_Planificacion_Recurso
(
     
    @Fecha_Planificacion_Personal DATE,
    @Descripcion_Planificacion varchar(150),
    @ID_Medico INT
)
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
    -- Verificar si el m�dico y la planificaci�n existen
    IF NOT EXISTS (SELECT 1 FROM Medico WHERE ID_Medico = @ID_Medico)
    BEGIN
        RAISERROR('El ID de médico no existe.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Planificacion_Recurso WHERE Descripcion_Planificacion = @Descripcion_Planificacion)
    BEGIN
        RAISERROR('El ID de planificación no existe.', 16, 1);
        RETURN;
    END
		
		Declare @ID_Planificacion int = (SELECT ID_Sala FROM Planificacion_Recurso WHERE Descripcion_Planificacion like @Descripcion_Planificacion)
    
        INSERT INTO Medico_Planificacion_Recurso (  Fecha_Planificacion_Personal, ID_Planificacion, ID_Medico)
        VALUES (  @Fecha_Planificacion_Personal, @ID_Planificacion, @ID_Medico);

        PRINT 'La planificación del médico se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);
		-- Capturar el mensaje de error del sistema
		SET @ErrorMessage = ERROR_MESSAGE();
    
		-- Lanzar un error
		RAISERROR (N'Error al registrar la planificación del médico: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO

---------Insertar Satiscaccion de Paciente
USE SaludPlus
GO
CREATE OR ALTER PROCEDURE Sp_RegistrarSatisfaccion_Paciente
(
     
    @Fecha_Evaluacion DATE,
    @Calificacion_Satisfaccion INT,
    @ID_Cita INT
)
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
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
    
        INSERT INTO Satisfaccion_Paciente (  Fecha_Evaluacion, Calificacion_Satisfaccion, ID_Cita)
        VALUES (  @Fecha_Evaluacion, @Calificacion_Satisfaccion, @ID_Cita);
		
        PRINT 'La satisfacción del paciente se ha registrado correctamente.';
    END TRY
    BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);
		-- Capturar el mensaje de error del sistema
		SET @ErrorMessage = ERROR_MESSAGE();
    
		-- Lanzar un error
		RAISERROR (N'Error al registrar la satisfacción del paciente: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO

-----------Insertar Rol
USE SaludPlus
GO
CREATE OR ALTER PROCEDURE Sp_RegistrarRol
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
CREATE OR ALTER PROCEDURE Sp_RegistrarUsuario
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

---------Registrar Permiso
USE SaludPlus
GO
CREATE OR ALTER PROCEDURE Sp_RegistrarPermiso
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

-----------Registrar Rol Permiso
USE SaludPlus
GO
CREATE OR ALTER PROCEDURE Sp_RegistrarRol_Permiso
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
