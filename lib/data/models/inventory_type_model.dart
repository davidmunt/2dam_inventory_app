class InventoryTypeModel {
  final int idType;
  final String description;

  InventoryTypeModel({
    required this.idType,
    required this.description,
  });

  factory InventoryTypeModel.fromJson(Map<String, dynamic> json) {
    //revisando la api me he dado cuenta que al hacer un push o pull de los campos id_type, id_classroom, no se añaden, por eso les he puesto un valor default
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