class GroupEntity {
  final String? id;
  final String? name;
  final String? description;
  final List<dynamic>? members;
  final List<dynamic>? admins;
  final String? picture;
  final String? createdBy;
  final bool? isActive;

  const GroupEntity({
    this.id,
    this.name,
    this.description,
    this.members,
    this.admins,
    this.picture,
    this.createdBy,
    this.isActive = true,
  });

  GroupEntity copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? members, // Changed to List<String>
    List<String>? admins, // Changed to List<String>
    String? picture,
    String? createdBy,
    bool? isActive,
  }) {
    return GroupEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      members: members ?? this.members,
      admins: admins ?? this.admins,
      picture: picture ?? this.picture,
      createdBy: createdBy ?? this.createdBy,
      isActive: isActive ?? this.isActive,
    );
  }

  factory GroupEntity.fromJson(Map<String, dynamic> map) {
    return GroupEntity(
      id: map['_id'] as String?,
      name: map['name'] as String?,
      description: map['description'] as String?,
      members:
          map['members'] is List ? List<dynamic>.from(map['members']) : null,
      admins: map['admins'] is List ? List<dynamic>.from(map['admins']) : null,
      picture: map['picture'] as String?,
      createdBy: map['createdBy'] as String?,
      isActive: map['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'members': members,
      'admins': admins,
      'picture': picture,
      'createdBy': createdBy,
      'isActive': isActive,
    };
  }
}
