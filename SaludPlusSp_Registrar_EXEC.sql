-- Recurso medico sala
EXEC Sp_RegistrarRecurso_Medico_Sala  @Fecha = '2024-02-01',@Cantidad_Recurso = 25,@ID_Recurso_Medico = 1,@ID_Sala = 1;
go
EXEC Sp_RegistrarRecurso_Medico_Sala  @Fecha = '2024-02-02',@Cantidad_Recurso = 35,@ID_Recurso_Medico = 2,@ID_Sala = 2;
go
EXEC Sp_RegistrarRecurso_Medico_Sala  @Fecha = '2024-02-03',@Cantidad_Recurso = 45,@ID_Recurso_Medico = 6,@ID_Sala = 3;
go
EXEC Sp_RegistrarRecurso_Medico_Sala  @Fecha = '2024-02-04',@Cantidad_Recurso =  55,@ID_Recurso_Medico = 7,@ID_Sala = 8;
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

EXEC Sp_RegistrarPlanificacion_Recurso  @Descripcion_Planificacion = 'Planificación 6',@Fecha_Planificacion = '2024-06-01',@ID_Sala = 1, 
    @ID_Horario_Trabajo = 1;
	go
EXEC Sp_RegistrarPlanificacion_Recurso  @Descripcion_Planificacion = 'Planificación 7',@Fecha_Planificacion = '2024-07-01',@ID_Sala = 2, 
    @ID_Horario_Trabajo = 2;
	go
EXEC Sp_RegistrarPlanificacion_Recurso  @Descripcion_Planificacion = 'Planificación 8',@Fecha_Planificacion = '2024-08-01',@ID_Sala = 8, 
    @ID_Horario_Trabajo = 5;
	go
EXEC Sp_RegistrarPlanificacion_Recurso  @Descripcion_Planificacion = 'Planificación 9',@Fecha_Planificacion = '2024-09-01',@ID_Sala = 3, 
    @ID_Horario_Trabajo = 8;
	go


-- Medico planificacion recurso

EXEC Sp_RegistrarMedico_Planificacion_Recurso  @Fecha_Planificacion_Personal = '2024-02-01',@ID_Planificacion = 1,@ID_Medico = 1;
go
EXEC Sp_RegistrarMedico_Planificacion_Recurso  @Fecha_Planificacion_Personal = '2024-02-01',@ID_Planificacion = 2,@ID_Medico = 2;
go
EXEC Sp_RegistrarMedico_Planificacion_Recurso  @Fecha_Planificacion_Personal = '2024-02-01',@ID_Planificacion = 3,@ID_Medico = 3;
go
EXEC Sp_RegistrarMedico_Planificacion_Recurso  @Fecha_Planificacion_Personal = '2024-02-01',@ID_Planificacion = 4, @ID_Medico = 10;
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