import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ovoid_flutter/ovoid_flutter.dart';

import '../login/login_page.dart';

class DashboardPage extends StatefulWidget {
	DashboardPage({ this.appTitle });
	
	String appTitle;
	
	final drawerItem = [
		new DrawerItem("Profil", Icons.person),
		new DrawerItem("Dana", Icons.account_balance_wallet),
	];
	
	@override
	_DashboardPageState createState() => new _DashboardPageState(appTitle: appTitle);
}

class _DashboardPageState extends State<DashboardPage> {
	_DashboardPageState({ this.appTitle });
	
	String appTitle;
	
	OvoidFlutter ovoid = new OvoidFlutter();
	
	String fullName;
	String email;
	
	int _selectedDrawerIndex = 0;
	
	_getDrawerItemWidget(int pos) {
		switch (pos) {
			case 0: return new ProfileFragment();
			case 1: return new BalanceFragment();
			default: return new Text("Error");
		}
	}

	_onSelectItem(int index) {
		setState(() => _selectedDrawerIndex = index);
		Navigator.of(context).pop(); // close the drawer
	}
	
	Future<String> setPreference(String index, String value) async {
		SharedPreferences preferences = await SharedPreferences.getInstance();
		setState(() => preferences.setString('${index}', '${value}') );
	}
	
	Future<String> getPreference(String index) async {
		SharedPreferences preferences = await SharedPreferences.getInstance();
		return preferences.getString(index);
	}
	
	Future logout() async {
		ovoid.authToken = await getPreference('token');
		await ovoid.logout();
	}
	
	initPreference() async {
		fullName = await getPreference('fullName');
		email = await getPreference('email');
		print(fullName);
		print(email);
		setState(() => fullName = fullName);
		setState(() => email = email);
	}
	
	@override
	void initState() {
		super.initState();
		initPreference();
	}
	
	@override
	Widget build(BuildContext context) {
		var drawerOptions = <Widget>[];
		for (var i = 0; i < widget.drawerItem.length; i++) {
			var d = widget.drawerItem[i];
			drawerOptions.add(
				ListTile(
					leading: new Icon(d.icon),
					title: new Text(d.title),
					trailing: new Icon(Icons.arrow_right),
					selected: i == _selectedDrawerIndex,
					onTap: () => _onSelectItem(i),
				)
			);
		}
		drawerOptions.add(
			ListTile(
				leading: new Icon(Icons.close),
				title: new Text("Keluar"),
				// trailing: new Icon(Icons.arrow_right),
				onTap: () {
					logout();
					
					Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(appTitle: appTitle)));
				},
			)
		);
		
		return Scaffold(
			appBar: AppBar(
				title: new Text(widget.drawerItem[_selectedDrawerIndex].title),
			),
			drawer: Drawer(
				child: Column(
					children: <Widget>[
						UserAccountsDrawerHeader(
							accountName: Text(fullName),
							accountEmail: Text(email),
							currentAccountPicture: CircleAvatar(
								backgroundColor: Theme.of(context).platform == TargetPlatform.iOS ? Colors.blue : Colors.white,
								child: Text("${getInitials(fullName)}",style: TextStyle(fontSize: 40.0), ),
							),
						),
						Column(children: drawerOptions)
					]
				),
			),
			body: _getDrawerItemWidget(_selectedDrawerIndex),
		);
	}
	
	String getInitials(String nameString) {
		if (nameString.isEmpty) return " ";
		
		List<String> arrayValue = nameString.replaceAll(RegExp(r"\s+\b|\b\s"), " ").split(" ");
		List<String> nameArray = (arrayValue.length > 1) ? [ arrayValue[0], arrayValue[1] ] : [ arrayValue[0] ];
		
		String initials = ((nameArray[0])[0] != null ? (nameArray[0])[0] : " ") + (nameArray.length == 1 ? " " : (nameArray[nameArray.length - 1])[0]);
		
		return initials;
	}
}

class DrawerItem {
	String title;
	IconData icon;
	
	DrawerItem(this.title, this.icon);
}

class ProfileFragment extends StatefulWidget {
	@override
	_ProfileFragmentState createState() => new _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
	String fullName;
	String email;
	String isEmailVerified;
	String mobile;
	
	Future<String> getPreference(String index) async {
		SharedPreferences preferences = await SharedPreferences.getInstance();
		return preferences.getString(index);
	}
	
	initPreference() async {
		fullName = await getPreference('fullName');
		email = await getPreference('email');
		isEmailVerified = await getPreference('isEmailVerified');
		mobile = await getPreference('mobile');
		setState(() => fullName = fullName);
		setState(() => email = email);
		setState(() => isEmailVerified = isEmailVerified);
		setState(() => mobile = mobile);
	}
	
	@override
	void initState() {
		super.initState();
		initPreference();
	}
	
	@override
	Widget build(BuildContext context) {
		return Container(
			padding: EdgeInsets.all(5.0),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: <Widget>[
					Text("nama : ${fullName}"),
					Text("email : ${email}"),
					Text("verified : ${isEmailVerified}"),
					Text("mobile : ${mobile}"),
				]
			)
		);
	}
}

class BalanceFragment extends StatefulWidget {
	@override
	_BalanceFragmentState createState() => new _BalanceFragmentState();
}

class _BalanceFragmentState extends State<BalanceFragment> {
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
