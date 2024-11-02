import { useMutation } from "react-query"
import { Query } from "./services"

const useQueryPost = (onSuccess: () => void) => {
    return useMutation({
        mutationFn: Query,
        onSuccess: onSuccess,
        onError: () => {
            alert("Algo salió mal....")
        }
    })
}

export default useQueryPost;