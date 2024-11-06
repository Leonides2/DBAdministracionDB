import { useForm } from "react-hook-form";
import useQueryGet from "../api/useQueryGet";
import Navbar from "../Components/Navbar";

type FormData = {
    username: string,
    password: string,
    confirmPassword: string,
    roleId: number
}

const RegisterUser = () => {
    const { register, handleSubmit } = useForm<FormData>();
    const { data: roles, isLoading, error } = useQueryGet("SELECT * FROM Rol");

    const registerUser = (data: FormData) => {
        if (data.password !== data.confirmPassword) {
            alert("Las contraseñas no coinciden");
            return;
        }

        
        
        alert(JSON.stringify(data));
    }

    if (isLoading) {
        return <></>
    }

    if (error) {
        return <div>Algo salió mal...</div>
    }
    
    return (
        <>
            <Navbar />
            <h1 className="ms-2">Registrar usuarios</h1>
            <form onSubmit={handleSubmit(registerUser)} style={{width: "35%"}}>
                <label className="ms-2">Nombre de usuario</label>
                <input type="text" className="form-control ms-2" {...register("username")}></input>
                <label className="ms-2">Contraseña</label>
                <input type="password" className="form-control ms-2" {...register("password")}></input>
                <label className="ms-2">Confirmar Contraseña</label>
                <input type="password" className="form-control ms-2" {...register("confirmPassword")}></input>
                <label className="ms-2">Rol</label>
                <select className="form-select ms-2"{...register("roleId")}>
                    {
                        roles.map((rol: any) => <option value={rol.ID_Rol}>{rol.Nombre_Rol}</option>)
                    }
                </select>
                <button type="submit" className="btn btn-primary ms-2 mt-2">Registrar usuario</button>
            </form>
        </>
    )
}

export default RegisterUser;