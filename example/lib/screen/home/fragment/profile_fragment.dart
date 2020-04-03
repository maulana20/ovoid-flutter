import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ovoid_flutter/ovoid_flutter.dart';

class ProfileFragment extends StatefulWidget {
	@override
	_ProfileFragmentState createState() => new _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
	OvoidFlutter ovoid = new OvoidFlutter();
	
	Future<String> getPreference(String index) async {
		SharedPreferences preferences = await SharedPreferences.getInstance();
		return preferences.getString(index);
	}
	
	getBalance() async {
		ovoid.authToken = await getPreference('token');
		final response = await ovoid.balanceModel();
		print(response);
	}
	
	@override
	void initState() {
		super.initState();
		getBalance();
	}
	
	@override
	Widget build(BuildContext context) {
		return Center(
			child: new Text("Hello Fragment Balance"),
		);
	}
}
