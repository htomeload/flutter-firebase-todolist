import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/state_manager.dart';
import 'package:todolist/constants/firebase_firestore_constants.dart';
import 'package:todolist/models/todo_group.dart';
import 'package:get/get.dart';
import 'package:todolist/models/todo_item.dart';

class TodoGroupController extends GetxController {
  Rx<List<TodoGroup>> todoGroupList = Rx<List<TodoGroup>>([]);
  List<TodoGroup> get todoGroups => todoGroupList.value.obs;

  var TodoGroups = <TodoGroup>[].obs;

  @override
  void onInit() {
    mockupTodoGroups();
    super.onInit();
  }

  @override
  void onReady() async {
    todoGroupList.bindStream(fetchTodoGroups());
  }

  Stream<List<TodoGroup>> fetchTodoGroups() {
    try {
      return FirebaseFirestore.instance
          .collection(FirestoreConstants.TODO_GROUP_COLLECTION)
          .where('status', isEqualTo: 'ACTIVE')
          .orderBy('createdDate', descending: true)
          .snapshots()
          .map((QuerySnapshot querySnapshot) {
        List<TodoGroup> groups = [];
        if (querySnapshot.size > 0) {
          for (var item in querySnapshot.docs) {
            final todoGroup =
                TodoGroup.fromDocumentSnapshot(documentSnapshot: item);
            groups.add(todoGroup);
          }
        }

        return groups;
      });
    } catch (e) {
      log(e.toString());
      return const Stream<List<TodoGroup>>.empty();
    }
  }

  void addTodoGroup(String groupName) async {
    /*
      required this.groupName,
      required this.isDone,
      required this.createdDate,
      required this.status
    */
    var firebaseFirestoreInstance = FirebaseFirestore.instance;
    var todoGroupCollection = firebaseFirestoreInstance
        .collection(FirestoreConstants.TODO_GROUP_COLLECTION);

    TodoGroup todoGroup = TodoGroup(
        groupName: groupName,
        isDone: false,
        createdDate: DateTime.now(),
        status: 'ACTIVE');

    todoGroup.updatedDate = DateTime.now();

    await todoGroupCollection.add({
      'groupName': todoGroup.groupName,
      'isDone': todoGroup.isDone,
      'createdDate': todoGroup.createdDate,
      'updatedDate': todoGroup.updatedDate,
      'status': todoGroup.status
    });
  }

  void updateTodoGroup(TodoGroup todoGroup) {
    /*
      required this.groupName,
      required this.isDone,
      required this.createdDate,
      required this.status
    */
    var firebaseFirestoreInstance = FirebaseFirestore.instance;
    var todoGroupCollection = firebaseFirestoreInstance
        .collection(FirestoreConstants.TODO_GROUP_COLLECTION);

    todoGroupCollection.doc(todoGroup.id).update({
      'groupName': todoGroup.groupName,
      'isDone': todoGroup.isDone,
      'status': todoGroup.status,
      'updatedDate': DateTime.now()
    });
  }

  void inactiveTodoGroupAndTasks(String id) {
    // inactive tasks in group
    inactiveTasksInGroup(id.toString());

    // inactive group
    inactiveTodoGroup(id);
  }

  void inactiveTodoGroup(String id) {
    var firebaseFirestoreInstance = FirebaseFirestore.instance;
    var todoGroupCollection = firebaseFirestoreInstance
        .collection(FirestoreConstants.TODO_GROUP_COLLECTION);

    todoGroupCollection
        .doc(id)
        .update({'status': 'INACTIVE', 'updatedDate': DateTime.now()});
  }

  void inactiveTasksInGroup(String parentId) {
    var firebaseFirestoreInstance = FirebaseFirestore.instance;
    var todoItemCollection = firebaseFirestoreInstance
        .collection(FirestoreConstants.TODO_ITEM_COLLECTION);

    todoItemCollection
        .where('parentId', isEqualTo: parentId)
        .get()
        .then((documents) {
      for (var doc in documents.docs) {
        if (doc['status'] == 'ACTIVE') {
          todoItemCollection
              .doc(doc.id)
              .update({'status': 'INACTIVE', 'updatedDate': DateTime.now()});
        }
      }
    });
  }

  void mockupTodoGroups() async {
    await Future.delayed(const Duration(seconds: 1));
    var result = [
      TodoGroup(
          id: 'a45q-48we4a65-s4d4d7-ad89-79a84d',
          groupName: 'Group 1',
          isDone: false,
          createdDate: DateTime.now(),
          status: 'ACTIVE'),
      TodoGroup(
          id: 'a45q-48we4a65-s4d4d7-ad89-79a84e',
          groupName: 'Group 2',
          isDone: false,
          createdDate: DateTime.now(),
          status: 'ACTIVE'),
      TodoGroup(
          id: 'a45q-48we4a65-s4d4d7-ad89-79a84f',
          groupName: 'Group 3',
          isDone: false,
          createdDate: DateTime.now(),
          status: 'ACTIVE')
    ];

    TodoGroups.assignAll(result);
  }
}
