import EntityPage from "../Components/EntityPage"

const Citas = () => {
    return (
        <EntityPage 
            title="Citas"
            getEntitiesQuery="SELECT * FROM Cita"
            noEntitiesMessage="No se han añadido citas al sistema"
            addEntityMessage="Añadir cita"
            idFieldName="ID_Cita"
            entityTableName="Cita"
            addEntityFields={[
                ["Fecha_Cita", "date"], 
                ["Hora_Cita", "time"], 
                ["ID_Estado_Cita", "number"],
                ["ID_Paciente", "number"],
                ["ID_Medico", "number"],
            ]}
        />
    )
}

export default Citas;