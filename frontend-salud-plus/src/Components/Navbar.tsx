import { Link } from "react-router-dom";

const Navbar = () => {
    return (
        <nav className="navbar navbar-expand-lg navbar-light bg-light p-3" style={{overflowX: "auto"}}>
            <Link className="navbar-brand mr-2" to="/citas">Citas</Link>
            <Link className="navbar-brand mr-2" to="/pacientes">Pacientes</Link>
            <Link className="navbar-brand mr-2" to="/especialidades">Especialidades</Link>
            <Link className="navbar-brand mr-2" to="/facturas">Facturas</Link>
            <Link className="navbar-brand mr-2" to="/estado-citas">Estados de Cita</Link>
            <Link className="navbar-brand mr-2" to="/estado-recurso-medicos">Estados de Recurso Medico</Link>
            <Link className="navbar-brand mr-2" to="/estado-salas">Estados de Sala</Link>
            <Link className="navbar-brand mr-2" to="/historiales-medicos">Historiales Medicos</Link>
            <Link className="navbar-brand mr-2" to="/horarios-trabajo">Horarios de Trabajo</Link>
            <Link className="navbar-brand mr-2" to="/medicos">Medicos</Link>
            <Link className="navbar-brand mr-2" to="/tipos-pago">Tipos de Pago</Link>
            <Link className="navbar-brand mr-2" to="/procedimientos">Procedimientos</Link>
            <Link className="navbar-brand mr-2" to="/tipos-procedimiento">Tipos de Procedimiento</Link>
            <Link className="navbar-brand mr-2" to="/recursos-medicos">Recursos Medicos</Link>
            <Link className="navbar-brand mr-2" to="/tipos-recurso">Tipos de Recurso</Link>
            <Link className="navbar-brand mr-2" to="/salas">Salas</Link>
            <Link className="navbar-brand mr-2" to="/tipos-salas">Tipos de Salas</Link>
            <Link className="navbar-brand mr-2" to="/recursos-medicos-salas">Recursos Medicos en Salas</Link>
            <Link className="navbar-brand mr-2" to="/planificaciones-recursos">Planificaciones de Recursos</Link>
            <Link className="navbar-brand mr-2" to="/medico-planificaciones-recursos">Medico-Planificaciones</Link>
            <Link className="navbar-brand mr-2" to="/satisfaccion-pacientes">Evaluaciones de Satisfacción</Link>
        </nav>
    )
}

export default Navbar;