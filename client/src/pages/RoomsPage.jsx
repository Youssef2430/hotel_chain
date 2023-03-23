export default function RoomsPage() {

    return (
        <div className="mt-4 grow flex items-center justify-around">
            <div className="mb-32">
                <h1 className="text-4xl text-center mb-6">Rooms</h1>
                <div className="max-w-md mx-auto">
                    <div className="flex gap-1 justify-around">
                        <div className="w-{1/8}" >
                            <input type="text" placeholder="Room number" />
                        </div>
                        <input type="text" placeholder="Room type" />
                    </div>
                    <div className="flex gap-1 justify-around">
                        <input type="text" placeholder="Room price" />
                        <input type="text" placeholder="Room status" />
                    </div>
                    <button className="text-white" type="submit">Search</button>
                </div>
            </div>
        </div>
    )

}