const express = require('express');
const app = express();
const cors = require('cors');
const pool = require('./db');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const cookieParser = require('cookie-parser');
const imagedownloader = require('image-downloader');
const multer = require('multer');
const fs = require('fs');

const secret_key = bcrypt.genSaltSync(10);
const jwtSecret = "sdhbfsijfdbvsaijbvsab";
// middleware
app.use(cors({
    origin: "http://localhost:3000",
    credentials: true
}));
app.use('/uploads', express.static(__dirname+'/uploads'));
app.use(express.json());
app.use(cookieParser());

// ***** basic routing

// exemple of a post request
// app.post('/person', async (req, res) => {

//     try {
//         const { fullname, gender } = req.body;
//         const newPerson = await pool.query(
//             "INSERT INTO person (fullname, gender) VALUES($1, $2) RETURNING *",
//             [fullname, gender]
//         );
//         res.json(newPerson.rows[0]);
//     } catch (err) {
//         console.error(err.message);
//     }
// });

// exemple of a get request
// app.get('/person', async (req, res) => {
//     try {
//         const allPerson = await pool.query("SELECT * FROM person");
//         res.json(allPerson.rows);
//     } catch (err) {
//         console.error(err.message);
//     }
// });

// exemple of a put request
// app.put('/person/:id', async (req, res) => {

//     try {
//         const{id} = req.params;
//         const{fullname, gender} = req.body;
//         const updatePerson = await pool.query(
//             "UPDATE person SET fullname = $1, gender = $2 WHERE SIN = $3",
//             [fullname, gender, id]
//         );
//         res.json("Person was updated!");
//     } catch (error) {
//         console.error(err.message);
//     }
// });

// exemple of a delete request
// app.delete('/person/:id', async (req, res) => {

//     try {
//         const{id} = req.params;
//         const deletePerson = await pool.query(
//             "DELETE FROM person WHERE SIN = $1",
//             [id]
//         );
//         res.json("Person was deleted!");
//     } catch (error) {
//         console.error(err.message);
//     }
// });

// post request to add customer
app.post('/customer', async (req, res) => {

    try {
        const { name, email, phone, streetNumber, streetName, region, city, postalCode, password } = req.body;
        if(streetNumber == null || streetNumber == undefined || streetNumber == ""){
            address = null;
        }else{
            address = [streetNumber + "&" + streetName + "&" + region + "&" + city + "&" + postalCode];
        }
        let password_encrypt = await bcrypt.hashSync(password, secret_key);
        const newPerson = await pool.query("INSERT INTO person (fullname, email) VALUES ($1, $2) RETURNING *", [name, email]);
        // console.log(newPerson.rows[0]);
        const newCustomer = await pool.query(
            "INSERT INTO customers (sin, email, password, phone_number, customer_address) VALUES ($1, $2, $3, $4, $5) RETURNING *",
            [newPerson.rows[0].sin, email, password_encrypt, [phone], [address]]
        );
        // console.log(newCustomer.rows[0]);
        res.json(newCustomer.rows[0]);
    } catch (err) {
        console.error(err.message);
    }
});

// post request to login customer
app.post('/customer/login', async (req, res) => {
    
        try {
            const { email, password } = req.body;
            const customer = await pool.query(
                "SELECT * FROM customers WHERE email = $1",
                [email]
            );
            if(customer.rows.length == 0){
                res.json("No customer found");
            }else{
                let password_decrypt = await bcrypt.compareSync(password, customer.rows[0].password);
                if(password_decrypt){
                    jwt.sign({id:customer.rows[0].sin}, jwtSecret, {}, (err, token) => {
                        if(err){
                            res.json("Error");
                        }else{
                            res.cookie("token", token).json(customer.rows[0]);
                        }
                    });
                }else{
                    res.json("Wrong password");
                }
            }
        } catch (err) {
            console.error(err.message);
        }
});

app.get("/profile", async (req, res) => {
    const token = req.cookies.token;
    if(token){
        jwt.verify(token, jwtSecret, {}, async (err, decoded) => {
            if(err){
                throw err;
            }else{
                const person = await pool.query(
                    "SELECT * FROM person WHERE sin = $1",
                    [decoded.id]
                );
                res.json(person.rows[0]);
            }
        });
    }else{
        res.json(null);
    }
    
});

app.get("/role", async (req, res) => {
    const token = req.cookies.token;
    if(token){
        jwt.verify(token, jwtSecret, {}, async (err, decoded) => {
            if(err){
                throw err;
            }else{
                const person = await pool.query(
                    "SELECT * FROM customers WHERE sin = $1",
                    [decoded.id]
                );
                if(person.rows.length == 0){
                    const employee = await pool.query(
                        "SELECT * FROM employees WHERE sin = $1",
                        [decoded.id]
                    );
                    res.json(employee.rows[0].role);
                }else{
                    res.json('customer');
                }
            }
        });
    }else{
        res.json(null);
    }
    
});

app.listen(6060, () => {
  console.log('Server is running on port 6060');
});

// post request to add employee
app.post('/employee_admin', async (req, res) => {

    try {
        const { name, email, address, password } = req.body;
        let password_encrypt = await bcrypt.hashSync(password, secret_key);
        role = "admin";
        const newPerson = await pool.query("INSERT INTO person (fullname, email) VALUES ($1, $2) RETURNING *", [name, email]);
        // console.log(newPerson.rows[0]);
        const newEmployee = await pool.query(
            "INSERT INTO employees (sin, email, password, role, employee_address) VALUES ($1, $2, $3, $4, $5) RETURNING *",
            [newPerson.rows[0].sin, email, password_encrypt, role, [address]]
        );
        // console.log(newCustomer.rows[0]);
        res.json(newEmployee.rows[0]);
    } catch (err) {
        console.error(err.message);
    }
});

// post request to login customer
app.post('/employee/login', async (req, res) => {
    
    try {
        const { email, password } = req.body;
        const employee = await pool.query(
            "SELECT * FROM employees WHERE email = $1",
            [email]
        );
        if(employee.rows.length == 0){
            res.json("No employee found");
        }else{
            let password_decrypt = await bcrypt.compareSync(password, employee.rows[0].password);
            if(password_decrypt){
                jwt.sign({id:employee.rows[0].sin}, jwtSecret, {}, (err, token) => {
                    if(err){
                        res.json("Error");
                    }else{
                        res.cookie("token", token).json(employee.rows[0]);
                    }
                });
            }else{
                res.json("Wrong password");
            }
        }
    } catch (err) {
        console.error(err.message);
    }
});

app.post('/logout', (req, res) => {
    res.cookie("token", "").json(true);
});

app.post("/hotel_chain", async (req, res) => {
    try {
        const { chain_name } = req.body;
        const newChain = await pool.query("INSERT INTO chains (name) VALUES ($1) RETURNING *", [chain_name]);
        // console.log(newCustomer.rows[0]);
        res.json(newChain.rows[0]);
    } catch (err) {
        console.error(err.message);
    }
});

app.get('/hotel_chain', async (req, res) => {
    try {
        const allChains = await pool.query("SELECT * FROM chains");
        res.json(allChains.rows);
    } catch (err) {
        console.error(err.message);
    }
});

app.post("/hotel", async (req, res) => {
    try {
        const { hotel_name, address, chainid, email, phone } = req.body;
        const newHotel = await pool.query("INSERT INTO hotels (hname, address, chain_id, phone_number, email, rating) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *", [hotel_name, address, chainid, [phone], email, 5]);
        // console.log(newCustomer.rows[0]);
        res.json(newHotel.rows[0]);
    } catch (err) {
        console.error(err.message);
    }
});

app.get('/hotel', async (req, res) => {
    try {
        const allHotels = await pool.query("SELECT * FROM hotels");
        res.json(allHotels.rows);
    } catch (err) {
        console.error(err.message);
    }
});

app.get('/employee', async (req, res) => {
    try {
        const allEmployees = await pool.query("SELECT * FROM employees");
        res.json(allEmployees.rows);
    } catch (err) {
        console.error(err.message);
    }
});

app.get('/employee/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const allEmployees = await pool.query("SELECT * FROM employees natural join hotels WHERE sin = $1", [id]);
        res.json(allEmployees.rows[0]);
    } catch (err) {
        console.error(err.message);
    }
});

app.get('/customer/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const allEmployees = await pool.query("SELECT * FROM customers WHERE sin = $1", [id]);
        res.json(allEmployees.rows[0]);
    } catch (err) {
        console.error(err.message);
    }
});

app.post('/employee', async (req, res) => {
    try {
        const { name, email, address, password, role, hotelId } = req.body;
        let password_encrypt = await bcrypt.hashSync(password, secret_key);
        const newPerson = await pool.query("INSERT INTO person (fullname, email) VALUES ($1, $2) RETURNING *", [name, email]);
        // console.log(newPerson.rows[0]);
        const newEmployee = await pool.query(
            "INSERT INTO employees (sin, email, password, role, employee_address, hotel_id) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *",
            [newPerson.rows[0].sin, email, password_encrypt, role, [address], hotelId]
        );
        // console.log(newCustomer.rows[0]);
        res.json(newEmployee.rows[0]);
    } catch (err) {
        console.error(err.message);
    }
} );

app.post('/upload-by-link', async (req, res) => {
    const {link} = req.body;
    const newName = "photo-" + Date.now().toString() + '.jpg';
    await imagedownloader.image({
        url: link,
        dest: __dirname + '/uploads/' + newName
    });
    res.json(newName);
});

const picturesMiddleware = multer({dest: __dirname + '/uploads/'});
app.post('/upload', picturesMiddleware.array('pictures', 10),async (req, res) => {
    uploadedFiles = [];
    for (let i = 0; i < req.files.length; i++) {
        const {path, originalname} = req.files[i];
        const parts = originalname.split('.');
        const extension = parts[parts.length - 1];
        const newPath = path + '.' + extension;
        fs.renameSync(path, newPath);
        uploadedFiles.push(newPath.replace(__dirname+'/uploads/', ''));
    }
    res.json(uploadedFiles);
});

app.post('/room', async (req, res) => {
    try {
        const { 
            roomNumber,
            hotelId,
            pictures,
            amenities,
            roomCapacity,
            extendable,
            roomPrice,
            roomView,
            damaged } = req.body;
        const newRoom = await pool.query("INSERT INTO rooms (room_number, hotel_id, view, price, capacity, extendable, amenities, damaged, pictures) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *", 
        [roomNumber, hotelId, roomView, roomPrice, roomCapacity, extendable, amenities, damaged, pictures]);
        // console.log(newCustomer.rows[0]);
        res.json(newRoom.rows[0]);
    } catch (err) {
        console.error(err.message);
    }
});

app.get('/room', async (req, res) => {
    try {
        const allRooms = await pool.query("SELECT * FROM rooms Natural Join hotels");
        res.json(allRooms.rows);
    } catch (err) {
        console.error(err.message);
    }
} );

app.get('/room/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const employee = await pool.query("SELECT * FROM employees WHERE sin = $1", [id]);
        const allRooms = await pool.query("SELECT * FROM rooms Natural Join hotels where hotel_id = $1", [employee.rows[0].hotel_id]);
        res.json(allRooms.rows);
    } catch (err) {
        console.error(err.message);
    }
} );



app.post('/rooms/:id', async (req, res) => {
    try {
        const { id } = req.params;
        let parts = id.split('$');
        let hotel_id = parts[0];
        let room_num = parts[1];
        const { 
            roomNumber,
            hotelId,
            pictures,
            amenities,
            roomCapacity,
            extendable,
            roomPrice,
            roomView,
            damaged } = req.body;
        const newRoom = await pool.query("UPDATE rooms SET room_number = $1, hotel_id = $2, view = $3, price = $4, capacity = $5, extendable = $6, amenities = $7, damaged = $8, pictures = $9 WHERE room_number = $10 and hotel_id = $11 RETURNING *", 
        [roomNumber, hotelId, roomView, roomPrice, roomCapacity, extendable, amenities, damaged, pictures, room_num, hotel_id]);
        // console.log(newCustomer.rows[0]);
        res.json(newRoom.rows[0]);
    } catch (err) {
        console.error(err.message);
    }
} );

app.get('/rooms/:id', async (req, res) => { 
    try {
        const { id } = req.params;
        let parts = id.split('$');
        let hotel_id = parts[0];
        let room_num = parts[1];
        const allRooms = await pool.query("SELECT * FROM rooms Natural Join hotels WHERE hotel_id = $1 and room_number = $2", [hotel_id, room_num]);
        res.json(allRooms.rows[0]);
    } catch (err) {
        console.error(err.message);
    }
} );

app.post('/reservation', async (req, res) => {
    try {
        const {chain_id, hotel_id, room_number,customerEmail, employeeId, checkIn, checkOut} = req.body;
        const customer = await pool.query("SELECT * FROM customers WHERE email = $1", [customerEmail]);
        // console.log(employeeId);
        let status = '';
        let newReservation = '';
        if(employeeId === '' || employeeId === null || employeeId === undefined){
            status = 'booked';
            newReservation = await pool.query("INSERT INTO reservation (chain_id, hotel_id, room_number, customer_id, check_in, check_out, status) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *", 
            [chain_id, hotel_id, room_number, customer.rows[0].customer_id, checkIn, checkOut, status]);
        }else {
            status = 'rented';
            newReservation = await pool.query("INSERT INTO reservation (chain_id, hotel_id, room_number, customer_id, check_in, check_out, status) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *", 
            [chain_id, hotel_id, room_number, customer.rows[0].customer_id, checkIn, checkOut, status]);
        }
        res.json(newReservation.rows[0]);
    } catch (err) {
        console.error(err.message);
        res.json(err.message);
    }

});

app.get('/reservation/:id', async (req, res) => {
    try {
        const { id } = req.params;
        let parts = id.split('$');
        let hotel_id = parts[0];
        let room_num = parts[1];
        const allReservations = await pool.query("SELECT * FROM reservation WHERE hotel_id = $1 and room_number = $2", [hotel_id, room_num]);
        res.json(allReservations.rows);
    } catch (err) {
        console.error(err.message);
    }
} );

app.get('/reservations', async (req, res) => {
    try {
        const allReservations = await pool.query("SELECT * FROM reservation Join hotels on reservation.hotel_id = hotels.hotel_id Join rooms on (reservation.room_number, reservation.hotel_id) = (rooms.room_number, rooms.hotel_id) Join customers on reservation.customer_id = customers.customer_id WHERE status = 'rented' or status = 'booked'");
        res.json(allReservations.rows);
    } catch (err) {
        console.error(err.message);
    }
} );

app.get('/reservations/employee/:id', async (req, res) => {
    try {
        const {id} = req.params;
        const employee = await pool.query("SELECT * FROM employees WHERE sin = $1", [id]);
        // console.log(employee.rows[0].hotel_id);
        const allReservations = await pool.query("SELECT * FROM reservation Join hotels on reservation.hotel_id = hotels.hotel_id Join rooms on (reservation.room_number, reservation.hotel_id) = (rooms.room_number, rooms.hotel_id) Join customers on reservation.customer_id = customers.customer_id WHERE (status = 'rented' or status = 'booked') AND (reservation.hotel_id = $1)", [employee.rows[0].hotel_id]);
        res.json(allReservations.rows);
    } catch (err) {
        console.error(err.message);
    }
} );

app.get('/single-reservations/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const reservation_id = parseInt(id);
        const allReservations = await pool.query("SELECT * FROM reservation Join hotels on reservation.hotel_id = hotels.hotel_id Join rooms on (reservation.room_number, reservation.hotel_id) = (rooms.room_number, rooms.hotel_id) Join customers on reservation.customer_id = customers.customer_id WHERE reservation_id = $1", [reservation_id]);
        res.json(allReservations.rows[0]);
    } catch (err) {
        console.error(err.message);
    }
} );

app.post('/confirm-reservation/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const {status} = req.body;
        const reservation_id = parseInt(id);
        if(id === undefined || reservation_id === null || reservation_id === undefined){
            res.json('Invalid reservation id');
        }else{
            const confirmReservation = await pool.query("UPDATE reservation SET status = $1 WHERE reservation_id = $2 RETURNING *", [status, reservation_id]);
            res.json(confirmReservation.rows[0]);
        }
    } catch (err) {
        console.error(err.message);
    }
});

app.get('/search', async (req, res) => {
    try {
        const {hotel_chain_id, hotel_id, city, checkIn, checkOut, num_of_rooms, price, rating} = req.query;
        // console.log(hotel_chain_id, hotel_id, city, checkIn, checkOut, num_of_rooms, price, rating);
        let query1 = [];
        if(hotel_chain_id !== '') query1.push(`chain_id = ${hotel_chain_id}`);
        if(hotel_id !== '') query1.push(`hotel_id = ${hotel_id}`);
        if(city !== '') query1.push(`(address like '%${city}%')`);
        if(price !== '') query1.push(`price <= ${price}`);
        if(rating !== '') query1.push(`rating >= ${rating}`);
        let query2 = '';
        if(checkIn !== '' && checkOut !== '') query2 = `WHERE (rooms_1.hotel_id, rooms_1.room_number) NOT IN
        (SELECT hotel_id, room_number from reservation 
        WHERE (check_in <= date('${checkOut}') and check_in >= date('${checkIn}')) or (check_out <= date('${checkOut}') and check_out >= date('${checkIn}')))`;
        let query3 = '';
        if(num_of_rooms !== '') query3 = `where num_of_rooms >= ${num_of_rooms}`;
        let query = ''
        if(query1.length > 0) query = `WHERE ${query1.join(' and ')}`;
        let finalQuery = `SELECT * from 
        (SELECT * from rooms 
        natural join hotels
        ${query})as rooms_1
        Natural join 
        (select * from (select hotel_id, count(room_number) as num_of_rooms from rooms
        group by hotel_id) as rooms_2 ${query3}) as rooms_3
        ${query2}`;
        // console.log(finalQuery);

        const allReservations = await pool.query(finalQuery);
        res.json(allReservations.rows);
    } catch (err) {
        console.error(err.message);
    }
} );

app.get('/bookings/:email', async (req, res) => {
    try {
        const { email } = req.params;
        const customer = await pool.query("SELECT * FROM customers WHERE email = $1", [email]);
        const allReservations = await pool.query("SELECT * FROM reservation Join hotels on reservation.hotel_id = hotels.hotel_id Join rooms on (reservation.room_number, reservation.hotel_id) = (rooms.room_number, rooms.hotel_id) Join customers on reservation.customer_id = customers.customer_id WHERE reservation.customer_id = $1", [customer.rows[0].customer_id]);
        res.json(allReservations.rows);
    } catch (err) {
        console.error(err.message);
    }
} );

app.post('/rating', async (req, res) => {
    try {
        const {reservation_id, rating} = req.body;
        const reservation = await pool.query("SELECT * FROM reservation WHERE reservation_id = $1", [reservation_id]);
        const hotel_id = reservation.rows[0].hotel_id;
        const updateReservation = await pool.query("UPDATE reservation SET rated = 'true' WHERE reservation_id = $1 RETURNING *", [reservation_id]);
        const hotel = await pool.query("SELECT * FROM hotels WHERE hotel_id = $1", [hotel_id]);
        const newRating = Math.ceil(((hotel.rows[0].rating*hotel.rows[0].count_rating) + parseInt(rating)) / (hotel.rows[0].count_rating + 1));
        // console.log(newRating);
        const updateRating = await pool.query("UPDATE hotels SET rating = $1, count_rating = $2 WHERE hotel_id = $3 RETURNING *", [newRating, (hotel.rows[0].count_rating + 1), hotel_id]);
        res.json(updateRating.rows[0]);
    } catch (err) {
        console.error(err.message);
    }
});

app.get('/rooms_capacity', async (req, res) => {
    try {
        const {hotel_id} = req.query;
        const createView = await pool.query(`CREATE or REPLACE view rooms_capacity as SELECT room_number, capacity from rooms WHERE hotel_id = ${hotel_id}`);
        const view = await pool.query(`SELECT * FROM rooms_capacity`);
        res.json(view.rows);
    } catch (err) {
        console.error(err.message);
    }
}  );

app.get('/rooms_per_area', async (req, res) => {
    try {
        const createView = await pool.query(`CREATE or REPLACE view rooms_per_area as
        SELECT SPLIT_PART(address, ', ', 2) as area, count(room_number) 
        from hotels natural join rooms
        group by area`);
        const view = await pool.query(`SELECT * FROM rooms_per_area`);
        res.json(view.rows);
    } catch (err) {
        console.error(err.message);
    }
}  );

app.delete('/chain/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const deleteChain = await pool.query("DELETE FROM chains WHERE chain_id = $1", [id]);
        const newChain = await pool.query("SELECT * FROM chains");
        res.json(newChain.rows);
    } catch (err) {
        console.error(err.message);
    }
} );

app.delete('/hotel/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const deleteHotel = await pool.query("DELETE FROM hotels WHERE hotel_id = $1", [id]);
        const newHotel = await pool.query("SELECT * FROM hotels");
        res.json(newHotel.rows);
    } catch (err) {
        console.error(err.message);
    }
} );

app.delete('/room/:hotel_id/:room_number', async (req, res) => {
    try {
        const { hotel_id, room_number } = req.params;
        const deleteRoom = await pool.query("DELETE FROM rooms WHERE room_number = $1 AND hotel_id = $2", [room_number, hotel_id]);
        res.json("Room Deleted");
    } catch (err) {
        console.error(err.message);
    }
} );

app.put('/change_employee_hotel', async (req, res) => {
    try {
        const {employee_id, hotel_id} = req.body;
        const updateEmployee = await pool.query("UPDATE employees SET hotel_id = $1 WHERE employee_id = $2 RETURNING *", [hotel_id, employee_id]);
        res.json(updateEmployee.rows[0]);
    } catch (err) {
        console.error(err.message);
    }
} );