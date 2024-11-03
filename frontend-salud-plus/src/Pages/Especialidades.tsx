import EntityPage from "../Components/EntityPage";

const Especialidades = () => {
    return (
        <EntityPage
            title="Especialidades"
            idFieldName="ID_Especialidad"
            noEntitiesMessage="No se han añadido especialidades"
            addEntityMessage="Añadir especialidad"
            entityTableName="Especialidad"
            addEntityFields={[["Nombre_Especialidad", "text"]]}
        />
    )
}

export default Especialidades;