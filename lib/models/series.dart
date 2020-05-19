import 'package:cloud_firestore/cloud_firestore.dart';

class Series {
  final String title;
  final int documentId;
  final Timestamp date;
  final String id;
  final String src;

  final DocumentReference reference;

  Series.fromMap(Map<String, dynamic> map, {this.reference})
      : id = reference.documentID ?? 'no',
        documentId = map['id'] ?? 0,
        title = map['title'] ?? '',
        date = map['date'] ?? DateTime.now(),
        src = map['src'] ?? "https://firebasestorage.googleapis.com/v0/b/fir-example-e20c8.appspot.com/o/text%2Ferror.json?alt=media&token=8d296067-b43b-4196-a980-9e7685ebd7cc";

  Series.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
  @override
  String toString() => "Series<$id:$documentId:$title:$date>";
}
