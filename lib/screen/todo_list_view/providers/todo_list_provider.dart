import 'dart:developer';

import 'package:crud_flutter/core/connectivity_checker/connectivity_checker.dart';
import 'package:crud_flutter/screen/todo_list_view/models/todo_list_model.dart';
import 'package:crud_flutter/screen/todo_list_view/repository/todo_list_repo.dart';
import 'package:flutter/material.dart';

import '../../../core/enum/screen_state.dart';
import '../../../core/provider/base_change_notifier.dart';

class TodoListProvider extends BaseChangeNotifier {
  ScreenState screenState = ScreenState.DEFAULT;

  void updateViewState({required ScreenState screenState}) {
    this.screenState = screenState;

    notifyListeners();
  }

  var todoList = [];
  Future<dynamic> getTodoList() async {
    updateViewState(screenState: ScreenState.START_LOADING);
    final hasInternet = await ConnectivityChecker.checkNetwork();
    if (!hasInternet) {
      updateViewState(screenState: ScreenState.NO_INTERNET);
      return;
    }
    final res = await TodoListRepo.getTodoList();
    if (res != null) {
      todoList = res;
      if (todoList.isNotEmpty) {
        updateViewState(screenState: ScreenState.HAS_DATA);
      } else {
        updateViewState(screenState: ScreenState.NO_DATA);
      }
    } else {
      updateViewState(screenState: ScreenState.NO_DATA);
    }
  }

  String selectedOption = '';
  String selectedOptionValue = '';

  void updateSelectedOption(int index, String title, String value) {
    selectedOption = title;
    selectedOptionValue = value;
    todoList[index].status = value;
    notifyListeners();
  }

  String getStatus(String status) {
    switch (status) {
      case 'todo':
        return 'Todo';
      case 'inprogress':
        return 'In Progress';
      case 'done':
        return 'Done';
      default:
        return 'Unknown';
    }
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<dynamic> createTodo(context) async {
    final hasInternet = await ConnectivityChecker.checkNetwork();
    if (!hasInternet) {
      updateViewState(screenState: ScreenState.NO_INTERNET);
      return;
    }
    final body = ListData(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      status: 'todo',
    );

    final res = await TodoListRepo.createTodo(body);
    if (res) {
      getTodoList();
      Navigator.pop(context);
    }
  }

  Future<dynamic> updateTodo(context,
      {required bool isStatusUpdate, required int index}) async {
    final hasInternet = await ConnectivityChecker.checkNetwork();
    if (!hasInternet) {
      updateViewState(screenState: ScreenState.NO_INTERNET);
      return;
    }
    final updateTodoBody = ListData(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      status: todoList[index].status,
    );

    final statusUpdateBody = ListData(
      title: todoList[index].title,
      description: todoList[index].description,
      status: selectedOptionValue,
    );

    final res = await TodoListRepo.updateTodo(
      isStatusUpdate ? statusUpdateBody : updateTodoBody,
      todoList[index].id ?? '',
    );
    if (res) {
      if (!isStatusUpdate) getTodoList();
      // if (!isStatusUpdate) Navigator.canPop(context);
      if (isStatusUpdate) log('Status updated');
    }
  }

  Future<dynamic> deleteAllTodo() async {
    final hasInternet = await ConnectivityChecker.checkNetwork();
    if (!hasInternet) {
      updateViewState(screenState: ScreenState.NO_INTERNET);
      return;
    }
    final res = await TodoListRepo.deleteAllTodo();
    if (res) {
      getTodoList();
    }
  }

  Future<dynamic> deleteTodo(int index) async {
    final hasInternet = await ConnectivityChecker.checkNetwork();
    if (!hasInternet) {
      updateViewState(screenState: ScreenState.NO_INTERNET);
      return;
    }
    final res = await TodoListRepo.deleteTodo(todoList[index].id ?? '');
    if (res) {
      getTodoList();
    }
  }
}
