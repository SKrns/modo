import 'package:cloud_firestore/cloud_firestore.dart';

class Works {
  String image;
  final String title;
  final String writer;
  final String series;
  final String genre;
  final String tag;
  final String id;

  final DocumentReference reference;

  Works.fromMap(Map<String, dynamic> map, {this.reference})
      : id = reference.documentID ?? 'no',
        image = map['image'] ?? 'http://image.yes24.com/goods/89729709/800x0',
        title = map['title'] ?? '',
        writer = map['writer'] ?? '',
        genre = map['genre'] ?? '',
        series = map['series'] ?? '',
        tag = map['tag'] ?? '';
  Works.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
  @override
  String toString() => "Works<$id:$image:$title:$writer:$series:$tag>";
}
