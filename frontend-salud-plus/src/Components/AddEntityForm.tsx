import { useForm } from "react-hook-form";
import useQueryPost from "../api/useQueryPost";

const AddEntityForm = ({tableName, addEntityFields, refetchFn}: {tableName: string, addEntityFields: [string, string][], refetchFn: () => void}) => {
    const { register, handleSubmit } = useForm();
    const { mutate: postQueryAdd } = useQueryPost(() => {
        refetchFn();
        alert("Se añadió la entidad exitosamente");
    });
    
    const addEntity = (data: any) => {
        postQueryAdd([
            `INSERT INTO ${tableName} (`,
            addEntityFields.map(([fieldName, _]) => fieldName).join(', '),
            `) VALUES (`,
            addEntityFields.map(([fieldName, fieldType]) => fieldType === "number" ? data[fieldName] : `'${data[fieldName]}'`).join(', '),
            ')'
        ].join(''));
    }

    return (
        <form className="card p-3" style={{minWidth: 500, maxHeight: 600, overflowY: "auto"}} onSubmit={handleSubmit(addEntity)}>
            {
                addEntityFields.map(([fieldName, fieldType]) => (
                    <>
                        <label>{fieldName}</label>
                        <input className="form-control mb-2" type={fieldType} {...register(fieldName, {required: true})} />
                    </>
                )) 
            }
            <button type="submit" className="btn btn-primary">Añadir</button>
        </form>
    )
}

export default AddEntityForm;