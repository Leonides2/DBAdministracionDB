import EntityPage from "../Components/EntityPage"

const Procedimientos = () => {
    return (
        <EntityPage 
            title="Procedimientos"
            noEntitiesMessage="No se han añadido procedimientos al sistema"
            addEntityMessage="Añadir procedimiento"
            idFieldName="ID_Procedimiento"
            entityTableName="Procedimiento"
            addEntityFields={[
                ["Descripcion_Procedimiento", "text"],
                ["Fecha_Procedimiento", "date"],
                ["Hora_Procedimiento", "time"],
                ["Monto_Procedimiento", "number"],
                ["Receta", "text"],
                ["ID_Sala", "number"],
                ["ID_Historial_Medico", "number"],
                ["ID_Cita", "number"],
                ["ID_Tipo_Procedimiento", "number"],
            ]}
        />
    )
}

export default Procedimientos;
