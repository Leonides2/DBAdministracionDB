import EntityPage from "../Components/EntityPage"

const EstadoSalas = () => {
    return (
        <EntityPage 
            title="Estados de Sala"
            noEntitiesMessage="No se han añadido estados de sala al sistema"
            addEntityMessage="Añadir estado de sala"
            idFieldName="ID_Estado_Sala"
            entityTableName="Estado_Sala"
            addEntityFields={[
                ["Nombre", "text"], 
            ]}
        />
    )
}

export default EstadoSalas;