import EntityPage from "../Components/EntityPage"

const TiposRecursos = () => {
    return (
        <EntityPage 
            title="Tipos de Recursos"
            noEntitiesMessage="No se han añadido tipos de recursos al sistema"
            addEntityMessage="Añadir tipo de recurso"
            idFieldName="ID_Tipo_Recurso"
            entityTableName="Tipo_Recurso"
            addEntityFields={[
                ["Titulo_Recurso", "text"],
            ]}
        />
    )
}

export default TiposRecursos;
