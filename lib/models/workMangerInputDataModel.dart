import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class WorkMangerInputData {
  WorkMangerInputData({
    required this.id,
    required this.title,
    required this.body,
  });
  late final int id;
  late final String title;
  late final String body;
  
  WorkMangerInputData.fromJson(Map<String?, dynamic>? json){
    id = json?['id'];
    title = json?['title'];
    body = json?['body'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['body'] = body;
    return _data;
  }
}
