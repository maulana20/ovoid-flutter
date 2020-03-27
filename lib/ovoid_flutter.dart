import 'dart:async';

import 'package:uuid/uuid.dart';

import 'package:ovoid_flutter/http/http.dart';
import 'package:ovoid_flutter/meta/action.dart';
import 'package:ovoid_flutter/meta/meta.dart';

class OvoidFlutter {
	Http http = new Http();
	var uuid = Uuid();
	
	String BASE_ENDPOINT = 'https://api.ovo.id/';
	Map<String, String> headers = { 'app-id': Meta.APP_ID, 'App-Version': Meta.APP_VERSION, 'OS': Meta.OS_NAME };
	
	Future login2FA(String mobile) async {
		headers = { 'app-id': Meta.APP_ID, 'App-Version': Meta.APP_VERSION };
		Map<String, String> body = { 'deviceId': uuid.v1(), 'mobile': mobile };
		print(body);
		
		http.headers = headers;
		final response = await http.post(BASE_ENDPOINT + Action.login2FA, body: body);
		
		print(response);
		return response;
	}
}
