import {useEffect, useState} from 'react';
import axios from 'axios';
import {Link} from 'react-router-dom';

export default function HotelChainsPage() {

    const [chains, setChains] = useState([]);

    useEffect(() => {
        axios.get("/hotel_chain").then((data) => {
            setChains(data.data);
        });
    }, []);

    return (
        <div className='text-center max-w-lg mx-auto'>
                <div className='py-6'>List of hotel chains</div>
                <div className='px-4 py-6'>
                    {chains.length > 0 && chains.map(chain => {
                        return <div className='border py-1' key={chain.chain_id}>{chain.name}</div>
                    })}
                </div>
                <Link className="py-2 px-4 bg-primary text-white rounded-full" to="/account/hotel_chain/add_hotel_chain">Add a hotel chain</Link>
            </div>
    )

}