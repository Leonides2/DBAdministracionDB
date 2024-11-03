import EntityPage from "../Components/EntityPage"

const TiposSalas = () => {
    return (
        <EntityPage 
            title="Tipos de Salas"
            noEntitiesMessage="No se han añadido tipos de salas al sistema"
            addEntityMessage="Añadir tipo de sala"
            idFieldName="ID_Tipo_Sala"
            entityTableName="Tipo_Sala"
            addEntityFields={[
                ["Descripcion_Tipo_Sala", "text"],
            ]}
        />
    )
}

export default TiposSalas;
