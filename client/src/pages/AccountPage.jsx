import axios from 'axios';
import {useContext, useEffect, useState} from 'react';
import { Navigate, useNavigate } from 'react-router';
import { Link, useParams } from 'react-router-dom';
import {UserContext} from '../UserContext.jsx';

export default function AccountPage() {
    const {role, ready, user, setUser} = useContext(UserContext);
    const [redirect, setRedirect] = useState(null);
    const [chain_name, setChainName] = useState("");
    const [hotel_name, setHotelName] = useState("");
    const [chains, setChains] = useState([]);
    let {subpage} = useParams();
    const navigate = useNavigate();
    useEffect(() => {
        axios.get("/hotel_chain").then((data) => {
            setChains(data.data);
        });
    }, []);

    async function handleAddHotel(ev) {
        ev.preventDefault();
        try {
            const response = await axios.post("/hotel", { hotel_name });
            if(typeof response.data === "string") {
                alert(response.data);
                return;
            }
            alert("Hotel added !");
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
        return 'py-2 px-4';
    }
    
    return (
        <div>
            <nav className='w-full flex justify-center mt-8 gap-2 mb-8'>
                <Link className={linkClasses('profile')} to="/account">My profile</Link>
                {role === 'admin' && <Link className={linkClasses('hotel_chain')} to="/account/hotel_chain">Hotel Chains</Link>}
                {role === 'admin' && <Link className={linkClasses('hotel')} to="/account/hotel">Hotels</Link>}
                {role === 'admin' && <Link className={linkClasses('employees')} to="/account/employees">Employees</Link>}
                {role === 'admin' && <Link className={linkClasses('rooms')} to="/account/rooms">Rooms</Link>}
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
                        console.log(chain);
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
        </div>
    );
    
}