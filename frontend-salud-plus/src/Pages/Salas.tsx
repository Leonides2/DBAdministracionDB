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
                ["Descripcion_Tipo_Sala", "text"],
                ["Estado_Sala", "text"],
            ]}
        />
    )
}

export default Salas;
