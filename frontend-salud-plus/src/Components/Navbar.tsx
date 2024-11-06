import { useState } from "react";
import {useNavigate } from "react-router-dom";

import './Navbar.css'

const Navbar = () => {
    const [selectedIndex, setSelectedIndex] = useState<number | null>(null);

    const navigate = useNavigate();

    // Define las rutas y etiquetas de los botones
    const links = [
        { path: "/citas", label: "Citas" },
        { path: "/pacientes", label: "Pacientes" },
        { path: "/especialidades", label: "Especialidades" },
        { path: "/facturas", label: "Facturas" },
        { path: "/estado-citas", label: "Estados de Cita" },
        { path: "/estado-recurso-medicos", label: "Estados de Recurso Medico" },
        { path: "/estado-salas", label: "Estados de Sala" },
        { path: "/historiales-medicos", label: "Historiales Medicos" },
        { path: "/horarios-trabajo", label: "Horarios de Trabajo" },
        { path: "/medicos", label: "Medicos" },
        { path: "/tipos-pago", label: "Tipos de Pago" },
        { path: "/procedimientos", label: "Procedimientos" },
        { path: "/tipos-procedimiento", label: "Tipos de Procedimiento" },
        { path: "/recursos-medicos", label: "Recursos Medicos" },
        { path: "/tipos-recurso", label: "Tipos de Recurso" },
        { path: "/salas", label: "Salas" },
        { path: "/tipos-salas", label: "Tipos de Salas" },
        { path: "/recursos-medicos-salas", label: "Recursos Medicos en Salas" },
        { path: "/planificaciones-recursos", label: "Planificaciones de Recursos" },
        { path: "/medico-planificaciones-recursos", label: "Medico-Planificaciones" },
        { path: "/satisfaccion-pacientes", label: "Evaluaciones de Satisfacción" },
        { path: "/registro-usuario", label: "Registro de Usuarios" },
    ];

    const handleButtonClick = (index: number) => {
        setSelectedIndex(index);
    };

    return (
        <nav className="navbar navbar-expand-lg navbar-light bg-light p-3" >
            {
            links.map((link, index) => (
                
                
                    //<Link key={link.path} className="mr-2" to={link.path}>
                
                    <button
                        type="button"
                        className={`btn btn-sm ${selectedIndex === index ? "btn-primary" : "btn-outline-secondary"}`}
                        onClick={() => {
                            handleButtonClick(index)
                            navigate(link.path)
                        }}
                    >
                        {link.label}
                    </button>
                    
                    //</Link>
                    
            ))}
        </nav>
    );
};

export default Navbar;