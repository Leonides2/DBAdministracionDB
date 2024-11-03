import EntityPage from "../Components/EntityPage"

const TiposPago = () => {
    return (
        <EntityPage 
            title="Tipos de Pago"
            noEntitiesMessage="No se han añadido tipos de pago al sistema"
            addEntityMessage="Añadir tipo de pago"
            idFieldName="ID_Tipo_Pago"
            entityTableName="Tipo_Pago"
            addEntityFields={[
                ["Descripcion_Tipo_Pago", "text"], 
            ]}
        />
    )
}

export default TiposPago;
