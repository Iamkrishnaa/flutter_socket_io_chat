class Message {
  constructor(sender, receiver, message) {
    this.sender = sender;
    this.receiver = receiver;
    this.message = message;
  }
}

let messges = [
  new Message("A", "B", "Hello"),
  new Message("B", "A", "Hello"),
  new Message("A", "B", "Hello"),
  new Message("B", "A", "Hello"),
];

const getMessage = (socket) => {
  socket.emit("receive-message", { message: messges });
  return messges;
};

module.exports = {
  getMessage,
};
