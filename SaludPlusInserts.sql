
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



-------------------Inserciones por procedimientos almacenados-Testing ------------


-- Insertar paciente 1
EXEC Sp_RegistrarPaciente   @Nombre_Paciente = 'Pedro', @Apellido1_Paciente = 'Fernandez', @Apellido2_Paciente = 'Torres',
    @Telefono_Paciente = '5678901122',@Fecha_Nacimiento = '1988-06-06',@Direccion_Paciente = 'Calle 6, Ciudad F',@Cedula = '987654321';
	go


-- Insertar paciente 2
EXEC Sp_RegistrarPaciente  @Nombre_Paciente = 'Lucia', @Apellido1_Paciente = 'Cruz',@Apellido2_Paciente = 'Mendez', 
    @Telefono_Paciente = '6789012233',@Fecha_Nacimiento = '1992-07-07',@Direccion_Paciente = 'Calle 7, Ciudad G',@Cedula = '456789012';
	go

-- Insertar paciente 3
EXEC Sp_RegistrarPaciente  @Nombre_Paciente = 'Fernando',@Apellido1_Paciente = 'Ramirez',@Apellido2_Paciente = 'Soto', 
    @Telefono_Paciente = '7890123344',@Fecha_Nacimiento = '1982-08-08',@Direccion_Paciente = 'Calle 8, Ciudad H',@Cedula = '654321789';
	go

-- Insertar paciente 4
EXEC Sp_RegistrarPaciente  @Nombre_Paciente = 'Isabella',@Apellido1_Paciente = 'Alvarez',@Apellido2_Paciente = 'Paredes', 
    @Telefono_Paciente = '8901234455',@Fecha_Nacimiento = '1995-09-09',@Direccion_Paciente = 'Calle 9, Ciudad I',@Cedula = '321654987';
	go



-- Insertar especialidad 1
EXEC Sp_RegistrarEspecialidad  @Nombre_Especialidad = 'Ginecología';
go

-- Insertar especialidad 2
EXEC Sp_RegistrarEspecialidad  @Nombre_Especialidad = 'Psiquiatría';
go



-- Insertar m�dico 1
EXEC Sp_RegistrarMedico  @Nombre1_Medico = 'Antonio',@Nombre2_Medico = 'Luis',@Apellido1_Medico = 'Salazar',@Apellido2_Medico = 'Jimenez', 
    @Telefono_Medico = '2345678901',@Especialidad = 'Cardiología'; -- Cardiología
	go

-- Insertar m�dico 2
EXEC Sp_RegistrarMedico  @Nombre1_Medico = 'Carmen',@Nombre2_Medico = 'Teresa',@Apellido1_Medico = 'Ruiz',@Apellido2_Medico = 'Mena', 
    @Telefono_Medico = '3456789012',@Especialidad = 'Dermatología'; -- Dermatología
	go
-- Insertar m�dico 3
EXEC Sp_RegistrarMedico  @Nombre1_Medico = 'Francisco',@Nombre2_Medico = 'Javier',@Apellido1_Medico = 'Hernandez',@Apellido2_Medico = 'Bermudez', 
    @Telefono_Medico = '4567890123',@Especialidad = 'Radiología'; -- Radiología
	go

-- Insertar m�dico 4
EXEC Sp_RegistrarMedico  @Nombre1_Medico = 'Elena',@Nombre2_Medico = 'Cristina',@Apellido1_Medico = 'Alvarez',@Apellido2_Medico = 'Luna', 
    @Telefono_Medico = '5678901234',@Especialidad = 'Pediatría'; -- Pediatría
	go

-- Insertar m�dico 5
EXEC Sp_RegistrarMedico @Nombre1_Medico = 'Ricardo',@Nombre2_Medico = 'Andrés',@Apellido1_Medico = 'Morales',@Apellido2_Medico = 'Santos', 
    @Telefono_Medico = '6789012345',@Especialidad = 'Cirugía'; -- Cirugía
	go

-- Insertar estado de cita 1
EXEC Sp_RegistrarEstadoCita   @Estado = 'En Espera';
go

-- Insertar estado de cita 2
EXEC Sp_RegistrarEstadoCita  @Estado = 'No Asistió';
go
-- Insertar estado de cita 3
EXEC Sp_RegistrarEstadoCita   @Estado = 'Finalizada';
go


-- Insertar cita 1
execute Sp_RegistrarCita  @Fecha_Cita= '2024-01-01',  @Hora_Cita= '08:00', @Cedula='456789012' , @ID_Medico=1, @Estado='Programada'
go
-- Insertar cita 2
EXEC Sp_RegistrarCita  @Fecha_Cita = '2024-06-01',@Hora_Cita = '08:30',@Cedula = '321654987',@ID_Medico = 2,@Estado='Programada';
go
-- Insertar cita 3
EXEC Sp_RegistrarCita   @Fecha_Cita = '2024-07-01',@Hora_Cita = '09:30',@Cedula = '987654321',@ID_Medico = 3,@Estado='En Espera';
go
-- Insertar cita 4
EXEC Sp_RegistrarCita  @Fecha_Cita = '2024-08-01',@Hora_Cita = '10:30',@Cedula = '456789012',@ID_Medico = 4,@Estado = 'Realizada';
go

-- Insertar cita 5
EXEC Sp_RegistrarCita  @Fecha_Cita = '2024-08-01',@Hora_Cita = '11:30',@Cedula = '867905532',@ID_Medico = 4,@Estado = 'Programada';
go


-- Insertar factura 1
EXEC Sp_RegistrarFactura   @Fecha_Factura = '2024-06-01', @Monto_Total = 1500.00,@Cedula='456789012',@ID_Cita = 1,@Tipo_Pago = 'Efectivo';
go
-- Insertar factura 2
EXEC Sp_RegistrarFactura  @Fecha_Factura = '2024-07-01',@Monto_Total = 2500.00,@Cedula = '867905532',@ID_Cita = 2, @Tipo_Pago = 'Tarjeta de debito';
go
-- Insertar factura 3
EXEC Sp_RegistrarFactura  @Fecha_Factura = '2024-08-01',@Monto_Total = 3500.00,@Cedula = '987654321',@ID_Cita = 3,@Tipo_Pago = 'Sinpe Movil';
go
-- Insertar factura 4
EXEC Sp_RegistrarFactura  @Fecha_Factura = '2024-09-01',@Monto_Total = 4500.00,@Cedula = '321654987',@ID_Cita = 4,@Tipo_Pago = 'Efectivo';
go

 -- Insertar historial médico para el paciente con ID 6
EXEC Sp_RegistrarHistorial_Medico @ID_Paciente = 6;
go
-- Insertar historial médico para el paciente con ID 7
EXEC Sp_RegistrarHistorial_Medico @ID_Paciente = 7;
go
-- Insertar historial médico para el paciente con ID 8
EXEC Sp_RegistrarHistorial_Medico @ID_Paciente = 8;
go
-- Insertar historial médico para el paciente con ID 9
EXEC Sp_RegistrarHistorial_Medico @ID_Paciente = 9;
go

-- Insertar estado de sala 1
EXEC Sp_RegistrarEstado_Sala  @Nombre = 'Inactiva';
go
-- Insertar estado de sala 2
EXEC Sp_RegistrarEstado_Sala  @Nombre = 'En mantenimiento';
go
-- Insertar estado de sala 3
EXEC Sp_RegistrarEstado_Sala  @Nombre = 'Cerrada';
go


-- Insertar tipo de sala 1
EXEC Sp_RegistrarTipo_Sala  @Descripcion_Tipo_Sala = 'Ginecología';
go
-- Insertar tipo de sala 2
EXEC Sp_RegistrarTipo_Sala  @Descripcion_Tipo_Sala = 'Traumatología';
go
-- Insertar tipo de sala 3
EXEC Sp_RegistrarTipo_Sala  @Descripcion_Tipo_Sala = 'Cardiología';
go
-- Insertar tipo de sala 5
EXEC Sp_RegistrarTipo_Sala  @Descripcion_Tipo_Sala = 'Oncología';
go


/*

-- Insertar sala 1
EXEC Sp_RegistrarSala  @Nombre_Sala = 'Sala de Ginecología',@Capacidad_Sala = 4,@ID_Tipo_Sala = 2,@ID_Estado_Sala = 3;
go
-- Insertar sala 2
EXEC Sp_RegistrarSala  @Nombre_Sala = 'Sala de Traumatología',@Capacidad_Sala = 5,@ID_Tipo_Sala = 3,@ID_Estado_Sala = 2;
go
-- Insertar sala 3
EXEC Sp_RegistrarSala  @Nombre_Sala = 'Sala de Cardiología',@Capacidad_Sala = 3,@ID_Tipo_Sala = 4,@ID_Estado_Sala = 1;
go

*/

-- Insertar tipo de procedimiento 1
EXEC Sp_RegistrarTipo_Procedimiento  @Nombre_Procedimiento = 'Cita de Ginecología';
go
-- Insertar tipo de procedimiento 2
EXEC Sp_RegistrarTipo_Procedimiento   @Nombre_Procedimiento = 'Cita de Traumatología';
go
-- Insertar tipo de procedimiento 3
EXEC Sp_RegistrarTipo_Procedimiento  @Nombre_Procedimiento = 'Cita de Cardiología';
go

/*
EXEC Sp_RegistrarProcedimiento  @Descripcion_Procedimiento = 'Consulta de medicina interna',@Fecha_Procedimiento = '2024-08-01', 
    @Hora_Procedimiento = '11:00',@Monto_Procedimiento = 5000,@Receta = 'Reposo y seguimiento',@ID_Sala = 1,@ID_Historial_Medico = 6,@ID_Cita = 6,@ID_Tipo_Procedimiento = 1;
	go
EXEC Sp_RegistrarProcedimiento @Descripcion_Procedimiento = 'Examen de laboratorio',@Fecha_Procedimiento = '2024-08-15',
    @Hora_Procedimiento = '09:30',@Monto_Procedimiento = 1500,@Receta = 'Ninguna',@ID_Sala = 2,@ID_Historial_Medico = 7,@ID_Cita = 7,@ID_Tipo_Procedimiento = 2;
	go
EXEC Sp_RegistrarProcedimiento  @Descripcion_Procedimiento = 'Radiografía de abdomen',@Fecha_Procedimiento = '2024-08-20',
    @Hora_Procedimiento = '13:00',@Monto_Procedimiento = 2000,@Receta = 'Ninguna',@ID_Sala = 3,@ID_Historial_Medico = 8,@ID_Cita = 8,@ID_Tipo_Procedimiento = 2;
	go
EXEC Sp_RegistrarProcedimiento  @Descripcion_Procedimiento = 'Consulta pediátrica',@Fecha_Procedimiento = '2024-09-01',@Hora_Procedimiento = '10:00',
     @Monto_Procedimiento = 6000,@Receta = 'Paracetamol si es necesario',@ID_Sala = 4,@ID_Historial_Medico = 5,@ID_Cita = 2,@ID_Tipo_Procedimiento = 3;
	 go
EXEC Sp_RegistrarProcedimiento  @Descripcion_Procedimiento = 'Consulta de ortopedia',@Fecha_Procedimiento = '2024-09-10', 
    @Hora_Procedimiento = '14:30',@Monto_Procedimiento = 7000,@Receta = 'Hielo y descanso',@ID_Sala = 5,@ID_Historial_Medico =1,@ID_Cita = 10,@ID_Tipo_Procedimiento = 7;
	go
*/

EXEC Sp_RegistrarEstado_Recurso_Medico  @Estado_Recurso = 'En mantenimiento';
go
EXEC Sp_RegistrarEstado_Recurso_Medico  @Estado_Recurso = 'Reparación necesaria';
go
EXEC Sp_RegistrarEstado_Recurso_Medico  @Estado_Recurso = 'Fuera de servicio';
go
EXEC Sp_RegistrarEstado_Recurso_Medico  @Estado_Recurso = 'Reservado';
go



EXEC Sp_RegistrarTipo_Recurso  @Titulo_Recurso = 'Recurso de Diagnóstico';
go
EXEC Sp_RegistrarTipo_Recurso  @Titulo_Recurso = 'Equipos de Protección Personal';
go
EXEC Sp_RegistrarTipo_Recurso  @Titulo_Recurso = 'Suministros de Emergencia';
go
EXEC Sp_RegistrarTipo_Recurso  @Titulo_Recurso = 'Material de Curación';
go

/*
EXEC Sp_RegistrarRecurso_Medico   @Nombre_Recurso = 'Recurso 6',@Lote = 'Lote 6',@Cantidad_Stock_Total = 150,@Ubicacion_Recurso = 'Almacen 6', 
    @ID_Tipo_Recurso = 1,@ID_Estado_Recurso_Medico = 4;
	go
EXEC Sp_RegistrarRecurso_Medico  @Nombre_Recurso = 'Recurso 7',@Lote = 'Lote 7',@Cantidad_Stock_Total = 250,@Ubicacion_Recurso = 'Almacen 7', 
    @ID_Tipo_Recurso = 2,@ID_Estado_Recurso_Medico = 6;
	go
EXEC Sp_RegistrarRecurso_Medico  @Nombre_Recurso = 'Recurso 8',@Lote = 'Lote 8',@Cantidad_Stock_Total = 350,@Ubicacion_Recurso = 'Almacen 8', 
    @ID_Tipo_Recurso = 3,@ID_Estado_Recurso_Medico = 5;
	go
EXEC Sp_RegistrarRecurso_Medico  @Nombre_Recurso = 'Recurso 9',@Lote = 'Lote 9',@Cantidad_Stock_Total = 450,@Ubicacion_Recurso = 'Almacen 9', 
    @ID_Tipo_Recurso = 6,@ID_Estado_Recurso_Medico = 2;
*/