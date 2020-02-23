import 'dart:collection';
import 'dart:io';
import 'package:http/http.dart';


class ApiRequests {
  Future<bool> getPrediction(String url, String base64Image) async {
    // set up POST request arguments
    String url = 'http://10.0.2.2:5000/prediction';
    Map<String, String> headers = {
      "Content-type": "application/json",
      "authorization": "secret"
    };
    String json = '{"title": "Hello", "body": "body text", "userId": 1}';


    // make POST request
    Response response = await post(url, headers: headers, body: json);
    // check the status code for the result
    int statusCode = response.statusCode;
    // this API passes back the id of the new item added to the body
    String body = response.body;

    return true;
  }
}