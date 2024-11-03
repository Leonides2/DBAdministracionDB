import EntityPage from "../Components/EntityPage"

const TiposProcedimiento = () => {
    return (
        <EntityPage 
            title="Tipos de Procedimiento"
            noEntitiesMessage="No se han añadido tipos de procedimiento al sistema"
            addEntityMessage="Añadir tipo de procedimiento"
            idFieldName="ID_Tipo_Procedimiento"
            entityTableName="Tipo_Procedimiento"
            addEntityFields={[
                ["Nombre_Procedimiento", "text"],
            ]}
        />
    )
}

export default TiposProcedimiento;
