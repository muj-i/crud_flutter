import 'package:flutter/material.dart';

class AddTodoView extends StatelessWidget {
  const AddTodoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add TODO'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: AddTodoForm(),
      ),
    );
  }
}

class AddTodoForm extends StatelessWidget {
  const AddTodoForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TextField(
          decoration: InputDecoration(
            labelText: 'Title',
          ),
        ),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Description',
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Add'),
        ),
      ],
    );
  }
}
