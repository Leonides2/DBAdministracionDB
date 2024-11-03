import EntityPage from "../Components/EntityPage"

const Citas = () => {
    return (
        <EntityPage 
            title="Citas"
            getEntitiesQuery="SELECT * FROM Cita"
            noEntitiesMessage="No se han añadido citas al sistema"
            addEntityMessage="Añadir cita"
            idFieldName="ID_Cita"
            entityTableName="Cita"
        />
    )
}

export default Citas;