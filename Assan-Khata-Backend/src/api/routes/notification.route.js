const notificationController = require('../controllers/notification.controller');
const router = require('express').Router();

router.post('/create', notificationController.createNotification);
router.get('/:userId', notificationController.getNotifications);
router.put('/:notificationId', notificationController.markAsRead);
router.delete('/:notificationId', notificationController.deleteNotification);

module.exports = router;