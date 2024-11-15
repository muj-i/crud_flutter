import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../screen/todo_list_view/providers/todo_list_provider.dart';

final todoListDataProvider = ChangeNotifierProvider<TodoListProvider>((ref) {
  return TodoListProvider();
});
