import {UserContext} from '../UserContext.jsx';
import {useContext, useState, useEffect} from 'react';
import axios from 'axios';
import {Link} from 'react-router-dom';

export default function Bookings() {
    const {role, user} = useContext(UserContext);
    const [bookings, setBookings] = useState([]);

    useEffect(() => {
        axios.get('/bookings/'+user.email).then((data) => {
            setBookings(data.data);
            console.log(data.data);
        });

    }, []);

    return (
        <div>
            <div className='mt-4 mb-6 grid lg:grid-cols-2 sm:grid-cols-1 gap-2'>
                {bookings.length > 0 && bookings.map(room => (
                    <Link to={'/account/bookings/'+room.reservation_id} key={room.hname+room.room_number} className='flex cursor-pointer gap-4 bg-gray-200 p-4 rounded-2xl'>
                        <div className='w-32 h-32 bg-gray-300'>
                            {room.pictures.length > 0 && 
                            (
                                <img className='w-32 h-32 w-full object-cover' src={'http://localhost:6060/uploads/'+room.pictures[0]} alt="" />
                            )}
                        </div>
                        <div className='items-center'>
                            <div className='text-gray-800 text-md font-bold italic'>{room.rated && <div>Rated</div>}{!room.rated && <div>Not rated</div>}</div>
                            <div className='text-gray-800 text-sm'>Hotel : {room.hname}</div>
                            <div className='text-gray-800 text-sm'>Capacity : {room.capacity}</div>
                            <div className='text-gray-800 text-sm'>Total to pay : {((Math.abs(new Date(room.check_out) - new Date(room.check_in)))/(1000 * 60 * 60 * 24))*room.price}$</div>
                            <div className='flex '>
                                <div className='text-gray-800 text-sm'>Other :</div>
                                <div className='text-gray-500 text-sm'>{room.view}{room.extendable && ", Extendable"}{room.damaged && ", Damaged"}</div>
                            </div>
                            
                            <div className='flex'>
                                <div className='text-gray-800 text-sm'>Amenities: </div>
                                <div className='flex text-gray-500 text-sm'>{room.amenities.map(item => (
                                    // console.log(item)
                                <div key={item}> {item}&nbsp;</div>
                                ))}</div>
                            </div>
                            
                        </div>

                    </Link>
                ))}
            </div>
            
        </div>
    )
}