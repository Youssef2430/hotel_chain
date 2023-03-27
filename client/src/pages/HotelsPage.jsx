import {useEffect, useState} from 'react';
import axios from 'axios';
import {Link} from 'react-router-dom';


export default function HotelsPage() {

    const [hotels, setHotels] = useState([]);
    
    useEffect(() => {
        axios.get("/hotel").then((data) => {
            setHotels(data.data);
        });
    }, []);

    return (
        <div className='text-center max-w-lg mx-auto'>
            <div className='py-6'>List of hotels</div>
            <div className='px-4 py-6'>
                {hotels.length > 0 && hotels.map(hotel => {
                    return <div className='border py-1' key={hotel.hotel_id}>{hotel.hname}</div>
                })}
            </div>
            <Link className="py-2 px-4 bg-primary text-white rounded-full" to="/account/hotel/add_hotel">Add a hotel</Link>
        </div>
    );
}