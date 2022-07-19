import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/controllers/todo_item_controller.dart';
import 'package:todolist/models/todo_item.dart';

class TodoItemPage extends StatefulWidget {
  const TodoItemPage({Key? key, this.parentId}) : super(key: key);
  final String? parentId;

  @override
  State<TodoItemPage> createState() => _TodoItemPageState();
}

class _TodoItemPageState extends State<TodoItemPage> {
  final todoItemController = Get.put(TodoItemController());
  TextEditingController itemTextTextFieldInputController =
      TextEditingController();
  late TodoItem editingTodoItem;
  bool isEditingItem = false;

  void handleNavigation(context) {
    Navigator.pop(context);
  }

  void handleOnSaveItemText(context) {
    if (itemTextTextFieldInputController.text.isNotEmpty) {
      if (isEditingItem) {
        editingTodoItem.text = itemTextTextFieldInputController.text;
        todoItemController.updateTodoItem(editingTodoItem);
      } else {
        todoItemController.addTodoItem(itemTextTextFieldInputController.text);
      }
    } else if (isEditingItem) {
      todoItemController.inactiveTask(editingTodoItem.id.toString());
    }
    todoItemController.fetchTodoItems(widget.parentId.toString());
    Navigator.pop(context);
  }

  void handleShowNewItemTextFieldEditorModal(context) {
    itemTextTextFieldInputController.text = '';
    isEditingItem = false;
    showItemTextFieldEditorModal(context);
  }

  void handleShowItemTextFieldEditorModal(
      context, String itemText, TodoItem todoItem) {
    itemTextTextFieldInputController.text = itemText;
    isEditingItem = true;
    editingTodoItem = todoItem;
    showItemTextFieldEditorModal(context);
  }

  void handleUpdateTaskIsDone(String id, bool isDone) {
    todoItemController.updateTaskIsDone(id, isDone);
  }

  @override
  void dispose() {
    itemTextTextFieldInputController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    todoItemController.parentId = widget.parentId.toString();
    todoItemController.bindStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          todoItemListHeader(context),
          Expanded(child: GetX<TodoItemController>(builder: (controller) {
            return ListView.builder(
              itemCount: controller.todoItems.length,
              itemBuilder: (BuildContext buildContext, int index) {
                var item = controller.todoItems[index];

                return Card(
                  margin: const EdgeInsets.all(12),
                  child: renderTodoItem(context, item),
                );
              },
            );
          }))
        ],
      )),
    );
  }

  Row todoItemListHeader(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                children: <Widget>[
                  ElevatedButton(
                      onPressed: () => handleNavigation(context),
                      style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          shadowColor: Colors.transparent,
                          primary: Colors.transparent),
                      child: const Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: Text(
                          '<',
                          style: TextStyle(fontSize: 32, color: Colors.black),
                        ),
                      )),
                  const Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: Text(
                      'Task',
                      style: TextStyle(fontSize: 32),
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.white),
                      onPressed: () =>
                          handleShowNewItemTextFieldEditorModal(context),
                      child: const Text(
                        '+',
                        style: TextStyle(fontSize: 32, color: Colors.black),
                      ))
                ],
              )
            ],
          ),
        ))
      ],
    );
  }

  ElevatedButton renderTodoItem(BuildContext context, TodoItem item) {
    return ElevatedButton(
        onPressed: () =>
            handleUpdateTaskIsDone(item.id.toString(), !item.isDone),
        onLongPress: () =>
            handleShowItemTextFieldEditorModal(context, item.text, item),
        style: ElevatedButton.styleFrom(primary: Colors.white),
        child: Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: Text(
                  item.text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 24,
                      color: item.isDone ? Colors.grey : Colors.black,
                      decorationColor: Colors.black,
                      decorationThickness: 3.4,
                      decoration: item.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                ))
              ],
            )));
  }

  Future<void> showItemTextFieldEditorModal(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: 200,
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: itemTextTextFieldInputController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Task description',
                            hintText: 'What will we do here?'),
                      ),
                    ),
                    ElevatedButton(
                      child: const Text('Save'),
                      onPressed: () => handleOnSaveItemText(context),
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }
}
