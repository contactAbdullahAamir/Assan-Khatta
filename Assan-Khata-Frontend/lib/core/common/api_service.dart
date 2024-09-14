import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(url, body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
    });
    _checkResponse(response);
    return response;
  }

  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(url);
    _checkResponse(response);
    return response;
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.put(url, body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
    });
    _checkResponse(response);
    return response;
  }

  Future<http.Response> delete(String path, Map<String, dynamic> body) async {
    final url = Uri.parse('${baseUrl}${path}');

    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    ); // Log the response body

    return response;
  }

  void _checkResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final errorMessage = _extractErrorMessage(response);
      throw Exception(errorMessage);
    }
  }

  String _extractErrorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      return body['message'] ?? 'An unknown error occurred';
    } catch (_) {
      return 'An unknown error occurred';
    }
  }
}
