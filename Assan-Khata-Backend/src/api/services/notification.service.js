const notificationModel = require("../models/notification.model");

class NotificationService {
  static async createNotification(senderId, receiverId, message, type) {
    const notification = new notificationModel({
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      type: type,
    });
    const savedNotification = await notification.save();

    // Emit the notification to the receiver
    if (global.io) {
      global.io.to(receiverId.toString()).emit("newNotification", {
        title: savedNotification.type.toString(),
        body: savedNotification.message.toString(),
      });
    } else {
      console.error("Socket.io is not initialized");
    }
    return savedNotification;
  }

  static async getNotifications(userId) {
    return notificationModel
      .find({ receiverId: userId })
      .sort({ createdAt: -1 });
  }

  static async markAsRead(notificationId) {
    const updatedNotification = await notificationModel.findByIdAndUpdate(
      notificationId,
      { isRead: true },
      { new: true }
    );

    if (updatedNotification) {
      // Emit an event to update the notification status on the client
      global.io
        .to(updatedNotification.receiverId.toString())
        .emit("notificationRead", notificationId);
    }

    return updatedNotification;
  }

  static async getUnreadCount(userId) {
    return notificationModel.countDocuments({
      receiverId: userId,
      isRead: false,
    });
  }

  static async deleteNotification(notificationId) {
    return notificationModel.findByIdAndDelete(notificationId);
  }
}

module.exports = NotificationService;
