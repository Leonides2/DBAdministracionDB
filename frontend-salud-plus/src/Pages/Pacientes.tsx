import EntityPage from "../Components/EntityPage"

const Pacientes = () => {
    return (
        <EntityPage
            title="Pacientes"
            getEntitiesQuery="SELECT * FROM Paciente"
            idFieldName="ID_Paciente"
            noEntitiesMessage="No existe ningún paciente"
            addEntityMessage="Añadir paciente"
            entityTableName="Paciente"
        />
    )
}

export default Pacientes;