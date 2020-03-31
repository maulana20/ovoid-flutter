import 'package:flutter/material.dart';

import 'login/login_page.dart';
import 'home/dashboard_page.dart';

class OvoidScreen extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Flutter Bus',
			theme: ThemeData(
				primarySwatch: Colors.blue,
			),
			home: LoginPage(),
		);
	}
}
