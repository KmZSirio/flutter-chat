// To parse this JSON data, do
//
//     final errorResponse = errorResponseFromJson(jsonString);

import 'dart:convert';

ErrorResponse errorResponseFromJson(String str) => ErrorResponse.fromJson(json.decode(str));

String errorResponseToJson(ErrorResponse data) => json.encode(data.toJson());

class ErrorResponse {
    ErrorResponse({
        this.ok,
        this.msg,
    });

    bool ok;
    String msg;

    factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
        ok: json["ok"],
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
    };
}
