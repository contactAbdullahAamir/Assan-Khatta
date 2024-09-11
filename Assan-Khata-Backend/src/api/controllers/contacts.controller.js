const ContactService = require("../services/contacts.service");

exports.createContact = async (req, res) => {
  try {
    const { userId, contactId } = req.body;
    const { user, contact } = await ContactService.createContact(
      userId,
      contactId
    );
    res.status(200).json({ user, contact });
  } catch (err) {
    res
      .status(400)
      .json({ message: "Error adding contact", error: err.message });
  }
};

exports.removeContact = async (req, res) => {
  try {
    const { userId, contactId } = req.body;
    const { user, contact } = await ContactService.removeContact(
      userId,
      contactId
    );
    res.status(200).json({ user, contact });
  } catch (err) {
    res
      .status(400)
      .json({ message: "Error removing contact", error: err.message });
  }
};

exports.getContacts = async (req, res) => {
  try {
    const userId = req.body.id;
    console.log(userId);
    const contacts = await ContactService.getContacts(userId);
    res.status(200).json(contacts);
  } catch (err) {
    res
      .status(400)
      .json({ message: "Error fetching contacts", error: err.message });
  }
};

exports.sendRequest = async (req, res) => {
  try {
    const { userId, contactId } = req.body;
    const { user, contact } = await ContactService.sendRequest(
      userId,
      contactId
    );
    res.status(200).json({ user, contact });
  } catch (err) {
    res
      .status(400)
      .json({ message: "Error sending request", error: err.message });
  }
}

exports.acceptRequest = async (req, res) => { 
  try {
    const { userId, contactId } = req.body;
    const { user, contact } = await ContactService.acceptRequest(
      userId,
      contactId
    );
    res.status(200).json({ user, contact });
  } catch (err) {
    res
      .status(400)
      .json({ message: "Error accepting request", error: err.message });
  }
}

exports.rejectRequest = async (req, res) => {
  try {
    const { userId, contactId } = req.body;
    const { user, contact } = await ContactService.rejectRequest(
      userId,
      contactId
    );
    res.status(200).json({ user, contact });
  } catch (err) {
    res
      .status(400)
      .json({ message: "Error rejecting request", error: err.message });
  }
}