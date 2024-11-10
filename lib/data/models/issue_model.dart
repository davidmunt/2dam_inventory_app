class IssueModel {
  final int idIssue;
  final DateTime createdAt;
  final String description;
  final DateTime lastUpdated;
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
      idIssue: json['id_issue'], 
      createdAt: DateTime.parse(json['created_at']),
      description: json['description'] ?? 'Unknown',
      lastUpdated: DateTime.parse(json['last_updated']),
      notes: json['notes'] ?? 'Unknown',
      idUser: json['user']?['id_user'] ?? 1,
      idTecnic: json['technician']?['id_user'] ?? 1,
      idStatus: json['status']?['id_status'] ?? 1,
      idInventory: json['fk_inventari']?['id_inventory'] ?? 1,
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
