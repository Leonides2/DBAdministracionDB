import { useQuery } from "react-query"
import { Query } from "./services"

const useQueryGet = (query: string) => {
    return useQuery({
        queryKey: [query],    
        queryFn: () => Query(query)
    })
}

export default useQueryGet;