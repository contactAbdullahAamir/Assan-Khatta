import 'package:assan_khata_frontend/features/contact_management/domain/entities/expense_entity.dart';

class ExpenseModel extends ExpenseEntity {
  @override
  final String? id;
  @override
  final String? payer;
  @override
  final int? amount;
  @override
  final String? description;
  @override
  final String? type;
  @override
  final DateTime? createdAt;
  @override
  final String? relatedUser;
  @override
  final String? relatedGroup;
  @override
  final String? status;
  @override
  final String? picture;

  const ExpenseModel({
    this.id,
    this.payer,
    this.amount,
    this.description,
    this.type,
    this.createdAt,
    this.relatedUser,
    this.relatedGroup,
    this.status,
    this.picture,
  }) : super(
          id: id,
          payer: payer,
          amount: amount,
          description: description,
          type: type,
          createdAt: createdAt,
          relatedUser: relatedUser,
          relatedGroup: relatedGroup,
          status: status,
          picture: picture,
        );

  @override
  ExpenseModel copyWith({
    String? id,
    String? payer,
    int? amount,
    String? description,
    String? type,
    DateTime? createdAt,
    String? relatedUser,
    String? relatedGroup,
    String? status,
    String? picture,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      payer: payer ?? this.payer,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      relatedUser: relatedUser ?? this.relatedUser,
      relatedGroup: relatedGroup ?? this.relatedGroup,
      status: status ?? this.status,
      picture: picture ?? this.picture,
    );
  }

  factory ExpenseModel.fromJson(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['_id'] as String?,
      payer: map['payer'] as String?,
      amount: map['amount'] as int?,
      description: map['description'] as String?,
      type: map['type'] as String?,
      createdAt: map['createdAt'] == null
          ? null
          : DateTime.parse(map['createdAt'] as String),
      relatedUser: map['relatedUser'] as String?,
      relatedGroup: map['relatedGroup'] as String?,
      status: map['status'] as String?,
      picture: map['picture'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'payer': payer,
      'amount': amount.toString(),
      'description': description,
      'type': type,
      'createdAt': createdAt?.toIso8601String(),
      'relatedUser': relatedUser,
      'relatedGroup': relatedGroup,
      'status': status,
      'picture': picture,
    };
  }
}
