import 'dart:convert';

import 'package:teledart/model.dart';

class Request {
  User user;
  Message message;
  int value;

  Request(this.user, this.message, this.value);

  String toJson() => jsonEncode(toMap());

  Map<String, dynamic> toMap() => {
        "user": user.toJson(),
        "message": message.toJson(),
        "value": value,
      };

  factory Request.fromJson(String json) => Request.fromMap(jsonDecode(json));

  factory Request.fromMap(Map<String, dynamic> map) => Request(
        User.fromJson(map['user']),
        Message.fromJson(map['message']),
        map['value'],
      );
}
