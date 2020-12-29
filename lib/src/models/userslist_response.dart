// To parse this JSON data, do
//
//     final usersListResponse = usersListResponseFromJson(jsonString);

import 'dart:convert';

import 'package:realtime_chat/src/models/user.dart';

UsersListResponse usersListResponseFromJson(String str) => UsersListResponse.fromJson(json.decode(str));

String usersListResponseToJson(UsersListResponse data) => json.encode(data.toJson());

class UsersListResponse {
    UsersListResponse({
        this.ok,
        this.users,
        this.count,
    });

    bool ok;
    List<User> users;
    int count;

    factory UsersListResponse.fromJson(Map<String, dynamic> json) => UsersListResponse(
        ok: json["ok"],
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
        count: json["count"],
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
        "count": count,
    };
}
