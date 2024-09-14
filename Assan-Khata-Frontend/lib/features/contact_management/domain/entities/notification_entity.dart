class NotificationEntity {
  final String? id;
  final String? senderId;
  final String? receiverId;
  final String? message;
  final String? type;
  final bool? isRead;

  NotificationEntity({
    this.id,
    this.senderId,
    this.receiverId,
    this.message,
    this.type,
    this.isRead,
  });

  NotificationEntity copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? message,
    String? type,
    bool? isRead,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  factory NotificationEntity.fromJson(Map<String, dynamic> map) {
    return NotificationEntity(
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
