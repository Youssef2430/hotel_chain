import {Link} from 'react-router-dom';

export default function RoomsPage() {

    return (
        <div className='text-center max-w-lg mx-auto'>
            <div className='py-6'>List of rooms</div>
            <Link className="py-2 px-4 bg-primary text-white rounded-full" to="/account/rooms/add_room">Add a room</Link>
        </div>
    )

}
