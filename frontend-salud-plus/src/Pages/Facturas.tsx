import EntityPage from "../Components/EntityPage"

const Facturas = () => {
    return (
        <EntityPage 
            title="Facturas"
            noEntitiesMessage="No se han añadido facturas al sistema"
            addEntityMessage="Añadir factura"
            idFieldName="ID_Factura"
            entityTableName="Factura"
            addEntityFields={[
                ["Fecha_Factura", "date"], 
                ["Monto_Total", "number"], 
                ["Cedula", "text"],  
                ["ID_Cita", "number"],  
                ["Descripcion_Tipo_Pago", "text"],  
            ]}
        />
    )
}

export default Facturas;