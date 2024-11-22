
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService{

  Future getData(String url) async{

    final response = await http.get(Uri.parse(url));

    if(response.statusCode == 200){
       final jsonBody = jsonDecode(response.body);
       return jsonBody;
    }else{
      throw("Failed to Mandir Tabs");
    }
  }

}