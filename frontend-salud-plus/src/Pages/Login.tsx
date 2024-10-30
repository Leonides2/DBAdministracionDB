import { useForm } from "react-hook-form";
import "./Login.css"

type FormData = {
    password: string,
    username: string
};

const Login = () => {
    const { register, handleSubmit } = useForm<FormData>();

    const AttemptLogIn = (data: FormData) => {
        alert(JSON.stringify(data));
    }
    
    return (
        <div className="login-page">
            <div>
                <h1>Salud Plus</h1>
                <h3>Inicio de sesión:</h3>
                <form onSubmit={handleSubmit(AttemptLogIn)}>
                    <label>Nombre de usuario:</label>
                    <input type="text" {...register("username", {
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