import '../../../../core/common/entities/user.dart';

class UserModel extends UserEntity {
  UserModel({
    String? id,
    String? name,
    String? email,
    bool? isVerified,
    String? verificationCode,
    String? magicLinkToken,
    String? googleId,
    String? profilePic,
    List<String>? contacts,
    List<String>? requests,
  }) : super(
          id: id,
          name: name,
          email: email,
          isVerified: isVerified,
          verificationCode: verificationCode,
          magicLinkToken: magicLinkToken,
          googleId: googleId,
          profilePic: profilePic,
          contacts: contacts,
          requests: requests,
        );

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] as String?,
      name: map['name'] as String?,
      email: map['email'] as String?,
      isVerified: map['isVerified'] as bool? ?? false,
      verificationCode: map['verificationCode'] as String?,
      magicLinkToken: map['magicLinkToken'] as String?,
      googleId: map['googleId'] as String?,
      profilePic: map['profilePic'] as String?,
      contacts: List<String>.from(map['contacts'] ?? []),
      requests: List<String>.from(map['requests'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isVerified': isVerified,
      'verificationCode': verificationCode,
      'magicLinkToken': magicLinkToken,
      'googleId': googleId,
      'profilePic': profilePic,
      'contacts': contacts,
      'requests': requests,
    };
  }
}
