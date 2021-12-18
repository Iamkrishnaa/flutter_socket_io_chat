const express = require("express");
var http = require("http");
const app = express();
const port = process.env.PORT || 5000;
var server = http.createServer(app);
var io = require("socket.io")(server, {
  cors: {
    origin: "*",
  },
});

var { getMessage } = require("./controller.js");

//TODO:1 -> Clean and Make reasonable functions and processes
//TODO:2 -> Work on database
//TODO:3 -> Working on Image Message
//TODO:4 -> FCM --> push notification
//TODO:5 -> Work on online checking system

app.use(express.json());
var users = {};

io.on("connection", (socket) => {
  //on user logged into app
  socket.on("login", (user) => {
    user = JSON.parse(user);
    users[socket.id] = user.userName;
    io.emit("users", Object.values(users));
    console.log(`${user.userName} Logged In`);
  });
  //on user disconnects
  socket.on("disconnect", () => {
    console.log(`${users[socket.id]} Disconnected`);
    delete users[socket.id];
    io.emit("users", Object.values(users));
  });

  socket.on("send_message", (data) => {
    //TODO: store message in database
    //TODO: check if user is active or not
    //TODO: if(user is active ==> trigger receive_message event to only matched socket_id)

    data = JSON.parse(data);

    let sender = data.senderName;
    let receiver = data.receiverName;
    let message = data.message;

    if (sender && receiver && message) {
      let receiverId = Object.keys(users).find(
        (key) => users[key] === receiver
      );

      let isReceiverActive = false;
      if (receiverId) isReceiverActive = true;

      if (isReceiverActive) {
        let messageResponse = {
          sender: sender,
          receiver: receiver,
          message: message,
        };
        io.to(receiverId).emit("receive-message", messageResponse);
      }
    }
  });
});

server.listen(port, () => {
  console.log("server started");
});
