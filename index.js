const express = require('express');
const swaggerUi = require('swagger-ui-express');
const swaggerJsdoc = require('swagger-jsdoc');

const app = express();
const port = 3000;

// Swagger options
const swaggerOptions = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'PeerHire API',
      version: '1.0.0',
      description: 'API documentation using Swagger',
    },
  },
  apis: ['./index.js'], // Path to the API docs (you can add other files here as well)
};

const swaggerDocs = swaggerJsdoc(swaggerOptions);

// Serve Swagger docs at /api-docs
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocs));

// Example API route
/**
 * @swagger
 * /:
 *   get:
 *     description: Welcome to the API
 *     responses:
 *       200:
 *         description: Welcome message
 */
app.get('/', (req, res) => {
  res.send('Welcome to the PeerHire API!');
});

// Make the app listen on 0.0.0.0 to accept external traffic
app.listen(port, '0.0.0.0', () => {
  console.log(`Server is running on http://0.0.0.0:${port}`);
  console.log(`Swagger docs are available at http://0.0.0.0:${port}/api-docs`);
});
