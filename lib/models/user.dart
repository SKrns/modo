class User {
  String uid;
  String email;
  String name;
  String photoUrl;

  User({this.uid, this.email, this.name, this.photoUrl});

  User.fromMap(Map map)
    : assert(map['uid'] != null),
      uid = map['uid'],
      email = map['email'] ?? '',
      name = map['name'] ?? '',
      photoUrl = map['photoUrl'] ?? '';

  Map<String, dynamic> toJson() =>
      {"uid": uid, "email": email, "name": name, "photoUrl": photoUrl};
}