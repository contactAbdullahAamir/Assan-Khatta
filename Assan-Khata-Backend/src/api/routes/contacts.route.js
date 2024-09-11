const express = require("express");
const router = express.Router();
const ContactController = require("../controllers/contacts.controller");

router.post("/add", ContactController.createContact);
router.post("/remove", ContactController.removeContact);
router.get("/get", ContactController.getContacts);
router.post('/request', ContactController.sendRequest);
router.post('/accept', ContactController.acceptRequest);
router.post('/reject', ContactController.rejectRequest);

module.exports = router;
