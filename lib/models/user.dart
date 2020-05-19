import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String email;
  String nickname;
  String photoUrl;
  Map myWork;
  Map mySubscribe;

  final DocumentReference reference;

//  User({this.uid, this.email, this.nickname, this.photoUrl, this.myWork, this.mySubscribe});

  User.fromSnapshot(DocumentSnapshot snapshot, this.reference)
    : assert(snapshot['uid'] != null),
      uid= reference.documentID,
      email = snapshot['email'] ?? '',
      nickname = snapshot['name'] ?? '',
      photoUrl = snapshot['photoUrl'] ?? '',
      myWork = snapshot['myWork'] ?? [],
      mySubscribe = snapshot['mySubscribe'] ?? [];

  Map<String, dynamic> toJson() =>
      {"uid": uid, "email": email, "name": nickname, "photoUrl": photoUrl, "myWork":myWork, "mySubscribe":mySubscribe};
}