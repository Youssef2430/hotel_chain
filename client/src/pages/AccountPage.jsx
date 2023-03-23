import axios from 'axios';
import {useContext, useEffect, useState} from 'react';
import { Navigate, useNavigate } from 'react-router';
import { Link, useParams } from 'react-router-dom';
import {UserContext} from '../UserContext.jsx';
import RoomsPage from './RoomsPage.jsx';

export default function AccountPage() {
    const {role, ready, user, setUser} = useContext(UserContext);
    const [redirect, setRedirect] = useState(null);
    const [chain_name, setChainName] = useState("");
    const [chainid, setChainId] = useState("");
    const [hotel_name, setHotelName] = useState("");
    const [chains, setChains] = useState([]);
    const [hotels, setHotels] = useState([]);
    const [email, setEmail] = useState("");
    const [phone, setPhone] = useState("");
    const [streetNumber, setStreetNumber] = useState("");
    const [streetName, setStreetName] = useState("");
    const [region, setRegion] = useState("");
    const [city, setCity] = useState("");
    const [postalCode, setPostalCode] = useState("");
    const [employees, setEmployees] = useState([]);
    const [name, setName] = useState("");
    const [password, setPassword] = useState("");
    const [hotelId, setHotelId] = useState("");
    const [role_new, setRole] = useState("");


    let {subpage} = useParams();
    const navigate = useNavigate();
    useEffect(() => {
        axios.get("/hotel_chain").then((data) => {
            setChains(data.data);
        });
        axios.get("/hotel").then((data) => {
            setHotels(data.data);
        });
        axios.get("/employee").then((data) => {
            setEmployees(data.data);
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

    async function handleAddChain(ev) {
        ev.preventDefault();
        try {
            const response = await axios.post("/hotel_chain", { chain_name });
            if(typeof response.data === "string") {
                alert(response.data);
                return;
            }
            alert("Chain added !");
            navigate('/account/hotel_chain');
            
        } catch (error) {
            alert("A problem occured !");
        }
    } 

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





    if (subpage === undefined) {
       subpage = 'profile';
    }

    async function logout() {
        await axios.post('/logout');
        setUser(null);
        setRedirect('/');
    }

    if(redirect) {
        return <Navigate to={redirect} />
    }

    if (!ready) {
        return <div>Loading...</div>
    }
    
    if(ready && !user) {
        return <Navigate to={'/login'}></Navigate>
    }

    function linkClasses(type=null){
        if(type === subpage || (type === 'profile' && subpage === undefined)) {
            return 'py-2 px-4 bg-primary text-white rounded-full';
        }
        if(type === "hotel_chain" && subpage === 'add_hotel_chain') {
            return 'py-2 px-4 bg-primary text-white rounded-full';
        }
        if(type === "hotel" && subpage === 'add_hotel') {
            return 'py-2 px-4 bg-primary text-white rounded-full';
        }
        if (type === "employees" && subpage === 'add_employee') {
            return 'py-2 px-4 bg-primary text-white rounded-full';
        }
        return 'py-2 px-4';
    }
    
    return (
        <div>
            <nav className='w-full flex justify-center mt-8 gap-2 mb-8'>
                <Link className={linkClasses('profile')} to="/account">My profile</Link>
                {role === 'admin' && <Link className={linkClasses('hotel_chain')} to="/account/hotel_chain">Hotel Chains</Link>}
                {role === 'admin' && <Link className={linkClasses('hotel')} to="/account/hotel">Hotels</Link>}
                {role === 'admin' && <Link className={linkClasses('employees')} to="/account/employees">Employees</Link>}
                {(role === 'admin' || role === 'employee') && <Link className={linkClasses('rooms')} to="/account/rooms">Rooms</Link>}
                {(role === 'admin' || role === 'employee') && <Link className={linkClasses('reservations')} to="/account/reservations">Reservations</Link>}
                {role === 'customer' && <Link className={linkClasses('bookings')} to="/account/bookings">Bookings</Link>}
            </nav>
            {subpage === 'profile' && 
            <div className='text-center max-w-lg mx-auto'>
                Logged in as {user.fullname} ({user.email}) <br/>
                <button onClick={logout} className='bg-primary py-2 px-4 rounded-full w-full my-6 text-white'>Logout</button>    
            </div>}
            {subpage === 'hotel_chain' && 
            <div className='text-center max-w-lg mx-auto'>
                <div className='py-6'>List of hotel chains</div>
                <div className='px-4 py-6'>
                    {chains.length > 0 && chains.map(chain => {
                        return <div className='bg-gray-200 border border-white py-1' key={chain.chain_id}>{chain.name}</div>
                    })}
                </div>
                <Link className="py-2 px-4 bg-primary text-white rounded-full" to="/account/hotel_chain/add_hotel_chain">Add a hotel chain</Link>
            </div>}
            {subpage === 'add_hotel_chain' && 
            <div className='text-center max-w-lg mx-auto'>
                <form className="max-w-md mx-auto" onSubmit={handleAddChain}>
                    <input type="text" placeholder="Chain Name"
                    value={chain_name} 
                    onChange={ev => setChainName(ev.target.value)}/>
                    <button className='text-white' type="submit">Add Chain</button>
                </form>
            </div>}
            {subpage === 'hotel' && 
            <div className='text-center max-w-lg mx-auto'>
                <div className='py-6'>List of hotels</div>
                <div className='px-4 py-6'>
                    {hotels.length > 0 && hotels.map(hotel => {
                        return <div className='bg-gray-200 border border-white py-1' key={hotel.hotel_id}>{hotel.hname}</div>
                    })}
                </div>
                <Link className="py-2 px-4 bg-primary text-white rounded-full" to="/account/hotel_chain/add_hotel">Add a hotel</Link>
            </div>}
            {subpage === 'add_hotel' && 
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
            </div>}
            {subpage === 'employees' && 
            <div className='text-center max-w-lg mx-auto'>
                <div className='py-6'>List of employees</div>
                <div className='px-4 py-6'>
                    {employees.length > 0 && employees.map(employee => {
                        return <div className='bg-gray-200 border border-white py-1' key={employee.sin}>{employee.email} | {employee.role}</div>
                    })}
                </div>
                <Link className="py-2 px-4 bg-primary text-white rounded-full" to="/account/employees/add_employee">Add an employee</Link>
            </div>}
            {subpage === 'add_employee' && 
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
            </div>}
            {subpage === 'rooms' && 
            <RoomsPage/>}
        </div>
    );
    
}