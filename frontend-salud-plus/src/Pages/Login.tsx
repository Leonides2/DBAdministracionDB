import { useForm } from "react-hook-form";
import "./Login.css"

import useLogIn from "../api/useLogIn";

type FormData = {
    password: string,
    user: string
};

const Login = () => {
    const { register, handleSubmit } = useForm<FormData>();
    const { mutate: logIn } = useLogIn();

    const AttemptLogIn = (data: FormData) => {
        logIn({user: data.user, password: data.password});   
    }
    
    return (
        <div className="login-page">
            <div>
                <h1>Salud Plus</h1>
                <h3>Inicio de sesión:</h3>
                <form onSubmit={handleSubmit(AttemptLogIn)}>
                    <label>Nombre de usuario:</label>
                    <input type="text" {...register("user", {
                        required: true
                    })}></input>
                    <label>Contraseña:</label>
                    <input type="password" {...register("password", {
                        required: true
                    })}></input>
                    <button type="submit">Iniciar sesión</button>
                </form>
            </div>
        </div>
    )
}

export default Login;