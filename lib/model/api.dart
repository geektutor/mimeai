import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';


class ApiRequests {
  Future<Map> getPrediction(String url, String base64Image) async {
    // set up POST request arguments
//    String url = 'http://10.0.2.2:5000/prediction';
    String url = 'https://e47a9af1.ngrok.io/prediction';
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "secret"
    };//{HttpHeaders.authorizationHeader: "Basic your_api_token_here"}

    String name = url.split('/').last;
    Map data = {"image": base64Image, "name": name};


    // make POST request
    Response response = await post(url, headers: headers, body: json.encode(data));
    // check the status code for the result
    int statusCode = response.statusCode;
    // this API passes back the id of the new item added to the body
    String body = response.body;
    if(statusCode == 200) {
      var prediction = json.decode(body);
      prediction['image_path'] = url + prediction['image_path']; //add domain

      return prediction;
    }
    return {"succes": false};
  }
}