--- Plan de mantenimiento
Use SaludPlus
go
DBCC CHECKDB 
go



ALTER DATABASE SaludPlus SET RECOVERY SIMPLE;
go
--- Reorganizacion y reconstruccion de indices

DECLARE @tableName NVARCHAR(128);
DECLARE @indexName NVARCHAR(128);
DECLARE @schemaName NVARCHAR(128);
DECLARE @fragmentation FLOAT;
DECLARE @sqlCommand NVARCHAR(MAX);

-- Cursor para recorrer todos los �ndices en la base de datos
DECLARE index_cursor CURSOR FOR
SELECT 
    s.name AS SchemaName,
    o.name AS TableName,
    i.name AS IndexName,
    ps.avg_fragmentation_in_percent AS Fragmentation
FROM 
    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS ps
    JOIN sys.indexes AS i ON ps.object_id = i.object_id AND ps.index_id = i.index_id
    JOIN sys.objects AS o ON ps.object_id = o.object_id
    JOIN sys.schemas AS s ON o.schema_id = s.schema_id
WHERE 
    ps.database_id = DB_ID()
    AND i.type > 0
    AND ps.avg_fragmentation_in_percent > 5
ORDER BY 
    ps.avg_fragmentation_in_percent DESC;

-- Ejecutar reorganizaci�n o reconstrucci�n seg�n el nivel de fragmentaci�n
OPEN index_cursor;
FETCH NEXT FROM index_cursor INTO @schemaName, @tableName, @indexName, @fragmentation;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sqlCommand = N'';

    -- Si la fragmentaci�n est� entre 5% y 30%, reorganizar el �ndice
    IF @fragmentation >= 5 AND @fragmentation < 30
    BEGIN
        SET @sqlCommand = 'ALTER INDEX ' + QUOTENAME(@indexName) + ' ON ' 
            + QUOTENAME(@schemaName) + '.' + QUOTENAME(@tableName) + ' REORGANIZE;';
    END
    -- Si la fragmentaci�n es mayor al 30%, reconstruir el �ndice
    ELSE IF @fragmentation >= 30
    BEGIN
        SET @sqlCommand = 'ALTER INDEX ' + QUOTENAME(@indexName) + ' ON ' 
            + QUOTENAME(@schemaName) + '.' + QUOTENAME(@tableName) + ' REBUILD;';
    END

    -- Ejecutar el comando si est� definido
    IF @sqlCommand <> ''
    BEGIN
        PRINT 'Ejecutando: ' + @sqlCommand;
        EXEC sp_executesql @sqlCommand;
    END

    FETCH NEXT FROM index_cursor INTO @schemaName, @tableName, @indexName, @fragmentation;
END

-- Cerrar y liberar el cursor
CLOSE index_cursor;
DEALLOCATE index_cursor;
Go

ALTER DATABASE SaludPlus SET RECOVERY Full;
go


EXEC sp_updatestats
go