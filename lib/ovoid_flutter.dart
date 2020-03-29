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
		headers = {'app-id': Meta.APP_ID, 'App-Version': Meta.APP_VERSION };
		Map<String, String> body = {
			'deviceId'			: uuid.v1(),
			'mobile'			: mobile
		};
		
		http.headers = headers;
		final response = await http.post(BASE_ENDPOINT + Action.login2FA, body: body);
		
		return {
			'refId'				: response['refId']
		};
	}
	
	Future login2FAVerify(String refId, String OTP, String mobile) async {
		Map<String, String> body = {
			'appVersion'		: Meta.APP_VERSION,
			'deviceId'			: uuid.v1(),
			'macAddress'		: Meta.MAC_ADDRESS,
			'mobile'			: mobile,
			'osName'			: Meta.OS_NAME,
			'osVersion'			: Meta.OS_VERSION,
			'pushNotificationId': 'FCM|f4OXYs_ZhuM:APA91bGde-ie2YBhmbALKPq94WjYex8gQDU2NMwJn_w9jYZx0emAFRGKHD2NojY6yh8ykpkcciPQpS0CBma-MxTEjaet-5I3T8u_YFWiKgyWoH7pHk7MXChBCBRwGRjMKIPdi3h0p2z7',
			'refId'				: refId,
			'verificationCode'	: OTP
		};
		
		http.headers = headers;
		final response = await http.post(BASE_ENDPOINT + Action.login2FAVerify, body: body);
		
		return {
			'mobile'			: response['mobile'],
			'email'				: response['email'],
			'fullName'			: response['fullName'],
			'isEmailVerified'	: response['isEmailVerified'],
			'isSecurityCodeSet'	: response['isSecurityCodeSet'],
			'updateAccessToken'	: response['updateAccessToken']
		};
	}
	
	Future loginSecurityCode(String PINOVO, String updateAccessToken) async {
		Map<String, String> body = {
			'deviceUnixtime'	: '1543693061',
			'securityCode'		: PINOVO,
			'updateAccessToken'	: updateAccessToken,
			'message'			: ''
		};
		
		http.headers = headers;
		final response = await http.post(BASE_ENDPOINT + Action.loginSecurityCode, body: body);
		
		return {
			'token'				: response['token'],
			'tokenSeed'			: response['tokenSeed'],
			'timeStamp'			: response['timeStamp'],
			'tokenSeedExpiredAt': response['tokenSeedExpiredAt'],
			'displayMessage'	: response['displayMessage'],
			'email'				: response['email'],
			'fullName'			: response['fullName'],
			'isEmailVerified'	: response['isEmailVerified'],
			'isSecurityCodeSet'	: response['isSecurityCodeSet'],
			'updateAccessToken'	: response['updateAccessToken']
		};
	}
}
