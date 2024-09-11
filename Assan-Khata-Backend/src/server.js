const server = require('./app');
const db = require('./config/database');
require('dotenv').config();

const PORT = process.env.PORT;

server.listen(PORT, () => {
  console.log(`Server is running on port ${process.env.CLIENT_URL}`);
});