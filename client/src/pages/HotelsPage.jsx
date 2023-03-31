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

    function deleteHotel(hotel_id){
        axios.delete("/hotel/"+hotel_id).then((data) => {
            setHotels(data.data);
        });
        console.log(hotel_id);
    }

    return (
        <div className='text-center max-w-lg mx-auto'>
            <div className='py-6'>List of hotels</div>
            <div className='px-4 py-6'>
                {hotels.length > 0 && hotels.map(hotel => {
                    return (
                    <div className='flex border items-center my-2' key={hotel.hotel_id}>
                        <div className='w-full py-1' >{hotel.hname}</div>
                        <div className='pr-2 cursor-pointer' onClick={() => deleteHotel(hotel.hotel_id)}>
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-6 h-6">
                                <path fillRule="evenodd" d="M16.5 4.478v.227a48.816 48.816 0 013.878.512.75.75 0 11-.256 1.478l-.209-.035-1.005 13.07a3 3 0 01-2.991 2.77H8.084a3 3 0 01-2.991-2.77L4.087 6.66l-.209.035a.75.75 0 01-.256-1.478A48.567 48.567 0 017.5 4.705v-.227c0-1.564 1.213-2.9 2.816-2.951a52.662 52.662 0 013.369 0c1.603.051 2.815 1.387 2.815 2.951zm-6.136-1.452a51.196 51.196 0 013.273 0C14.39 3.05 15 3.684 15 4.478v.113a49.488 49.488 0 00-6 0v-.113c0-.794.609-1.428 1.364-1.452zm-.355 5.945a.75.75 0 10-1.5.058l.347 9a.75.75 0 101.499-.058l-.346-9zm5.48.058a.75.75 0 10-1.498-.058l-.347 9a.75.75 0 001.5.058l.345-9z" clipRule="evenodd" />
                            </svg>
                        </div>
                    </div> 
                    )
                })}
            </div>
            <Link className="py-2 px-4 bg-primary text-white rounded-full" to="/account/hotel/add_hotel">Add a hotel</Link>
        </div>
    );
}