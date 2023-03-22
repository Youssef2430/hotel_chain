import axios from "axios";
import { createContext, useEffect, useState } from "react";

export const UserContext = createContext({});

export function UserContextProvider({ children }) {
    const [user, setUser] = useState(null);
    const [ready, setReady] = useState(false);
    const [role, setRole] = useState(null);
    useEffect(() => {
        if(!user) {
            axios.get("/profile").then(({data}) => {
                setUser(data);
                setReady(true);
            });
            axios.get("/role").then((data) => {
                setRole(data.data);
            });   
        }
    }, []);
    return (
        <UserContext.Provider value={{user, setUser, ready,setReady, role}}>
            {children}
        </UserContext.Provider>
    );
}