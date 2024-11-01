class InventoryModel {
  final int idInventory;
  final String numSerie;
  final int idType;
  final String brand;
  final String model;
  final int gvaCodArticle;
  final String gvaDescriptionCodArticulo;
  final String status;
  final int idClassroom;

  InventoryModel({
    required this.idInventory,
    required this.numSerie,
    required this.idType,
    required this.brand,
    required this.model,
    required this.gvaCodArticle,
    required this.gvaDescriptionCodArticulo,
    required this.status,
    required this.idClassroom,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    //revisando la api me he dado cuenta que al hacer un push o pull de los campos id_type, id_classroom, no se añaden, por eso les he puesto un valor default
    return InventoryModel(
      idInventory: json['id_inventory'],
      numSerie: json['num_serie'] ?? 'Empty',
      idType: (json['id_type'].isNotEmpty) ? json['id_type'] : 1,
      brand: json['brand'],
      model: json['model'] ?? 'Empty',
      gvaCodArticle: json['GVA_cod_article'],
      gvaDescriptionCodArticulo: json['GVA_description_cod_articulo'],
      status: json['status'],
      idClassroom: (json['id_classroom'].isNotEmpty) ? json['id_classroom'] : 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idInventory': idInventory,
      'numSerie': numSerie,
      'idType': idType,
      'brand': brand,
      'model': model,
      'gvaCodArticle': gvaCodArticle,
      'gvaDescriptionCodArticulo': gvaDescriptionCodArticulo,
      'status': status,
      'idClassroom': idClassroom,
    };
  }
}