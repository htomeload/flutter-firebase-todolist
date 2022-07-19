import 'package:cloud_firestore/cloud_firestore.dart';

class TodoGroup {
  String? id;
  late String groupName;
  late bool isDone;
  late DateTime createdDate;
  late DateTime updatedDate;
  late String status;

  TodoGroup(
      {this.id,
      required this.groupName,
      required this.isDone,
      required this.createdDate,
      required this.status});

  TodoGroup.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    groupName = documentSnapshot['groupName'];
    isDone = documentSnapshot['isDone'];
    createdDate =
        DateTime.parse(documentSnapshot['createdDate'].toDate().toString());
    updatedDate =
        DateTime.parse(documentSnapshot['updatedDate'].toDate().toString());
    status = documentSnapshot['status'];
  }
}
