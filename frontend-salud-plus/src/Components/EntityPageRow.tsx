import { useState } from "react";
import { useForm } from "react-hook-form";
import useQueryPost from "../api/useQueryPost";

const EntityPageRow = ({entity, idFieldName, tableName, refetchFn, entityFields}: {entity: any, idFieldName: string, tableName: string, refetchFn: () => void, entityFields: [string, string][]}) => {
    const [edit, setEdit] = useState(false);
    const { register, reset, handleSubmit } = useForm();
    const { mutate: postUpdateQuery } = useQueryPost(() => {
        refetchFn();
        alert("Se actualizaron los datos exitosamente");
    });

    const { mutate: postDeleteQuery } = useQueryPost(() => {
        refetchFn();
        alert("Se eliminó el dato exitosamente");
    });

    const UpdateValues = (data: any) => {
        /*postUpdateQuery([`UPDATE ${tableName} SET `, Object.entries(entity).filter(([key, _]) => key !== idFieldName).map(([key, value]) => 
            `${key} = ${typeof(value) !== "string" ? data[key] : `'${data[key]}'` }`
        ).join(', '), `WHERE ${idFieldName} = ${entity[idFieldName]}`].join(' '));*/

        postUpdateQuery([`EXEC Sp_Modificar${tableName}`,
            `@${idFieldName} = ${entity[idFieldName]},`,
            entityFields.map(([fieldName, fieldType]) => fieldType === "number" ? `@${fieldName} = ${data[fieldName]}` : `@${fieldName} = '${data[fieldName]}'`).join(', '),
        ].join(' '));

        reset();
        setEdit(false);
    }

    const DeleteEntity = () => {
        postDeleteQuery(`EXEC Sp_Eliminar${tableName} ${entity[idFieldName]}`);
    }

    const cancelEdit = () => {
        reset();
        setEdit(false);
    }

    if (!edit) {
        return (
            <tr>
                {
                    Object.entries(entity).map(([key, value]: [string, any]) => (
                        <td key={key}>
                            {value}
                        </td>
                    ))
                }
                <td>
                    <button className="btn btn-danger" type="button" onClick={DeleteEntity}>Eliminar</button>
                </td>
                <td>
                    <button type="button" className="btn btn-primary" onClick={() => setEdit(true)}>Modificar</button>
                </td>
            </tr>
        )
    }

    // Edit mode
    return (
        <tr>
            {
                Object.entries(entity).map(([key, value]: [string, any]) => key !== idFieldName ? (
                    <td key={key}>
                        <input type={entityFields.find(([fieldName, _]) => fieldName === key)?.[1]} className="form-control" defaultValue={value} {...register(key, {
                            required: true
                        })} />
                    </td>
                ) : 
                    <td key={key}>
                        {value}
                    </td>
                )
            }
            <td>
                <button className="btn btn-danger" type="button" onClick={DeleteEntity}>Eliminar</button>
            </td>
            <td style={{display: "flex", flexDirection: "column"}}>
                <button type="button" className="btn btn-primary mb-1" onClick={handleSubmit(UpdateValues)}>Guardar</button>
                <button type="button" className="btn btn-secondary" onClick={cancelEdit}>Cancelar</button>
            </td>
        </tr>
    )
}

export default EntityPageRow;