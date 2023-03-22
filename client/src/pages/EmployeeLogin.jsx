import { Navigate } from "react-router-dom";
import { useContext, useState } from "react";
import axios from "axios";
import { UserContext } from "../UserContext";

export default function EmployeeLogin() {
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const [redirect, setRedirect] = useState(false);
    const {setUser} = useContext(UserContext);
    async function handleLogin(ev) {
        ev.preventDefault();
        try {
            const response = await axios.post("/employee/login", { email, password });
            if(typeof response.data === "string") {
                alert(response.data);
                return;
            }
            setUser(response.data);
            alert("Logged in successfully !");
            setRedirect(true);
        } catch (error) {
            alert("Invalid credentials !");
        }
    } 

    if(redirect) {
        return <Navigate to="/account" />
    }
    return (
        <div className="mt-4 grow flex items-center justify-around">
            <div className="mb-32">
                <h1 className="text-4xl text-center mb-6">Administrative Login</h1>
                <form className="max-w-md mx-auto" onSubmit={handleLogin}>
                    <input type="email" placeholder="your@email.com"
                    value={email} 
                    onChange={ev => setEmail(ev.target.value)}/>
                    <input type="password" placeholder="password"
                    value={password} 
                    onChange={ev => setPassword(ev.target.value)}/>
                    <button type="submit">Login</button>
                </form>
            </div>
        </div>
    );
}