import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ovoid_flutter/ovoid_flutter.dart';

import '../login/login_page.dart';

import 'fragment/profile_fragment.dart';
import 'fragment/budget_fragment.dart';
import 'fragment/notification_fragment.dart';

class DashboardPage extends StatefulWidget {
	DashboardPage({ this.appTitle });
	
	String appTitle;
	
	final drawerItem = [
		new DrawerItem("Profil", Icons.person),
		new DrawerItem("Anggaran", Icons.account_balance_wallet),
		new DrawerItem("Notif", Icons.notifications_active),
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
	int totalUnread;
	
	int _selectedDrawerIndex = 0;
	
	_getDrawerItemWidget(int pos) {
		switch (pos) {
			case 0: return new ProfileFragment();
			case 1: return new BudgetFragment();
			case 2: return new NotificationFragment();
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
	
	Future getUnreadNotification() async {
		ovoid.authToken = await getPreference('token');
		return (await ovoid.unreadHistory())['total'];
	}
	
	initPreference() async {
		fullName = await getPreference('fullName');
		email = await getPreference('email');
		
		totalUnread = await getUnreadNotification();
		
		setState(() => fullName = !["", null, false, 0].contains(fullName) ? fullName : " ");
		setState(() => email = !["", null, false, 0].contains(email) ? email : " ");
		setState(() => totalUnread = !["", null, false, 0].contains(totalUnread) ? totalUnread : 0);
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
					title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [ Text(d.title), showNotif(d.title) ]),
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
	
	Widget showNotif(String title) {
		if (title == "Notif") {
			if (totalUnread > 0) {
				return Container(
					padding: EdgeInsets.all(5.0),
					decoration: BoxDecoration(
						color: Colors.grey[300],
						borderRadius: BorderRadius.circular(10.0),
					),
					child: Text("${totalUnread}", style: TextStyle(color: Colors.white, fontSize: 12.0))
				);
			} else {
				return Text("");
			}
		} else {
			return Text("");
		}
	}
	
	String getInitials(String nameString) {
		if (nameString.isEmpty) return " ";
		
		List<String> arrayValue = nameString.replaceAll(RegExp(r"\s+\b|\b\s"), " ").split(" ");
		List<String> nameArray = (arrayValue.length > 1) ? [ arrayValue[0], arrayValue[1] ] : [ arrayValue[0] ];
		
		String initials = ((nameArray[0])[0] != null ? (nameArray[0])[0] : " ") + (nameArray.length == 1 ? " " : (nameArray[nameArray.length - 1])[0]);
		
		return initials.toUpperCase();
	}
}

class DrawerItem {
	String title;
	IconData icon;
	
	DrawerItem(this.title, this.icon);
}
