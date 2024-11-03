import { Route, Routes } from "react-router-dom"
import Login from "./Pages/Login"
import Citas from "./Pages/Citas"
import Pacientes from "./Pages/Pacientes"

function App() {
  return (
    <Routes>
      <Route path="/" element={<Login />} />
      <Route path="/citas" element={<Citas />} />
      <Route path="/pacientes" element={<Pacientes />} />
    </Routes>
  )
}

export default App
