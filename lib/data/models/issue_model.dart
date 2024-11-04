class IssueModel {
  final int idIssue;
  final String createdAt;
  final String description;
  final String lastUpdated;
  final String notes;
  final int idUser;
  final int idTecnic;
  final int idStatus;
  final int idInventory;

  IssueModel({
    required this.idIssue,
    required this.createdAt,
    required this.description,
    required this.lastUpdated,
    required this.notes,
    required this.idUser,
    required this.idTecnic,
    required this.idStatus,
    required this.idInventory,
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      idIssue: json['id_issue'] ?? 0, 
      createdAt: json['created_at'] ?? '',
      description: json['description'] ?? 'Unknown',
      lastUpdated: json['last_updated'] ?? '',
      notes: json['notes'] ?? 'Unknown',
      idUser: (json['id_user'] != null) ? json['id_user'] : 1, 
      idTecnic: (json['id_tecnic'] != null) ? json['id_tecnic'] : 1, 
      idStatus: (json['id_status'] != null) ? json['id_status'] : 1, 
      idInventory: json['id_inventory'] ?? 1, 
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'idIssue': idIssue,
      'createdAt': createdAt,
      'description': description,
      'lastUpdated': lastUpdated,
      'notes': notes,
      'idUser': idUser,
      'idTecnic': idTecnic,
      'idStatus': idStatus,
      'idInventory': idInventory,
    };
  }
}
