import 'package:cloud_firestore/cloud_firestore.dart';

class Series {
  final String title;
  final int documentId;
  final Timestamp date;
  final String id;

  final DocumentReference reference;

  Series.fromMap(Map<String, dynamic> map, {this.reference})
      : id = reference.documentID ?? 'no',
        documentId = map['id'] ?? 0,
        title = map['title'] ?? '',
        date = map['date'] ?? DateTime.now();

  Series.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
  @override
  String toString() => "Series<$id:$documentId:$title:$date>";
}
