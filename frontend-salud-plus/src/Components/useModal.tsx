import { ReactNode, useState } from "react"
import "./Modal.css"

const useModal = () => {
    const [show, setShow] = useState(false);

    return {
        setShow: setShow,
        Modal: ({children}: {children: ReactNode}) => (            
            show ? 
                <div className="modal-wrapper" onClick={(e) => {
                    if (e.target == e.currentTarget) {
                        setShow(false);
                    }
                }}>
                    {children}
                </div>    
            : <></>
        )
    }
}

export default useModal;