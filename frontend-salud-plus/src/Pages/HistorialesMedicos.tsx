import EntityPage from "../Components/EntityPage"

const HistorialesMedicos = () => {
    return (
        <EntityPage 
            title="Historiales Medicos"
            noEntitiesMessage="No se han añadido historiales medicos al sistema"
            addEntityMessage="Añadir historial medico"
            idFieldName="ID_Historial_Medico"
            entityTableName="Historial_Medico"
            addEntityFields={[
                ["Cedula", "text"]
            ]}
        />
    )
}

export default HistorialesMedicos;