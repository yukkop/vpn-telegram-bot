import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import 'const.dart';

Future<Map<String, int>> getManagersIdList() async {
  var res =
      jsonDecode((await http.post(Uri.https("dataapi.callgear.com", 'v2.0'),
              body: jsonEncode({
                "id": Random().nextInt(100000),
                "method": "get.employees",
                "jsonrpc": "2.0",
                "params": {
                  "access_token": "5l3tgozq1wvy72h14awnq8ev0os5t25lnj211xgl"
                }
              }),
              headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
      }))
          .body);
  res = (res['result']['data'] as List).asMap().map((index, value) =>
      (value['full_name'] != null && value['id'] != null)
          ? MapEntry(value['full_name'] as String, value['id'] as int)
          : const MapEntry('', 0));
  return res;
}

Future<Map<String, int>> getManagersNumberList() async {
  var res =
      jsonDecode((await http.post(Uri.https("dataapi.callgear.com", 'v2.0'),
              body: jsonEncode({
                "id": Random().nextInt(100000),
                "method": "get.employees",
                "jsonrpc": "2.0",
                "params": {
                  "access_token": "5l3tgozq1wvy72h14awnq8ev0os5t25lnj211xgl"
                }
              }),
              headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
      }))
          .body);
  res = (res['result']['data'] as List).asMap().map((index, value) =>
      (value['full_name'] != null &&
              value['extension']['extension_phone_number'] != null)
          ? MapEntry(value['full_name'] as String,
              int.parse(value['extension']['extension_phone_number']))
          : const MapEntry('und', 0));
  print(res);
  return res;
}

Future<List<dynamic>> getGroupEmployees() async {
  var res =
      jsonDecode((await http.post(Uri.https("dataapi.callgear.com", 'v2.0'),
              body: jsonEncode({
                "id": Random().nextInt(100000),
                "method": "get.group_employees",
                "jsonrpc": "2.0",
                "params": {
                  "access_token": "5l3tgozq1wvy72h14awnq8ev0os5t25lnj211xgl"
                }
              }),
              headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
      }))
          .body);
  res = (res['result']['data']);
  return res;
}

Future<Map<String, dynamic>> updateGroupEmployees(
    List<int> usersId, String groupName) async {
  var res =
      jsonDecode((await http.post(Uri.https("dataapi.callgear.com", 'v2.0'),
              body: jsonEncode({
                "id": Random().nextInt(100000),
                "method": "update.group_employees",
                "jsonrpc": "2.0",
                "params": {
                  "id": groupId[groupName],
                  "name": groupName,
                  "members": usersId,
                  "access_token": "5l3tgozq1wvy72h14awnq8ev0os5t25lnj211xgl"
                }
              }),
              headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
      }))
          .body);
  return res;
}

Future<Map<String, dynamic>> addEmployer(int userId, String groupName) async {
  var group = (await getGroupEmployees())
          .firstWhere((element) => element["name"] == groupName)
      as Map<String, dynamic>;
  List<Map<String, dynamic>> groupMembers = (group["members"] as List)
      .map((e) => Map<String, dynamic>.from(e))
      .toList();
  var groupMembersId = groupMembers.map((e) => e["employee_id"] as int);
  if (!groupMembersId.contains(userId)) {
    return await updateGroupEmployees([...groupMembersId, userId], groupName);
  }
  return {"Error": "Employer yet contained"};
}

Future<Map<String, dynamic>> removeEmployer(
    int userId, String groupName) async {
  var group = (await getGroupEmployees())
          .firstWhere((element) => element["name"] == groupName)
      as Map<String, dynamic>;
  List<Map<String, dynamic>> groupMembers = (group["members"] as List)
      .map((e) => Map<String, dynamic>.from(e))
      .toList();
  var groupMembersId = groupMembers.map((e) => e["employee_id"] as int);
  groupMembersId = groupMembersId.where((element) => element != userId);
  var res = await updateGroupEmployees([...groupMembersId], groupName);
  return res;
}
