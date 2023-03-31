import {useEffect, useState} from 'react';
import axios from 'axios';
import {Link} from 'react-router-dom';
import Table from 'react-bootstrap/Table';
import { useNavigate } from 'react-router';

export default function EmployeesPage() {

    const [employees, setEmployees] = useState([]);
    const [hotels, setHotels] = useState([]);
    const [hotelId, setHotelId] = useState("");
    const navigate = useNavigate();

    useEffect(() => {
        axios.get("/employee").then((data) => {
            setEmployees(data.data);
        });
        axios.get("/hotel").then((data) => {
            setHotels(data.data);
        } );
    }, []);


    function findId(data, idToLookFor) {
        var categoryArray = data;
        for (var i = 0; i < categoryArray.length; i++) {
            if (categoryArray[i].hotel_id === idToLookFor) {
                return(categoryArray[i].hname);
            }
        }
        return 'No hotels bound to this employee';
    }

    async function changeHotel(employee_id) {
        console.log(employee_id);
        try {
            await axios.put('/change_employee_hotel', {
                hotel_id: hotelId,
                employee_id: employee_id
            });
            alert("Hotel changed !");
            navigate('/account/employees');
        } catch (err) {
            alert("Error while changing hotel !");
        }
    }

    return (
        <div className='text-center mx-auto'>
        <div className='py-6'>List of employees</div>
        <div className='px-4 py-6'>
                    <Table striped bordered hover size="sm" className='w-full text-center'>
                        <thead>
                        <tr>
                            <th>Employee's email</th>
                            <th>Role</th>
                            <th>Hotel</th>
                            <th>Hotel transfer ?</th>
                        </tr>
                        </thead>
                        <tbody>
                        {employees.map(employee => (
                            <tr key={employee.email}>
                            <td>{employee.email}</td>
                            <td>{employee.role}</td>
                            <td>{findId(hotels, employee.hotel_id)}</td>
                            <td className='flex items-center gap-2'>
                                <select className='w-full border my-2 py-2 px-3 rounded-2xl' value={hotelId} onChange={ev => setHotelId(ev.target.value)}>
                                <option value="">Change employee's hotel</option>
                                {hotels.map(hotel => <option key={hotel.hotel_id} value={hotel.hotel_id}>{hotel.hname}</option>)}
                                </select>
                                <div className='cursor-pointer' onClick={() => changeHotel(employee.employee_id)}>
                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-6 h-6">
                                    <path d="M9.97.97a.75.75 0 011.06 0l3 3a.75.75 0 01-1.06 1.06l-1.72-1.72v3.44h-1.5V3.31L8.03 5.03a.75.75 0 01-1.06-1.06l3-3zM9.75 6.75v6a.75.75 0 001.5 0v-6h3a3 3 0 013 3v7.5a3 3 0 01-3 3h-7.5a3 3 0 01-3-3v-7.5a3 3 0 013-3h3z" />
                                    <path d="M7.151 21.75a2.999 2.999 0 002.599 1.5h7.5a3 3 0 003-3v-7.5c0-1.11-.603-2.08-1.5-2.599v7.099a4.5 4.5 0 01-4.5 4.5H7.151z" />
                                    </svg>
                                </div>
                            </td>
                            </tr>
                        ))}
                        </tbody>
                    </Table>
        </div>
        <Link className="py-2 px-4 bg-primary text-white rounded-full" to="/account/employees/add_employee">Add an employee</Link>
    </div>
    );
}