import axios from 'axios';
import {useState, useEffect} from 'react';
import { Link, useParams } from 'react-router-dom';
import Table from 'react-bootstrap/Table';

export default function Views() {

    const [hotels, setHotels] = useState([]);
    const [hotelId, setHotelId] = useState("");
    const [roomCapacity, setRoomCapacity] = useState([]);
    const [capacityView, setCapacityView] = useState(false);
    const [roomArea, setRoomArea] = useState([]);
    const [roomAreaView, setRoomAreaView] = useState(false);
    let {subpage} = useParams();

    useEffect(() => {
        axios.get("/hotel").then((data) => {
            setHotels(data.data);
        });
        axios.get("/rooms_per_area").then((data) => {
            setRoomArea(data.data);
            setRoomAreaView(true);
        });
    }, []);

    async function getView(ev) {
        ev.preventDefault();
        setHotelId(ev.target.value);
        const view = await axios.get('rooms_capacity', {params: {hotel_id: ev.target.value}});
        // console.log(view.data);
        setRoomCapacity(view.data);
        setCapacityView(true);
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
        <div className='justify-center'>
            <Link className="w-full flex justify-center mt-8 gap-2 mb-8" to="/">
                <div className='flex items-center gap-1 font-bold'>
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-6 h-6">
                    <path fillRule="evenodd" d="M7.5 3.75A1.5 1.5 0 006 5.25v13.5a1.5 1.5 0 001.5 1.5h6a1.5 1.5 0 001.5-1.5V15a.75.75 0 011.5 0v3.75a3 3 0 01-3 3h-6a3 3 0 01-3-3V5.25a3 3 0 013-3h6a3 3 0 013 3V9A.75.75 0 0115 9V5.25a1.5 1.5 0 00-1.5-1.5h-6zm5.03 4.72a.75.75 0 010 1.06l-1.72 1.72h10.94a.75.75 0 010 1.5H10.81l1.72 1.72a.75.75 0 11-1.06 1.06l-3-3a.75.75 0 010-1.06l3-3a.75.75 0 011.06 0z" clipRule="evenodd" />
                    </svg>
                    Return to index page
                </div>
            
            </Link>
            <nav className='w-full flex justify-center mt-8 gap-2 mb-8'>
                <Link className={linkClasses('profile')} to="/views">
                <div className='flex items-center gap-1'>
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-5 h-5">
                    <path fillRule="evenodd" d="M8.161 2.58a1.875 1.875 0 011.678 0l4.993 2.498c.106.052.23.052.336 0l3.869-1.935A1.875 1.875 0 0121.75 4.82v12.485c0 .71-.401 1.36-1.037 1.677l-4.875 2.437a1.875 1.875 0 01-1.676 0l-4.994-2.497a.375.375 0 00-.336 0l-3.868 1.935A1.875 1.875 0 012.25 19.18V6.695c0-.71.401-1.36 1.036-1.677l4.875-2.437zM9 6a.75.75 0 01.75.75V15a.75.75 0 01-1.5 0V6.75A.75.75 0 019 6zm6.75 3a.75.75 0 00-1.5 0v8.25a.75.75 0 001.5 0V9z" clipRule="evenodd" />
                </svg>
                Rooms per area
                </div>
                </Link>
                <Link className={linkClasses('hotel_chain')} to="/views/hotel_chain">
                <div className='flex items-center gap-1'>
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-5 h-5">
                    <path d="M21 6.375c0 2.692-4.03 4.875-9 4.875S3 9.067 3 6.375 7.03 1.5 12 1.5s9 2.183 9 4.875z" />
                    <path d="M12 12.75c2.685 0 5.19-.586 7.078-1.609a8.283 8.283 0 001.897-1.384c.016.121.025.244.025.368C21 12.817 16.97 15 12 15s-9-2.183-9-4.875c0-.124.009-.247.025-.368a8.285 8.285 0 001.897 1.384C6.809 12.164 9.315 12.75 12 12.75z" />
                    <path d="M12 16.5c2.685 0 5.19-.586 7.078-1.609a8.282 8.282 0 001.897-1.384c.016.121.025.244.025.368 0 2.692-4.03 4.875-9 4.875s-9-2.183-9-4.875c0-.124.009-.247.025-.368a8.284 8.284 0 001.897 1.384C6.809 15.914 9.315 16.5 12 16.5z" />
                    <path d="M12 20.25c2.685 0 5.19-.586 7.078-1.609a8.282 8.282 0 001.897-1.384c.016.121.025.244.025.368 0 2.692-4.03 4.875-9 4.875s-9-2.183-9-4.875c0-.124.009-.247.025-.368a8.284 8.284 0 001.897 1.384C6.809 19.664 9.315 20.25 12 20.25z" />
                </svg>
                Rooms capacity in a hotel
                </div>
                </Link>
            </nav>
            {subpage === undefined && 
            <div>
                {roomAreaView &&
                <div className='justify-center text-center'>
                    <Table striped bordered hover size="sm" className='w-full text-center'>
                        <thead>
                        <tr>
                            <th>Area</th>
                            <th>Number of rooms</th>
                        </tr>
                        </thead>
                        <tbody>
                        {roomArea.map(room => (
                            <tr key={room.area}>
                            <td>{room.area}</td>
                            <td>{room.count}</td>
                            </tr>
                        ))}
                        </tbody>
                    </Table>
                </div>
                }    
            </div>}
            {subpage === 'hotel_chain' && 
            <div className='justify-center text-center'>
                <select className='border my-2 py-2 px-3 rounded-2xl' value={hotelId} onChange={getView}>
                    <option value="">Select hotel</option>
                    {hotels.map(hotel => <option key={hotel.hotel_id} value={hotel.hotel_id}>{hotel.hname}</option>)}
                </select>
                {capacityView &&
                <div className='justify-center text-center'>
                    <Table striped bordered hover size="sm" className='w-full text-center'>
                        <thead>
                        <tr>
                            <th>Room number</th>
                            <th>Capacity</th>
                        </tr>
                        </thead>
                        <tbody>
                        {roomCapacity.map(room => (
                            <tr key={room.room_number}>
                            <td>{room.room_number}</td>
                            <td>{room.capacity}</td>
                            </tr>
                        ))}
                        </tbody>
                    </Table>
                </div>
                }
            </div>}
        </div>
    )
}