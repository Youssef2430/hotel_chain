import {useState} from 'react';
import { useNavigate } from 'react-router';
import axios from 'axios';
import {useParams } from 'react-router-dom';

export default function RatingPage() {

    const [rating, setRating] = useState("");
    let {subpage2} = useParams();
    const navigate = useNavigate();

    async function submitRating(ev) {
        ev.preventDefault();
        try {
            const response = await axios.post("/rating", { rating, reservation_id: subpage2 });
            console.log(response.data);
            alert("Rating submitted !");
            navigate("/account/bookings");
        } catch (error) {
            alert("A problem occured !");
        }
    }

    return (
        <div className='text-center max-w-lg mx-auto'>
            <form className="max-w-md mx-auto" onSubmit={submitRating}>
                <input type="number" placeholder="Chain Name" min={1} max={5}
                value={rating} 
                onChange={ev => setRating(ev.target.value)}/>
                <button className='text-white' type="submit">Rate your reservation</button>
            </form>
        </div>
    )
}