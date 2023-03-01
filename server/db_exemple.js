const Pool = require('pg').Pool

const pool = new Pool({
    user: 'user',
    password: 'password',
    host: 'host',
    port: 0000,
    database: 'random'
});

module.exports = pool;