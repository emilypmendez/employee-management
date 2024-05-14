// Run: node server/server.js
const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
require('dotenv').config();
const app = express();
const serverless = require('serverless-http');
const fs = require('fs');
const path = require('path');

app.use(express.static('public'));
const port = process.env.PORT || 8081;

// Middleware
app.use(cors());
app.use(express.json());

// Log all requests
app.use((req, res, next) => {
    console.log(`${req.method} ${req.url}`);
    next();
});

// Create a MySQL connection pool
const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// Function to read and execute the SQL file
const executeSQLFile = async (filePath) => {
    const sql = fs.readFileSync(filePath, 'utf8');
    const statements = sql.split(';').filter(Boolean); // Split and remove empty statements

    for (const statement of statements) {
        await pool.promise().query(statement.trim());
    }
};

// Endpoint to initialize the database
app.get('/api/init-database', async (req, res) => {
    try {
        const filePath = path.join(__dirname, 'database.sql');
        await executeSQLFile(filePath);
        res.status(200).json({ message: 'Database initialized successfully' });
    } catch (error) {
        console.error('Error initializing database:', error);
        res.status(500).json({ error: 'Database initialization error: ' + error.message });
    }
});

// If there is an authentication problem
// ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';

// // Start the server (Commented out for the Netlify Function)
// app.listen(port, () => {
//     console.log(`Server running on port ${port}`);
// });

// Test server connection
app.get('/', (req, res) => {
    res.send('Server is running');
});

/* 
//////////////////////////
SPACE FOR CODE
//////////////////////////
*/

// Insert a new employee
app.post('/api/employees', async (req, res) => {
    const { fname, minit, lname, ssn, phone, email, department_id, e_emplid } = req.body;
    if (!fname || !minit || !lname || !ssn || !phone || !email || !department_id || !e_emplid) {
        return res.status(400).json({ error: 'All fields are required' });
    }

    try {
        const [departmentRows] = await pool.promise().query('SELECT 1 FROM department WHERE department_id = ?', [department_id]);
        if (departmentRows.length === 0) {
            return res.status(400).json({ error: 'Invalid department_id. Department does not exist.' });
        }

        const [result] = await pool.promise().query(
            'INSERT INTO employee (fname, minit, lname, ssn, phone, email, department_id, e_emplid) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
            [fname, minit, lname, ssn, phone, email, department_id, e_emplid]
        );
        res.status(201).json({ id: result.insertId, ...req.body });
    } catch (error) {
        console.error('Error inserting employee:', error);
        res.status(500).json({ error: 'Database error: ' + error.message });
    }
});



// Read all employees
app.get('/api/employees', async (req, res) => {
    try {
        const [rows] = await pool.promise().query('SELECT * FROM employee');
        res.json(rows);
    } catch (error) {
        console.error('Error fetching employees:', error);
        res.status(500).json({ error: 'Database error' });
    }
});

// Read single employee by ID
app.get('/api/employees/:e_emplid', async (req, res) => {
    const e_emplid = req.params.e_emplid;

    const [rows] = await pool.promise().query('SELECT * FROM employee WHERE id = ?', [e_emplid], (err, result) => {
        if (err) {
            console.log('I AM HERE 2 -- inside GET', err);
            return res.status(500).json({ error: 'Database error (fetching employee)' });
        } else {
            console.log('I AM HERE 3 -- inside GET', result);
            return res.json(result);
        }
    });

    if (rows.length === 0) {
        return res.status(404).json({ error: 'Employee not found' });
    }

    res.json(rows[0]);
});

// Update an employee (based on their ID) with Department Check
app.put('/api/employees/:e_emplid', async (req, res) => {
    const { e_emplid } = req.params;
    const { fname, minit, lname, ssn, phone, email, department_id } = req.body;

    if (!fname || !minit || !lname || !ssn || !phone || !email || !department_id) {
        return res.status(400).json({ error: 'All fields are required' });
    }

    try {
        const [empExists] = await pool.promise().query('SELECT 1 FROM employee WHERE e_emplid = ?', [e_emplid]);
        if (empExists.length === 0) {
            return res.status(404).json({ error: 'Employee not found' });
        }

        const [deptExists] = await pool.promise().query('SELECT 1 FROM department WHERE department_id = ?', [department_id]);
        if (deptExists.length === 0) {
            return res.status(400).json({ error: 'Invalid department_id' });
        }

        const [result] = await pool.promise().query(
            'UPDATE employee SET fname = ?, minit = ?, lname = ?, ssn = ?, phone = ?, email = ?, department_id = ? WHERE e_emplid = ?',
            [fname, minit, lname, ssn, phone, email, department_id, e_emplid]
        );
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'No employee updated' });
        }
        res.json({ message: 'Employee updated successfully', id: e_emplid, ...req.body });
    } catch (error) {
        console.error('Error updating employee:', error);
        res.status(500).json({ error: 'Database error' });
    }
});

// SERVER TEST (DELETE)
// console.log('I AM HERE 1 -- server.js -- DELETE');

// Delete an employee
app.delete('/api/employees/:e_emplid', async (req, res) => {
    const e_emplid = req.params.e_emplid;
    
    const [result] = await pool.promise().query('DELETE FROM employee WHERE e_emplid = ?', [e_emplid], (err, result) => {
        if (err) {
            console.log('I AM HERE 2 -- inside DELETE', err);
            return res.status(500).json({ error: 'Database error (deleting employee)' });
        } else {
            console.log('I AM HERE 3 -- inside DELETE', result);
            return res.json({ message: 'Employee deleted successfully' });
        }
    });

    if (result.affectedRows === 0) {
        return res.status(404).json({ error: 'Employee not found' });
    }
});

// Retrieve all departments
app.get('/api/departments', async (req, res) => {
    try {
        // Assuming `department_id` exists in the `employee` table
        const [rows] = await pool.promise().query('SELECT DISTINCT department_id FROM employee');
        res.json(rows);
    } catch (error) {
        console.error('Error fetching departments:', error);
        res.status(500).json({ error: 'Database error' });
    }
});

// // Export the pool for API usage if needed
// module.exports = pool.promise();

// Export the app as a Netlify function
module.exports.handler = serverless(app);