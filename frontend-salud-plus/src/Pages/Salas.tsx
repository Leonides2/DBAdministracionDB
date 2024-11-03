import EntityPage from "../Components/EntityPage"

const Salas = () => {
    return (
        <EntityPage 
            title="Salas"
            noEntitiesMessage="No se han añadido salas al sistema"
            addEntityMessage="Añadir sala"
            idFieldName="ID_Sala"
            entityTableName="Sala"
            addEntityFields={[
                ["Nombre_Sala", "text"],
                ["Capacidad_Sala", "number"],
                ["ID_Tipo_Sala", "number"],
                ["ID_Estado_Sala", "number"],
            ]}
        />
    )
}

export default Salas;
