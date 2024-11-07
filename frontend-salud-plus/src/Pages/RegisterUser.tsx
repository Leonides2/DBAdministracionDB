import { useForm } from "react-hook-form";
import useQueryGet from "../api/useQueryGet";
import useQueryPost from "../api/useQueryPost";

type FormData = {
    username: string,
    password: string,
    confirmPassword: string,
    roleName: string
}

const RegisterUser = () => {
    const { register, handleSubmit, reset } = useForm<FormData>();
    const { data: roles, isLoading, error } = useQueryGet("SELECT * FROM Rol");
    const { mutate: postQueryAdd } = useQueryPost(() => {
        alert("El usuario fue añadido exitosamente");
        reset();
    });

    const registerUser = (data: FormData) => {
        if (data.password !== data.confirmPassword) {
            alert("Las contraseñas no coinciden");
            return;
        }

        postQueryAdd(`EXEC Sp_RegistrarUsuarioSistema 
            @NombreUsuario = '${data.username}',
            @Contrasena = '${data.password}',
            @Rol = '${data.roleName}'`
        )
    }

    if (isLoading) {
        return <></>
    }

    if (error) {
        return (
            <>
                <div>Algo salió mal... O seguro no tienes permisos para acceder a esta area</div>
            </>
        )
    }
    
    return (
        <>
            <h1 className="ms-2">Registrar usuarios</h1>
            <form onSubmit={handleSubmit(registerUser)} style={{width: "35%"}}>
                <label className="ms-2">Nombre de usuario</label>
                <input type="text" className="form-control ms-2" {...register("username")}></input>
                <label className="ms-2">Contraseña</label>
                <input type="password" className="form-control ms-2" {...register("password")}></input>
                <label className="ms-2">Confirmar contraseña</label>
                <input type="password" className="form-control ms-2" {...register("confirmPassword")}></input>
                <label className="ms-2">Rol</label>
                <select className="form-select ms-2"{...register("roleName")}>
                    {
                        roles.map((rol: any) => <option key={rol.ID_Rol} value={rol.Nombre_Rol}>{rol.Nombre_Rol}</option>)
                    }
                </select>
                <button type="submit" className="btn btn-primary ms-2 mt-2">Registrar usuario</button>
            </form>
        </>
    )
}

export default RegisterUser;