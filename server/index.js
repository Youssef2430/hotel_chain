const express = require('express');
const app = express();
const cors = require('cors');
const pool = require('./db');
const bcrypt = require('bcryptjs');
const secret_key = bcrypt.genSaltSync(10);

// middleware
app.use(cors());
app.use(express.json());

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
                    res.json(customer.rows[0]);
                }else{
                    res.json("Wrong password");
                }
            }
        } catch (err) {
            console.error(err.message);
        }
});

app.listen(6060, () => {
  console.log('Server is running on port 6060');
});
