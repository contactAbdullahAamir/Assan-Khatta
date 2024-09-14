import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  @override
  final String? id;
  @override
  final String? senderId;
  @override
  final String? receiverId;
  @override
  final String? message;
  @override
  final String? type;
  @override
  final bool? isRead;

  NotificationModel({
    this.id,
    this.senderId,
    this.receiverId,
    this.message,
    this.type,
    this.isRead,
  });

  @override
  NotificationModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? message,
    String? type,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  factory NotificationModel.fromJson(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['_id'],
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      message: map['message'],
      type: map['type'],
      isRead: map['isRead'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'type': type,
      'isRead': isRead,
    };
  }
}
