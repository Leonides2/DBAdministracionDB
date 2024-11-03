import EntityPage from "../Components/EntityPage"

const HorariosDeTrabajo = () => {
    return (
        <EntityPage 
            title="Horarios de Trabajo"
            noEntitiesMessage="No se han añadido horarios de trabajo al sistema"
            addEntityMessage="Añadir horario de trabajo"
            idFieldName="ID_Horario_Trabajo"
            entityTableName="Horario_Trabajo"
            addEntityFields={[
                ["Nombre_Horario", "text"], 
                ["Hora_Inicio", "time"],
                ["Hora_Fin", "time"]
            ]}
        />
    )
}

export default HorariosDeTrabajo;