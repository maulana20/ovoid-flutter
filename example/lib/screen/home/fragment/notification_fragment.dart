import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ovoid_flutter/ovoid_flutter.dart';

class NotificationFragment extends StatefulWidget {
	@override
	_NotificationFragmentState createState() => new _NotificationFragmentState();
}

class _NotificationFragmentState extends State<NotificationFragment> {
	OvoidFlutter ovoid = new OvoidFlutter();
	
	Future<String> getPreference(String index) async {
		SharedPreferences preferences = await SharedPreferences.getInstance();
		return preferences.getString(index);
	}
	
	getNotification() async {
		ovoid.authToken = await getPreference('token');
		final response = await ovoid.allNotification();
		print(response);
	}
	
	@override
	void initState() {
		super.initState();
		getNotification();
	}
	
	@override
	Widget build(BuildContext context) {
		return Center(
			child: new Text("Hello Fragment Notification"),
		);
	}
}
