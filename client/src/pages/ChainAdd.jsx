import {useState} from 'react';
import { useNavigate } from 'react-router';
import axios from 'axios';

export default function ChainAdd() {

    const [chain_name, setChainName] = useState("");
    const navigate = useNavigate();

    async function handleAddChain(ev) {
        ev.preventDefault();
        try {
            const response = await axios.post("/hotel_chain", { chain_name });
            if(typeof response.data === "string") {
                alert(response.data);
                return;
            }
            alert("Chain added !");
            navigate('/account/hotel_chain');
            
        } catch (error) {
            alert("A problem occured !");
        }
    } 


    return (
        <div className='text-center max-w-lg mx-auto'>
            <form className="max-w-md mx-auto" onSubmit={handleAddChain}>
                <input type="text" placeholder="Chain Name"
                value={chain_name} 
                onChange={ev => setChainName(ev.target.value)}/>
                <button className='text-white' type="submit">Add Chain</button>
            </form>
        </div>
    );
}