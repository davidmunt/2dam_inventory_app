class InventoryTypeModel {
  final int idType;
  final String description;

  InventoryTypeModel({
    required this.idType,
    required this.description,
  });

  factory InventoryTypeModel.fromJson(Map<String, dynamic> json) {
    return InventoryTypeModel(
      idType: json['id_type'],
      description: json['description'] ?? 'Empty',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idType': idType,
      'description': description,
    };
  }
}