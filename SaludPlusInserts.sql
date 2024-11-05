
------------------------------------------------Inserciones 
USE SaludPlus;
GO
-- Inserciones para la tabla Paciente
INSERT INTO Paciente (Nombre_Paciente, Apellido1_Paciente, Apellido2_Paciente, Telefono_Paciente, Fecha_Nacimiento, Direccion_Paciente, Cedula)
VALUES 
('Juan', 'Perez', 'Gomez', '1234567890', '1980-01-01', 'Calle 1, Ciudad A', '12345698'),
('Maria', 'Lopez', 'Martinez', '2345678901', '1990-02-02', 'Calle 2, Ciudad B', '123454322'),
('Carlos', 'Garcia', 'Rodriguez', '3456789012', '1985-03-03', 'Calle 3, Ciudad C', '867905532'),
('Ana', 'Hernandez', 'Sanchez', '4567890123', '1995-04-04', 'Calle 4, Ciudad D', '508975568'),
('Luis', 'Martinez', 'Diaz', '5678901234', '2000-05-05', 'Calle 5, Ciudad E', '186790004');

-- Inserciones para la tabla Tipo Sala
INSERT INTO Tipo_Sala (Descripcion_Tipo_Sala)
VALUES 
('Emergencias'),
('Cirugia'),
('Consulta General'),
('Observacion'),
('Laboratorio');
GO

-- Inserciones para la tabla Estado Sala
INSERT INTO Estado_Sala (Nombre)
VALUES 
('activa');
GO

-- Inserciones para la tabla Sala
INSERT INTO Sala (Nombre_Sala, ID_Tipo_Sala, Capacidad_Sala, ID_Estado_Sala)
VALUES 
('Sala de Emergencias', 1, 5, 1),
('Sala de Cirugia', 2, 10, 1),
('Consulta General 1', 2, 3, 1),
('Sala de Observacion', 4, 3, 1),
('Laboratorio 1', 5, 2, 1);
GO

-- Inserciones para la tabla Especialidad
INSERT INTO Especialidad (Nombre_Especialidad)
VALUES 
('Cardiología'),
('Dermatología'),
('Radiología'),
('Pediatría'),
('Cirugía');
GO

-- Inserciones para la tabla Medico
INSERT INTO Medico (Nombre1_Medico, Nombre2_Medico, Apellido1_Medico, Apellido2_Medico, Telefono_Medico, ID_Especialidad)
VALUES 
('Pedro', 'Jose', 'Ramirez', 'Fernandez', '6789012345', 1),
('Laura', 'Maria', 'Gonzalez', 'Lopez', '7890123456', 2),
('Miguel', 'Angel', 'Torres', 'Perez', '8901234567', 3),
('Sofia', 'Elena', 'Vargas', 'Garcia', '9012345678', 4),
('Diego', 'Luis', 'Castro', 'Martinez', '1234567890', 5);
GO

-- Inserciones para la tabla Estado Cita
INSERT INTO Estado_Cita (Estado)
VALUES 
('Programada'),   
('Realizada'),
('Cancelada');
GO

-- Inserciones para la tabla Cita
INSERT INTO Cita (Fecha_Cita, Hora_Cita, ID_Estado_Cita, ID_Paciente, ID_Medico)
VALUES 
('2024-01-01', '08:00', 1, 1, 1),   
('2024-02-01', '09:00', 2, 2, 2),
('2024-03-01', '10:00', 3, 3, 3),
('2024-04-01', '11:00', 1, 4, 4),
('2024-05-01', '12:00', 2, 5, 5);
GO

-- Inserciones para la tabla Tipo Pago
INSERT INTO Tipo_Pago (Descripcion_Tipo_Pago)
VALUES 
('Efectivo'),
('Tarjeta de credito'),
('Tarjeta de debito'),
('Transferencia Bancaria'),
('Sinpe Movil');
GO

-- Inserciones para la tabla Factura
INSERT INTO Factura (Fecha_Factura, Monto_Total, ID_Paciente, ID_Cita, ID_Tipo_Pago)
VALUES 
('2024-01-01', 1000.00, 1, 1, 1),
('2024-02-01', 2000.00, 2, 2, 2),
('2024-03-01', 3000.00, 3, 3, 3),
('2024-04-01', 4000.00, 4, 4, 4),
('2024-05-01', 5000.00, 5, 5, 5);
GO

-- Inserciones para la tabla Historial_Medico
INSERT INTO Historial_Medico (Fecha_Registro, ID_Paciente)
VALUES 
('2024-01-01', 1),   
('2024-02-01', 2),
('2024-03-01', 3),
('2024-04-01', 4),
('2024-05-01', 5);
GO

-- Inserciones para la tabla Tipo Procedimiento
INSERT INTO Tipo_Procedimiento (Nombre_Procedimiento)
VALUES 
('Cita de Cirugía'),   
('Cita de Laboratorio'),
('Cita de Consulta General'),
('Emergencias'),
('Cita de Diagnostico');
GO

-- Inserciones para la tabla Procedimiento
INSERT INTO Procedimiento (Descripcion_Procedimiento, Fecha_Procedimiento, Hora_Procedimiento, Monto_Procedimiento, Receta, ID_Sala, ID_Historial_Medico, ID_Cita, ID_Tipo_Procedimiento)
VALUES 
('Cirugía de corazon', '2024-01-01', '14:00', 10000, 'Ibuprofeno cada seis horas por tres días', 1, 1, 1, 1), 
('Entrada de emergencia por pierna lesionada', '2024-02-01', '12:30', 200000, 'Ibuprofeno cada seis horas por 5 días', 2, 2, 2, 4),
('Enfermedad de piel', '2024-03-01', '09:00', 30000, 'Paracetamol cada ocho horas por cinco días', 3, 3, 3, 3),
('Por dolores fuertes de cabeza', '2024-04-01', '10:00', 400000, 'Paracetamol cada ocho horas por siete días', 4, 4, 4, 3),
('Laboratorio de cardiología', '2024-05-01', '15:00', 5000000, 'Ibuprofeno cada seis horas por seis días', 5, 5, 5, 2);
GO

-- Inserciones para la tabla Satisfaccion_Paciente
INSERT INTO Satisfaccion_Paciente (Fecha_Evaluacion, Calificacion_Satisfaccion, ID_Cita)
VALUES 
('2024-01-02', 5, 1),
('2024-02-02', 4, 2),
('2024-03-02', 3, 3),
('2024-04-02', 2, 4),
('2024-05-02', 1, 5);
GO

-- Inserciones para la tabla Tipo_Recurso
INSERT INTO Tipo_Recurso (Titulo_Recurso)
VALUES 
('Medicamento'),
('Equipo Médico'),
('Material de Oficina'),
('Instrumento Quirúrgico'),
('Suministro Médico');
GO

-- Inserciones para la tabla Estado_Recurso_Medico
INSERT INTO Estado_Recurso_Medico (Estado_Recurso)
VALUES 
('Disponible'),
('Agotado');
GO

-- Inserciones para la tabla Recurso_Medico
INSERT INTO Recurso_Medico (Nombre_Recurso, Lote, Cantidad_Stock_Total, Ubicacion_Recurso, ID_Tipo_Recurso, ID_Estado_Recurso_Medico)
VALUES 
('Recurso 1', 'Lote 1', 100, 'Almacén 1', 1, 1),
('Recurso 2', 'Lote 2', 200, 'Almacén 2', 2, 2),
('Recurso 3', 'Lote 3', 300, 'Almacén 3', 3, 1),
('Recurso 4', 'Lote 4', 400, 'Almacén 4', 4, 2),
('Recurso 5', 'Lote 5', 500, 'Almacén 5', 5, 1);
GO

-- Inserciones para la tabla Horario_Trabajo
INSERT INTO Horario_Trabajo (Nombre_Horario, Hora_Inicio, Hora_Fin)
VALUES 
('Mañana', '08:00', '12:00'),
('Tarde', '13:00', '17:00'),
('Noche', '18:00', '22:00'),
('Madrugada', '23:00', '03:00'),
('Completo', '08:00', '17:00');
GO 

-- Inserciones para la tabla Planificacion_Recurso
INSERT INTO Planificacion_Recurso (Descripcion_Planificacion, Fecha_Planificacion, ID_Sala, ID_Horario_Trabajo)
VALUES 
('Planificación 1', '2024-01-01', 1, 1),
('Planificación 2', '2024-02-01', 2, 2),
('Planificación 3', '2024-03-01', 3, 3),
('Planificación 4', '2024-04-01', 4, 4),
('Planificación 5', '2024-05-01', 5, 5);
GO

-- Inserciones de la tabla Medico_Planificacion_Recurso
INSERT INTO Medico_Planificacion_Recurso (Fecha_Planificacion_Personal, ID_Medico, ID_Planificacion)
VALUES
('2024-01-01', 1, 1),
('2024-01-01', 2, 2),
('2024-01-01', 3, 3),
('2024-01-01', 4, 4),
('2024-01-01', 5, 5);
GO

-- Inserciones para la tabla Recurso_Medico_Sala
INSERT INTO Recurso_Medico_Sala (Fecha, Cantidad_Recurso, ID_Recurso_Medico, ID_Sala)
VALUES 
('2024-01-01', 20, 1, 1),
('2024-01-01', 30, 2, 2),
('2024-01-01', 40, 3, 3),
('2024-01-01', 50, 4, 4),
('2024-01-01', 60, 5, 5);
GO

-- Inserciones de Rol
INSERT INTO Rol (Nombre_Rol) 
VALUES
('Administrador'),
('Médico'),
('Recepcionista');
GO

-- Inserciones para el Usuario
INSERT INTO Usuario (Nombre_Usuario, Correo_Usuario, Contraseña_Usuario, ID_Rol) 
VALUES
('Juan Pérez', 'juan.perez@saludplus.com', 'contraseña123', 1),  
('María Gómez', 'maria.gomez@saludplus.com', 'contraseña456', 2),  
('Carlos López', 'carlos.lopez@saludplus.com', 'contraseña789', 3);
GO

-- Inserciones de permisos
INSERT INTO Permiso (Nombre_Permiso) 
VALUES 
('Crear Citas'),
('Ver Citas'),
('Modificar Citas'),
('Eliminar Citas'),
('Acceso a Historial Médico'),
('Gestionar Pacientes');
GO

-- Inserciones de Rol_Permisos
INSERT INTO Rol_Permiso (ID_Rol, ID_Permiso) 
VALUES 
(1, 1),  -- Administrador puede crear citas
(1, 2),  -- Administrador puede ver citas
(1, 3),  -- Administrador puede modificar citas
(1, 4),  -- Administrador puede eliminar citas
(1, 5),  -- Administrador puede acceder a historial médico
(1, 6);  -- Administrador puede gestionar pacientes
GO
