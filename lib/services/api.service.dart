

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_call_app/components/tok-tok-dialog.component.dart';
import 'package:video_call_app/constants/api.constants.dart';
import 'package:video_call_app/model/res/join-room.response.dart';

import '../model/res/nest-error.model.dart';
import '../model/utility/either.model.dart';

class ApiService {
  BuildContext context;
  ApiService({ required this.context });

  Future<Response<JoinRoomResponse, NestError>> joinRoom({ required String roomId, required String userId }) async {
    print("Join room ran");
    final body = jsonEncode({
      'userId': userId,
      'roomId': roomId,
    });

    try {
      final response = await http
          .post(Uri.parse(ApiRoutes.main_server_root)
          .replace(path: ApiRoutes.join_room),
          headers: {
            'Content-Type': 'application/json',
          },
          body: body
      );

      print("Body:");
      print(response.body);

      if (response.statusCode == 201) {
        final res = JoinRoomResponse.fromJson(jsonDecode(response.body));

        return Response.setSuccess(res);
      } else {
        final errorResponse = NestError.fromJson(jsonDecode(response.body));

        return Response.setError(errorResponse);
      }
    } catch (e) {
      final errorResponse = new NestError(error: e.toString(), message: "Something went wrong", statusCode: 0);
      return Response.setError(errorResponse);
    }
  }

}

