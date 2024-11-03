import { useMutation } from "react-query";
import { LogIn } from "./services";

import { useNavigate } from "react-router-dom";

const useLogIn = () => {
    const navigate = useNavigate();

    return useMutation({
        mutationFn: LogIn,
        onSuccess: () => {
            alert("Inicio de sesión exitoso");
            navigate("/citas");
        },
        onError: () => {
            alert("El nombre de usuario o contraseña proveídos fueron incorrectos");
        }
    });
};

export default useLogIn;