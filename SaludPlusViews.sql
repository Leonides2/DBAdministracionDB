--------------------------------------------------Vistas---------------------------------------------------------


CREATE OR ALTER VIEW vw_Paciente AS
SELECT 
ID_Paciente,
Nombre_Paciente ,
Apellido1_Paciente, 
Apellido2_Paciente, 
Telefono_Paciente, 
 CONVERT(VARCHAR, Fecha_Nacimiento, 103) AS Fecha_Nacimiento, 
Direccion_Paciente, 
Cedula
FROM Paciente;
GO

/*
Select * from vw_Paciente
go
*/

CREATE OR ALTER VIEW vw_Medico AS
SELECT 
Medico.ID_Medico,
Medico.Nombre1_Medico, 
Medico.Nombre2_Medico, 
Medico.Apellido1_Medico, 
Medico.Apellido2_Medico, 
Medico.Telefono_Medico,
Especialidad.Nombre_Especialidad
FROM Medico inner join Especialidad on Especialidad.ID_Especialidad = Medico.ID_Especialidad;
GO

/*
Select * from vw_Medico
go
*/

CREATE OR ALTER VIEW vw_Cita AS
SELECT 
Cita.ID_Cita,
Convert(VARCHAR,Cita.Fecha_Cita,103) AS Fecha_Cita,
Convert(VARCHAR, Cita.Hora_Cita, 108) AS Hora_Cita,
Cita.ID_Medico, 
Estado_Cita.Estado, 
Paciente.Cedula
FROM Cita inner join Paciente on Cita.ID_Paciente = Paciente.ID_Paciente
left join Estado_Cita on Cita.ID_Estado_Cita = Estado_Cita.ID_Estado_Cita;
GO

/*
Select * from vw_Cita
go
*/
CREATE OR ALTER VIEW vw_Factura AS
SELECT 
Factura.ID_Factura,
Convert(VARCHAR,Factura.Fecha_Factura,103) AS Fecha_Factura,
Factura.Monto_Total,
Paciente.Cedula, 
Factura.ID_Cita,
Tipo_Pago.Descripcion_Tipo_Pago
FROM Factura inner join Paciente on Factura.ID_Paciente = Paciente.ID_Paciente
left join Tipo_Pago on Tipo_Pago.ID_Tipo_Pago = Factura.ID_Tipo_Pago;
GO

/*
	Select * from vw_Factura
	go
*/

CREATE OR ALTER VIEW vw_Recurso_Medico_Sala AS
SELECT 
Convert(VARCHAR,Recurso_Medico_Sala.Fecha,103) AS Fecha,
Recurso_Medico_Sala.Cantidad_Recurso,
Recurso_Medico.Lote, 
Sala.Nombre_Sala
FROM Recurso_Medico_Sala inner join Recurso_Medico on Recurso_Medico.ID_Recurso_Medico = Recurso_Medico_Sala.ID_Recurso_Medico
left join Sala on Sala.ID_Sala = Recurso_Medico_Sala.ID_Sala;
GO
/*
	Select * from vw_Recurso_Medico_Sala
	go
*/

CREATE OR ALTER VIEW vw_Auditoria AS 
SELECT 
ID_Auditoria,
Nombre_Tabla,
ID_Registro,
Accion,
CONVERT(varchar, FechaAuditoria, 100) as FechaAuditoria,
Usuario
From Auditoria
GO
/*
	Select * from vw_Auditoria
	go
*/

CREATE OR ALTER VIEW vw_Estado_Cita AS 
SELECT 
ID_Estado_Cita,
Estado
From Estado_Cita
GO
/*
	Select * from vw_Estado_Cita
	go
*/

CREATE OR ALTER VIEW vw_Estado_Recurso_Medico AS 
SELECT 
ID_Estado_Recurso_Medico,
Estado_Recurso
From Estado_Recurso_Medico
GO
/*
	Select * from vw_Estado_Recurso_Medico
	go
*/
CREATE OR ALTER VIEW vw_Estado_Sala AS 
SELECT 
ID_Estado_Sala,
Nombre
From Estado_Sala
GO
/*
	Select * from vw_Estado_Sala
	go
*/

CREATE OR ALTER VIEW vw_Historial_Medico AS 
SELECT 
Historial_Medico.ID_Historial_Medico,
CONVERT(varchar, Historial_Medico.Fecha_Registro, 103) AS Fecha_Registro,
Paciente.Cedula
From Historial_Medico inner join Paciente on Paciente.ID_Paciente = Historial_Medico.ID_Paciente
GO
/*
	Select * from vw_Historial_Medico
	go
*/

CREATE OR ALTER VIEW vw_Especialidad AS 
SELECT 
ID_Especialidad,
Nombre_Especialidad
From Especialidad 
GO

CREATE OR ALTER VIEW vw_Especialidad AS 
SELECT 
ID_Especialidad,
Nombre_Especialidad
From Especialidad 
GO


CREATE OR ALTER VIEW vw_Horario_Trabajo AS 
SELECT 
ID_Horario_Trabajo,
Nombre_Horario,
CONVERT(varchar, Hora_Inicio, 108) AS Hora_Inicio,
CONVERT(varchar, Hora_Fin, 108) AS Hora_Fin
From Horario_Trabajo 
GO

CREATE OR ALTER VIEW vw_Tipo_Pago AS 
SELECT 
ID_Tipo_Pago,
Descripcion_Tipo_Pago
From Tipo_Pago 
GO


CREATE OR ALTER VIEW vw_Procedimiento AS 
SELECT 
Procedimiento.ID_Procedimiento,
Procedimiento.Descripcion_Procedimiento,
CONVERT(varchar, Procedimiento.Fecha_Procedimiento, 103) AS Fecha_Procedimiento,
CONVERT(varchar, Procedimiento.Hora_Procedimiento, 108) AS Hora_Procedimiento,
Procedimiento.Monto_Procedimiento,
Procedimiento.Receta,
Sala.Nombre_Sala,
Historial_Medico.ID_Historial_Medico,
ID_Cita,
Tipo_Procedimiento.Nombre_Procedimiento
From Procedimiento inner join Sala ON Procedimiento.ID_Sala = Sala.ID_Sala
inner join Historial_Medico On Procedimiento.ID_Historial_Medico = Historial_Medico.ID_Historial_Medico
inner join Tipo_Procedimiento on Procedimiento.ID_Tipo_Procedimiento = Tipo_Procedimiento.ID_Tipo_Procedimiento
GO

CREATE OR ALTER VIEW vw_Tipo_Procedimiento AS 
SELECT 
ID_Tipo_Procedimiento,
Nombre_Procedimiento
From Tipo_Procedimiento 
GO

CREATE OR ALTER VIEW vw_Recurso_Medico AS 
SELECT 
Recurso_Medico.ID_Recurso_Medico,
Recurso_Medico.Nombre_Recurso,
Recurso_Medico.Lote,
Recurso_Medico.Cantidad_Stock_Total,
Recurso_Medico.Ubicacion_Recurso,
Tipo_Recurso.Titulo_Recurso,
Estado_Recurso_Medico.Estado_Recurso
From Recurso_Medico inner join Tipo_Recurso on Recurso_Medico.ID_Tipo_Recurso = Tipo_Recurso.ID_Tipo_Recurso
inner join Estado_Recurso_Medico on Recurso_Medico.ID_Estado_Recurso_Medico = Estado_Recurso_Medico.ID_Estado_Recurso_Medico
GO

CREATE OR ALTER VIEW vw_Tipo_Recurso AS 
SELECT 
ID_Tipo_Recurso,
Titulo_Recurso
From Tipo_Recurso 
GO

CREATE OR ALTER VIEW vw_Sala AS 
SELECT 
Sala.ID_Sala,
Sala.Nombre_Sala,
Sala.Capacidad_Sala,
Tipo_Sala.Descripcion_Tipo_Sala,
Estado_Sala.Nombre AS 'Estado_Sala'
From Sala inner join Tipo_Sala on Sala.ID_Tipo_Sala = Tipo_Sala.ID_Tipo_Sala
inner join Estado_Sala on Sala.ID_Estado_Sala = Estado_Sala.ID_Estado_Sala
GO

CREATE OR ALTER VIEW vw_Tipo_Sala AS 
SELECT 
ID_Tipo_Sala,
Descripcion_Tipo_Sala
From Tipo_Sala 
GO


CREATE OR ALTER VIEW vw_Recurso_Medico_Sala AS 
SELECT 
Recurso_Medico_Sala.ID_Recurso_Medico_Sala,
CONVERT(varchar, Recurso_Medico_Sala.Fecha, 103) AS Fecha,
Recurso_Medico_Sala.Cantidad_Recurso,
Recurso_Medico.Lote,
Sala.Nombre_Sala
From Recurso_Medico_Sala inner join Recurso_Medico on Recurso_Medico_Sala.ID_Recurso_Medico = Recurso_Medico.ID_Recurso_Medico
inner join Sala ON Recurso_Medico_Sala.ID_Sala = Sala.ID_Sala
GO

CREATE OR ALTER VIEW vw_Planificacion_Recurso AS 
SELECT 
ID_Planificacion,
Descripcion_Planificacion,
CONVERT(varchar, Fecha_Planificacion, 103) AS Fecha_Planificacion,
Sala.Nombre_Sala,
Horario_Trabajo.Nombre_Horario
From Planificacion_Recurso inner join Sala on Planificacion_Recurso.ID_Sala = Sala.ID_Sala
inner join Horario_Trabajo on Planificacion_Recurso.ID_Horario_Trabajo = Horario_Trabajo.ID_Horario_Trabajo
GO


CREATE OR ALTER VIEW vw_Satisfaccion_Paciente AS 
SELECT 
ID_Satisfaccion,
Calificacion_Satisfaccion,
CONVERT(varchar, Fecha_Evaluacion, 103) AS Fecha_Evaluacion,
ID_Cita
From Satisfaccion_Paciente
GO


CREATE OR ALTER VIEW vw_Medico_Planificacion_Recurso AS 
SELECT 
ID_Medico_Planificacion_Recurso,
CONVERT(varchar, Fecha_Planificacion_Personal, 103) AS Fecha_Planificacion_Personal,
Planificacion_Recurso.Descripcion_Planificacion,
ID_Medico
From Medico_Planificacion_Recurso inner join Planificacion_Recurso on Medico_Planificacion_Recurso.ID_Planificacion
= Planificacion_Recurso.ID_Planificacion
GO
