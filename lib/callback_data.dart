// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CallbackData {
  /// page
  String pg;

  /// parameters
  List<Param>? prms;

  CallbackData({
    required this.pg,
    this.prms,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pg': pg,
      'prms': prms?.map((x) => x.toMap()).toList(),
    };
  }

  factory CallbackData.fromMap(Map<String, dynamic> map) {
    print(map);
    return CallbackData(
      pg: map['pg'] as String,
      prms: map['prms'] != null
          ? List<Param>.from(
              (map['prms']).map<Param?>(
                (x) => Param.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() {
    String jsonString = json.encode(toMap());
    print(jsonString);
    return jsonString;
  }

  factory CallbackData.fromJson(String source) =>
      CallbackData.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Param {
  /// name
  String n;

  /// value
  String v;

  Param({
    required this.n,
    required this.v,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'n': n,
      'v': v,
    };
  }

  factory Param.fromMap(Map<String, dynamic> map) {
    return Param(
      n: map['n'] as String,
      v: map['v'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Param.fromJson(String source) =>
      Param.fromMap(json.decode(source) as Map<String, dynamic>);
}
