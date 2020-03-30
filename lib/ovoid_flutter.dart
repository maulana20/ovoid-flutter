import 'dart:async';
import 'dart:core';

import 'package:uuid/uuid.dart';

import 'package:ovoid_flutter/http/http.dart';
import 'package:ovoid_flutter/meta/action.dart';
import 'package:ovoid_flutter/meta/action_mark.dart';
import 'package:ovoid_flutter/meta/meta.dart';

class OvoidFlutter {
	Http http = new Http();
	var uuid = Uuid();
	
	String BASE_ENDPOINT = 'https://api.ovo.id/';
	String AWS = 'https://apigw01.aws.ovo.id/';
	
	String authToken;
	
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
		int deviceUnixtime = 1543693061;
		Map<String, String> body = {
			'deviceUnixtime'	: '${deviceUnixtime}',
			'securityCode'		: PINOVO,
			'updateAccessToken'	: updateAccessToken,
			'message'			: ''
		};
		
		http.headers = headers;
		final response = await http.post(BASE_ENDPOINT + Action.loginSecurityCode, body: body);
		
		authToken = response['updateAccessToken'];
		
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
	
	Future getBudget() async {
		headers['Authorization'] = authToken;
		
		http.headers = headers;
		final response = await http.get(BASE_ENDPOINT + Action.getBudget);
		
		print(response);
		return {};
	}
	
	Future balanceModel() async {
		headers['Authorization'] = authToken;
		
		http.headers = headers;
		final response = await http.get(BASE_ENDPOINT + Action.balanceModel);
		
		print(response);
		return {};
	}
	
	Future generateTrxId(double amount, String actionMark) async {
		headers['Authorization'] = authToken;
		Map<String, String> body = {
			'actionMark'		: actionMark,
			'amount'			: '${amount}'
		};
		
		http.headers = headers;
		final response = await http.post(BASE_ENDPOINT + Action.generateTrxId, body: body);
		
		return {
			'trxId'				: response['trxId']
		};
	}
	
	Future transferOvo(String to_mobile, double amount, String message) async {
		headers['Authorization'] = authToken;
		Map<String, String> body = {
			'amount'			: '${amount}',
			'message'			: message == '' ? 'Sent from OVOID' : message,
			'to'				: to_mobile,
			'trxId'				: (await generateTrxId(amount, ActionMark.TRANSFER_OVO))['trxId']
		};
		
		http.headers = headers;
		final response = await http.post(BASE_ENDPOINT + Action.transferOvo, body: body);
		
		return {
			'code'				: response['code'],
			'message'			: response['message'],
			'isOvo'				: response['isOvo']
		};
	}
	
	Future isOVO(double totalAmount, String mobile) async {
		headers['Authorization'] = authToken;
		Map<String, String> body = {
			'totalAmount'		: '${totalAmount}',
			'mobile'			: mobile
		};
		
		http.headers = headers;
		final response = await http.post(BASE_ENDPOINT + Action.isOVO, body: body);
		
		return {
			'resp'				: response
		};
	}
	
	Future transferBank(String accountName, String accountNo, String accountNoDestination, double amount, String bankCode, String bankName, String message, String notes) async {
		headers['Authorization'] = authToken;
		Map<String, String> body = {
			'accountName'		: accountName,
			'accountNo'			: accountNo,
			'accountNoDestination': accountNoDestination,
			'amount'			: '${amount}',
			'bankCode'			: bankCode,
			'bankName'			: bankName,
			'message'			: message,
			'notes'				: notes,
			'transactionId'		: (await generateTrxId(amount, ActionMark.TRANSFER_OVO))['trxId']
		};
		
		http.headers = headers;
		final response = await http.post(BASE_ENDPOINT + Action.transferBank, body: body);
		
		return {
			'resp'				: response
		};
	}
	
	Future transferInquiry(String accountNo, double amount, String bankCode, String bankName, String message) async {
		headers['Authorization'] = authToken;
		Map<String, String> body = {
			'accountNo'			: accountNo,
			'amount'			: '${amount}',
			'bankCode'			: bankCode,
			'bankName'			: bankName,
			'message'			: message
		};
		
		http.headers = headers;
		final response = await http.post(BASE_ENDPOINT + Action.transferInquiry, body: body);
		
		return {
			'resp'				: response
		};
	}
	
	Future getRefBank() async {
		headers['Authorization'] = authToken;
		
		http.headers = headers;
		final response = await http.get(BASE_ENDPOINT + Action.getRefBank);
		
		return {
			'resp'				: response
		};
	}
	
	Future logout() async {
		headers['Authorization'] = authToken;
		
		http.headers = headers;
		final response = await http.get(BASE_ENDPOINT + Action.logout);
		
		return {};
	}
	
	Future unreadHistory() async {
		headers['Authorization'] = authToken;
		
		http.headers = headers;
		final response = await http.get(BASE_ENDPOINT + Action.unreadHistory);
		
		return {
			'total'				: response['Total']
		};
	}
	
	Future allNotification() async {
		headers['Authorization'] = authToken;
		
		http.headers = headers;
		final response = await http.get(BASE_ENDPOINT + Action.allNotification);
		
		return {
			'notifications'		: response['notifications']
		};
	}
	
	Future getWalletTransaction(int page, int limit) async {
		headers['Authorization'] = authToken;
		
		http.headers = headers;
		final response = await http.get(BASE_ENDPOINT + 'wallet/v2/transaction?page=${page}&limit=${limit}&productType=001');
		
		return {
			'status'			: response['status'],
			'data'				: response['data'],
			'message'			: response['message'],
		};
	}
	
	Future getBillers() async {
		headers['Authorization'] = authToken;
		
		http.headers = headers;
		final response = await http.get(AWS + 'gpdm/ovo/ID/v2/billpay/get-billers?categoryID=5C6');
		
		return {
			'biller_list'		: response
		};
	}
	
	Future getDenominationByProductId(String product_id) async {
		headers['Authorization'] = authToken;
		
		http.headers = headers;
		final response = await http.get(AWS + 'gpdm/ovo/ID/v1/billpay/get-denominations/${product_id}');
		
		return {
			'denominations'		: response
		};
	}
	
	Future inquiry(String billerId, String customerId, String denomId, String productId) async {
		headers['Authorization'] = authToken;
		int period = 0;
		List<String> payment_method = [ '001' ];
		Map<String, String> body = {
			'billerId'			: billerId,
			'customer_id'		: customerId,
			'denomination_id'	: denomId,
			'payment_method'	: '{payment_method}',
			'phone_number'		: customerId,
			'product_id'		: productId,
			'period'			: '${period}'
		};
		
		http.headers = headers;
		final response = await http.post(AWS + 'gpdm/ovo/ID/v1/billpay/inquiry', body: body);
		
		return {
			'response'			: response
		};
	}
	
	Future customerUnlock(String securityCode) async {
		headers['Authorization'] = authToken;
		Map<String, String> body = {
			'appVersion'		: Meta.APP_VERSION,
			'securityCode'		: securityCode
		};
		
		http.headers = headers;
		final response = await http.post(BASE_ENDPOINT + 'v1.0/api/auth/customer/unlock', body: body);
		
		return {};
	}
	
	Future pay(String billerId, String customerId, String order_id, String productId) async {
		headers['Authorization'] = authToken;
		List<String> payment_method = [ '001' ];
		Map<String, String> body = {
			'billerId'			: billerId,
			'customerId'		: customerId,
			'order_id'			: order_id,
			'payment_method'	: '{payment_method}',
			'phone_number'		: customerId,
			'product_id'		: productId
		};
		
		http.headers = headers;
		final response = await http.post(AWS + 'gpdm/ovo/ID/v1/billpay/pay', body: body);
		
		return {
			'response'			: response
		};
	}
	
	Future payCheckStatus(String orderId) async {
		headers['Authorization'] = authToken;
		Map<String, String> body = {
			'order_reference'	: orderId
		};
		
		http.headers = headers;
		final response = await http.post(AWS + 'gpdm/ovo/ID/v1/billpay/checkstatus', body: body);
		
		return {
			'PayCheckStatusResponse': response
		};
	}
}
