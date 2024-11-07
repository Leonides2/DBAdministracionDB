-- Seguridad

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