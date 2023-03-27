import axios from 'axios';
import {useEffect, useState} from 'react';
import { Link, useParams } from 'react-router-dom';
import Amenities from './Amenities';
import { useNavigate } from 'react-router';

export default function RoomEdit() {

    let {subpage2} = useParams();
    const [hotels, setHotels] = useState([]);
    const [room, setRoom] = useState(null);
    const [hotelId, setHotelId] = useState("");
    const [roomNumber, setRoomNumber] = useState("");
    const [picLink, setPicLink] = useState([]);
    const [pictures, setPictures] = useState([]);
    const [amenities, setAmenities] = useState([]);
    const [roomCapacity, setRoomCapacity] = useState("");
    const [extendable, setExtendable] = useState(false);
    const [roomPrice, setRoomPrice] = useState("");
    const [roomView, setRoomView] = useState("");
    const [damaged, setDamaged] = useState(false);

    const navigate = useNavigate();

    useEffect(() => {
        axios.get('/rooms/'+subpage2).then(({data}) => {
            // console.log(data);
            setRoom(data);
            setRoomNumber(data.room_number);
            setHotelId(data.hotel_id);
            setPictures(data.pictures);
            setAmenities(data.amenities);
            setRoomCapacity(data.capacity);
            setExtendable(data.extendable);
            setRoomPrice(data.price);
            setRoomView(data.view);
            setDamaged(data.damaged);
            console.log(data);
        } );

        axios.get("/hotel").then((data) => {
            setHotels(data.data);
        });

        

    }, []);

    async function addPictureByLink(ev) {
        ev.preventDefault();
        const {data:filename} = await axios.post('/upload-by-link', {link:picLink})
        setPictures([...pictures, filename]);
        setPicLink("");
    }
    
    async function uploadPicture(ev) {
        ev.preventDefault();
        const formData = new FormData();
        for (let i = 0; i < ev.target.files.length; i++) {
            formData.append('pictures', ev.target.files[i]);
        }
        const {data:filenames} = await axios.post('/upload', formData, 
            {headers: {'Content-Type': 'multipart/form-data'}});
        setPictures([...pictures, ...filenames]);
    }

    async function editRoom(ev) {
        ev.preventDefault();
        try {
            await axios.post('/rooms/'+subpage2, {
                roomNumber,
                hotelId,
                pictures,
                amenities,
                roomCapacity,
                extendable,
                roomPrice,
                roomView,
                damaged
            });
            alert("Room edited !");
            navigate('/account/rooms/');
        } catch (error) {
            alert("A problem occured !");
        }
    }


    return (
        <div>
            <div className='flex justify-between items-center text-center max-w-lg mx-auto'>
                <h1 className='text-3xl'>Edit Room</h1>
                <Link to='/account/rooms'>
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6">
                        <path strokeLinecap="round" strokeLinejoin="round" d="M9 15L3 9m0 0l6-6M3 9h12a6 6 0 010 12h-3" />
                    </svg>
                </Link>
            </div>
            <form onSubmit={editRoom}>
                <h2 className='text-2xl mt-4'>Hotel</h2>
                <p className='text-gray-500 text-sm'>To which hotel does this room belong to</p>
                <select className='w-full border my-2 py-2 px-3 rounded-2xl' value={hotelId} onChange={ev => setHotelId(ev.target.value)}>
                    <option value="">Select hotel</option>
                    {hotels.map(hotel => <option key={hotel.hotel_id} value={hotel.hotel_id}>{hotel.hname}</option>)}
                </select>
                <h2 className='text-2xl mt-4'>Room Number</h2>
                <p className='text-gray-500 text-sm'>Number for the room</p>
                <input type="text" placeholder="Room Number"
                    value={roomNumber} 
                    onChange={ev => setRoomNumber(ev.target.value)}
                />
                <h2 className='text-2xl mt-4'>Pictures</h2>
                <p className='text-gray-500 text-sm'>The more = the better</p>
                <div className='flex gap-2'>
                    <input type="text" placeholder={'Add using a link ....jpg'}
                        value={picLink}
                        onChange={ev => setPicLink(ev.target.value)}
                    />
                    <button onClick={addPictureByLink} className='bg-gray-200 px-4 rounded-2xl'>Add&nbsp;photo</button>
                </div>
                <div className='mt-2 grid gap-2 grid-cols-3 md:grid-cols-4 lg:grid-cols-6'>
                    {pictures.length > 0 && pictures.map(pic => (
                        <div className='h-32 flex' key={pic}>
                            <img alt='room-img' className="rounded-2xl w-full object-cover" src={'http://localhost:6060/uploads/'+pic}/>
                        </div>
                    ))}
        
                    <label className='h-32 cursor-pointer flex items-center gap-1 justify-center border bg-transparent rounded-2xl p-2 text-xl text-gray-600'>
                        <input type="file" multiple className='hidden' onChange={uploadPicture}/>
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-8 h-8">
                            <path strokeLinecap="round" strokeLinejoin="round" d="M12 16.5V9.75m0 0l3 3m-3-3l-3 3M6.75 19.5a4.5 4.5 0 01-1.41-8.775 5.25 5.25 0 0110.233-2.33 3 3 0 013.758 3.848A3.752 3.752 0 0118 19.5H6.75z" />
                        </svg>
                        Upload
                    </label>
                </div>
                <h2 className='text-2xl mt-4'>Amenities</h2>
                <p className='text-gray-500 text-sm'>what does the room have</p>
                <Amenities selected={amenities} onChange={setAmenities}/>
                <h2 className='text-2xl mt-4'>Capacity</h2>
                <p className='text-gray-500 text-sm'>How many people can the room fit</p>
                <div className='flex items-center gap-2'>
                    <input type="text" placeholder="capacity"
                        value={roomCapacity} 
                        onChange={ev => setRoomCapacity(ev.target.value)}
                    />
                    <label className="border p-2 flex rounded-2xl gap-2 items-center cursor-pointer">
                        <input type="checkbox"
                            onChange={ev => setExtendable(ev.target.checked)}
                            checked={extendable}
                        />
                        <span className='ml-2'>Extendable?</span>
                    </label>
                </div>
                <h2 className='text-2xl mt-4'>Price</h2>
                <p className='text-gray-500 text-sm'>How much does the room cost per night</p>
                <input type="text" placeholder="price"
                    value={roomPrice}
                    onChange={ev => setRoomPrice(ev.target.value)}
                />
                <h2 className='text-2xl mt-4'>View</h2>
                <p className='text-gray-500 text-sm'>Select the room's view</p>
                <select className='w-full border my-2 py-2 px-3 rounded-2xl' onChange={e=>setRoomView(e.target.value)} value={roomView}>
                    <option value="">Select a view</option>
                    <option value="Sea View">Sea View</option>
                    <option value="Mountain View">Mountain View</option>
                    <option value="City View">City View</option>
                </select>
                <h2 className='text-2xl mt-4'>State</h2>
                <p className='text-gray-500 text-sm'>Is the room damaged ?</p>
                <label className="border p-2 flex rounded-2xl gap-2 items-center cursor-pointer">
                    <input type="checkbox"
                        onChange={ev => setDamaged(ev.target.checked)}
                        checked={damaged}
                    />
                    <span className='ml-2'>Damaged ?</span>
                </label>

                <button type="submit" className='py-2 px-4 bg-primary text-white rounded-full'>Save Edit</button>
            </form>
        </div>
    )
}