const express = require("express");
const bodyParser = require("body-parser");
const dotenv = require("dotenv");
const session = require("express-session");
const passport = require("./config/passport");
const cors = require("cors");
const http = require("http");
const socketIo = require("socket.io");

dotenv.config();

const app = express();
const server = http.createServer(app);
const io = socketIo(server, {
  cors: {
    origin: "*", // Be more specific in production
    methods: ["GET", "POST", "PUT"],
  },
});

// Make `io` available globally (if needed)
global.io = io;

app.use(cors());
app.use(bodyParser.json({ limit: "10mb" }));
app.use(bodyParser.urlencoded({ limit: "10mb", extended: true }));
app.use(session({ secret: "secret", resave: false, saveUninitialized: false }));
app.use(passport.initialize());
app.use(passport.session());

// Socket.IO connection handling
io.on("connection", (socket) => {
  console.log("A user connected");

  socket.on('join', (userId) => {
    socket.join(userId.toString());
    console.log(`User with ID ${userId} joined their room`);
  });

  socket.on("disconnect", () => {
    console.log("User disconnected");
  });

  socket.on("connect_error", (error) => {
    console.log("Connection error: ", error);
  });

  socket.on("error", (error) => {
    console.log("Socket error: ", error);
  });

  socket.on("test", (data) => {
    console.log("Test event received with data: ", data);
    // Optionally, you can send back a response or emit a new event
    socket.emit('newNotification', { title: 'Test Title', body: 'This is a test notification' });
  });
});

// Define api routes
const authRoutes = require("./api/routes/auth.route");
app.use("/api/auth", authRoutes);

const userRoutes = require("./api/routes/user.route");
app.use("/api/user", userRoutes);

const walletRoutes = require("./api/routes/wallet.route");
app.use("/api/wallet", walletRoutes);

const contactRoutes = require("./api/routes/contacts.route");
app.use("/api/contact", contactRoutes);

const groupRoutes = require("./api/routes/group.route");
app.use("/api/group", groupRoutes);

const expenseRoutes = require("./api/routes/expense.route");
app.use("/api/expense", expenseRoutes);

const notificationRoutes = require("./api/routes/notification.route");
app.use("/api/notification", notificationRoutes);

app.get("/dashboard", (req, res) => {
  res.send("This is Dashboard");
});

// define external api routes
const externalApiRoutes = require("./external-api/routes/auth.route");
app.use("/api/external-api", externalApiRoutes);

const externalApiRecipeRoutes = require("./external-api/routes/recipe.route");
app.use("/api/external-api/recipe", externalApiRecipeRoutes);

// Export server
module.exports = server;
