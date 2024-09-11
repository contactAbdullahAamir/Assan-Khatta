const express = require("express");
const router = express.Router();
const GroupController = require("../controllers/group.controller");

router.post("/create", GroupController.createGroup);
router.post("/add-members", GroupController.addMembers);
router.post("/add-admins", GroupController.addAdmins);
router.post("/remove-member", GroupController.removeMember);
router.get("/:groupId", GroupController.getGroup);
router.get("/get-members/:groupId", GroupController.getGroupMembers);
router.get("/get-admins/:groupId", GroupController.getGroupAdmins);
router.get("/get-all-groups/:member", GroupController.getGroupBYMemberId); 

module.exports = router;
