-- Seguridad

use SaludPlus
go

CREATE ROLE Administrador;
GO
CREATE ROLE Médico
Go
CREATE ROLE Recepcionista
GO

---- Se le da acceso completo a la base de datos
GRANT SELECT, EXECUTE, INSERT, UPDATE, DELETE ON DATABASE::SaludPlus TO Administrador;
GO

--- Se le da acceso exclusivamente a lo que puede realizar un medico

--- Permisos de insercion
GRANT EXECUTE ON dbo.Sp_RegistrarProcedimiento
TO Médico;
GO

GRANT EXECUTE ON dbo.Sp_RegistrarSatisfaccion_Paciente 
TO Médico;
GO

GRANT EXECUTE ON dbo.Sp_RegistrarTipo_Procedimiento 
TO Médico;
GO

---Permisos de modificacion

GRANT EXECUTE ON dbo.Sp_ModificarProcedimiento
TO Médico;
GO

GRANT EXECUTE ON dbo.Sp_ModificarSatisfaccion_Paciente 
TO Médico;
GO

GRANT EXECUTE ON dbo.Sp_ModificarTipo_Procedimiento 
TO Médico;
GO


---Vistas
GRANT SELECT ON dbo.vw_Cita TO Médico;
GO

GRANT SELECT ON dbo.vw_Especialidad TO Médico;
GO

GRANT SELECT ON dbo.vw_Sala TO Médico;
GO

GRANT SELECT ON dbo.vw_Satisfaccion_Paciente TO Médico;
GO

GRANT SELECT ON dbo.vw_Tipo_Procedimiento TO Médico;
GO

GRANT SELECT ON dbo.vw_Paciente TO Médico;
GO

GRANT SELECT ON dbo.vw_Procedimiento TO Médico;
GO

--- Se le da acceso a todo lo que puede realizar un secretario 

--- Permisos de insercion
GRANT EXECUTE ON dbo.Sp_RegistrarCita
TO Recepcionista;
GO

GRANT EXECUTE ON dbo.Sp_RegistrarFactura
TO Recepcionista;
GO

GRANT EXECUTE ON dbo.Sp_RegistrarHistorial_Medico
TO Recepcionista;
GO

GRANT EXECUTE ON dbo.Sp_RegistrarPlanificacion_Recurso
TO Recepcionista;
GO

GRANT EXECUTE ON dbo.Sp_RegistrarRecurso_Medico
TO Recepcionista;
GO

GRANT EXECUTE ON dbo.Sp_RegistrarPaciente
TO Recepcionista;
GO

GRANT EXECUTE ON dbo.Sp_RegistrarRecurso_Medico_Sala
TO Recepcionista;
GO

GRANT EXECUTE ON dbo.Sp_RegistrarProcedimiento
TO Recepcionista;
GO

GRANT EXECUTE ON dbo.Sp_RegistrarSatisfaccion_Paciente 
TO Recepcionista;
GO

GRANT EXECUTE ON dbo.Sp_RegistrarTipo_Procedimiento 
TO Recepcionista;
GO

--- Permisos de modificacion

GRANT EXECUTE ON dbo.Sp_ModificarCita
TO Recepcionista;
GO

GRANT EXECUTE ON dbo.Sp_ModificarFactura
TO Recepcionista;
GO

GRANT EXECUTE ON dbo.Sp_ModificarHistorial_Medico
TO Recepcionista;
GO

GRANT EXECUTE ON dbo.Sp_ModificarPlanificacion_Recurso
TO Recepcionista;
GO

GRANT EXECUTE ON dbo.Sp_ModificarRecurso_Medico
TO Recepcionista;
GO

GRANT EXECUTE ON dbo.Sp_ModificarPaciente
TO Recepcionista;
GO

GRANT EXECUTE ON dbo.Sp_ModificarRecurso_Medico_Sala
TO Recepcionista;
GO

GRANT EXECUTE ON dbo.Sp_ModificarProcedimiento
TO Recepcionista;
GO

GRANT EXECUTE ON dbo.Sp_ModificarSatisfaccion_Paciente 
TO Recepcionista;
GO

GRANT EXECUTE ON dbo.Sp_ModificarTipo_Procedimiento 
TO Recepcionista;
GO


--- Vistas (Todas)
GRANT SELECT ON DATABASE::SaludPlus TO Recepcionista;
GO

---- La secretaria ni el medico pueden eliminar nada

CREATE OR ALTER PROCEDURE Sp_RegistrarUsuarioSistema
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
        ELSE IF @Rol = 'Administrador'
        BEGIN
            SET @sql = 'ALTER ROLE Administrador ADD MEMBER [' + @NombreUsuario + ']';
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