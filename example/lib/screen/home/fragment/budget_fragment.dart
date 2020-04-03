import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ovoid_flutter/ovoid_flutter.dart';

class BudgetFragment extends StatefulWidget {
	@override
	_BudgetFragmentState createState() => new _BudgetFragmentState();
}

class _BudgetFragmentState extends State<BudgetFragment> {
	OvoidFlutter ovoid = new OvoidFlutter();
	
	Future<String> getPreference(String index) async {
		SharedPreferences preferences = await SharedPreferences.getInstance();
		return preferences.getString(index);
	}
	
	getBudget() async {
		ovoid.authToken = await getPreference('token');
		final response = await ovoid.getBudget();
		print(response);
	}
	
	@override
	void initState() {
		super.initState();
		getBudget();
	}
	
	@override
	Widget build(BuildContext context) {
		return Center(
			child: new Text("Hello Fragment Budget"),
		);
	}
}
