import 'package:crud_flutter/data/utils/logger.dart';
import 'package:crud_flutter/screen/todo_list_view/models/todo_list_model.dart';

import '../../../data/network_caller/network_response.dart';
import '../../../data/network_caller/request_methods/get_request.dart';
import '../../../data/utils/urls.dart';

abstract class TodoListRepo {
  static Future getTodoList() async {
    TodoListModel todoListModel = TodoListModel();
    try {
      final NetworkResponse res = await GetRequest.execute(Urls.getTodoList);
      todoListModel = TodoListModel.fromJson(res.responseData); 
      return todoListModel.data;
    } catch (e) {
      logger.e('getTodoList: $e');
      return Future.error(e);
    }
  }
}
