import EntityPage from "../Components/EntityPage"

const RecursosMedicosSalas = () => {
    return (
        <EntityPage 
            title="Recursos Médicos en Salas"
            noEntitiesMessage="No se han añadido recursos médicos en salas al sistema"
            addEntityMessage="Añadir recurso médico en sala"
            idFieldName="ID_Recurso_Medico_Sala"
            entityTableName="Recurso_Medico_Sala"
            addEntityFields={[
                ["Fecha", "date"],
                ["Cantidad_Recurso", "number"],
                ["ID_Recurso_Medico", "number"],
                ["ID_Sala", "number"],
            ]}
        />
    )
}

export default RecursosMedicosSalas;
