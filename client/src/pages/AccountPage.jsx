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
import RoomAdd from './RoomAdd.jsx';
import RoomEdit from './RoomEdit.jsx';
import ReservationsPage from './ReservationsPage.jsx';
import ReservationPage from './ReservationPage.jsx';

export default function AccountPage() {
    const {role, ready, user, setUser} = useContext(UserContext);
    const [redirect, setRedirect] = useState(null);
    let {subpage, subpage2} = useParams();


    if(redirect) {
        return <Navigate to={redirect} />
    }

    if (!ready) {
        return <div>Loading...</div>
    }
    
    if(ready && !user) {
        return <Navigate to={'/login'}></Navigate>
    }

    if (subpage === undefined) {
       subpage = 'profile';
    }

    async function logout() {
        await axios.post('/logout');
        setUser(null);
        setRedirect('/');
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
        if (type === "rooms" && subpage === 'add_room') {
            return 'py-2 px-4 bg-primary text-white rounded-full';
        }
        return 'py-2 px-4';
    }
    
    return (
        <div>
            <nav className='w-full flex justify-center mt-8 gap-2 mb-8'>
                <Link className={linkClasses('profile')} to="/account">
                <div className='flex items-center gap-1'>
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-5 h-5">
                    <path strokeLinecap="round" strokeLinejoin="round" d="M15 9h3.75M15 12h3.75M15 15h3.75M4.5 19.5h15a2.25 2.25 0 002.25-2.25V6.75A2.25 2.25 0 0019.5 4.5h-15a2.25 2.25 0 00-2.25 2.25v10.5A2.25 2.25 0 004.5 19.5zm6-10.125a1.875 1.875 0 11-3.75 0 1.875 1.875 0 013.75 0zm1.294 6.336a6.721 6.721 0 01-3.17.789 6.721 6.721 0 01-3.168-.789 3.376 3.376 0 016.338 0z" />
                </svg>
                My profile
                </div>
                </Link>
                {role === 'admin' && <Link className={linkClasses('hotel_chain')} to="/account/hotel_chain">
                <div className='flex items-center gap-1'>
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-5 h-5">
                    <path strokeLinecap="round" strokeLinejoin="round" d="M12 21v-8.25M15.75 21v-8.25M8.25 21v-8.25M3 9l9-6 9 6m-1.5 12V10.332A48.36 48.36 0 0012 9.75c-2.551 0-5.056.2-7.5.582V21M3 21h18M12 6.75h.008v.008H12V6.75z" />
                </svg>
                Hotel Chains
                </div>
                </Link>}
                {role === 'admin' && <Link className={linkClasses('hotel')} to="/account/hotel">
                <div className='flex items-center gap-1'>
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-5 h-5">
                    <path strokeLinecap="round" strokeLinejoin="round" d="M2.25 21h19.5m-18-18v18m10.5-18v18m6-13.5V21M6.75 6.75h.75m-.75 3h.75m-.75 3h.75m3-6h.75m-.75 3h.75m-.75 3h.75M6.75 21v-3.375c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21M3 3h12m-.75 4.5H21m-3.75 3.75h.008v.008h-.008v-.008zm0 3h.008v.008h-.008v-.008zm0 3h.008v.008h-.008v-.008z" />
                </svg>
                Hotels
                </div>
                </Link>}
                {role === 'admin' && <Link className={linkClasses('employees')} to="/account/employees">
                <div className='flex items-center gap-1'>
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-5 h-5">
                    <path strokeLinecap="round" strokeLinejoin="round" d="M19 7.5v3m0 0v3m0-3h3m-3 0h-3m-2.25-4.125a3.375 3.375 0 11-6.75 0 3.375 3.375 0 016.75 0zM4 19.235v-.11a6.375 6.375 0 0112.75 0v.109A12.318 12.318 0 0110.374 21c-2.331 0-4.512-.645-6.374-1.766z" />
                </svg>
                Employees
                </div>
                </Link>}
                {(role === 'admin' || role === 'employee') && <Link className={linkClasses('rooms')} to="/account/rooms">
                <div className='flex items-center gap-1'>
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-5 h-5">
                    <path strokeLinecap="round" strokeLinejoin="round" d="M3 8.25V18a2.25 2.25 0 002.25 2.25h13.5A2.25 2.25 0 0021 18V8.25m-18 0V6a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 6v2.25m-18 0h18M5.25 6h.008v.008H5.25V6zM7.5 6h.008v.008H7.5V6zm2.25 0h.008v.008H9.75V6z" />
                </svg>
                Rooms
                </div>
                </Link>}
                {(role === 'admin' || role === 'employee') && <Link className={linkClasses('reservations')} to="/account/reservations">
                <div className='flex items-center gap-1'>
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-5 h-5">
                <path strokeLinecap="round" strokeLinejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75m-18 0v-7.5A2.25 2.25 0 015.25 9h13.5A2.25 2.25 0 0121 11.25v7.5" />
                </svg>
                Reservations
                </div>
                </Link>}
                {role === 'customer' && <Link className={linkClasses('bookings')} to="/account/bookings">
                <div className='flex items-center gap-1'>
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-5 h-5">
                <path strokeLinecap="round" strokeLinejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75m-18 0v-7.5A2.25 2.25 0 015.25 9h13.5A2.25 2.25 0 0121 11.25v7.5m-9-6h.008v.008H12v-.008zM12 15h.008v.008H12V15zm0 2.25h.008v.008H12v-.008zM9.75 15h.008v.008H9.75V15zm0 2.25h.008v.008H9.75v-.008zM7.5 15h.008v.008H7.5V15zm0 2.25h.008v.008H7.5v-.008zm6.75-4.5h.008v.008h-.008v-.008zm0 2.25h.008v.008h-.008V15zm0 2.25h.008v.008h-.008v-.008zm2.25-4.5h.008v.008H16.5v-.008zm0 2.25h.008v.008H16.5V15z" />
                </svg>
                Bookings
                </div>
                </Link>}
            </nav>
            {subpage === 'profile' && 
            <div className='text-center max-w-lg mx-auto'>
                Logged in as {user.fullname} ({user.email}) <br/>
                <button onClick={logout} className='bg-primary py-2 px-4 rounded-full w-full my-6 text-white'>Logout</button>    
            </div>}
            {subpage === 'hotel_chain' && subpage2 === undefined &&
            <HotelChainsPage/>}
            {subpage2 === 'add_hotel_chain' && 
            <ChainAdd/>}
            {subpage === 'hotel' && subpage2 === undefined &&
            <HotelsPage/>}
            {subpage2 === 'add_hotel' && 
            <HotelAdd/>}
            {subpage === 'employees' && subpage2 === undefined &&
            <EmployeesPage/>}
            {subpage2 === 'add_employee' && 
            <EmployeeAdd/>}
            {subpage === 'rooms' && subpage2 === undefined &&
            <RoomsPage/>}
            {subpage2 === 'add_room' &&
            <RoomAdd/>}
            {subpage === 'rooms' && (subpage2 !== 'add_room' && subpage2 !== undefined) &&
            <RoomEdit/>}
            {subpage === 'reservations' && subpage2 === undefined &&
            <ReservationsPage/>}
            {subpage === 'reservations' && subpage2 &&
            <ReservationPage/>}
        </div>
    );
    
}