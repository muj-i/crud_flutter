import 'package:crud_flutter/core/enum/screen_state.dart';
import 'package:crud_flutter/core/provider/providers.dart';
import 'package:crud_flutter/screen/add_todo_view/view/add_todo_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(todoListDataProvider).getTodoList();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TODO'),
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
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const AddTodoView();
            }));
          },
          child: const Icon(Icons.add),
        ),
      ),
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
        return dataView(data);
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

  dataView(data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(data[index].title),
          subtitle: Text(data[index].description),
        );
      },
    );
  }
}
