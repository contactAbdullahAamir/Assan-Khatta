class UserEntity {
  final String? id;
  final String? name;
  final String? email;
  final bool? isVerified;
  final String? verificationCode;
  final String? magicLinkToken;
  final String? googleId;
  final String? profilePic;
  final List<String>? contacts;
  final List<String>? requests;
  final String? token;

  const UserEntity({
    this.id,
    this.name,
    this.email,
    this.isVerified,
    this.verificationCode,
    this.magicLinkToken,
    this.googleId,
    this.profilePic,
    this.contacts,
    this.requests,
    this.token,
  });

  UserEntity copyWith(
      {String? id,
      String? name,
      String? email,
      bool? isVerified,
      String? verificationCode,
      String? magicLinkToken,
      String? googleId,
      String? profilePic,
      List<String>? contacts,
      List<String>? requests,
      String? token}) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isVerified: isVerified ?? this.isVerified,
      verificationCode: verificationCode ?? this.verificationCode,
      magicLinkToken: magicLinkToken ?? this.magicLinkToken,
      googleId: googleId ?? this.googleId,
      profilePic: profilePic ?? this.profilePic,
      contacts: contacts ?? this.contacts,
      requests: requests ?? this.requests,
      token: token ?? this.token,
    );
  }

  factory UserEntity.fromJson(Map<String, dynamic> map) {
    return UserEntity(
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
      token: map['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'isVerified': isVerified,
      'verificationCode': verificationCode,
      'magicLinkToken': magicLinkToken,
      'googleId': googleId,
      'profilePic': profilePic,
      'contacts': contacts,
      'requests': requests,
      'token': token,
    };
  }
}
