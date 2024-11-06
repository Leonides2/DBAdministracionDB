import { useForm } from "react-hook-form";
import "./Login.css"

import useLogIn from "../api/useLogIn";
import { useEffect } from "react";
import { useNavigate } from "react-router-dom";

type FormData = {
    password: string,
    user: string
};

const Login = () => {
    const { register, handleSubmit } = useForm<FormData>();
    const { mutate: logIn } = useLogIn();
    const navigate = useNavigate();

    useEffect(() => {
        if (localStorage.getItem("user")) {
            navigate("/citas");
        }
    }, [])
    
    const AttemptLogIn = (data: FormData) => {
        logIn({user: data.user, password: data.password});   
    }
    
    return (
        <div className="login-page">
            <div className="login-page-form-container">
                <h1>Sistema Salud Plus</h1>
                <h3>Inicio de sesión:</h3>
                <form onSubmit={handleSubmit(AttemptLogIn)}>
                    <label>Nombre de usuario:</label>
                    <input className="form-control" type="text" {...register("user", {
                        required: true
                    })}></input>
                    <label>Contraseña:</label>
                    <input className="form-control" type="password" {...register("password", {
                        required: true
                    })}></input>
                    <button className="btn btn-primary" type="submit">Iniciar sesión</button>
                </form>
            </div>
        </div>
    )
}

export default Login;