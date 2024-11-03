import EntityPage from "../Components/EntityPage"

const Pacientes = () => {
    return (
        <EntityPage
            title="Pacientes"
            idFieldName="ID_Paciente"
            noEntitiesMessage="No existe ningún paciente"
            addEntityMessage="Añadir paciente"
            entityTableName="Paciente"
            addEntityFields={[
                ["Nombre_Paciente", "text"],
                ["Apellido1_Paciente", "text"],
                ["Apellido2_Paciente", "text"],
                ["Telefono_Paciente", "tel"],
                ["Fecha_Nacimiento", "date"],
                ["Direccion_Paciente", "text"],
                ["Cedula", "text"],
            ]}
        />
    )
}

export default Pacientes;