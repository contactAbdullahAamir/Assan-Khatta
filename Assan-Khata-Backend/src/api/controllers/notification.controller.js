const notificationService = require("../services/notification.service");

exports.createNotification = async (req, res) => {
  const { notification } = req.body;

  const { senderId, receiverId, message , type } = notification;

  try {
    const notification = await notificationService.createNotification(
      senderId,
      receiverId,
      message,
      type
    );
    res.json(notification);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.getNotifications = async (req, res) => {
  const { userId } = req.params;

  try {
    const notifications = await notificationService.getNotifications(userId);
    res.json(notifications);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.markAsRead = async (req, res) => {
  const { notificationId } = req.params;

  try {
    const notification = await notificationService.markAsRead(notificationId);
    res.json(notification);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.deleteNotification = async (req, res) => {
  const { notificationId } = req.params;

  try {
    const notification = await notificationService.deleteNotification(notificationId);
    res.json(notification);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};