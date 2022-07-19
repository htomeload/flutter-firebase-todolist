import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/state_manager.dart';
import 'package:todolist/constants/firebase_firestore_constants.dart';
import 'package:todolist/models/todo_item.dart';
import 'package:get/get.dart';

class TodoItemController extends GetxController {
  Rx<List<TodoItem>> todoItemList = Rx<List<TodoItem>>([]);
  List<TodoItem> get todoItems => todoItemList.value.obs;
  late String parentId;

  var TodoItems = <TodoItem>[].obs;

  @override
  void onInit() {
    mockupTodoItems();
    super.onInit();
  }

  void bindStream() async {
    todoItemList.bindStream(fetchTodoItems(parentId));
  }

  @override
  void dispose() {
    todoItemList.close();
    todoItemList = Rx<List<TodoItem>>([]);
    parentId = '';
    super.dispose();
  }

  Stream<List<TodoItem>> fetchTodoItems(String parentId) {
    try {
      return FirebaseFirestore.instance
          .collection(FirestoreConstants.TODO_ITEM_COLLECTION)
          .where('parentId', isEqualTo: parentId)
          .orderBy('createdDate')
          .snapshots()
          .map((QuerySnapshot querySnapshot) {
        List<TodoItem> items = [];
        if (querySnapshot.size > 0) {
          for (var item in querySnapshot.docs) {
            if (item['status'] == 'ACTIVE') {
              final todoItem =
                  TodoItem.fromDocumentSnapshot(documentSnapshot: item);
              items.add(todoItem);
            }
          }
        }

        return items;
      });
    } catch (e) {
      log(e.toString());
      return const Stream<List<TodoItem>>.empty();
    }
  }

  void addTodoItem(String text) async {
    /*
      required this.parentId,
      required this.text,
      required this.isDone,
      required this.createdDate,
      required this.status
    */
    var firebaseFirestoreInstance = FirebaseFirestore.instance;
    var todoItemCollection = firebaseFirestoreInstance
        .collection(FirestoreConstants.TODO_ITEM_COLLECTION);

    TodoItem todoItem = TodoItem(
        parentId: parentId,
        text: text,
        isDone: false,
        createdDate: DateTime.now(),
        status: 'ACTIVE');

    todoItem.updatedDate = DateTime.now();

    await todoItemCollection.add({
      'parentId': todoItem.parentId,
      'text': todoItem.text,
      'isDone': todoItem.isDone,
      'createdDate': todoItem.createdDate,
      'updatedDate': todoItem.updatedDate,
      'status': todoItem.status
    });
  }

  void updateTodoItem(TodoItem todoItem) async {
    /*
      required this.parentId,
      required this.text,
      required this.isDone,
      required this.createdDate,
      required this.status
    */
    var firebaseFirestoreInstance = FirebaseFirestore.instance;
    var todoItemCollection = firebaseFirestoreInstance
        .collection(FirestoreConstants.TODO_ITEM_COLLECTION);

    await todoItemCollection.doc(todoItem.id).update({
      'text': todoItem.text,
      'isDone': todoItem.isDone,
      'updatedDate': todoItem.updatedDate,
      'status': todoItem.status
    });
  }

  void inactiveTask(String id) {
    var firebaseFirestoreInstance = FirebaseFirestore.instance;
    var todoItemCollection = firebaseFirestoreInstance
        .collection(FirestoreConstants.TODO_ITEM_COLLECTION);

    todoItemCollection
        .doc(id)
        .update({'status': 'INACTIVE', 'updatedDate': DateTime.now()});
  }

  void updateGroupIsDone(String id, bool isDone) {
    var firebaseFirestoreInstance = FirebaseFirestore.instance;
    var todoGroupCollection = firebaseFirestoreInstance
        .collection(FirestoreConstants.TODO_GROUP_COLLECTION);

    todoGroupCollection
        .doc(id)
        .update({'isDone': isDone, 'updatedDate': DateTime.now()});
  }

  void updateTaskIsDone(String id, bool isDone) {
    var firebaseFirestoreInstance = FirebaseFirestore.instance;
    var todoItemCollection = firebaseFirestoreInstance
        .collection(FirestoreConstants.TODO_ITEM_COLLECTION);

    todoItemCollection
        .doc(id)
        .update({'isDone': isDone, 'updatedDate': DateTime.now()});

    var isDoneCount = 0;

    for (var item in todoItems) {
      if (item.isDone) {
        isDoneCount++;
      }
    }

    if (isDone) {
      isDoneCount++;
    } else {
      isDoneCount--;
    }

    updateGroupIsDone(parentId, isDoneCount >= todoItems.length);
  }

  void mockupTodoItems() async {
    await Future.delayed(const Duration(seconds: 1));
    var result = [
      TodoItem(
          id: 'gsdg-5we7a56s-dfdgt5-41h5-1d321a',
          parentId: 'abcd-defghijk-lmnopq-rstu-vwxyz1',
          text: 'Create Model',
          isDone: true,
          createdDate: DateTime.now(),
          status: 'ACTIVE'),
      TodoItem(
          id: 'gsdg-5we7a56s-dfdgt5-41h5-1d321b',
          parentId: 'abcd-defghijk-lmnopq-rstu-vwxyz1',
          text: 'Create Controller',
          isDone: true,
          createdDate: DateTime.now(),
          status: 'ACTIVE'),
      TodoItem(
          id: 'gsdg-5we7a56s-dfdgt5-41h5-1d321c',
          parentId: 'abcd-defghijk-lmnopq-rstu-vwxyz1',
          text: 'Create View',
          isDone: false,
          createdDate: DateTime.now(),
          status: 'ACTIVE'),
      TodoItem(
          id: 'gsdg-5we7a56s-dfdgt5-41h5-1d321d',
          parentId: 'abcd-defghijk-lmnopq-rstu-vwxyz2',
          text: 'Connect to firebase',
          isDone: false,
          createdDate: DateTime.now(),
          status: 'ACTIVE'),
      TodoItem(
          id: 'gsdg-5we7a56s-dfdgt5-41h5-1d321e',
          parentId: 'abcd-defghijk-lmnopq-rstu-vwxyz2',
          text: 'Fetch data from firebase',
          isDone: false,
          createdDate: DateTime.now(),
          status: 'ACTIVE'),
      TodoItem(
          id: 'gsdg-5we7a56s-dfdgt5-41h5-1d321f',
          parentId: 'abcd-defghijk-lmnopq-rstu-vwxyz3',
          text: 'Modify data on firebase',
          isDone: false,
          createdDate: DateTime.now(),
          status: 'ACTIVE'),
    ];

    TodoItems.assignAll(result);
  }
}
