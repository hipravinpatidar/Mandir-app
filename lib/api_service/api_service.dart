import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  Future getData(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      return jsonBody;
    } else {
      throw ("Failed to Mandir Tabs");
    }
  }

  Future<Map<String, dynamic>?> postData(String url, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        // Safely parse JSON response
        final json = jsonDecode(response.body);
        if (json is Map<String, dynamic>) {
          return json;
        } else {
          print("Unexpected response format: $json");
          return null;
        }
      } else {
        print("HTTP Error: ${response.statusCode}, Body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error in postData: $e");
      return null;
    }
  }
}
