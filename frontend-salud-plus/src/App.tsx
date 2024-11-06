import { Route, Routes } from "react-router-dom"
import Login from "./Pages/Login"
import Citas from "./Pages/Citas"
import Pacientes from "./Pages/Pacientes"
import Especialidades from "./Pages/Especialidades"
import EstadoCitas from "./Pages/EstadoCitas"
import EstadoRecursoMedicos from "./Pages/EstadoRecursoMedicos"
import EstadoSalas from "./Pages/EstadoSalas"
import Facturas from "./Pages/Facturas"
import HistorialesMedicos from "./Pages/HistorialesMedicos"
import HorariosDeTrabajo from "./Pages/HorariosDeTrabajo"
import Medicos from "./Pages/Medicos"
import TiposPago from "./Pages/TiposPago"
import Procedimientos from "./Pages/Procedimientos"
import TiposProcedimiento from "./Pages/TiposProcedimiento"
import RecursosMedicos from "./Pages/RecursosMedicos"
import TiposRecursos from "./Pages/TiposDeRecurso"
import Salas from "./Pages/Salas"
import TiposSalas from "./Pages/TiposSalas"
import RecursosMedicosSalas from "./Pages/RecursosMedicosSalas"
import PlanificacionesRecursos from "./Pages/PlanificacionesRecursos"
import MedicoPlanificacionRecursos from "./Pages/MedicoPlanificacionRecursos"
import SatisfaccionPacientes from "./Pages/SatisfaccionPacientes"

import Navbar from "./Components/Navbar"

import { Navigate } from "react-router-dom"
import RegisterUser from "./Pages/RegisterUser"

function App() {
  return (
    <>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/citas" element={<Citas />} />
        <Route path="/pacientes" element={<Pacientes />} />
        <Route path="/especialidades" element={<Especialidades />} />
        <Route path="/estado-citas" element={<EstadoCitas />} />
        <Route path="/estado-recurso-medicos" element={<EstadoRecursoMedicos />} />
        <Route path="/estado-salas" element={<EstadoSalas />} />
        <Route path="/facturas" element={<Facturas />} />
        <Route path="/historiales-medicos" element={<HistorialesMedicos />} />
        <Route path="/horarios-trabajo" element={<HorariosDeTrabajo />} />
        <Route path="/medicos" element={<Medicos />} />
        <Route path="/tipos-pago" element={<TiposPago />} />
        <Route path="/procedimientos" element={<Procedimientos />} />
        <Route path="/tipos-procedimiento" element={<TiposProcedimiento />} />
        <Route path="/recursos-medicos" element={<RecursosMedicos />} />
        <Route path="/tipos-recurso" element={<TiposRecursos />} />
        <Route path="/salas" element={<Salas />} />
        <Route path="/tipos-salas" element={<TiposSalas />} />
        <Route path="/recursos-medicos-salas" element={<RecursosMedicosSalas />} />
        <Route path="/planificaciones-recursos" element={<PlanificacionesRecursos />} />
        <Route path="/medico-planificaciones-recursos" element={<MedicoPlanificacionRecursos />} />
        <Route path="/satisfaccion-pacientes" element={<SatisfaccionPacientes />} />  
        <Route path="/registrar-usuario" element={<RegisterUser />} />
        <Route path="*" element={<Navigate to="/login" />} />
      </Routes>
    </>
  )
}

export default App
