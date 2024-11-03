import EntityPage from "../Components/EntityPage"

const EstadoRecursoMedicos = () => {
    return (
        <EntityPage 
            title="Estados de Recurso Medico"
            noEntitiesMessage="No se han añadido estados de recurso medico al sistema"
            addEntityMessage="Añadir estado de recurso medico"
            idFieldName="ID_Estado_Recurso_Medico"
            entityTableName="Estado_Recurso_Medico"
            addEntityFields={[
                ["Estado_Recurso", "text"], 
            ]}
        />
    )
}

export default EstadoRecursoMedicos;