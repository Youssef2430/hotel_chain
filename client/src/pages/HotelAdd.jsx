import {useState, useEffect} from 'react';
import { useNavigate } from 'react-router';
import axios from 'axios';

export default function HotelAdd() {

    const [chainid, setChainId] = useState("");
    const [hotel_name, setHotelName] = useState("");
    const [chains, setChains] = useState([]);
    const [email, setEmail] = useState("");
    const [phone, setPhone] = useState("");
    const [streetNumber, setStreetNumber] = useState("");
    const [streetName, setStreetName] = useState("");
    const [region, setRegion] = useState("");
    const [city, setCity] = useState("");
    const [postalCode, setPostalCode] = useState("");
    const navigate = useNavigate();

    useEffect(() => {
        axios.get("/hotel_chain").then((data) => {
            setChains(data.data);
        });
    }, []);

    async function handleAddHotel(ev) {
        ev.preventDefault();
        try {
            let address = streetNumber + " " + streetName + ", " + city + ", " + region + ", " + postalCode;
            const response = await axios.post("/hotel", { hotel_name, address, phone, email, chainid });
            if(typeof response.data === "string") {
                alert(response.data);
                return;
            }
            alert("Hotel added !");
            navigate('/account/hotel');
        } catch (error) {
            alert("A problem occured !");
        }
    }



    return (
        <div className='text-center max-w-lg mx-auto'>
                <form className="max-w-md mx-auto" onSubmit={handleAddHotel}>
                    <input type="text" placeholder="Hotel Name"
                    value={hotel_name} 
                    onChange={ev => setHotelName(ev.target.value)}/>
                    <select className='w-full border my-2 py-2 px-3 rounded-2xl' onChange={e=>setChainId(e.target.value)}>
                        <option value="">Select a chain</option>
                        {chains.map(chain => {
                            return <option value={chain.chain_id}>{chain.name}</option>
                        })}
                    </select>
                    <input type="email" placeholder="hotel@email.com" 
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
                    <button className='text-white' type="submit">Add Chain</button>
                </form>
            </div>
    );
}