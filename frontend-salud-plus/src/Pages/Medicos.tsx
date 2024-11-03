import EntityPage from "../Components/EntityPage"

const Medicos = () => {
    return (
        <EntityPage 
            title="Medicos"
            noEntitiesMessage="No se han añadido medicos al sistema"
            addEntityMessage="Añadir medico"
            idFieldName="ID_Medico"
            entityTableName="Medico"
            addEntityFields={[
                ["Nombre1_Medico", "text"], 
                ["Nombre2_Medico", "text"], 
                ["Apellido1_Medico", "text"], 
                ["Apellido2_Medico", "text"], 
                ["Telefono_Medico", "text"], 
                ["ID_Especialidad", "number"]
            ]}
        />
    )
}

export default Medicos;