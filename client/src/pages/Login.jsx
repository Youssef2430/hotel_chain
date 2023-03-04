import { Link } from "react-router-dom";

export default function Login() {
    return (
        <div className="mt-4 grow flex items-center justify-around">
            <div className="mb-32">
                <h1 className="text-4xl text-center mb-6">Login</h1>
                <form className="max-w-md mx-auto">
                    <input type="email" placeholder="your@email.com"/>
                    <input type="password" placeholder="password"/>
                    <button type="submit">Login</button>
                    <div className="text-center py-2 text-gray-500">
                        Don't have an account ? <Link className="underline text-black" to={"/register"}>Register now</Link>
                    </div>
                </form>
            </div>
        </div>
    );
}