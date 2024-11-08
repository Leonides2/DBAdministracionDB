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
			RAISERROR('No existe la relación Rol-Permiso con ID_Rol_Permiso = %d', 16, 1, @ID_Rol_Permiso)
			RETURN
		END

		DELETE FROM Rol_Permiso WHERE ID_Rol_Permiso = @ID_Rol_Permiso
	END TRY
	BEGIN CATCH
		DECLARE @ERROR NVARCHAR(1000)

		SET @ERROR = ERROR_MESSAGE()

		RAISERROR(N'%s', 16, 1, @ERROR);
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
            RAISERROR('No existe el Usuario con ID_Usuario = %d', 16, 1, @ID_Usuario)
            RETURN
        END

        DELETE FROM Usuario WHERE ID_Usuario = @ID_Usuario
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'%s', 16, 1, @ERROR);
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
            RAISERROR('No existe el Rol con ID_Rol = %d', 16, 1, @ID_Rol)
            RETURN
        END

        IF EXISTS (SELECT 1 FROM Usuario WHERE ID_Rol = @ID_Rol) OR
           EXISTS (SELECT 1 FROM Rol_Permiso WHERE ID_Rol = @ID_Rol)
        BEGIN
            RAISERROR('No se puede eliminar el Rol. Existen usuarios o permisos asociados.', 16, 1)
            RETURN
        END

        DELETE FROM Rol WHERE ID_Rol = @ID_Rol
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'%s', 16, 1, @ERROR);
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
            RAISERROR('No existe el Permiso con ID_Permiso = %d', 16, 1, @ID_Permiso)
            RETURN
        END

        IF EXISTS (SELECT 1 FROM Rol_Permiso WHERE ID_Permiso = @ID_Permiso)
        BEGIN
            RAISERROR('No se puede eliminar el Permiso, tiene roles asociados.', 16, 1)
            RETURN
        END

        DELETE FROM Permiso WHERE ID_Permiso = @ID_Permiso
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'%s', 16, 1, @ERROR);
        PRINT @ERROR
    END CATCH
END
GO
-----------------------Eliminar satisfaccion Paciente
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE Sp_EliminarSatisfaccion_Paciente
    @ID_Satisfaccion INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Satisfaccion_Paciente WHERE ID_Satisfaccion = @ID_Satisfaccion)
        BEGIN
            RAISERROR('No existe la Satisfacción del Paciente con ID_Satisfaccion = %d', 16, 1, @ID_Satisfaccion)
            RETURN
        END

        IF EXISTS (SELECT 1 FROM Satisfaccion_Paciente WHERE ID_Cita = @ID_Satisfaccion)
        BEGIN
            RAISERROR('No se puede eliminar la Satisfacción del Paciente con ID_Satisfaccion = %d porque tiene citas asociadas.', 16, 1, @ID_Satisfaccion)
            RETURN
        END

        DELETE FROM Satisfaccion_Paciente WHERE ID_Satisfaccion = @ID_Satisfaccion
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'%s', 16, 1, @ERROR);
        PRINT @ERROR
    END CATCH
END
GO

------------------ Procedimiento para eliminar Medico_Planificacion_RecursoUse SaludPlus
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarMedico_Planificacion_Recurso
    @ID_Medico_Planificacion_Recurso INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Medico_Planificacion_Recurso WHERE ID_Medico_Planificacion_Recurso = @ID_Medico_Planificacion_Recurso)
        BEGIN
            RAISERROR('No existe la planificación de recurso médico con ID_Medico_Planificacion_Recurso = %d', 16, 1, @ID_Medico_Planificacion_Recurso)
            RETURN
        END

        DELETE FROM Medico_Planificacion_Recurso WHERE ID_Medico_Planificacion_Recurso = @ID_Medico_Planificacion_Recurso
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'%s', 16, 1, @ERROR);
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
            RAISERROR('No existe el Paciente con ID_Paciente = %d', 16, 1, @ID_Paciente)
            RETURN
        END

        IF EXISTS (SELECT 1 FROM Historial_Medico WHERE ID_Paciente = @ID_Paciente)
        BEGIN
            RAISERROR('No se puede eliminar el Paciente, tiene historial médico asociado.', 16, 1)
            RETURN
        END

        IF EXISTS (SELECT 1 FROM Cita WHERE ID_Paciente = @ID_Paciente)
        BEGIN
            RAISERROR('No se puede eliminar el Paciente, tiene citas asociadas.', 16, 1)
            RETURN
        END

        IF EXISTS (SELECT 1 FROM Factura WHERE ID_Paciente = @ID_Paciente)
        BEGIN
            RAISERROR('No se puede eliminar el Paciente, tiene facturas asociadas.', 16, 1)
            RETURN
        END

        DELETE FROM Paciente WHERE ID_Paciente = @ID_Paciente
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'%s', 16, 1, @ERROR);
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
            RAISERROR('No existe la Cita con ID_Cita = %d', 16, 1, @ID_Cita)
            RETURN
        END

        IF EXISTS (SELECT 1 FROM Factura WHERE ID_Cita = @ID_Cita)
        BEGIN
            RAISERROR('No se puede eliminar la Cita, tiene facturas asociadas.', 16, 1)
            RETURN
        END

        IF EXISTS (SELECT 1 FROM Satisfaccion_Paciente WHERE ID_Cita = @ID_Cita)
        BEGIN
            RAISERROR('No se puede eliminar la Cita, tiene satisfacción asociada.', 16, 1)
            RETURN
        END

        DELETE FROM Cita WHERE ID_Cita = @ID_Cita
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'%s', 16, 1, @ERROR);
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
            RAISERROR('No existe el Estado de Cita con ID_Estado_Cita = %d', 16, 1, @ID_Estado_Cita)
            RETURN
        END

        IF EXISTS (SELECT 1 FROM Cita WHERE ID_Estado_Cita = @ID_Estado_Cita)
        BEGIN
            RAISERROR('No se puede eliminar el Estado de Cita, hay citas asociadas.', 16, 1)
            RETURN
        END

        DELETE FROM Estado_Cita WHERE ID_Estado_Cita = @ID_Estado_Cita
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'%s', 16, 1, @ERROR);
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
            RAISERROR('No existe la Factura con ID_Factura = %d', 16, 1, @ID_Factura)
            RETURN
        END

        DELETE FROM Factura WHERE ID_Factura = @ID_Factura
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'%s', 16, 1, @ERROR);
        PRINT @ERROR
    END CATCH
END
GO
---------------- Procedimiento para eliminar Tipo_Pago
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarTipo_Pago
    @ID_Tipo_Pago INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Tipo_Pago WHERE ID_Tipo_Pago = @ID_Tipo_Pago)
        BEGIN
            RAISERROR('No existe el Tipo de Pago con ID_Tipo_Pago = %d', 16, 1, @ID_Tipo_Pago)
            RETURN
        END

        IF EXISTS (SELECT 1 FROM Factura WHERE ID_Tipo_Pago = @ID_Tipo_Pago)
        BEGIN
            RAISERROR('No se puede eliminar el Tipo de Pago, tiene facturas asociadas.', 16, 1)
            RETURN
        END

        DELETE FROM Tipo_Pago WHERE ID_Tipo_Pago = @ID_Tipo_Pago
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'%s', 16, 1, @ERROR);
        PRINT @ERROR
    END CATCH
END
GO

------------------------- Procedimiento para eliminar Tipo_Procedimiento

USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarTipo_Procedimiento
    @ID_Tipo_Procedimiento INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Tipo_Procedimiento WHERE ID_Tipo_Procedimiento = @ID_Tipo_Procedimiento)
        BEGIN
            RAISERROR('No existe el Tipo de Procedimiento con ID_Tipo_Procedimiento = %d', 16, 1, @ID_Tipo_Procedimiento)
            RETURN
        END

        IF EXISTS (SELECT 1 FROM Procedimiento WHERE ID_Tipo_Procedimiento = @ID_Tipo_Procedimiento)
        BEGIN
            RAISERROR('No se puede eliminar el Tipo de Procedimiento, tiene procedimientos asociados.', 16, 1)
            RETURN
        END

        DELETE FROM Tipo_Procedimiento WHERE ID_Tipo_Procedimiento = @ID_Tipo_Procedimiento
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'%s', 16, 1, @ERROR);
        PRINT @ERROR
    END CATCH
END
GO
------------------------- Procedimiento para eliminar Historial_Medico
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarHistorial_Medico
    @ID_Historial_Medico INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Historial_Medico WHERE ID_Historial_Medico = @ID_Historial_Medico)
        BEGIN
            RAISERROR('No existe el Historial Médico con ID_Historial_Medico = %d', 16, 1, @ID_Historial_Medico)
            RETURN
        END

        IF EXISTS (SELECT 1 FROM Procedimiento WHERE ID_Historial_Medico = @ID_Historial_Medico)
        BEGIN
            RAISERROR('No se puede eliminar el Historial Médico, tiene procedimientos asociados.', 16, 1)
            RETURN
        END

        DELETE FROM Historial_Medico WHERE ID_Historial_Medico = @ID_Historial_Medico
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'%s', 16, 1, @ERROR);
        PRINT @ERROR
    END CATCH
END
GO
------------------------- Procedimiento para eliminar Recurso_Medico
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarRecurso_Medico
    @ID_Recurso_Medico INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Recurso_Medico WHERE ID_Recurso_Medico = @ID_Recurso_Medico)
        BEGIN
            RAISERROR('No existe el Recurso Médico con ID_Recurso_Medico = %d', 16, 1, @ID_Recurso_Medico)
            RETURN
        END

        IF EXISTS (SELECT 1 FROM Recurso_Medico_Sala WHERE ID_Recurso_Medico = @ID_Recurso_Medico)
        BEGIN
            RAISERROR('No se puede eliminar el Recurso Médico, tiene asignaciones a salas.', 16, 1)
            RETURN
        END

        DELETE FROM Recurso_Medico WHERE ID_Recurso_Medico = @ID_Recurso_Medico
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'%s', 16, 1, @ERROR);
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
            RAISERROR('No existe la Sala con ID_Sala = %d', 16, 1, @ID_Sala)
            RETURN
        END

        IF EXISTS (SELECT 1 FROM Recurso_Medico_Sala WHERE ID_Sala = @ID_Sala)
        BEGIN
            RAISERROR('No se puede eliminar la Sala, tiene recursos médicos asociados.', 16, 1)
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

        RAISERROR(N'%s', 16, 1, @ERROR);
        PRINT @ERROR
    END CATCH
END
GO

-------------------------Procedimiento para eliminar Estado_Recurso_Medico
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarEstado_Recurso_Medico
    @ID_Estado_Recurso_Medico INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Estado_Recurso_Medico WHERE ID_Estado_Recurso_Medico = @ID_Estado_Recurso_Medico)
        BEGIN
            RAISERROR('No existe el Estado de Recurso Médico con ID_Estado_Recurso_Medico = %d', 16, 1, @ID_Estado_Recurso_Medico)
            RETURN
        END

        IF EXISTS (SELECT 1 FROM Recurso_Medico WHERE ID_Estado_Recurso_Medico = @ID_Estado_Recurso_Medico)
        BEGIN
            RAISERROR('No se puede eliminar el Estado de Recurso Médico, tiene recursos médicos asociados.', 16, 1)
            RETURN
        END

        DELETE FROM Estado_Recurso_Medico WHERE ID_Estado_Recurso_Medico = @ID_Estado_Recurso_Medico
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'%s', 16, 1, @ERROR);
        PRINT @ERROR
    END CATCH
END
GO

-------------------------Procedimiento para eliminar Tipo_Recurso
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarTipo_Recurso
    @ID_Tipo_Recurso INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Tipo_Recurso WHERE ID_Tipo_Recurso = @ID_Tipo_Recurso)
        BEGIN
            RAISERROR('No existe el Tipo de Recurso con ID_Tipo_Recurso = %d', 16, 1, @ID_Tipo_Recurso)
            RETURN
        END

        IF EXISTS (SELECT 1 FROM Recurso_Medico WHERE ID_Tipo_Recurso = @ID_Tipo_Recurso)
        BEGIN
            RAISERROR('No se puede eliminar el Tipo de Recurso, tiene recursos médicos asociados.', 16, 1)
            RETURN
        END

        DELETE FROM Tipo_Recurso WHERE ID_Tipo_Recurso = @ID_Tipo_Recurso
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'%s', 16, 1, @ERROR);
        PRINT @ERROR
    END CATCH
END
GO

------------------------- Procedimiento para eliminar Estado_Sala
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarEstado_Sala
    @ID_Estado_Sala INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Estado_Sala WHERE ID_Estado_Sala = @ID_Estado_Sala)
        BEGIN
            RAISERROR('No existe el Estado de Sala con ID_Estado_Sala = %d', 16, 1, @ID_Estado_Sala)
            RETURN
        END

        IF EXISTS (SELECT 1 FROM Sala WHERE ID_Estado_Sala = @ID_Estado_Sala)
        BEGIN
            RAISERROR('No se puede eliminar el Estado de Sala, tiene salas asociadas.', 16, 1)
            RETURN
        END

        DELETE FROM Estado_Sala WHERE ID_Estado_Sala = @ID_Estado_Sala
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'%s', 16, 1, @ERROR);
        PRINT @ERROR
    END CATCH
END
GO

-------------------------Procedimiento para eliminar Tipo_Sala

USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarTipo_Sala
    @ID_Tipo_Sala INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Tipo_Sala WHERE ID_Tipo_Sala = @ID_Tipo_Sala)
        BEGIN
            RAISERROR('No existe el Tipo de Sala con ID_Tipo_Sala = %d', 16, 1, @ID_Tipo_Sala)
            RETURN
        END

        IF EXISTS (SELECT 1 FROM Sala WHERE ID_Tipo_Sala = @ID_Tipo_Sala)
        BEGIN
            RAISERROR('No se puede eliminar el Tipo de Sala, tiene salas asociadas.', 16, 1)
            RETURN
        END

        DELETE FROM Tipo_Sala WHERE ID_Tipo_Sala = @ID_Tipo_Sala
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'%s', 16, 1, @ERROR);
        PRINT @ERROR
    END CATCH
END
GO
------------------------- Procedimiento para eliminar Recurso_Medico_Sala
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarRecurso_Medico_Sala
    @ID_Recurso_Medico_Sala INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Recurso_Medico_Sala WHERE ID_Recurso_Medico_Sala = @ID_Recurso_Medico_Sala)
        BEGIN
            RAISERROR('No existe el Recurso Médico en Sala con ID_Recurso_Medico_Sala = %d', 16, 1, @ID_Recurso_Medico_Sala)
            RETURN
        END

        DELETE FROM Recurso_Medico_Sala WHERE ID_Recurso_Medico_Sala = @ID_Recurso_Medico_Sala
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'%s', 16, 1, @ERROR);
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
            RAISERROR('No existe el Médico con ID_Medico = %d', 16, 1, @ID_Medico)
            RETURN
        END

        IF EXISTS (SELECT 1 FROM Medico_Planificacion_Recurso WHERE ID_Medico = @ID_Medico)
        BEGIN
            RAISERROR('No se puede eliminar el Médico, tiene planificación de recursos asociada.', 16, 1)
            RETURN
        END

        DELETE FROM Medico WHERE ID_Medico = @ID_Medico
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'%s', 16, 1, @ERROR);
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
            RAISERROR('No existe la Especialidad con ID_Especialidad = %d', 16, 1, @ID_Especialidad)
            RETURN
        END

        IF EXISTS (SELECT 1 FROM Medico WHERE ID_Especialidad = @ID_Especialidad)
        BEGIN
            RAISERROR('No se puede eliminar la Especialidad, tiene médicos asociados.', 16, 1)
            RETURN
        END

        DELETE FROM Especialidad WHERE ID_Especialidad = @ID_Especialidad
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'%s', 16, 1, @ERROR);
        PRINT @ERROR
    END CATCH
END
GO
------------------------- Procedimiento para eliminar Horario_Trabajo
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarHorario_Trabajo
    @ID_Horario_Trabajo INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Horario_Trabajo WHERE ID_Horario_Trabajo = @ID_Horario_Trabajo)
        BEGIN
            RAISERROR('No existe el Horario de Trabajo con ID_Horario_Trabajo = %d', 16, 1,@ID_Horario_Trabajo)
            RETURN
        END

        IF EXISTS (SELECT 1 FROM Planificacion_Recurso WHERE ID_Horario_Trabajo = @ID_Horario_Trabajo)
        BEGIN
            RAISERROR('No se puede eliminar el Horario de Trabajo, tiene planificación de recursos asociada.', 16, 1)
            RETURN
        END

        DELETE FROM Horario_Trabajo WHERE ID_Horario_Trabajo = @ID_Horario_Trabajo
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'%s', 16, 1, @ERROR);
        PRINT @ERROR
    END CATCH
END
GO
------------------------- Procedimiento para eliminar Planificacion_Recurso
USE SaludPlus
GO

CREATE OR ALTER PROCEDURE sp_EliminarPlanificacion_Recurso
    @ID_Planificacion INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Planificacion_Recurso WHERE ID_Planificacion = @ID_Planificacion)
        BEGIN
            RAISERROR('No existe la Planificación de Recurso con ID_Planificacion = %d', 16, 1, @ID_Planificacion)
            RETURN
        END

		IF EXISTS (SELECT 1 FROM Medico_Planificacion_Recurso WHERE ID_Planificacion = @ID_Planificacion)
		BEGIN
            RAISERROR('Error al eliminar la planificación: está relacionada a una planificación de recurso de un médico', 16, 1)
			RETURN

		END

        DELETE FROM Planificacion_Recurso WHERE ID_Planificacion = @ID_Planificacion
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'%s', 16, 1, @ERROR);
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
            RAISERROR('No existe el Procedimiento con ID_Procedimiento = %d', 16, 1, @ID_Procedimiento)
            RETURN
        END

        --IF EXISTS (SELECT 1 FROM Historial_Medico WHERE ID_Historial_Medico IN (SELECT ID_Historial_Medico FROM Procedimiento WHERE ID_Procedimiento = @ID_Procedimiento))
        --BEGIN
        --    RAISERROR('No se puede eliminar el Procedimiento, tiene historial médico asociado.', 16, 1)
        --    RETURN
        --END

        DELETE FROM Procedimiento WHERE ID_Procedimiento = @ID_Procedimiento
    END TRY

    BEGIN CATCH
        DECLARE @ERROR NVARCHAR(1000)

        SET @ERROR = ERROR_MESSAGE()

        RAISERROR(N'%s', 16, 1, @ERROR);
        PRINT @ERROR
    END CATCH
END
GO

