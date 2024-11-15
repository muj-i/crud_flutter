class TodoListModel {
  String? message;
  List<ListData>? data;

  TodoListModel({this.message, this.data});

  TodoListModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <ListData>[];
      json['data'].forEach((v) {
        data!.add(ListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListData {
  String? title;
  String? description;
  String? status;
  String? id;

  ListData({this.title, this.description, this.status, this.id});

  ListData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    status = json['status'];
    id = json['id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['status'] = status;
    return data;
  }
}
