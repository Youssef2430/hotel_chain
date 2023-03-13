import {useContext} from 'react';
import {UserContext} from '../UserContext.jsx';

export default function AccountPage() {
    const {user} = useContext(UserContext);
    return (
        <div>
            Welcome {user.fullname} !!!
        </div>
    );
}