import 'dart:developer';

import 'package:crud_flutter/core/enum/screen_state.dart';
import 'package:crud_flutter/core/provider/providers.dart';
import 'package:crud_flutter/screen/todo_list_view/widgets/add_or_update_todo_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/enum/todo_purpose.dart';

class TodoListView extends ConsumerStatefulWidget {
  const TodoListView({super.key});

  @override
  ConsumerState<TodoListView> createState() => _TodoListViewState();
}

class _TodoListViewState extends ConsumerState<TodoListView> {
  @override
  void initState() {
    WidgetsBinding.instance.scheduleFrameCallback((_) async {
      ref.invalidate(todoListDataProvider);
      await ref.read(todoListDataProvider).getTodoList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(todoListDataProvider).deleteAllTodo();
            },
            icon: const Icon(Icons.remove_circle_outline_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(todoListDataProvider).getTodoList();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer(builder: (context, ref, child) {
            return viewByScreenState(ref);
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomSheet(TodoPurpose.ADD, -1);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  showBottomSheet(TodoPurpose purpose, int index) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: AddOrUpdateTodoSheet(
              purpose: purpose,
              provider: ref.read(todoListDataProvider),
              index: index,
            ));
      },
    );
  }

  Widget viewByScreenState(ref) {
    final provider = ref.watch(todoListDataProvider);
    final data = provider.todoList;

    switch (provider.screenState) {
      case ScreenState.START_LOADING:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case ScreenState.HAS_DATA:
        return dataView(data, provider);
      case ScreenState.NO_DATA:
        return const Center(
          child: Text('No data found'),
        );
      case ScreenState.ERROR:
        return const Center(
          child: Text('Error occurred'),
        );
      case ScreenState.NO_INTERNET:
        return const Center(
          child: Text('No internet connection'),
        );
      default:
        return const SizedBox(); //default
    }
  }

  dataView(data, provider) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        provider.selectedOption = provider.getStatus(data[index].status);
        return Row(
          children: [
            Expanded(
              child: ListTile(
                title: Text(data[index].title),
                subtitle: Text(data[index].description),
                trailing: statusPopupMenu(provider, index),
              ),
            ),
            IconButton(
                onPressed: () {
                  showBottomSheet(TodoPurpose.EDIT, index);
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  provider.updateViewState(screenState: ScreenState.START_LOADING);
                  provider.deleteTodo(index);
                },
                icon: const Icon(Icons.delete)),
          ],
        );
      },
    );
  }

  PopupMenuButton<CustomPopupMenuItemModel> statusPopupMenu(
      provider, int index) {
    return PopupMenuButton<CustomPopupMenuItemModel>(
        color: Colors.white,
        child: Text(provider.selectedOption),
        onSelected: (result) {
          provider.updateSelectedOption(index, result.title, result.value);
          log("Selected: ${provider.selectedOption}");
          log("Selected: ${provider.selectedOptionValue}");
          provider.updateTodo(context, isStatusUpdate: true, index: index);
        },
        itemBuilder: (BuildContext context) => [
              CustomPopupMenuItemModel(
                title: 'Todo',
                value: 'todo',
              ),
              CustomPopupMenuItemModel(
                title: 'In Progress',
                value: 'inprogress',
              ),
              CustomPopupMenuItemModel(
                title: 'Done',
                value: 'done',
              ),
            ]
                .map((e) => PopupMenuItem<CustomPopupMenuItemModel>(
                    value: e, child: Text(e.title)))
                .toList());
  }
}

class CustomPopupMenuItemModel {
  final String title;
  final String value;

  CustomPopupMenuItemModel({required this.title, required this.value});
}
