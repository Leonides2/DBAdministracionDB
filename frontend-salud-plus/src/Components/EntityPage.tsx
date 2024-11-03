import useQueryGet from "../api/useQueryGet";
import AddEntityForm from "./AddEntityForm";
import EntityPageRow from "./EntityPageRow";
import Navbar from "./Navbar";
import useModal from "./useModal";

type PageProperties = {
    title: string,
    noEntitiesMessage: string,
    addEntityMessage: string
    idFieldName: string,
    entityTableName: string
    addEntityFields: [string, string][]
}

const EntityPage = ({title, noEntitiesMessage, addEntityMessage, idFieldName, entityTableName, addEntityFields}: PageProperties) => {
    const { data: entities, isLoading, error, refetch } = useQueryGet(`SELECT * FROM ${entityTableName}`);
    const { setShow, Modal } = useModal();

    if (isLoading) {
        return <Navbar />
    }
    
    if (error) {
        return <div>Algo salió mal</div>
    }
    
    return (
        <>
            <Navbar />
            <h1 className="ms-2">{title}</h1>
            <button type="button" className="btn btn-primary mb-3 ms-2" onClick={() => setShow(true)}>{addEntityMessage}</button>
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