import { Link } from "react-router-dom";

const Navbar = () => {
    return (
        <nav className="navbar navbar-expand-lg navbar-light bg-light p-3" style={{overflowX: "auto"}}>
            <Link className="mr-2" to="/citas"><button type="button" className="btn btn-sm btn-outline-secondary">Citas</button></Link>
            <Link className="mr-2" to="/pacientes"><button type="button" className="btn btn-sm btn-outline-secondary">Pacientes</button></Link>
            <Link className="mr-2" to="/especialidades"><button type="button" className="btn btn-sm btn-outline-secondary">Especialidades</button></Link>
            <Link className="mr-2" to="/facturas"><button type="button" className="btn btn-sm btn-outline-secondary">Facturas</button></Link>
            <Link className="mr-2" to="/estado-citas"><button type="button" className="btn btn-sm btn-outline-secondary">Estados de Cita</button></Link>
            <Link className="mr-2" to="/estado-recurso-medicos"><button type="button" className="btn btn-sm btn-outline-secondary">Estados de Recurso Medico</button></Link>
            <Link className="mr-2" to="/estado-salas"><button type="button" className="btn btn-sm btn-outline-secondary">Estados de Sala</button></Link>
            <Link className="mr-2" to="/historiales-medicos"><button type="button" className="btn btn-sm btn-outline-secondary">Historiales Medicos</button></Link>
            <Link className="mr-2" to="/horarios-trabajo"><button type="button" className="btn btn-sm btn-outline-secondary">Horarios de Trabajo</button></Link>
            <Link className="mr-2" to="/medicos"><button type="button" className="btn btn-sm btn-outline-secondary">Medicos</button></Link>
            <Link className="mr-2" to="/tipos-pago"><button type="button" className="btn btn-sm btn-outline-secondary">Tipos de Pago</button></Link>
            <Link className="mr-2" to="/procedimientos"><button type="button" className="btn btn-sm btn-outline-secondary">Procedimientos</button></Link>
            <Link className="mr-2" to="/tipos-procedimiento"><button type="button" className="btn btn-sm btn-outline-secondary">Tipos de Procedimiento</button></Link>
            <Link className="mr-2" to="/recursos-medicos"><button type="button" className="btn btn-sm btn-outline-secondary">Recursos Medicos</button></Link>
            <Link className="mr-2" to="/tipos-recurso"><button type="button" className="btn btn-sm btn-outline-secondary">Tipos de Recurso</button></Link>
            <Link className="mr-2" to="/salas"><button type="button" className="btn btn-sm btn-outline-secondary">Salas</button></Link>
            <Link className="mr-2" to="/tipos-salas"><button type="button" className="btn btn-sm btn-outline-secondary">Tipos de Salas</button></Link>
            <Link className="mr-2" to="/recursos-medicos-salas"><button type="button" className="btn btn-sm btn-outline-secondary">Recursos Medicos en Salas</button></Link>
            <Link className="mr-2" to="/planificaciones-recursos"><button type="button" className="btn btn-sm btn-outline-secondary">Planificaciones de Recursos</button></Link>
            <Link className="mr-2" to="/medico-planificaciones-recursos"><button type="button" className="btn btn-sm btn-outline-secondary">Medico-Planificaciones</button></Link>
            <Link className="mr-2" to="/satisfaccion-pacientes"><button type="button" className="btn btn-sm btn-outline-secondary">Evaluaciones de Satisfacción</button></Link>
            <Link className="mr-2" to="/registro-usuario"><button type="button" className="btn btn-sm btn-outline-secondary">Registro de Usuarios</button></Link>
        </nav>
    )
}

export default Navbar;