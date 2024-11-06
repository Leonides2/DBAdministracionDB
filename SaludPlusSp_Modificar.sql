-- Procedimientos de UPDATE 
-- Modificar Paciente

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
    @Nombre_Especialidad VARCHAR(50) = NULL
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
        IF @Nombre_Especialidad IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Especialidad WHERE Nombre_Especialidad = @Nombre_Especialidad)
        BEGIN
            RAISERROR('La especialidad "%s" no existe.', 16, 1, @Nombre_Especialidad);
            RETURN;
        END

        DECLARE @ID_Especialidad INT;
        SET @ID_Especialidad = (SELECT ID_Especialidad FROM Especialidad WHERE Nombre_Especialidad = @Nombre_Especialidad);

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
    @ID_Medico INT = NULL,
    @Estado varchar(50) = NULL,
    @Cedula VARCHAR(12) = NULL
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
        IF @Cedula IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Paciente WHERE Cedula = @Cedula)
        BEGIN
            RAISERROR('El paciente con Cedula %s no existe.', 16, 2, @Cedula);
            RETURN;
        END

        -- Validar que el ID_Medico exista si es proporcionado
        IF @ID_Medico IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Medico WHERE ID_Medico = @ID_Medico)
        BEGIN
            RAISERROR('El médico con ID %d no existe.', 16, 2, @ID_Medico);
            RETURN;
        END

        -- Validar que el ID_Estado_Cita exista si es proporcionado
        IF @Estado IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Estado_Cita WHERE Estado = @Estado)
        BEGIN
            RAISERROR('El estado de cita "%s" no existe.', 16, 2, @Estado);
            RETURN;
        END

        -- Validar que no haya citas duplicadas para el paciente en la misma fecha y hora
        IF @Cedula IS NOT NULL AND @Fecha_Cita IS NOT NULL AND @Hora_Cita IS NOT NULL
        BEGIN
            DECLARE @ID_Paciente INT;
            SET @ID_Paciente = (SELECT ID_Paciente FROM Paciente WHERE Cedula = @Cedula);

            IF EXISTS (SELECT 1 FROM Cita 
                    WHERE ID_Paciente = @ID_Paciente 
                    AND Fecha_Cita = @Fecha_Cita 
                    AND Hora_Cita = @Hora_Cita
                    AND ID_Cita != @ID_Cita
            ) 
            BEGIN
                RAISERROR('El paciente ya tiene una cita programada a la misma fecha y hora.', 16, 3);
                RETURN;
            END
        END

        -- Realizar la actualización
        DECLARE @ID_Estado_Cita INT;

        SET @ID_Estado_Cita = (SELECT ID_Estado_Cita FROM Estado_Cita WHERE Estado = @Estado);

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

CREATE OR ALTER PROCEDURE Sp_ModificarFactura
(
    @ID_Factura INT,
    @Fecha_Factura DATE = NULL,
    @Monto_Total MONEY = NULL,
    @Cedula varchar(12) = NULL,
    @ID_Cita INT = NULL,
    @Descripcion_Tipo_Pago varchar(50) = NULL
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
        IF @Cedula IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Paciente WHERE Cedula = @Cedula)
        BEGIN
            RAISERROR('El paciente con cédula %s no existe.', 16, 1, @Cedula);
            RETURN;
        END

        -- Verificar si la cita existe
        IF @ID_Cita IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Cita WHERE ID_Cita = @ID_Cita)
        BEGIN
            RAISERROR('La cita con ID %d no existe.', 16, 1, @ID_Cita);
            RETURN;
        END

        -- Verificar si el tipo de pago existe
        IF @Descripcion_Tipo_Pago IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Tipo_Pago WHERE Descripcion_Tipo_Pago = @Descripcion_Tipo_Pago)
        BEGIN
            RAISERROR('El tipo de pago "%s" no existe.', 16, 1, @Descripcion_Tipo_Pago);
            RETURN;
        END

        -- Actualizar la factura solo si el ID es válido
        DECLARE @ID_Tipo_Pago INT;
        DECLARE @ID_Paciente INT;

        SET @ID_Tipo_Pago = (SELECT ID_Tipo_Pago FROM Tipo_Pago WHERE Descripcion_Tipo_Pago = @Descripcion_Tipo_Pago);
        SET @ID_Paciente = (SELECT ID_Paciente FROM Paciente WHERE Cedula = @Cedula);

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
    @Cedula varchar(12) = NULL
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
        IF @Cedula IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Paciente WHERE Cedula = @Cedula)
        BEGIN
            RAISERROR('El paciente con cédula %s no existe.', 16, 1, @Cedula);
            RETURN;
        END

        -- Actualizar el historial médico solo si se proporciona un valor válido para Fecha_Registro
        DECLARE @ID_Paciente INT;
        SET @ID_Paciente = (SELECT ID_Paciente FROM Paciente WHERE Cedula = @Cedula);

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
    @Descripcion_Tipo_Sala varchar(50) = NULL,         
    @Estado_Sala varchar(50) = NULL        
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
        IF @Descripcion_Tipo_Sala IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Tipo_Sala WHERE Descripcion_Tipo_Sala = @Descripcion_Tipo_Sala)
        BEGIN
            RAISERROR('El de tipo de sala "%s" no existe.', 16, 2, @Descripcion_Tipo_Sala);
            RETURN;
        END

        -- Verificar que el ID_Estado_Sala existe si es proporcionado
        IF @Estado_Sala IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Estado_Sala WHERE Nombre = @Estado_Sala)
        BEGIN
            RAISERROR('El estado de sala "%s" no existe.', 16, 3, @Estado_Sala);
            RETURN;
        END

        -- Verificar que el nombre de la sala no exista ya para otro ID_Sala
        IF @Nombre_Sala IS NOT NULL AND EXISTS (SELECT 1 FROM Sala WHERE Nombre_Sala = @Nombre_Sala AND ID_Sala <> @ID_Sala)
        BEGIN
            RAISERROR('El nombre de la sala "%s" ya existe en otro registro de sala.', 16, 4, @Nombre_Sala);
            RETURN;
        END

        -- Realizar la actualización solo si es necesario (si los valores son nuevos)
        DECLARE @ID_Estado_Sala INT;
        DECLARE @ID_Tipo_Sala INT;

        SET @ID_Tipo_Sala = (SELECT ID_Tipo_Sala FROM Tipo_Sala WHERE Descripcion_Tipo_Sala = @Descripcion_Tipo_Sala);
        SET @ID_Estado_Sala = (SELECT ID_Estado_Sala FROM Estado_Sala WHERE Nombre = @Estado_Sala);

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

CREATE OR ALTER PROCEDURE Sp_ModificarTipo_Procedimiento
(
    @ID_Tipo_Procedimiento INT,
    @Nombre_Procedimiento VARCHAR(50)
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
        IF EXISTS (SELECT 1 FROM Tipo_Procedimiento WHERE Nombre_Procedimiento = @Nombre_Procedimiento AND ID_Tipo_Procedimiento <> @ID_Tipo_Procedimiento)
        BEGIN
            RAISERROR('El nombre del tipo de procedimiento "%s" ya existe en otro registro.', 16, 2, @Nombre_Procedimiento);
            RETURN;
        END

        -- Realizar la actualización
        UPDATE Tipo_Procedimiento
        SET Nombre_Procedimiento = @Nombre_Procedimiento
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

CREATE OR ALTER PROCEDURE Sp_ModificarEstado_Recurso_Medico
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

CREATE OR ALTER PROCEDURE Sp_ModificarTipo_Recurso
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

CREATE OR ALTER PROCEDURE Sp_ModificarRecurso_Medico
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

CREATE OR ALTER PROCEDURE Sp_ModificarRecurso_Medico_Sala
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

CREATE OR ALTER PROCEDURE Sp_ModificarHorario_Trabajo
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

CREATE OR ALTER PROCEDURE Sp_ModificarPlanificacion_Recurso
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

CREATE OR ALTER PROCEDURE Sp_ModificarMedico_Planificacion_Recurso
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

CREATE OR ALTER PROCEDURE Sp_ModificarSatisfaccion_Paciente
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

CREATE OR ALTER PROCEDURE Sp_ModificarRol_Permiso
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
