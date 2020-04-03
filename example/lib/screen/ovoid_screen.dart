import 'package:flutter/material.dart';

import 'login/login_page.dart';
import 'home/dashboard_page.dart';

class OvoidScreen extends StatelessWidget {
	String appTitle = 'OVOID FLUTTER';
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: appTitle,
			theme: ThemeData(
				primarySwatch: Colors.blue,
			),
			home: DashboardPage(appTitle: appTitle),
		);
	}
}
