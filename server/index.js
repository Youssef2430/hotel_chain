const express = require('express');
const app = express();
const cors = require('cors');
const pool = require('./db');

// middleware
app.use(cors());
app.use(express.json());

// basic route
app.post('/person', async (req, res) => {

    try {
        const { fullname, email } = req.body;
        const newPerson = await pool.query(
            "INSERT INTO person (fullname, email) VALUES($1, $2) RETURNING *",
            [fullname, email]
        );
        res.json(newPerson.rows[0]);
    } catch (err) {
        console.error(err.message);
    }
});

app.listen(6000, () => {
  console.log('Server is running on port 6000');
});
