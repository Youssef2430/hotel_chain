import {useEffect, useState} from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router';


export default function EmployeeAdd() {

    const [email, setEmail] = useState("");
    const [phone, setPhone] = useState("");
    const [streetNumber, setStreetNumber] = useState("");
    const [streetName, setStreetName] = useState("");
    const [region, setRegion] = useState("");
    const [city, setCity] = useState("");
    const [postalCode, setPostalCode] = useState("");
    const [name, setName] = useState("");
    const [password, setPassword] = useState("");
    const [hotelId, setHotelId] = useState("");
    const [role_new, setRole] = useState("");
    const [hotels, setHotels] = useState([]);

    const navigate = useNavigate();
    
    useEffect(() => {
        axios.get("/hotel").then((data) => {
            setHotels(data.data);
        });
    }, []);

    async function handleAddEmployee(ev) {
        ev.preventDefault();
        try {
            let address = streetNumber + " " + streetName + ", " + city + ", " + region + ", " + postalCode;
            const response = await axios.post("/employee", { name, password, email, phone, address, hotelId, role: role_new });
            if(typeof response.data === "string") {
                alert(response.data);
                return;
            }
            alert("Employee added !");
            navigate('/account/employees');
        } catch (error) {
            alert("A problem occured !");
        }
    }

    return (
        <div className='text-center max-w-lg mx-auto'>
        <div className='py-6'>Register a new employee</div>
        <div className='px-4 py-6'>
        <form className="max-w-md mx-auto" onSubmit={handleAddEmployee}>
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

            <select className='w-full border my-2 py-2 px-3 rounded-2xl' onChange={e=>setHotelId(e.target.value)}>
                <option value="">Select a hotel</option>
                {hotels.map(hotel => {
                    return <option value={hotel.hotel_id}>{hotel.hname}</option>
                })}
            </select>
            <select className='w-full border my-2 py-2 px-3 rounded-2xl' onChange={e=>setRole(e.target.value)}>
                <option value="">Select a role</option>
                <option value="manager">Manager</option>
                <option value="employee">Employee</option>
            </select>
            

            
            <input type="password" placeholder="Password" 
            value={password} 
            onChange={ev => setPassword(ev.target.value)}/>
            <button className="py-2 px-4 bg-primary text-white rounded-full" type="submit">Register employee</button>
        </form>
        </div>
    </div>
    );
}