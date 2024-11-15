import 'package:flutter/material.dart';

import '../../../core/enum/todo_purpose.dart';

class AddOrUpdateTodoSheet extends StatelessWidget {
  const AddOrUpdateTodoSheet(
      {super.key,
      required this.purpose,
      required this.provider,
      required this.index});
  final TodoPurpose purpose;
  final dynamic provider;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(purpose == TodoPurpose.ADD ? 'Add TODO' : 'Update TODO'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: todoForm(context),
      ),
    );
  }

  Widget todoForm(context) {
    return Column(
      children: [
        TextField(
          controller: provider.titleController,
          decoration: const InputDecoration(
            labelText: 'Title',
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: provider.descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            if (purpose == TodoPurpose.ADD) {
              provider.createTodo(context);
            } else {
              provider.updateTodo(context, isStatusUpdate: false, index: index);
            }
          },
          child: Text(purpose == TodoPurpose.ADD ? 'Add' : 'Update'),
        ),
      ],
    );
  }
}
