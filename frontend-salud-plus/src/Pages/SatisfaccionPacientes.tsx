import EntityPage from "../Components/EntityPage"

const SatisfaccionPacientes = () => {
    return (
        <EntityPage 
            title="Evaluaciones de Satisfacción de Paciente"
            noEntitiesMessage="No se han añadido evaluaciones de satisfacción al sistema"
            addEntityMessage="Añadir evaluación de satisfacción"
            idFieldName="ID_Satisfaccion"
            entityTableName="Satisfaccion_Paciente"
            addEntityFields={[
                ["Fecha_Evaluacion", "date"],
                ["Calificacion_Satisfaccion", "number"],
                ["ID_Cita", "number"],
            ]}
        />
    )
}

export default SatisfaccionPacientes;
