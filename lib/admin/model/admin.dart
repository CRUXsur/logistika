

class Admin
{
  int admin_id;
  String name;
  String email;
  String phone;
  String password;

  Admin(
      this.admin_id,
      this.name,
      this.email,
      this.phone,
      this.password,
      );

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
    int.parse(json["admin_id"]),
    json["name"],
    json["email"],
    json["phone"],
    json["password"],
  );


  Map<String, dynamic> toJson() =>
      {
        'admin_id': admin_id.toString(),
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      };
}