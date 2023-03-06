import { Link } from "react-router-dom";
import { useState } from "react";
import axios from "axios";

export default function Register() {
    const [name, setName] = useState("");
    const [email, setEmail] = useState("");
    const [phone, setPhone] = useState("");
    const [streetNumber, setStreetNumber] = useState("");
    const [streetName, setStreetName] = useState("");
    const [region, setRegion] = useState("");
    const [city, setCity] = useState("");
    const [postalCode, setPostalCode] = useState("");
    const [password, setPassword] = useState("");
    const registerUser = async (ev) => {
        try {
            ev.preventDefault();
            const body = { name, email, phone, streetNumber, streetName, region, city, postalCode, password };

            // *** Note: This is using the fetch API
            // const response = await fetch(`http://localhost:6060/customer`, {
            //     method: "POST",
            //     headers: { "Content-Type": "application/json" },
            //     body: JSON.stringify(body)
            // });

            // *** Note: This is using the axios library
            const response = await axios.post(`/customer`, body);
            console.log(response);
            alert("Registered successfully. You can now log in !");
        } catch (err) {
            console.error(err.message);
        }
    }
    return (
        <div className="mt-4 grow flex items-center justify-around">
            <div className="mb-32">
                <h1 className="text-4xl text-center mb-6">Register</h1>
                <form className="max-w-md mx-auto" onSubmit={registerUser}>
                    <input type="text" placeholder="Name" 
                    value={name} 
                    onChange={ev => setName(ev.target.value)}/>
                    <input type="email" placeholder="your@email.com" 
                    value={email} 
                    onChange={ev => setEmail(ev.target.value)}/>
                    <input type="tel" placeholder="Phone number" 
                    value={phone} 
                    onChange={ev => setPhone(ev.target.value)}/>
                    <div className="flex gap-1 justify-around">
                        <div className="w-{1/8}" >
                        <input type="text" placeholder="Street number" 
                        value={streetNumber} 
                        onChange={ev => setStreetNumber(ev.target.value)}/>
                        </div>
                        <input type="text" placeholder="Street name" 
                        value={streetName} 
                        onChange={ev => setStreetName(ev.target.value)}/>
                    </div>
                    <div className="flex gap-1 justify-around">
                    <input type="text" placeholder="Region" 
                    value={region} 
                    onChange={ev => setRegion(ev.target.value)}/>
                    <input type="text" placeholder="City" 
                    value={city} 
                    onChange={ev => setCity(ev.target.value)}/>
                    <input type="text" placeholder="Postal code" 
                    value={postalCode} 
                    onChange={ev => setPostalCode(ev.target.value)}/>
                    </div>
                    
                    <input type="password" placeholder="Password" 
                    value={password} 
                    onChange={ev => setPassword(ev.target.value)}/>
                    <button type="submit">Register</button>
                    <div className="text-center py-2 text-gray-500">
                        Already a member ? <Link className="underline text-black" to={"/login"}>Login</Link>
                    </div>
                </form>
            </div>
        </div>
    );
}