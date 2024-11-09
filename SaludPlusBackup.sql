
-- Generar un full backup de la base de datos
DECLARE @DatabaseName NVARCHAR(50) = 'SaludPlus' 
DECLARE @BackupPath NVARCHAR(200) = 'C:\SQL\Backups\' 
DECLARE @BackupFileName NVARCHAR(200)

-- Construir archivo de backup con fecha y hora
SET @BackupFileName = @BackupPath + @DatabaseName + '_Backup_' + 
                      CONVERT(NVARCHAR, GETDATE(), 112) + '_' + 
                      REPLACE(CONVERT(NVARCHAR, GETDATE(), 108), ':', '') + '.bak'

-- Ejecutar el comando de backup
BACKUP DATABASE @DatabaseName
TO DISK = @BackupFileName
WITH FORMAT, COMPRESSION, INIT, 
     STATS = 10;  -- Muestra el progreso cada 10%

PRINT 'Backup completo creado en ' + @BackupFileName
Go



