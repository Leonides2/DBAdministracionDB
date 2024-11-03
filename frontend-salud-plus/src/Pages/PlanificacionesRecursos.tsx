import EntityPage from "../Components/EntityPage"

const PlanificacionesRecursos = () => {
    return (
        <EntityPage 
            title="Planificación de Recursos"
            noEntitiesMessage="No se han añadido planificaciones de recursos al sistema"
            addEntityMessage="Añadir planificación de recurso"
            idFieldName="ID_Planificacion"
            entityTableName="Planificacion_Recurso"
            addEntityFields={[
                ["Descripcion_Planificacion", "text"],
                ["Fecha_Planificacion", "date"],
                ["ID_Sala", "number"],
                ["ID_Horario_Trabajo", "number"],
            ]}
        />
    )
}

export default PlanificacionesRecursos;
