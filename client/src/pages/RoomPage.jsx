import axios from 'axios';
import { useEffect, useState, useContext } from 'react';
import {useParams } from 'react-router-dom';
import {UserContext} from '../UserContext.jsx';
import { useNavigate } from 'react-router';

export default function RoomPage() {

    const {role, user} = useContext(UserContext);
    let {room} = useParams();
    const [roomData, setRoomData] = useState(null);
    const [showAllPictures, setShowAllPictures] = useState(false);
    const [checkIn, setCheckIn] = useState('');
    const [checkOut, setCheckOut] = useState('');
    const [customerEmail, setCustomerEmail] = useState('');
    const [employeeId, setEmployeeId] = useState("");
    const [reservations, setReservations] = useState([]);
    const navigate = useNavigate();

    useEffect(() => {
        axios.get('/rooms/'+room).then((data) => {
            setRoomData(data.data);
            // console.log(data.data);
        });
        axios.get('/reservation/'+room).then((data) => {
            setReservations(data.data);
            console.log(data.data);
        });
        console.log(user.sin);
        if(role === 'customer') {
            setCustomerEmail(user.email);
        }else{
            setEmployeeId(user.sin);
        }
    }, [ room, user.email, user.sin, role]);

    function checkCheckIn(date) {
        for(let reservation of reservations) {
            if(new Date(checkIn) >= new Date(reservation.check_in) && new Date(checkIn) <= new Date(reservation.check_out)) {
                alert('Room is not available on this check in date');
                return;
            }
        }
        setCheckIn(date);

    }


    function checkDates(date) {
        for(let reservation of reservations) {
            if(new Date(date) >= new Date(reservation.check_in) && new Date(date) <= new Date(reservation.check_out)) {
                alert('Room is not available on this check out date');
                return;
            }
        }
        if(checkIn === ''){
            alert('Please select a check-in date first');
        }else if(new Date(date) < new Date(checkIn)) {
            alert('Check-out date cannot be before check-in date');
            return;
        } else {
            setCheckOut(date);
        }
    }

    async function bookRoom() {
        // console.log(user);
        if(checkIn === '' || checkOut === '') {
            alert('Please select check-in and check-out dates');
            return;
        }
        let chain_id = roomData.chain_id;
        let hotel_id = roomData.hotel_id;
        let room_number = roomData.room_number;
        if(customerEmail === '' && role !== 'customer') {
            alert('Please enter a customer email');
            return;
        }

        const response = await axios.post('/reservation', {chain_id, hotel_id, room_number,customerEmail, employeeId, checkIn, checkOut});
        // console.log(response);
        if(response.status === 200) {
            alert('Reservation successful');
            navigate('/');
        } else {
            alert('Reservation failed');
        }
    }

    if(!roomData) {
        return <div>Nothing here</div>
    }

    if(showAllPictures) {
        return (
            <div className='absolute inset-0 bg-gray-400 min-h-screen'>
                <div className='bg-gray-400 p-8 grid gap-4'>
                    <div>
                        <button onClick={() => setShowAllPictures(false)} className="fixed flex gap-1 py-2 px-4 rounded-2xl text-black bg-gray-100">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-6 h-6">
                                <path fillRule="evenodd" d="M2.515 10.674a1.875 1.875 0 000 2.652L8.89 19.7c.352.351.829.549 1.326.549H19.5a3 3 0 003-3V6.75a3 3 0 00-3-3h-9.284c-.497 0-.974.198-1.326.55l-6.375 6.374zM12.53 9.22a.75.75 0 10-1.06 1.06L13.19 12l-1.72 1.72a.75.75 0 101.06 1.06l1.72-1.72 1.72 1.72a.75.75 0 101.06-1.06L15.31 12l1.72-1.72a.75.75 0 10-1.06-1.06l-1.72 1.72-1.72-1.72z" clipRule="evenodd" />
                            </svg>
                            Close pictures
                        </button>
                    </div>
                    {roomData.pictures.length > 0 && roomData.pictures.map(photo => (
                        <div>
                            <img src={'http://localhost:6060/uploads/'+photo} alt="" />
                        </div>
                    ))}
                </div>
            </div>
        )
    }

    return (
        <div className='mt-4 -mx-8 px-8 py-6'>
            <h1 className='text-2xl'>{roomData.hname}</h1>
            <a target="_blank" href={'https://maps.google.com/?q='+roomData.address} className='my-2 block font-semibold underline' rel="noreferrer">{roomData.address}</a>
            <div className='relative'>
                <div className="grid gap-2 grid-cols-[2fr_1fr]">
                    <div>
                        {roomData.pictures?.[0] && (
                            <div>
                                <img className='aspect-square object-cover' src={'http://localhost:6060/uploads/'+roomData.pictures[0]} alt="" />
                            </div>
                        )}
                    </div>
                    <div className='grid'>
                        {roomData.pictures?.[1] && (
                            <img className='aspect-square object-cover' src={'http://localhost:6060/uploads/'+roomData.pictures[1]} alt="" />
                        )}
                        <div className='overflow-hidden'>
                            {roomData.pictures?.[2] && (
                                <img className='aspect-square object-cover relative top-2' src={'http://localhost:6060/uploads/'+roomData.pictures[2]} alt="" />
                            )}
                            {!roomData.pictures?.[2] && (
                                <img className='aspect-square bg-gray-400 object-cover relative top-2' src={'http://localhost:6060/uploads/'+roomData.pictures[2]} alt="" />
                            )}
                        </div>
                        
                    </div>
                </div>
                <button onClick={() => setShowAllPictures(true)} className='absolute bottom-2 right-2 py-2 px-4 bg-white rounded-2xl border border-black text-black'>Show more pictures</button>
            </div>
            <div className='grid grid-cols-2'>
                <div>
                    <h2 className='text-2xl mt-4'>View</h2>
                    {roomData.view}
                    <h2 className='text-2xl mt-4'>Amenities</h2>
                    {roomData.amenities.reduce((a, b) => a + ', ' + b)}
                    <h2 className='text-2xl mt-4'>Capacity</h2>
                    <div className='flex gap-5'>
                        <div>
                            Guest number : {roomData.capacity}
                        </div>
                        {roomData.extendable && (
                            <div className='italic'>(Extendable)</div>
                        )}
                    </div>
                </div>
                <div>
                    <div className='p-4 shadow bg-gray-200 mt-4 rounded-2xl'>
                        <h2 className='text-2xl pb-2 text-center'>
                        Price: {roomData.price}$ / night
                        </h2>
                        <div className='flex my-4 border bg-white shadow py-4 px-4 rounded-2xl justify-between'>
                            <label>Check in date :</label>
                            <input value={checkIn} onChange={ev => checkCheckIn(ev.target.value)} className='rounded-2xl px-3' type="date" />
                        </div>
                        <div className='flex my-4 border bg-white shadow py-4 px-4 rounded-2xl justify-between'>
                            <label>Check in date :</label>
                            <input value={checkOut} 
                            onChange={ev => checkDates(ev.target.value)} className='rounded-2xl px-3' type="date" />
                        </div>
                        <h2 className='text-2xl pb-2 text-center bold italic'>
                            {checkIn && checkOut && 
                            <div>Total to pay : {((Math.abs(new Date(checkOut) - new Date(checkIn)))/(1000 * 60 * 60 * 24))*roomData.price}$</div>
                            }
                        
                        </h2>
                        <div>
                            {role !== 'customer' && 
                            <input type="email" placeholder="customer@email.com" 
                            value={customerEmail} 
                            onChange={ev => setCustomerEmail(ev.target.value)}/>}
                        </div>
                        <button onClick={bookRoom} className='bg-primary p-2 text-white rounded-2xl w-full'>Book this place</button>
                    </div>
                </div>
                
            </div>
            
        </div>
    )
}