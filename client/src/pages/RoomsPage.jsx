import axios from 'axios';
import { useEffect, useState, useContext } from 'react';
import {Link} from 'react-router-dom';
import {UserContext} from '../UserContext.jsx';

export default function RoomsPage() {

    const {role, user} = useContext(UserContext);
    const [rooms, setRooms] = useState([]);


    useEffect(() => {
        if(role === 'employee'){
            axios.get('/room/'+user.sin).then(({data}) => {
                // console.log(data);
                setRooms(data);
            } );
        }else{
            axios.get('/room').then(({data}) => {
                // console.log(data);
                setRooms(data);
            } );
        }
        

    }, [role, user.sin]);
    return (
        <div>
            <div className='text-center'>
                <Link className="inline-flex gap-1 py-2 px-4 bg-primary text-white rounded-full" to="/account/rooms/add_room">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6">
                        <path strokeLinecap="round" strokeLinejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
                    </svg>
                    Add new room
                </Link>
            </div>
            <div className='mt-4 mb-6 grid lg:grid-cols-2 sm:grid-cols-1 gap-2'>
                {rooms.length > 0 && rooms.map(room => (
                    <Link to={'/account/rooms/'+room.hotel_id+"$"+room.room_number} key={room.hname+room.room_number} className='flex cursor-pointer gap-4 bg-gray-200 p-4 rounded-2xl'>
                        <div className='w-32 h-32 bg-gray-300'>
                            {room.pictures.length > 0 && 
                            (
                                <img className='w-32 h-32 w-full object-cover' src={'http://localhost:6060/uploads/'+room.pictures[0]} alt="" />
                            )}
                        </div>
                        <div className='items-center'>
                            <div className='text-gray-800 text-sm'>Hotel : {room.hname}</div>
                            <div className='text-gray-800 text-sm'>Address : {room.address}</div>
                            <div className='text-gray-800 text-sm'>Capacity : {room.capacity}</div>
                            <div className='text-gray-800 text-sm'>Price : {room.price} $/night</div>
                            <div className='flex '>
                                <div className='text-gray-800 text-sm'>Other :</div>
                                <div className='text-gray-500 text-sm'>{room.view}{room.extendable && ", Extendable"}</div>
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
