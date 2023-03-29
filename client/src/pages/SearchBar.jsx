import { useEffect, useState } from "react"
import axios from "axios";

export default function SearchBar() {

    const [hotelChains, setHotelChains] = useState([]);
    const [hotels, setHotels] = useState([]);
    const [regions, setRegions] = useState([]);
    const [hotel_chain, setHotelChain] = useState([]);
    const [hotel, setHotel] = useState([]);
    const [region, setRegion] = useState([]);
    const [price, setPrice] = useState([]);
    const [rating, setRating] = useState([]);
    const [numRooms, setNumRooms] = useState([]);
    const [checkIn, setCheckIn] = useState([]);
    const [checkOut, setCheckOut] = useState([]);

    async function search(ev) {
        ev.preventDefault();
        console.log(checkIn, checkOut);
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


    return (
        <form className="m-8" onSubmit={search}>
            <div>
                <select className='w-full border my-2 py-2 px-3 rounded-2xl' value={hotel_chain} onChange={ev => setHotelChain(ev.target.value)}>
                    <option value="0">Select hotel chain</option>
                    {hotelChains.map(hotelChain => <option key={hotelChain.chain_id} value={hotelChain.chain_id}>{hotelChain.name}</option>)}
                </select>
            </div>
            <div className="flex gap-3">
                <div className="w-full flex gap-3">
                    <select className='w-full border my-2 py-2 px-3 rounded-2xl' value={hotel} onChange={ev => setHotel(ev.target.value)}>
                        <option value="0">Select hotel</option>
                        {hotels.map(hotel => <option key={hotel.hotel_id} value={hotel.hotel_id}>{hotel.hname}</option>)}
                    </select>
                    <select className='w-full border my-2 py-2 px-3 rounded-2xl' value={region} onChange={ev => setRegion(ev.target.value)}>
                        <option value="0">Region</option>
                        {regions.map(reg => <option key={reg} value={reg}>{reg}</option>)}
                    </select>
                    
                </div>
                
                
                <div className="w-full flex gap-2">
                    <input className="w-min" type="number" placeholder="Num of rooms"
                        value={numRooms}
                        onChange={ev => setNumRooms(ev.target.value)}
                    />
                    <input type="number" placeholder="Price"
                        value={price}
                        onChange={ev => setPrice(ev.target.value)}
                    />
                    <input type="number" placeholder="Rating" min={1} max={5}
                        value={rating}
                        onChange={ev => setRating(ev.target.value)}
                    />
                </div>
                
            </div>
            <div className="flex items-center justify-between">
                <div className="flex gap-2">  
                    <div>   
                        <p className="italic text-sm">Check In</p>
                        <input 
                        value={checkIn}
                        onChange={ev => setCheckIn(ev.target.value)}
                        className="w-full border my-2 py-2 px-3 rounded-2xl" type = "date" name = "date"/>  
                    </div> 
                    <div>   
                        <p className="italic text-sm">Check Out</p>
                        <input 
                        value={checkOut}
                        onChange={ev => setCheckOut(ev.target.value)}
                        className="w-full border my-2 py-2 px-3 rounded-2xl" type = "date" name = "date"/>  
                    </div> 

                    <script src = "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>  
                    <script src ="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
                </div>
                <div>
                    <button className="w-full h-15 text-white" type="submit">Search</button>
                </div>
            </div>
            
        </form>
    )
}