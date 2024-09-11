const GroupService = require("../services/group.service");
const userModel = require("../models/user.model");

exports.createGroup = async (req, res) => {
  try {
    const { createdBy, name, description } = req.body;

    const group = await GroupService.createGroup(name, description, createdBy);
    res.status(201).json(group);
  } catch (err) {
    res
      .status(400)
      .json({ message: "Error creating group", error: err.message });
  }
};

exports.addMembers = async (req, res) => {
  try {
    const { groupId, userIds } = req.body;
    const group = await GroupService.addMembers(groupId, userIds);
    res.status(200).json({ group: group });
  } catch (err) {
    res
      .status(400)
      .json({ message: "Error adding member", error: err.message });
  }
};

exports.addAdmins = async (req, res) => {
  try {
    const { groupId, userIds } = req.body;
    const group = await GroupService.addAdmins(groupId, userIds);
    res.status(200).json(group);
  } catch (err) {
    res.status(400).json({ message: "Error adding admin", error: err.message });
  }
};

exports.removeMember = async (req, res) => {
  try {
    const { groupId, userId } = req.body;
    const group = await GroupService.removeMember(groupId, userId);
    res.status(200).json(group);
  } catch (err) {
    res
      .status(400)
      .json({ message: "Error removing member", error: err.message });
  }
};

exports.getGroup = async (req, res) => {
  try {
    const { groupId } = req.params;
    const group = await GroupService.getGroupById(groupId);
    res.status(200).json(group);
  } catch (err) {
    res
      .status(400)
      .json({ message: "Error fetching group", error: err.message });
  }
};

exports.getGroupMembers = async (req, res) => {
  try {
    const { groupId } = req.params;
    const group = await GroupService.getGroupMembers(groupId);
    res.status(200).json({members: group});
  } catch (err) {
    res
      .status(400)
      .json({ message: "Error fetching group members", error: err.message });
  }
};

exports.getGroupAdmins = async (req, res) => {
  try {
    const { groupId } = req.params;
    const group = await GroupService.getGroupAdmins(groupId);
    res.status(200).json(group);
  } catch (err) {
    res
      .status(400)
      .json({ message: "Error fetching group admins", error: err.message });
  }
};

exports.getGroupBYMemberId = async (req, res) => {
  try {
    const { member } = req.params;
    const groups = await GroupService.getGroupByMemberId(member);
    res.status(200).json({groups : groups});
  } catch (err) {
    res
      .status(400)
      .json({ message: "Error fetching groups", error: err.message });
  }
}
