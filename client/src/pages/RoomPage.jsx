import {useParams } from 'react-router-dom';

export default function RoomPage() {

    let {room} = useParams();

    return (
        <div> here is the room page, {room} </div>
    )
}