import {useEffect, useState} from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router';

export default function CentralOfficeAdd(){

    const [officeName, setOfficeName] = useState("");
    const [email, setEmail] = useState("");
    const [streetNumber, setStreetNumber] = useState("");
    const [streetName, setStreetName] = useState("");
    const [region, setRegion] = useState("");
    const [city, setCity] = useState("");
    const [postalCode, setPostalCode] = useState("");
    const [country, setCountry] = useState("");
    const [phone, setPhone] = useState("");
    const [chains, setChains] = useState([]);
    const [chainid, setChainId] = useState(""); 
    const navigate = useNavigate();

    useEffect(() => {
        axios.get("/hotel_chain").then((data) => {
            setChains(data.data);
        });
    }, []);

    async function handleAddOffice(ev){
        ev.preventDefault();
        try {
            let address = streetNumber + " " + streetName + ", " + city + ", " + region + ", " + postalCode + ", " + country;
            const response = await axios.post("/add_office", { officeName, address, phone, email, chainid });
            if(typeof response.data === "string") {
                alert(response.data);
                return;
            }
            alert("Office added !");
            navigate('/account/offices');
        } catch (error) {
            alert("A problem occured !");
        }
    }

    return (
        <div className='text-center max-w-lg mx-auto'>
                <form className="max-w-md mx-auto" onSubmit={handleAddOffice}>
                    <input type="text" placeholder="Office Name"
                    value={officeName} 
                    onChange={ev => setOfficeName(ev.target.value)}/>
                    <select className='w-full border my-2 py-2 px-3 rounded-2xl' onChange={e=>setChainId(e.target.value)}>
                        <option value="">Select a chain</option>
                        {chains.map(chain => {
                            return <option value={chain.chain_id}>{chain.name}</option>
                        })}
                    </select>
                    <input type="email" placeholder="office@email.com" 
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
                    <input type="text" placeholder="Country" 
                    value={country} 
                    onChange={ev => setCountry(ev.target.value)}/>
                    </div>
                    <button className='text-white' type="submit">Add Office</button>
                </form>
            </div>
    )
}