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
            "INSERT INTO customers (sin, email, password, phone_number, address) VALUES ($1, $2, $3, $4, $5) RETURNING *",
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
            "INSERT INTO employees (sin, email, password, role, address) VALUES ($1, $2, $3, $4, $5) RETURNING *",
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
        const newHotel = await pool.query("INSERT INTO hotels (hname, address, chain_id, phone_number, email, rating) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *", [hotel_name, address, chainid, [phone], email, 1]);
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

app.post('/employee', async (req, res) => {
    try {
        const { name, email, address, password, role, hotelId } = req.body;
        let password_encrypt = await bcrypt.hashSync(password, secret_key);
        const newPerson = await pool.query("INSERT INTO person (fullname, email) VALUES ($1, $2) RETURNING *", [name, email]);
        // console.log(newPerson.rows[0]);
        const newEmployee = await pool.query(
            "INSERT INTO employees (sin, email, password, role, address, hotel_id) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *",
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