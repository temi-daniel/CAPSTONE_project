const express = require('express');
const { Pool } = require('pg');

const app = express();

// PostgreSQL connection
const pool = new Pool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: 5432,
  ssl: {
    rejectUnauthorized: false
  }
});

// Create visits table if it doesn't exist
pool.query(`
  CREATE TABLE IF NOT EXISTS visits (
    id SERIAL PRIMARY KEY,
    seen_at TIMESTAMP DEFAULT NOW()
  )
`)
  .then(() => {
    console.log('Visits table is ready');
  })
  .catch((err) => {
    console.error('Error creating visits table:', err);
  });

// Readiness probe
// Checks whether the application can reach PostgreSQL
app.get('/healthz', async (req, res) => {
  try {
    await pool.query('SELECT 1');
    res.status(200).send('ok');
  } catch (err) {
    console.error('Database unreachable:', err);
    res.status(500).send('db unreachable');
  }
});

// Main application endpoint
app.get('/', async (req, res) => {
  try {
    await pool.query('INSERT INTO visits DEFAULT VALUES');

    const result = await pool.query('SELECT COUNT(*) FROM visits');

    res.send(`Hello from EKS. Visits: ${result.rows[0].count}`);
  } catch (err) {
    console.error('Database error:', err);
    res.status(500).send('Database error');
  }
});

// Start server
const PORT = 3000;

app.listen(PORT, () => {
  console.log(`Listening on port ${PORT}`);
});
