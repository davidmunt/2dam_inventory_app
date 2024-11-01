class UserModel {
 final String email;
 final String password;
 final String name;
 final int type;
 final int id;

 UserModel({required this.email, required this.password, required this.name, required this.type, required this.id});

 factory UserModel.fromJson(Map<String, dynamic> json) {
   return UserModel(email: json['email'], password: json['password'], name: json['name'], type: json['type'], id: json['id']);
 }

 Map<String, dynamic> toJson() {
   return {
     'email': email,
     'password': password,
     'name': name,
     'type': type,
     'id': id,
   };
 }
}