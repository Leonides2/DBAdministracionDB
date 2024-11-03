import { Fragment, useState } from "react";
import { useForm } from "react-hook-form";
import useQueryPost from "../api/useQueryPost";

const EntityPageRow = ({entity, idFieldName, tableName, refetchFn}: {entity: any, idFieldName: string, tableName: string, refetchFn: () => void}) => {
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
        postUpdateQuery([`UPDATE ${tableName} SET `, Object.entries(entity).filter(([key, _]) => key !== idFieldName).map(([key, value]) => 
            `${key} = ${typeof(value) !== "string" ? data[key] : `'${data[key]}'` }`
        ).join(', '), `WHERE ${idFieldName} = ${entity[idFieldName]}`].join(' '));
        reset();
        setEdit(false);
    }

    const DeleteEntity = () => {
        postDeleteQuery(`DELETE FROM ${tableName} WHERE ${idFieldName} = ${entity[idFieldName]}`);
    }

    if (!edit) {
        return (
            <tr>
                {
                    Object.entries(entity).map(([key, value]) => (
                        <td key={key}>
                            {value}
                        </td>
                    ))
                }
                <td>
                    <button className="btn btn-danger" type="button" onClick={DeleteEntity}>Eliminar</button>
                </td>
                <td>
                    {
                        <button type="button" className="btn btn-primary" onClick={() => setEdit(true)}>Modificar</button>
                    }
                    </td>
            </tr>
        )
    }

    // Edit mode
    return (
        <tr>
            {
                Object.entries(entity).map(([key, value]) => key !== idFieldName ? (
                    <td key={key}>
                        <input className="form-control" defaultValue={value} {...register(key, {
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
            <td>
                {
                    <button type="button" className="btn btn-primary" onClick={handleSubmit(UpdateValues)}>Guardar</button>
                }
            </td>
        </tr>
    )
}

export default EntityPageRow;