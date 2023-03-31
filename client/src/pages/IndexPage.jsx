import { useEffect, useState } from "react";
import axios from "axios";
import { Link } from "react-router-dom";
import SearchBar from "./SearchBar";

export default function IndexPage() {

    const [searchResults, setSearchResults] = useState([]);

    useEffect(() => {
        axios.get('/room').then(response => {
            setSearchResults(response.data);
            // console.log(response.data);
        });
    }, []);


    return (
        <div>
            <SearchBar setSearchResults = {setSearchResults}/>
            <div className="mt-8 gap-8 grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4">
                {searchResults.length > 0 && searchResults.map(room => {
                    let parts = room.address.split(', ');
                    let city = parts[1];
                    let country = parts[3];
                    return (
                        <Link to={"/"+room.hotel_id+"$"+room.room_number} className="cursor-pointer" key={room.hotel_id+"$"+room.room_number}>
                            <div className="bg-gray-500 rounded-2xl flex">
                                {room.pictures?.[0] &&
                                    <img className="rounded-2xl object-cover aspect-square" src={'http://localhost:6060/uploads/'+room.pictures[0]} alt="room" />
                                }
                            </div>
                            <div className="flex justify-between">
                                <h2 className="text-md font-bold pt-2">{city+", "+country}</h2>
                                <div className="flex items-center">
                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-6 h-6 pt-2">
                                        <path fillRule="evenodd" d="M10.788 3.21c.448-1.077 1.976-1.077 2.424 0l2.082 5.007 5.404.433c1.164.093 1.636 1.545.749 2.305l-4.117 3.527 1.257 5.273c.271 1.136-.964 2.033-1.96 1.425L12 18.354 7.373 21.18c-.996.608-2.231-.29-1.96-1.425l1.257-5.273-4.117-3.527c-.887-.76-.415-2.212.749-2.305l5.404-.433 2.082-5.006z" clipRule="evenodd" />
                                    </svg>
                                    <h2 className="text-md bold pt-2">{room.rating}</h2>
                                </div>
                                
                            </div>
                            <h2 className="text-sm italic ">{room.hname}</h2>
                            <h3 className="text-xs">{room.view}</h3>
                            <div>
                                <span className="font-bold text-md">{"$" +room.price}</span> per night
                            </div>
                        </Link>
                    );
                })}
            </div>
        </div>
    );
}