import 'package:flutter/material.dart';
import 'package:todolist/controllers/todo_group_controller.dart';
import 'package:get/get.dart';
import 'package:todolist/views/TodoItemPage.dart';
import 'package:todolist/models/todo_group.dart';

class TodoGroupPage extends StatelessWidget {
  final todoGroupController = Get.put(TodoGroupController());
  TextEditingController groupNameTextFieldInputController =
      TextEditingController();
  late TodoGroup editingTodoGroupItem;
  bool isEditingItem = false;

  TodoGroupPage({Key? key}) : super(key: key);

  void handleNavigation(context, String? parentId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TodoItemPage(
                  parentId: parentId,
                )));
  }

  void handleOnSaveGroupName(context) {
    if (groupNameTextFieldInputController.text.isNotEmpty) {
      if (isEditingItem) {
        editingTodoGroupItem.groupName = groupNameTextFieldInputController.text;
        todoGroupController.updateTodoGroup(editingTodoGroupItem);
      } else {
        todoGroupController
            .addTodoGroup(groupNameTextFieldInputController.text);
      }
    } else if (isEditingItem) {
      todoGroupController
          .inactiveTodoGroupAndTasks(editingTodoGroupItem.id.toString());
    }
    todoGroupController.fetchTodoGroups();
    Navigator.pop(context);
  }

  void handleShowNewGroupNameTextFieldEditorModal(context) {
    groupNameTextFieldInputController.text = '';
    isEditingItem = false;
    showGroupNameTextFieldEditorModal(context);
  }

  void handleShowGroupNameTextFieldEditorModal(
      context, String groupName, TodoGroup todoGroup) {
    groupNameTextFieldInputController.text = groupName;
    isEditingItem = true;
    editingTodoGroupItem = todoGroup;
    showGroupNameTextFieldEditorModal(context);
  }

  void dispose() {
    groupNameTextFieldInputController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: Column(
        children: [
          todoGroupListHeader(context),
          Expanded(child: GetX<TodoGroupController>(builder: (controller) {
            return ListView.builder(
              itemCount: controller.todoGroups.length,
              itemBuilder: (BuildContext buildContext, int index) {
                var item = controller.todoGroups[index];

                return Card(
                    margin: const EdgeInsets.all(12),
                    child: renderTodoGroupItem(context, item));
              },
            );
          }))
        ],
      )),
    );
  }

  Row todoGroupListHeader(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
      Expanded(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('Group', style: TextStyle(fontSize: 32)),
                    ElevatedButton(
                        onPressed: () =>
                            handleShowNewGroupNameTextFieldEditorModal(context),
                        child: const Text(
                          '+',
                          style: TextStyle(fontSize: 32),
                        ))
                  ],
                ))),
      )
    ]);
  }

  ElevatedButton renderTodoGroupItem(BuildContext context, TodoGroup item) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: item.isDone ? Colors.blueGrey : Colors.lightBlue),
      onPressed: () => handleNavigation(context, item.id),
      onLongPress: () => handleShowGroupNameTextFieldEditorModal(
          context, item.groupName, item),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.groupName,
                      style: TextStyle(
                          fontSize: 24,
                          decorationColor: Colors.blueAccent,
                          decorationThickness: 3.8,
                          decoration: item.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> showGroupNameTextFieldEditorModal(BuildContext context) {
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
                        controller: groupNameTextFieldInputController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Group Name',
                            hintText: 'Enter group task name'),
                      ),
                    ),
                    ElevatedButton(
                      child: const Text('Save'),
                      onPressed: () => handleOnSaveGroupName(context),
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }
}
