import EntityPage from "../Components/EntityPage"

const MedicoPlanificacionRecursos = () => {
    return (
        <EntityPage 
            title="Medico-Planificación"
            noEntitiesMessage="No se han relacionado planificaciones con médicos en el sistema"
            addEntityMessage="Añadir planificación de médico"
            idFieldName="ID_Medico_Planificacion_Recurso"
            entityTableName="Medico_Planificacion_Recurso"
            addEntityFields={[
                ["Fecha_Planificacion_Personal", "date"],
                ["Descripcion_Planificacion", "text"],
                ["ID_Medico", "number"],
            ]}
        />
    )
}

export default MedicoPlanificacionRecursos;
