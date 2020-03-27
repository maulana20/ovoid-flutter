import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class Http {
	final JsonDecoder _decoder = new JsonDecoder();
	
	Map<String, String> headers = {};
	Map<String, dynamic> data = {};
	
	Future<Map> get(String url) async {
		headers['Content-Type'] = 'application/json';
		http.Response response = await http.get(url, headers: headers);
		
		Map<String, dynamic> result = jsonDecode(response.body);
		
		if (result['code'] == null) throw Exception('${result['message']} ${url}');
		
		data = result;
	}
	
	Future<Map> post(String url, {Map<String, String> body}) async {
		headers['Content-Type'] = 'application/json';
		http.Response response = await http.post(url, body: jsonEncode(body), headers: headers);
		
		print(response.body);
		Map<String, dynamic> result = jsonDecode(response.body);
		
		if (result['code'] == null) throw Exception('${result['message']} ${url}');
		
		return result;
	}
}
