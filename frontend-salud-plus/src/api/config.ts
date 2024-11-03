import axios, { AxiosRequestConfig } from "axios"

const config: AxiosRequestConfig = {
    baseURL: "http://localhost:3000",
    headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
        
    }
};

const api = axios.create(config);

export default api;