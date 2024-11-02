type ResponseStatus = "Success" | "Failure";

export type LoginResponse = {
    status: ResponseStatus,
};

export type QueryResponse = {
    status: ResponseStatus,
    msg?: string,
    recordset?: any
};