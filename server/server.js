'use strict';

// Minimal Express server with optional Prisma DB-check
// - GET /            -> basic status
// - GET /health      -> lightweight health check
// - GET /db-check    -> attempts a simple DB query via Prisma
// Includes JSON parsing, 404 handler, error handler, and graceful shutdown.

const dotenv = require('dotenv');
dotenv.config();

const express = require('express');
const { PrismaClient } = require('@prisma/client');
const getAllCases = require("./src/routes/get_all_cases");
const getHomeDetails = require("./src/routes/get_home_details");
const userRoutes = require("./src/routes/userRoutes");
const caseRoutes = require("./src/routes/caseRoutes");
const paymentRoutes = require("./src/routes/paymentRoutes");

const app = express();
app.use(express.json());

// Create Prisma client. It's lazy and won't connect until a query is made.
const prisma = new PrismaClient();

app.get('/', (req, res) => {
  res.json({ status: 'ok', uptime: process.uptime(), pid: process.pid });
});

app.get('/health', (req, res) => {
  // lightweight health endpoint
  res.json({ status: 'healthy', timestamp: new Date().toISOString() });
});

app.get('/db-check', async (req, res) => {
  // Try a tiny raw query. This will work for MySQL/Postgres (SELECT 1).
  try {
    const result = await prisma.$queryRaw`SELECT 1 as result`;
    res.json({ db: 'ok', result });
  } catch (err) {
    console.error('Database check failed:', err);
    res.status(500).json({ db: 'error', message: err && err.message ? err.message : String(err) });
  }
});

// Register routes BEFORE 404 handler
app.use('/getAllCases', getAllCases);
app.use('/home', getHomeDetails);

app.use('/user', userRoutes);
app.use('/case', caseRoutes);
app.use('/payment', paymentRoutes);

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Not Found' });
});

// Error handler
app.use((err, req, res, next) => {
  // reference next to avoid "unused parameter" warnings while preserving Express' 4-arg error handler signature
  void next;
  console.error('Unhandled error:', err);
  res.status(500).json({ error: 'Internal Server Error', message: err && err.message ? err.message : undefined });
});

const port = process.env.PORT ? Number(process.env.PORT) : 3000;
const server = app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});

// Graceful shutdown
const shutdown = async () => {
  console.log('Shutting down server...');
  try {
    server.close(async (err) => {
      if (err) {
        console.error('Error closing server:', err);
        process.exit(1);
      }
      try {
        await prisma.$disconnect();
      } catch (e) {
        console.error('Error disconnecting Prisma:', e);
      }
      process.exit(0);
    });
  } catch (e) {
    console.error('Shutdown error:', e);
    process.exit(1);
  }
};

process.on('SIGINT', shutdown);
process.on('SIGTERM', shutdown);

module.exports = app;
