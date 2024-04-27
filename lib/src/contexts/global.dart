import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_sit_operation_application/constants.dart';
import 'package:http/http.dart';

class GlobalContext extends ChangeNotifier {
  late String accessToken = "";

  Future<void> initialLoad(BuildContext context) async {
    print("................ Loading initial data ................");
    return;
  }

  Future<bool> signInUser(String email, String password) async {
    print("singin user");
    try {
      print('****** request *******');
      Map data = {"orgSlug": "macae", 'username': email, 'password': password};

      print('data: ${data}');

      Response response = await post(Uri.parse('$API_URL/auth/signin'),
          headers: {"Content-Type": "application/json"},
          body: json.encode(data));
      if (response.statusCode == 200) {
        dynamic bodyJson = json.decode(response.body);

        print('body: ${bodyJson}');
        accessToken = bodyJson['accessToken'];

        notifyListeners();
        print("Usuario logado com sucesso");
        return true;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (exception, stackTrace) {
      print('An error occurred: $exception $stackTrace');
    }
    return false;
  }
}
