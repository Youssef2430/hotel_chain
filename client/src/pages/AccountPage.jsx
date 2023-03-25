import axios from 'axios';
import {useContext, useState} from 'react';
import { Navigate } from 'react-router';
import { Link, useParams } from 'react-router-dom';
import {UserContext} from '../UserContext.jsx';
import ChainAdd from './ChainAdd.jsx';
import EmployeesPage from './EmployeesPage.jsx';
import EmployeeAdd from './EmployeeAdd.jsx';
import HotelAdd from './HotelAdd.jsx';
import HotelChainsPage from './HotelChainsPage.jsx';
import HotelsPage from './HotelsPage.jsx';
import RoomsPage from './RoomsPage.jsx';

export default function AccountPage() {
    const {role, ready, user, setUser} = useContext(UserContext);
    const [redirect, setRedirect] = useState(null);



    let {subpage} = useParams();

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
            <HotelChainsPage/>}
            {subpage === 'add_hotel_chain' && 
            <ChainAdd/>}
            {subpage === 'hotel' && 
            <HotelsPage/>}
            {subpage === 'add_hotel' && 
            <HotelAdd/>}
            {subpage === 'employees' && 
            <EmployeesPage/>}
            {subpage === 'add_employee' && 
            <EmployeeAdd/>}
            {subpage === 'rooms' && 
            <RoomsPage/>}
        </div>
    );
    
}