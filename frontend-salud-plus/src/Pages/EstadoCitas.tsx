import EntityPage from "../Components/EntityPage"

const EstadoCitas = () => {
    return (
        <EntityPage 
            title="Estados de Cita"
            noEntitiesMessage="No se han añadido estados de cita al sistema"
            addEntityMessage="Añadir estado de cita"
            idFieldName="ID_Estado_Cita"
            entityTableName="Estado_Cita"
            addEntityFields={[
                ["Estado", "text"], 
            ]}
        />
    )
}

export default EstadoCitas;