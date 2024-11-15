class Urls {
  Urls._();
  static const String baseUrl = 'https://ppvz8jd5-3000.inc1.devtunnels.ms';

  static const String createTodo = '$baseUrl/todo/create-todo';
  static const String getTodoList = '$baseUrl/todo/get-todo-list';
  static String updateTodo(String id) => '$baseUrl/todo/update-todo/$id';
  static String deleteTodo(String id) => '$baseUrl/todo/delete-todo/$id';
  static String deleteAllTodo = '$baseUrl/todo/delete-all-todo';
}
