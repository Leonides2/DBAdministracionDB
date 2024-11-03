import api from "./config";
import { LoginResponse, QueryResponse } from "./ResponseSchema";

export const LogOut = () => {
    localStorage.removeItem("user");
    localStorage.removeItem("password");
}

export const LogIn = ({user, password}: {user: string, password: string}) => {
    return api.post<LoginResponse>("/database/login", {
        user: user,
        password: password
    })
    .then(response => {
        if (response.data.status === "Success") {
            localStorage.setItem("user", user);
            localStorage.setItem("password", password);

            return true;
        };

        localStorage.removeItem("user");
        localStorage.removeItem("password");

        throw new Error("Login failed");
    })
};

export const Query = (query: string) => {
    const user = localStorage.getItem("user");
    const password = localStorage.getItem("password");
    
    return api.post<QueryResponse>("/database/query", {
        sqlQuery: query,
        user: user,
        password: password
    })
    .then(response => {
        if (response.data.status === "Success") {
            return response.data.recordset;
        }

        
        throw new Error(response.data.msg);
    })
};