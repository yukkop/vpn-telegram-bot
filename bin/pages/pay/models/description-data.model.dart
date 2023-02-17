import 'dart:convert';

import 'package:teledart/model.dart';

@Deprecated("не нужен как оказалось")
class DescriptionData {
  User user;
  Message message;
  int price;
  int balls;

  DescriptionData(this.user, this.message, this.price, this.balls);

  String toJson() => jsonEncode(toMap());

  Map<String, dynamic> toMap() => {
        "user": user.toJson(),
        "message": message.toJson(),
        "price": price,
        "balls": balls
      };
}

