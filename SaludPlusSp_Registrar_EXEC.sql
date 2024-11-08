 -- Recurso medico sala
EXEC Sp_RegistrarRecurso_Medico_Sala  @Fecha = '2024-02-01',@Cantidad_Recurso = 25,  @Lote='Lote 1', @Nombre_Sala='Sala de Emergencias'; 
go
EXEC Sp_RegistrarRecurso_Medico_Sala  @Fecha = '2024-02-02',@Cantidad_Recurso = 35,  @Lote='Lote 2',  @Nombre_Sala= 'Sala de Cirugia';
go
EXEC Sp_RegistrarRecurso_Medico_Sala  @Fecha = '2024-02-03',@Cantidad_Recurso = 45,   @Lote='Lote 3',  @Nombre_Sala= 'Consulta General 1';
go
EXEC Sp_RegistrarRecurso_Medico_Sala  @Fecha = '2024-02-04',@Cantidad_Recurso =  55, @Lote='Lote 4',  @Nombre_Sala= 'Laboratorio 1';
go

-- Horario Trabajo
EXEC Sp_RegistrarHorario_Trabajo  @Nombre_Horario = 'Turno de fin de semana', @Hora_Inicio = '09:00',@Hora_Fin = '13:00';
go
EXEC Sp_RegistrarHorario_Trabajo  @Nombre_Horario = 'Turno de tarde extendido',@Hora_Inicio = '14:00',@Hora_Fin = '18:30';
go
EXEC Sp_RegistrarHorario_Trabajo  @Nombre_Horario = 'Turno nocturno',@Hora_Inicio = '20:00', @Hora_Fin = '23:00';
go
EXEC Sp_RegistrarHorario_Trabajo  @Nombre_Horario = 'Horario de consultas especiales',@Hora_Inicio = '10:00',@Hora_Fin = '14:00';
go

-- Planificacion recurso

EXEC Sp_RegistrarPlanificacion_Recurso  @Descripcion_Planificacion = 'Planificación 6',@Fecha_Planificacion = '2024-06-01' ,@Nombre_Sala= 'Sala de Emergencias', 
    @Nombre_Horario = 'Mañana';
	go
EXEC Sp_RegistrarPlanificacion_Recurso  @Descripcion_Planificacion = 'Planificación 7',@Fecha_Planificacion = '2024-07-01',  @Nombre_Sala=  'Sala de Cirugia', 
    @Nombre_Horario = 'Tarde';
	go
EXEC Sp_RegistrarPlanificacion_Recurso  @Descripcion_Planificacion = 'Planificación 8',@Fecha_Planificacion = '2024-08-01',@Nombre_Sala=  'Sala de Observacion', 
    @Nombre_Horario = 'Noche';
	go
EXEC Sp_RegistrarPlanificacion_Recurso  @Descripcion_Planificacion = 'Planificación 9',@Fecha_Planificacion = '2024-09-01', @Nombre_Sala= 'Sala de Emergencias', 
    @Nombre_Horario= 'Mañana';
	go


-- Medico planificacion recurso

EXEC Sp_RegistrarMedico_Planificacion_Recurso  @Fecha_Planificacion_Personal = '2024-02-01', @Descripcion_Planificacion='Planificación 1', @ID_Medico = 1;
go
EXEC Sp_RegistrarMedico_Planificacion_Recurso  @Fecha_Planificacion_Personal = '2024-02-01',@Descripcion_Planificacion='Planificación 2', @ID_Medico = 2;
go
EXEC Sp_RegistrarMedico_Planificacion_Recurso  @Fecha_Planificacion_Personal = '2024-02-01',@Descripcion_Planificacion='Planificación 3', @ID_Medico = 3;
go
EXEC Sp_RegistrarMedico_Planificacion_Recurso  @Fecha_Planificacion_Personal = '2024-02-01', @Descripcion_Planificacion='Planificación 4',  @ID_Medico = 4;
go


-- Satisfaccion paciente

EXEC Sp_RegistrarSatisfaccion_Paciente  @Fecha_Evaluacion = '2024-06-02',@Calificacion_Satisfaccion = 5,@ID_Cita = 1;
go
EXEC Sp_RegistrarSatisfaccion_Paciente  @Fecha_Evaluacion = '2024-06-03',@Calificacion_Satisfaccion = 4,@ID_Cita = 2;
go
EXEC Sp_RegistrarSatisfaccion_Paciente  @Fecha_Evaluacion = '2024-06-04',@Calificacion_Satisfaccion = 3,@ID_Cita = 3;
go
EXEC Sp_RegistrarSatisfaccion_Paciente  @Fecha_Evaluacion = '2024-06-05',@Calificacion_Satisfaccion = 2,@ID_Cita = 4;
go

-- Usuario

EXEC Sp_RegistrarUsuario @Nombre_Usuario = 'Ana Torres',@Correo_Usuario = 'ana.torres@saludplus.com',@Contraseña_Usuario = 'contraseña101',@ID_Rol = 1;
go
EXEC Sp_RegistrarUsuario  @Nombre_Usuario = 'Luis Fernández',@Correo_Usuario = 'luis.fernandez@saludplus.com',@Contraseña_Usuario = 'contraseña202', 
    @ID_Rol = 2;
	go
EXEC Sp_RegistrarUsuario  @Nombre_Usuario = 'Elena Ruiz',@Correo_Usuario = 'elena.ruiz@saludplus.com',@Contraseña_Usuario = 'contraseña303', 
    @ID_Rol = 3;
	go
EXEC Sp_RegistrarUsuario  @Nombre_Usuario = 'Fernando Martínez',@Correo_Usuario = 'fernando.martinez@saludplus.com',@Contraseña_Usuario = 'contraseña404', 
    @ID_Rol = 1;
	go

-- Permiso

EXEC Sp_RegistrarPermiso  @Nombre_Permiso = 'Ver Informes';
go
EXEC Sp_RegistrarPermiso @Nombre_Permiso = 'Modificar Informes';
go
EXEC Sp_RegistrarPermiso  @Nombre_Permiso = 'Eliminar Informes';
go
EXEC Sp_RegistrarPermiso  @Nombre_Permiso = 'Gestionar Recursos Médicos';
go

-- Rol Permiso

EXEC Sp_RegistrarRol_Permiso  @ID_Rol = 2,@ID_Permiso = 2;  -- M�dico puede ver citas
go
EXEC Sp_RegistrarRol_Permiso  @ID_Rol = 2,@ID_Permiso = 5;  -- M�dico puede acceder a historial m�dico
go
EXEC Sp_RegistrarRol_Permiso  @ID_Rol = 3,@ID_Permiso = 6;  -- Recepcionista puede gestionar pacientes
go
EXEC Sp_RegistrarRol_Permiso  @ID_Rol = 3,@ID_Permiso = 1;  -- Recepcionista puede crear citas
go


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
    @Telefono_Medico = '2345678901',@Nombre_Especialidad = 'Cardiología'; -- Cardiología
	go

-- Insertar m�dico 2
EXEC Sp_RegistrarMedico  @Nombre1_Medico = 'Carmen',@Nombre2_Medico = 'Teresa',@Apellido1_Medico = 'Ruiz',@Apellido2_Medico = 'Mena', 
    @Telefono_Medico = '3456789012',@Nombre_Especialidad = 'Dermatología'; -- Dermatología
	go
-- Insertar m�dico 3
EXEC Sp_RegistrarMedico  @Nombre1_Medico = 'Francisco',@Nombre2_Medico = 'Javier',@Apellido1_Medico = 'Hernandez',@Apellido2_Medico = 'Bermudez', 
    @Telefono_Medico = '4567890123',@Nombre_Especialidad = 'Radiología'; -- Radiología
	go

-- Insertar m�dico 4
EXEC Sp_RegistrarMedico  @Nombre1_Medico = 'Elena',@Nombre2_Medico = 'Cristina',@Apellido1_Medico = 'Alvarez',@Apellido2_Medico = 'Luna', 
    @Telefono_Medico = '5678901234',@Nombre_Especialidad = 'Pediatría'; -- Pediatría
	go

-- Insertar m�dico 5
EXEC Sp_RegistrarMedico @Nombre1_Medico = 'Ricardo',@Nombre2_Medico = 'Andrés',@Apellido1_Medico = 'Morales',@Apellido2_Medico = 'Santos', 
    @Telefono_Medico = '6789012345',@Nombre_Especialidad = 'Cirugía'; -- Cirugía
	go

-- Insertar estado de cita 1
EXEC Sp_RegistrarEstado_Cita   @Estado = 'En Espera';
go

-- Insertar estado de cita 2
EXEC Sp_RegistrarEstado_Cita  @Estado = 'No Asistió';
go
-- Insertar estado de cita 3
EXEC Sp_RegistrarEstado_Cita   @Estado = 'Finalizada';
go


-- Insertar cita 1
execute Sp_RegistrarCita  @Fecha_Cita= '2024-01-01',  @Hora_Cita= '08:00', @Cedula='456789012' , @ID_Medico=1, @Estado='Programada'
go
-- Insertar cita 2
EXEC Sp_RegistrarCita  @Fecha_Cita = '2024-06-01',@Hora_Cita = '08:30',@Cedula = '321654987',@ID_Medico = 2,@Estado='Programada';
go
-- Insertar cita 3
EXEC Sp_RegistrarCita   @Fecha_Cita = '2024-07-01',@Hora_Cita = '09:30',@Cedula = '987654321',@ID_Medico = 3,@Estado='Realizada';
go
-- Insertar cita 4
EXEC Sp_RegistrarCita  @Fecha_Cita = '2024-08-01',@Hora_Cita = '10:30',@Cedula = '456789012',@ID_Medico = 4,@Estado = 'Realizada';
go

-- Insertar cita 5
EXEC Sp_RegistrarCita  @Fecha_Cita = '2024-08-01',@Hora_Cita = '11:30',@Cedula = '867905532',@ID_Medico = 4,@Estado = 'Programada';
go


-- Insertar factura 1
EXEC Sp_RegistrarFactura   @Fecha_Factura = '2024-06-01', @Monto_Total = 1500.00,@Cedula='456789012',@ID_Cita = 1,@Descripcion_Tipo_Pago = 'Efectivo';
go
-- Insertar factura 2
EXEC Sp_RegistrarFactura  @Fecha_Factura = '2024-07-01',@Monto_Total = 2500.00,@Cedula = '867905532',@ID_Cita = 2, @Descripcion_Tipo_Pago = 'Tarjeta de debito';
go
-- Insertar factura 3
EXEC Sp_RegistrarFactura  @Fecha_Factura = '2024-08-01',@Monto_Total = 3500.00,@Cedula = '987654321',@ID_Cita = 3,@Descripcion_Tipo_Pago = 'Sinpe Movil';
go
-- Insertar factura 4
EXEC Sp_RegistrarFactura  @Fecha_Factura = '2024-09-01',@Monto_Total = 4500.00,@Cedula = '321654987',@ID_Cita = 4,@Descripcion_Tipo_Pago = 'Efectivo';
go
/*
--- Los pacientes ya tiene un historial medico registrado, hay que crear unos pacientes nuevos

 -- Insertar historial médico para el paciente con ID 6
EXEC Sp_RegistrarHistorial_Medico @Cedula = '123456987';
go
-- Insertar historial médico para el paciente con ID 7
EXEC Sp_RegistrarHistorial_Medico @Cedula = '123454322';
go
-- Insertar historial médico para el paciente con ID 8
EXEC Sp_RegistrarHistorial_Medico @Cedula = '867905532';
go
-- Insertar historial médico para el paciente con ID 9
EXEC Sp_RegistrarHistorial_Medico @Cedula = '508975568';
go
*/


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
EXEC Sp_RegistrarSala  @Nombre_Sala = 'Sala de Ginecología',@Capacidad_Sala = 4,@Descripcion_Tipo_Sala='Emergencias' , @Estado_Sala = 'Activa';
go
-- Insertar sala 2
EXEC Sp_RegistrarSala  @Nombre_Sala = 'Sala de Traumatología',@Capacidad_Sala = 5 , @Descripcion_Tipo_Sala='Cirugia'  ,@Estado_Sala = 'Activa'
go
-- Insertar sala 3
EXEC Sp_RegistrarSala  @Nombre_Sala = 'Sala de Cardiología',@Capacidad_Sala = 3,@Descripcion_Tipo_Sala= 'Consulta General',  @Estado_Sala = 'Activa';
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
    @Hora_Procedimiento = '11:00',@Monto_Procedimiento = 5000,@Receta = 'Reposo y seguimiento',@Nombre_Sala = 'Sala de Emergencias',@ID_Historial_Medico = 6,@ID_Cita = 6,
	@Nombre_Procedimiento = 'Emergencias';
	go
EXEC Sp_RegistrarProcedimiento @Descripcion_Procedimiento = 'Examen de laboratorio',@Fecha_Procedimiento = '2024-08-15',
    @Hora_Procedimiento = '09:30',@Monto_Procedimiento = 1500,@Receta = 'Ninguna',@Nombre_Sala = 'Sala de Cirugia',@ID_Historial_Medico = 7,@ID_Cita = 7,
	@Nombre_Procedimiento = 'Cita de Cirugía';
	go
EXEC Sp_RegistrarProcedimiento  @Descripcion_Procedimiento = 'Radiografía de abdomen',@Fecha_Procedimiento = '2024-08-20',
    @Hora_Procedimiento = '13:00',@Monto_Procedimiento = 2000,@Receta = 'Ninguna',@Nombre_Sala = 'Sala de Cirugia',@ID_Historial_Medico = 8,@ID_Cita = 8,
	@Nombre_Procedimiento = 'Cita de Cirugía';
	go
EXEC Sp_RegistrarProcedimiento  @Descripcion_Procedimiento = 'Consulta pediátrica',@Fecha_Procedimiento = '2024-09-01',@Hora_Procedimiento = '10:00',
     @Monto_Procedimiento = 6000,@Receta = 'Paracetamol si es necesario',@Nombre_Sala = 'Sala de Observacion',@ID_Historial_Medico = 5,@ID_Cita = 2,
	 @Nombre_Procedimiento = 'Cita de Diagnostico';
	 go
EXEC Sp_RegistrarProcedimiento  @Descripcion_Procedimiento = 'Consulta de ortopedia',@Fecha_Procedimiento = '2024-09-10', 
    @Hora_Procedimiento = '14:30',@Monto_Procedimiento = 7000,@Receta = 'Hielo y descanso',@Nombre_Sala = 'Sala de Emergencias',@ID_Historial_Medico =1,@ID_Cita = 10,
	@Nombre_Procedimiento = 'Emergencias';
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
    @Titulo_Recurso= 'Medicamento',@Estado_Recurso = 'Disponible';
	go
EXEC Sp_RegistrarRecurso_Medico  @Nombre_Recurso = 'Recurso 7',@Lote = 'Lote 7',@Cantidad_Stock_Total = 250,@Ubicacion_Recurso = 'Almacen 7', 
    @Titulo_Recurso = 'Equipo Médico',@Estado_Recurso = 'Disponible';
	go
EXEC Sp_RegistrarRecurso_Medico  @Nombre_Recurso = 'Recurso 8',@Lote = 'Lote 8',@Cantidad_Stock_Total = 350,@Ubicacion_Recurso = 'Almacen 8', 
    @Titulo_Recurso= 'Material de Oficina',@Estado_Recurso = 'Disponible';
	go
EXEC Sp_RegistrarRecurso_Medico  @Nombre_Recurso = 'Recurso 9',@Lote = 'Lote 9',@Cantidad_Stock_Total = 450,@Ubicacion_Recurso = 'Almacen 9', 
    @Titulo_Recurso= 'Suministro Médico',@Estado_Recurso = 'Disponible';
	go
*/