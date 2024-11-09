class StatusModel {
  final int idStatus;
  final String description;

  StatusModel({
    required this.idStatus,
    required this.description,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      idStatus: json['id_status'],
      description: json['description'] ?? 'Empty',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idStatus': idStatus,
      'description': description,
    };
  }
}