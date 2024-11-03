import useQueryGet from "../api/useQueryGet";
import AddEntityForm from "./AddEntityForm";
import EntityPageRow from "./EntityPageRow";
import useModal from "./useModal";

type PageProperties = {
    title: string,
    noEntitiesMessage: string,
    getEntitiesQuery: string,
    addEntityMessage: string
    idFieldName: string,
    entityTableName: string
    addEntityFields: [string, string][]
}

const EntityPage = ({title, getEntitiesQuery, noEntitiesMessage, addEntityMessage, idFieldName, entityTableName, addEntityFields}: PageProperties) => {
    const { data: entities, isLoading, error, refetch } = useQueryGet(getEntitiesQuery);
    const { setShow, Modal } = useModal();

    if (isLoading) {
        return <></>
    }
    
    if (error) {
        return <div>Algo salió mal</div>
    }
    
    return (
        <>
            <h1>{title}</h1>
            <button type="button" className="btn btn-primary" onClick={() => setShow(true)}>{addEntityMessage}</button>
            {
                entities.length === 0 ? <div>{noEntitiesMessage}</div>
                : 
                <table className="table table-light table-striped">
                    <thead>
                        <tr>
                            {
                                Object.entries(entities[0]).map(([key, _]) => (
                                    <th key={key}>{key}</th>                               
                                ))
                            }
                            <th>Borrar</th>
                            <th>Editar</th>
                        </tr>
                    </thead>
                    <tbody>
                        {
                            entities.map(entity => (
                                <EntityPageRow key={entity[idFieldName]} 
                                    entity={entity} 
                                    idFieldName={idFieldName}
                                    tableName={entityTableName}
                                    refetchFn={refetch}
                                />
                            ))
                        }
                    </tbody>
                </table>
            }
            <Modal>
                <AddEntityForm tableName={entityTableName} addEntityFields={addEntityFields} refetchFn={refetch} />
            </Modal>
        </>
    )
}

export default EntityPage;