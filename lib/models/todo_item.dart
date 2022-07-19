import 'package:cloud_firestore/cloud_firestore.dart';

class TodoItem {
  String? id;
  late String parentId;
  late String text;
  late bool isDone;
  late DateTime createdDate;
  late DateTime updatedDate;
  late String status;

  TodoItem(
      {this.id,
      required this.parentId,
      required this.text,
      required this.isDone,
      required this.createdDate,
      required this.status});

  TodoItem.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    parentId = documentSnapshot['parentId'];
    text = documentSnapshot['text'];
    isDone = documentSnapshot['isDone'];
    createdDate =
        DateTime.parse(documentSnapshot['createdDate'].toDate().toString());
    updatedDate =
        DateTime.parse(documentSnapshot['updatedDate'].toDate().toString());
    status = documentSnapshot['status'];
  }
}
