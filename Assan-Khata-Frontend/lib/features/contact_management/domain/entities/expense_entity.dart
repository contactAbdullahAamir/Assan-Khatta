class ExpenseEntity {
  final String? id;
  final String? payer;
  final int? amount;
  final String? description;
  final String? type;
  final DateTime? createdAt;
  final String? relatedUser;
  final String? relatedGroup;
  final String? status;
  final String? picture;

  const ExpenseEntity({
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
  });

  ExpenseEntity copyWith({
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
    return ExpenseEntity(
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

  factory ExpenseEntity.fromJson(Map<String, dynamic> map) {
    return ExpenseEntity(
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
