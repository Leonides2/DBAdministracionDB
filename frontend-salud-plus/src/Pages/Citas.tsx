import EntityPage from "../Components/EntityPage"

const Citas = () => {
    return (
        <EntityPage 
            title="Citas"
            noEntitiesMessage="No se han añadido citas al sistema"
            addEntityMessage="Añadir cita"
            idFieldName="ID_Cita"
            entityTableName="Cita"
            addEntityFields={[
                ["Fecha_Cita", "date"], 
                ["Hora_Cita", "time"], 
                ["ID_Medico", "number"],
                ["Estado", "text"],
                ["Cedula", "text"],
            ]}
        />
    )
}

export default Citas;