const Group = require("../models/group.model");
const User = require("../models/user.model");

class GroupService {
  static async createGroup(name, description, createdBy) {
    const group = new Group({
      name,
      description,
      createdBy,
      admins: [createdBy],
      members: [createdBy], // The creator is also the first member
    });

    await group.save();
    return group;
  }

  static async addMembers(groupId, userIds) {
    const group = await Group.findById(groupId);
    const users = await User.find({ _id: { $in: userIds } });

    if (!group || users.length !== userIds.length) {
      throw new Error("Group or User not found");
    }

    userIds.forEach((userId) => {
      if (!group.members.includes(userId)) {
        group.members.push(userId);
      }
    });

    await group.save();

    return group;
  }

  static async addAdmins(groupId, userIds) {
    const group = await Group.findById(groupId);
    const users = await User.find({ _id: { $in: userIds } });

    if (!group || users.length !== userIds.length) {
      throw new Error("Group or User not found");
    }

    userIds.forEach((userId) => {
      if (!group.admins.includes(userId)) {
        group.admins.push(userId);
      }
      if (!group.members.includes(userId)) {
        group.members.push(userId);
      }
    });

    await group.save();
    return group;
  }

  static async removeMember(groupId, userId) {
    const group = await Group.findById(groupId);
    const user = await User.findById(userId);

    if (!group || !user) {
      throw new Error("Group or User not found");
    }

    group.members = group.members.filter((id) => !id.equals(userId));

    // Also remove the user from admins if they are an admin
    group.admins = group.admins.filter((id) => !id.equals(userId));

    await group.save();
    return group;
  }

  static async getGroupById(groupId) {
    const group = await Group.findById(groupId).populate(
      "admins members",
      "name email"
    );
    if (!group) {
      throw new Error("Group not found");
    }
    return group;
  }

  static async getGroupMembers(groupId) {
    const group = await Group.findById(groupId).populate(
      "members",
      "name email"
    );
    if (!group) {
      throw new Error("Group not found");
    }
    return group.members;
  }

  static async getGroupAdmins(groupId) {
    try {
      // Fetch the group with populated admins
      const group = await Group.findById(groupId)
        .populate('admins', 'name email'); // Populate only 'name' and 'email' fields of admins

      // Check if the group was found
      if (!group) {
        throw new Error('Group not found');
      }

      // Return the list of admins
      return group.admins;
    } catch (error) {
      // Handle any errors that occurred during the process
      console.error('Error fetching group admins:', error.message);
      throw error; // Rethrow the error to be handled by the calling function
    }
  }

  static async getGroupByMemberId(member) {
    const groups = await Group.find({ members: member }).populate(
      "admins members",
      "name email"
    );
    if (!groups) {
      throw new Error("Group not found");
    }
    return groups;
  }
}

module.exports = GroupService;
