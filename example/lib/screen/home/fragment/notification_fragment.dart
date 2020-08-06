import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ovoid_flutter/ovoid_flutter.dart';

class NotificationFragment extends StatefulWidget {
	@override
	_NotificationFragmentState createState() => new _NotificationFragmentState();
}

class _NotificationFragmentState extends State<NotificationFragment> {
	OvoidFlutter ovoid = new OvoidFlutter();
	
	bool isError = false;
	String reason;
	
	List notifications = [];
	
	Future<String> getPreference(String index) async {
		SharedPreferences preferences = await SharedPreferences.getInstance();
		return preferences.getString(index);
	}
	
	getNotification() async {
		ovoid.authToken = await getPreference('token');
		final response = await ovoid.allNotification();
		
		if (!["", null, false, 0].contains(response['code'])) {
			setState(() => isError = true);
			setState(() => reason = !["", null, false, 0].contains(response['message']) ? response['message'] : " ");
		} else {
			setState(() => notifications = response['notifications']);
		}
	}
	
	@override
	void initState() {
		super.initState();
		getNotification();
	}
	
	@override
	Widget build(BuildContext context) {
		return isError ? errorResult() : dataResult(context);
	}
	
	Widget errorResult() {
		return Center(
			child: new Text(reason),
		);
	}
	
	Widget dataResult(BuildContext context) {
		return Container(
			color: Colors.grey[200],
			padding: EdgeInsets.all(10.0),
			child: ListView.builder(
				shrinkWrap: true,
				itemCount: notifications.length,
				itemBuilder: (context, index) {
					Map<String, dynamic> message = jsonDecode(notifications[index]['message']);
					return Card(
						child: Padding(
							padding: EdgeInsets.all(8.0),
							child: ListTile(
								title: Text(message['message'], style: TextStyle(fontSize: 14.0, )),
							)
						)
					);
				},
			),
		);
	}
}
