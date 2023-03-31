import {useEffect, useState} from 'react';
import axios from 'axios';
import {Link} from 'react-router-dom';
import Table from 'react-bootstrap/Table';

export default function Offices(){

    const [chains, setChains] = useState([]);
    const [chainId, setChainId] = useState("");
    const [offices, setOffices] = useState([]);
    const [officesSet, setOfficesSet] = useState(false);

    useEffect(() => {
        axios.get("/hotel_chain").then((data) => {
            setChains(data.data);
        });
    }, []);

    async function getOffices(ev) {
        ev.preventDefault();
        setChainId(ev.target.value);
        const view = await axios.get("/offices", {params: {chain_id: ev.target.value}});
        setOffices(view.data);
        setOfficesSet(true);
    }

    async function deleteOffice(office_id) {
        const response = await axios.delete("/offices/"+chainId+"/"+office_id);
        setOffices(response.data);
    }

    return (
        <div className='text-center'>
            <div>
            <select className='border my-5 mb-10 py-2 px-3 rounded-2xl' value={chainId} onChange={getOffices}>
                    <option value="">Select a chain</option>
                    {chains.map(hotel => <option key={hotel.chain_id} value={hotel.chain_id}>{hotel.name}</option>)}
            </select>
            {officesSet &&
                <div className='justify-center text-center'>
                    <Table striped bordered hover size="sm" className='w-full text-center'>
                        <thead>
                        <tr>
                            <th>Office Name</th>
                            <th>Email</th>
                            <th>Address</th>
                            <th></th>
                        </tr>
                        </thead>
                        <tbody>
                        {offices.map(office => (
                            <tr key={office.office_id}>
                            <td>{office.office_name}</td>
                            <td>{office.email}</td>
                            <td>{office.address}</td>
                            <td>
                                <div className='cursor-pointer' onClick={() => deleteOffice(office.office_id)}>
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-6 h-6">
                                    <path fillRule="evenodd" d="M12 2.25c-5.385 0-9.75 4.365-9.75 9.75s4.365 9.75 9.75 9.75 9.75-4.365 9.75-9.75S17.385 2.25 12 2.25zm-1.72 6.97a.75.75 0 10-1.06 1.06L10.94 12l-1.72 1.72a.75.75 0 101.06 1.06L12 13.06l1.72 1.72a.75.75 0 101.06-1.06L13.06 12l1.72-1.72a.75.75 0 10-1.06-1.06L12 10.94l-1.72-1.72z" clipRule="evenodd" />
                                </svg>
                                </div>
                            </td>
                            </tr>
                        ))}
                        </tbody>
                    </Table>
                </div>
                }
            </div>
            <div className='mt-8'>
            <Link className="py-2 px-4 bg-primary text-white rounded-full" to="/account/offices/add">Add a central office</Link>
            </div>
        </div>
    )
}