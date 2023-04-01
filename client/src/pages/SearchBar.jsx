import { useEffect, useState } from "react"
import axios from "axios";
import { useNavigate } from 'react-router';

export default function SearchBar(props) {

    const [hotelChains, setHotelChains] = useState([]);
    const [hotels, setHotels] = useState([]);
    const [regions, setRegions] = useState([]);
    const [hotel_chain, setHotelChain] = useState('');
    const [hotel, setHotel] = useState('');
    const [region, setRegion] = useState('');
    const [price, setPrice] = useState('');
    const [rating, setRating] = useState('');
    const [numRooms, setNumRooms] = useState('');
    const [checkIn, setCheckIn] = useState('');
    const [checkOut, setCheckOut] = useState('');
    const [category, setCategory] = useState('');
    const navigate = useNavigate();

    async function setVariables(ev){
        ev.preventDefault();
        let response = null;
        if (ev.target.id === "chains") {
            setHotelChain(ev.target.value);
            response = await axios.get("/search", {params : {hotel_chain_id: ev.target.value, hotel_id: hotel, city: region, checkIn: checkIn, checkOut: checkOut, num_of_rooms: numRooms, price:price, rating: rating, category: category}});
            props.setSearchResults(response.data);
            console.log(response.data);
        } else if (ev.target.id === "hotels") {
            setHotel(ev.target.value);
            response = await axios.get("/search", {params : {hotel_chain_id: hotel_chain, hotel_id: ev.target.value, city: region, checkIn: checkIn, checkOut: checkOut, num_of_rooms: numRooms, price:price, rating: rating, category: category}});
            props.setSearchResults(response.data);
            console.log(response.data);
        } else if (ev.target.id === "regions") {
            setRegion(ev.target.value);
            response = await axios.get("/search", {params : {hotel_chain_id: hotel_chain, hotel_id: hotel, city: ev.target.value, checkIn: checkIn, checkOut: checkOut, num_of_rooms: numRooms, price:price, rating: rating, category: category}});
            props.setSearchResults(response.data);
            console.log(response.data);
        } else if (ev.target.id === "price") {
            setPrice(ev.target.value);
            response = await axios.get("/search", {params : {hotel_chain_id: hotel_chain, hotel_id: hotel, city: region, checkIn: checkIn, checkOut: checkOut, num_of_rooms: numRooms, price:ev.target.value, rating: rating, category: category}});
            props.setSearchResults(response.data);
            console.log(response.data);
        } else if (ev.target.id === "rating") {
            setRating(ev.target.value);
            response = await axios.get("/search", {params : {hotel_chain_id: hotel_chain, hotel_id: hotel, city: region, checkIn: checkIn, checkOut: checkOut, num_of_rooms: numRooms, price:price, rating: ev.target.value, category: category}});
            props.setSearchResults(response.data);
            console.log(response.data);
        } else if (ev.target.id === "numRooms") {
            setNumRooms(ev.target.value);
            response = await axios.get("/search", {params : {hotel_chain_id: hotel_chain, hotel_id: hotel, city: region, checkIn: checkIn, checkOut: checkOut, num_of_rooms: ev.target.value, price:price, rating: rating, category: category}});
            props.setSearchResults(response.data);
            console.log(response.data);
        } else if (ev.target.id === "checkIn") {
            setCheckIn(ev.target.value);
            response = await axios.get("/search", {params : {hotel_chain_id: hotel_chain, hotel_id: hotel, city: region, checkIn: ev.target.value, checkOut: checkOut, num_of_rooms: numRooms, price:price, rating: rating, category: category}});
            props.setSearchResults(response.data);
            console.log(response.data);
        } else if (ev.target.id === "checkOut") {
            setCheckOut(ev.target.value);
            response = await axios.get("/search", {params : {hotel_chain_id: hotel_chain, hotel_id: hotel, city: region, checkIn: checkIn, checkOut: ev.target.value, num_of_rooms: numRooms, price:price, rating: rating, category: category}});
            props.setSearchResults(response.data);
            console.log(response.data);
        } else if (ev.target.id === "category") {
            setCategory(ev.target.value);
            response = await axios.get("/search", {params : {hotel_chain_id: hotel_chain, hotel_id: hotel, city: region, checkIn: checkIn, checkOut: checkOut, num_of_rooms: numRooms, price:price, rating: rating, category: ev.target.value}});
            props.setSearchResults(response.data);
            console.log(response.data);
        }
    }

    async function search(ev) {
        ev.preventDefault();
        setVariables(ev);
    }

    useEffect(() => {
        axios.get("/hotel_chain").then(data => {
            setHotelChains(data.data);
        });
        axios.get("/hotel").then(data => {
            setHotels(data.data);
            data.data.forEach((hotel) => {
                let parts = hotel.address.split(", ")
                let region = parts[1];
                if((typeof region !== "undefined") && !regions.includes(region)) {
                    setRegions([...regions, region]);
                }
            });
        });
    });

    function goToViews(ev){
        ev.preventDefault();
        navigate("/views");
    }


    return (
        <form className="m-8" onSubmit={goToViews}>
            <div className="grid gap-2 grid-cols-[2fr_1fr]">
                <select className='w-full border my-2 py-2 px-3 rounded-2xl' id="chains" value={hotel_chain} onChange={search}>
                    <option value="">Select hotel chain</option>
                    {hotelChains.map(hotelChain => <option key={hotelChain.chain_id} value={hotelChain.chain_id}>{hotelChain.name}</option>)}
                </select>
                <select className='w-full border my-2 py-2 px-3 rounded-2xl' id="category" value={category} onChange={search}>
                    <option value="">Select a category</option>
                    <option value="Luxurious">Luxurious</option>
                    <option value="Comfortable">Comfortable</option>
                    <option value="Economic">Economic</option>
                </select>
            </div>
            <div className="flex gap-3">
                <div className="w-full flex gap-3">
                    <select className='w-full border my-2 py-2 px-3 rounded-2xl' id="hotels" value={hotel} onChange={search}>
                        <option value="">Select hotel</option>
                        {hotels.map(hotel => <option key={hotel.hotel_id} value={hotel.hotel_id}>{hotel.hname}</option>)}
                    </select>
                    <select className='w-full border my-2 py-2 px-3 rounded-2xl' id="regions" value={region} onChange={search}>
                        <option value="">Region</option>
                        {regions.map(reg => <option key={reg} value={reg}>{reg}</option>)}
                    </select>
                    
                </div>
                
                
                <div className="w-full flex gap-2">
                    <input className="w-min" type="number" id="numRooms" placeholder="Num of rooms"
                        value={numRooms}
                        onChange={search}
                    />
                    <input type="number" id="price" placeholder="Price"
                        value={price}
                        onChange={search}
                    />
                    <input type="number" id="rating" placeholder="Rating" min={1} max={5}
                        value={rating}
                        onChange={search}
                    />
                </div>
                
            </div>
            <div className="flex items-center justify-between">
                <div className="flex gap-2">  
                    <div>   
                        <p className="italic text-sm">Check In</p>
                        <input 
                        id="checkIn"
                        value={checkIn}
                        onChange={search}
                        className="w-full border my-2 py-2 px-3 rounded-2xl" type = "date" name = "date"/>  
                    </div> 
                    <div>   
                        <p className="italic text-sm">Check Out</p>
                        <input 
                        id="checkOut"
                        value={checkOut}
                        onChange={search}
                        className="w-full border my-2 py-2 px-3 rounded-2xl" type = "date" name = "date"/>  
                    </div> 

                    <script src = "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>  
                    <script src ="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
                </div>
                <div>
                    <button className="w-full h-15 text-white" type="submit">Go to views</button>
                </div>
            </div>
            
        </form>
    )
}