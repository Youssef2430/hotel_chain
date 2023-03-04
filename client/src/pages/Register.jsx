import { Link } from "react-router-dom";

export default function Register() {
    return (
        <div className="mt-4 grow flex items-center justify-around">
            <div className="mb-32">
                <h1 className="text-4xl text-center mb-6">Register</h1>
                <form className="max-w-md mx-auto">
                    <input type="text" placeholder="Name"/>
                    <input type="email" placeholder="your@email.com"/>
                    <input type="tel" placeholder="Phone number"/>
                    <div className="flex gap-1 justify-around">
                        <div className="w-{1/8}" >
                        <input type="text" placeholder="Street number" />
                        </div>
                        <input type="text" placeholder="Street name" />
                    </div>
                    <div className="flex gap-1 justify-around">
                    <input type="text" placeholder="Country" />
                    <input type="text" placeholder="City" />
                    <input type="text" placeholder="Postal code" />
                    </div>
                    
                    <input type="password" placeholder="Password"/>
                    <button type="submit">Register</button>
                    <div className="text-center py-2 text-gray-500">
                        Already a member ? <Link className="underline text-black" to={"/login"}>Login</Link>
                    </div>
                </form>
            </div>
        </div>
    );
}