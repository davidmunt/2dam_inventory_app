class UserModel {
 final String email;
 final String password;
 final String name;
 final int type;

 UserModel({required this.email, required this.password, required this.name, required this.type});

 factory UserModel.fromJson(Map<String, dynamic> json) {
   return UserModel(email: json['email'], password: json['password'], name: json['name'], type: json['type']);
 }

 Map<String, dynamic> toJson() {
   return {
     'email': email,
     'password': password,
     'name': name,
     'type': type,
   };
 }
}