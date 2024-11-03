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
                ["Monto_Total", "number"], // TODO: MONEY 
                ["ID_Paciente", "number"],  
                ["ID_Paciente", "number"],  
                ["ID_Cita", "number"],  
                ["ID_Tipo_Pago", "number"],  
            ]}
        />
    )
}

export default Facturas;