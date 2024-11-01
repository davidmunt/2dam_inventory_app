class Issue {
  final int idIssue;
  final String createdAt;
  final String description;
  final String lastUpdated;
  final String notes;
  final int idUser;
  final int idTecnic;
  final int idStatus;
  final int idInventory;

  Issue({
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
}