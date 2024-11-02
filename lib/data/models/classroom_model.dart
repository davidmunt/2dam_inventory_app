class ClassroomModel {
  final int idClassroom;
  final String description;

  ClassroomModel({
    required this.idClassroom,
    required this.description,
  });

  factory ClassroomModel.fromJson(Map<String, dynamic> json) {
    return ClassroomModel(
      idClassroom: json['id_classroom'],
      description: json['description'] ?? 'Empty',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idClassroom': idClassroom,
      'description': description,
    };
  }
}