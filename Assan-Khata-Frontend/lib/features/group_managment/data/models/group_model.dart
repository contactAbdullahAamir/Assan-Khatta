import 'package:assan_khata_frontend/features/group_managment/domain/entities/group_entity.dart';

class GroupModel extends GroupEntity {
  @override
  final String? id;
  @override
  final String? name;
  @override
  final String? description;
  @override
  final List<dynamic>? members;

  @override
  final List<dynamic>? admins;
  @override
  final String? picture;
  @override
  final String? createdBy;
  @override
  final bool? isActive;

  const GroupModel({
    this.id,
    this.name,
    this.description,
    this.members,
    this.admins,
    this.picture,
    this.createdBy,
    this.isActive = true,
  }) : super(
          id: id,
          name: name,
          description: description,
          members: members,
          admins: admins,
          picture: picture,
          createdBy: createdBy,
          isActive: isActive,
        );

  @override
  GroupModel copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? members, // Changed to List<String>
    List<String>? admins, // Changed to List<String>
    String? picture,
    String? createdBy,
    bool? isActive,
  }) {
    return GroupModel(
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

  factory GroupModel.fromJson(Map<String, dynamic> map) {
    return GroupModel(
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

  @override
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
