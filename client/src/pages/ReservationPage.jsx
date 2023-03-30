import axios from 'axios';
import {useEffect, useState} from 'react';
import { Link, useParams } from 'react-router-dom';
import { useNavigate } from 'react-router';

export default function ReservationPage() {

    let {subpage2} = useParams();
    const [reservationData, setReservationData] = useState({});
    const [showAllPictures, setShowAllPictures] = useState(false);
    const [checkIn, setCheckIn] = useState('');
    const [checkOut, setCheckOut] = useState('');

    const navigate = useNavigate();

    useEffect(() => {
        axios.get('/single-reservations/'+subpage2).then(({data}) => {
            console.log(data);
            setReservationData(data);
            setCheckIn(data.check_in);
            setCheckOut(data.check_out);
        } );

    }, [subpage2]);

    if(!reservationData) {
        return <div>Nothing here</div>
    }

    if(showAllPictures) {
        return (
            <div className='absolute inset-0 bg-gray-400 min-h-screen'>
                <div className='bg-gray-400 p-8 grid gap-4'>
                    <div>
                        <button onClick={() => setShowAllPictures(false)} className="fixed flex gap-1 py-2 px-4 rounded-2xl text-black bg-gray-100">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-6 h-6">
                                <path fillRule="evenodd" d="M2.515 10.674a1.875 1.875 0 000 2.652L8.89 19.7c.352.351.829.549 1.326.549H19.5a3 3 0 003-3V6.75a3 3 0 00-3-3h-9.284c-.497 0-.974.198-1.326.55l-6.375 6.374zM12.53 9.22a.75.75 0 10-1.06 1.06L13.19 12l-1.72 1.72a.75.75 0 101.06 1.06l1.72-1.72 1.72 1.72a.75.75 0 101.06-1.06L15.31 12l1.72-1.72a.75.75 0 10-1.06-1.06l-1.72 1.72-1.72-1.72z" clipRule="evenodd" />
                            </svg>
                            Close pictures
                        </button>
                    </div>
                    {reservationData.pictures.length > 0 && reservationData.pictures.map(photo => (
                        <div>
                            <img src={'http://localhost:6060/uploads/'+photo} alt="" />
                        </div>
                    ))}
                </div>
            </div>
        )
    }

    function confirmReservation() {

        axios.post(('/confirm-reservation/'+subpage2), {status:"rented"}).then(({data}) => {
            console.log(data);
            alert('Reservation confirmed');
            navigate('/account/reservations');
        });
    }

    function closeReservation() {

        axios.post(('/confirm-reservation/'+subpage2), {status:"finished"}).then(({data}) => {
            console.log(data);
            alert('Reservation closed');
            navigate('/account/reservations');
        });
    }

    return (
        <div>
            <div className='flex justify-between items-center text-center max-w-lg mx-auto'>
                <h1 className='text-3xl'>Confirm reservation</h1>
                <Link to='/account/reservations'>
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6">
                        <path strokeLinecap="round" strokeLinejoin="round" d="M9 15L3 9m0 0l6-6M3 9h12a6 6 0 010 12h-3" />
                    </svg>
                </Link>
            </div>
            <div className='mt-4 -mx-8 px-8 py-6'>
            <h1 className='text-2xl'>{reservationData.hname}</h1>
            <a target="_blank" href={'https://maps.google.com/?q='+reservationData.address} className='my-2 block font-semibold underline' rel="noreferrer">{reservationData.address}</a>
            <div className='relative'>
                <div className="grid gap-2 grid-cols-[2fr_1fr]">
                    <div>
                        {reservationData.pictures?.[0] && (
                            <div>
                                <img className='aspect-square object-cover' src={'http://localhost:6060/uploads/'+reservationData.pictures[0]} alt="" />
                            </div>
                        )}
                    </div>
                    <div className='grid'>
                        {reservationData.pictures?.[1] && (
                            <img className='aspect-square object-cover' src={'http://localhost:6060/uploads/'+reservationData.pictures[1]} alt="" />
                        )}
                        <div className='overflow-hidden'>
                            {reservationData.pictures?.[2] && (
                                <img className='aspect-square object-cover relative top-2' src={'http://localhost:6060/uploads/'+reservationData.pictures[2]} alt="" />
                            )}
                            {!reservationData.pictures?.[2] && (
                                <img className='aspect-square bg-gray-400 object-cover relative top-2' src={''} alt="" />
                            )}
                        </div>
                        
                    </div>
                </div>
                <button onClick={() => setShowAllPictures(true)} className='absolute bottom-2 right-2 py-2 px-4 bg-white rounded-2xl border border-black text-black'>Show more pictures</button>
            </div>
            <div className='grid grid-cols-2'>
                <div className='mt-10'>
                <h2 className='text-2xl mt-4'>Reservation status</h2>
                    {reservationData.status}
                    <h2 className='text-2xl mt-4'>Customer's email</h2>
                    {reservationData.email}
                    <h2 className='text-2xl mt-4'>View</h2>
                    {reservationData.view}
                    <h2 className='text-2xl mt-4'>Capacity</h2>
                    <div className='flex gap-5'>
                        <div>
                            Guest number : {reservationData.capacity}
                        </div>
                        {reservationData.extendable && (
                            <div className='italic'>(Extendable)</div>
                        )}
                    </div>
                </div>
                <div>
                    <div className='p-4 shadow bg-gray-200 mt-4 rounded-2xl'>
                        <h2 className='text-2xl pb-2 text-center'>
                        Price: {reservationData.price}$ / night
                        </h2>
                        <div className='flex my-4 border bg-white shadow py-4 px-4 rounded-2xl justify-between'>
                            <label>Check in date :</label>
                            <div>{checkIn.split("T")[0]}</div>
                        </div>
                        <div className='flex my-4 border bg-white shadow py-4 px-4 rounded-2xl justify-between'>
                            <label>Check out date :</label>
                            <div>{checkOut.split("T")[0]}</div>
                        </div>
                        <h2 className='text-2xl pb-2 text-center bold italic'>
                            <div>Total to pay : {((Math.abs(new Date(reservationData.check_out) - new Date(reservationData.check_in)))/(1000 * 60 * 60 * 24))*reservationData.price}$</div>
                        
                        </h2>
                        <button onClick={confirmReservation} className='bg-primary p-2 my-2 text-white rounded-2xl w-full'>Confirm reservation</button>
                        <button onClick={closeReservation} className='bg-black p-2 text-white rounded-2xl w-full'>Close reservation</button>
                    </div>
                </div>
                
            </div>
            
        </div>
        </div>
    )
}