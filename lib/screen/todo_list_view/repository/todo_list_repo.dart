import 'package:crud_flutter/data/utils/logger.dart';
import 'package:crud_flutter/screen/todo_list_view/models/todo_list_model.dart';

import '../../../data/network_caller/network_response.dart';
import '../../../data/network_caller/request_methods/delete_request.dart';
import '../../../data/network_caller/request_methods/get_request.dart';
import '../../../data/network_caller/request_methods/patch_request.dart';
import '../../../data/network_caller/request_methods/post_request.dart';
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

  static Future<bool> createTodo(ListData body) async {
    try {
      final NetworkResponse res =
          await PostRequest.execute(Urls.createTodo, body.toJson());
      return res.isSuccess;
    } catch (e) {
      logger.e('addTodoList: $e');
      return false;
    }
  }

  static Future<bool> updateTodo(ListData body, String id) async {
    try {
      final NetworkResponse res =
          await PatchRequest.execute(Urls.updateTodo(id), body.toJson());
      return res.isSuccess;
    } catch (e) {
      logger.e('updateTodoList: $e');
      return false;
    }
  }

  static Future<bool> deleteTodo(String id) async {
    try {
      final NetworkResponse res =
          await DeleteRequest.execute(Urls.deleteTodo(id));
      return res.isSuccess;
    } catch (e) {
      logger.e('deleteTodoList: $e');
      return false;
    }
  }

  static Future<bool> deleteAllTodo() async {
    try {
      final NetworkResponse res =
          await DeleteRequest.execute(Urls.deleteAllTodo);
      return res.isSuccess;
    } catch (e) {
      logger.e('deleteAllTodoList: $e');
      return false;
    }
  }
}
