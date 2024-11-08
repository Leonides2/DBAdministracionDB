import EntityPage from "../Components/EntityPage"

const RecursosMedicos = () => {
    return (
        <EntityPage 
            title="Recursos Médicos"
            noEntitiesMessage="No se han añadido recursos médicos al sistema"
            addEntityMessage="Añadir recurso médico"
            idFieldName="ID_Recurso_Medico"
            entityTableName="Recurso_Medico"
            addEntityFields={[
                ["Nombre_Recurso", "text"],
                ["Lote", "text"],
                ["Cantidad_Stock_Total", "number"],
                ["Ubicacion_Recurso", "string"],
                ["Titulo_Recurso", "text"],
                ["Estado_Recurso", "text"],
            ]}
        />
    )
}

export default RecursosMedicos;
