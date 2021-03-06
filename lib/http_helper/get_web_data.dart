import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future getDataFromWeb({@required String url}) async {
  http.Response response = await http.get(url);
  if (response.statusCode == 200) {
    var result = await jsonDecode(response.body);

    return result;
  }
}

//String _url = "https://api.myjson.com/bins/1223hx"; // with my mobile Grameen phone no and an invalid no