const userModel = require("../models/user.model");

exports.createContact = async (userId, contactId) => {
  // Ensure user and friend are not the same
  if (userId.toString() === contactId.toString()) {
    throw new Error("Cannot add yourself as a friend");
  }

  // Find both users
  const user = await userModel.findById(userId);
  const contact = await userModel.findById(contactId);

  if (!user || !contact) {
    throw new Error("User or friend not found");
  }

  // Check if the friend is already in the user's friend list
  if (user.contacts.includes(contactId)) {
    throw new Error("Already friends");
  }

  // Add friend to user and user to friend
  user.contacts.push(contactId);
  contact.contacts.push(userId);

  await user.save();
  await contact.save();

  return { user, contact };
};

exports.removeContact = async (userId, contactId) => {
  // Ensure user and friend are not the same
  if (userId.toString() === contactId.toString()) {
    throw new Error("Cannot remove yourself as a friend");
  }

  // Find both users
  const user = await userModel.findById(userId);
  const contact = await userModel.findById(contactId);

  if (!user || !contact) {
    throw new Error("User or friend not found");
  }

  // Remove friend from user and user from friend
  user.contacts = user.contacts.filter((id) => !id.equals(contactId));
  contact.contacts = contact.contacts.filter((id) => !id.equals(userId));

  await user.save();
  await contact.save();

  return { user, contact };
};

exports.getContacts = async (userId) => {
  const user = await userModel
    .findById(userId)
    .populate("contacts", "name email");

  if (!user) {
    throw new Error("User not found");
  }

  return user.contacts;
};

exports.sendRequest = async (userId, contactId) => {
  // Ensure user and friend are not the same
  if (userId.toString() === contactId.toString()) {
    throw new Error("Cannot send request to yourself");
  }

  // Find both users
  const user = await userModel.findById(userId);
  const contact = await userModel.findById(contactId);

  if (!user || !contact) {
    throw new Error("User or friend not found");
  }

  // Check if the friend is already in the user's friend list
  if (user.contacts.includes(contactId)) {
    throw new Error("Already friends");
  }

  // Check if the request has already been sent
  if (user.requests.includes(contactId)) {
    throw new Error("Request already sent");
  }
  // Send request
  user.requests.push(contactId);
  await user.save();

  return { user, contact };
};

exports.acceptRequest = async (userId, contactId) => {
  // Ensure user and friend are not the same
  if (userId.toString() === contactId.toString()) {
    throw new Error("Cannot accept request from yourself");
  }

  // Find both users
  const user = await userModel.findById(userId);
  const contact = await userModel.findById(contactId);

  if (!user || !contact) {
    throw new Error("User or friend not found");
  }

  // Check if the request has been sent
  if (!user.requests.includes(contactId)) {
    throw new Error("No request found");
  }

  // Accept request
  user.requests = user.requests.filter((id) => !id.equals(contactId));
  user.contacts.push(contactId);
  contact.contacts.push(userId);

  await user.save();
  await contact.save();

  return { user, contact };
};

exports.rejectRequest = async (userId, contactId) => {
  // Ensure user and friend are not the same
  if (userId.toString() === contactId.toString()) {
    throw new Error("Cannot delete request from yourself");
  }

  // Find both users
  const user = await userModel.findById(userId);
  const contact = await userModel.findById(contactId);

  if (!user || !contact) {
    throw new Error("User or friend not found");
  }

  // Check if the request has been sent
  if (!user.requests.includes(contactId)) {
    throw new Error("No request found");
  }

  // Delete request
  user.requests = user.requests.filter((id) => !id.equals(contactId));
  await user.save();

  return { user, contact };
};
