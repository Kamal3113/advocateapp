class ClientList {
  int id;
  String name;
  String password;
  String phone;
  String email;
  String token;
  ClientList(
      this.id, this.name, this.phone, this.email, this.token, this.password);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'username': name,
      'password': password,
      'phone': phone,
      'email': email,
      'token': token
    };
    return map;
  }

  ClientList.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['username'];
    password = map['password'];
    phone = map['phone'];
    email = map['email'];
    token = map['token'];
  }
}
