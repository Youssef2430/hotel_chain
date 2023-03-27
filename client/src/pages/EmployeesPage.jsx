import {useEffect, useState} from 'react';
import axios from 'axios';
import {Link} from 'react-router-dom';

export default function EmployeesPage() {

    const [employees, setEmployees] = useState([]);

    useEffect(() => {
        axios.get("/employee").then((data) => {
            setEmployees(data.data);
        });
    }, []);

    return (
        <div className='text-center max-w-lg mx-auto'>
        <div className='py-6'>List of employees</div>
        <div className='px-4 py-6'>
            {employees.length > 0 && employees.map(employee => {
                return <div className='border py-1' key={employee.sin}>{employee.email} | {employee.role}</div>
            })}
        </div>
        <Link className="py-2 px-4 bg-primary text-white rounded-full" to="/account/employees/add_employee">Add an employee</Link>
    </div>
    );
}