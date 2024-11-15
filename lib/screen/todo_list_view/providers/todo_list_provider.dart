import 'package:crud_flutter/core/connectivity_checker/connectivity_checker.dart';
import 'package:crud_flutter/screen/todo_list_view/models/todo_list_model.dart';
import 'package:crud_flutter/screen/todo_list_view/repository/todo_list_repo.dart';

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
      updateViewState(screenState: ScreenState.HAS_DATA);
    } else {
      updateViewState(screenState: ScreenState.NO_DATA);
    }
  }
}
