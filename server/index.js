const express = require('express');
const app = express();
const cors = require('cors');
const pool = require('./db');

// middleware
app.use(cors());
app.use(express.json());

// basic routing

// exemple of a post request
app.post('/person', async (req, res) => {

    try {
        const { fullname, gender } = req.body;
        const newPerson = await pool.query(
            "INSERT INTO person (fullname, gender) VALUES($1, $2) RETURNING *",
            [fullname, gender]
        );
        res.json(newPerson.rows[0]);
    } catch (err) {
        console.error(err.message);
    }
});

// exemple of a get request
app.get('/person', async (req, res) => {
    try {
        const allPerson = await pool.query("SELECT * FROM person");
        res.json(allPerson.rows);
    } catch (err) {
        console.error(err.message);
    }
});

// exemple of a put request
app.put('/person/:id', async (req, res) => {

    try {
        const{id} = req.params;
        const{fullname, gender} = req.body;
        const updatePerson = await pool.query(
            "UPDATE person SET fullname = $1, gender = $2 WHERE SIN = $3",
            [fullname, gender, id]
        );
        res.json("Person was updated!");
    } catch (error) {
        console.error(err.message);
    }
});

// exemple of a delete request
app.delete('/person/:id', async (req, res) => {

    try {
        const{id} = req.params;
        const deletePerson = await pool.query(
            "DELETE FROM person WHERE SIN = $1",
            [id]
        );
        res.json("Person was deleted!");
    } catch (error) {
        console.error(err.message);
    }
});

app.listen(6000, () => {
  console.log('Server is running on port 6000');
});
