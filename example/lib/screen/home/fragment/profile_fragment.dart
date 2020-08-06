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
	
	bool isError = false;
	String reason;
	
	Map<String, dynamic> result = { 'balance' : {}, 'profile': {} };
	
	int ovo_total = 0;
	int ovocash_total = 0;
	
	String ovo_card = 'xxx';
	String ovocash_card = 'xxx';
	String handphone = 'xxx';
	String email = 'xxx';
	
	Future<String> getPreference(String index) async {
		SharedPreferences preferences = await SharedPreferences.getInstance();
		return preferences.getString(index);
	}
	
	Future<Map> setOvo(Map<String, dynamic> result) async {
		setState(() => handphone = result['profile']['telephones'][0]['number']);
		setState(() => email = result['profile']['emails'][0]['address']);
		
		setState(() => ovo_card = result['balance']['OVO']['card_no']);
		setState(() => ovocash_card = result['balance']['OVOCash']['card_no']);
		
		setState(() => ovo_total = int.parse(result['balance']['OVO']['cardBalance']));
		setState(() => ovocash_total = int.parse(result['balance']['OVOCash']['cardBalance']));
	}
	
	getBalance() async {
		ovoid.authToken = await getPreference('token');
		final response = await ovoid.balanceModel();
		
		if (!["", null, false, 0].contains(response['code'])) {
			setState(() => isError = true);
			setState(() => reason = !["", null, false, 0].contains(response['message']) ? response['message'] : " ");
		} else {
			setState(() => result = response);
			setOvo(result);
		}
	}
	
	@override
	void initState() {
		super.initState();
		getBalance();
	}
	
	@override
	Widget build(BuildContext context) {
		return isError ? errorResult() : dataResult();
	}
	
	Widget errorResult() {
		return Center(
			child: new Text(reason),
		);
	}
	
	Widget dataResult() {
		return Container(
			color: Colors.grey[200],
			padding: EdgeInsets.all(10.0),
			child: ListView(
				padding: EdgeInsets.zero,
				children: [
					infoOvo(),
					SizedBox(height: 5.0),
					setTitle('Data Pribadi'),
					infoProfile()
				]
			)
		);
	}
	
	Widget infoOvo() {
		return Container(
			padding: EdgeInsets.all(5.0),
			color: Colors.white,
			child: Column(
				children: [
					dataOvo('OVO', '${ovo_card}', double.parse('${ovo_total}')),
					dataOvo('OVO Cash', '${ovocash_card}', double.parse('${ovocash_total}')),
				]
			),
		);
	}
	
	Widget dataOvo(String type, String card, double balance) {
		return Container(
			padding: EdgeInsets.all(5.0),
			child: Row(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				children: [
					Container(
						width: 200.0,
						child: Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: [
								Text(type, style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
								Container(
									padding: EdgeInsets.all(5.0),
									decoration: BoxDecoration(
										color: Colors.grey[300],
										borderRadius: BorderRadius.circular(10.0),
									),
									child: Text(card, style: TextStyle(color: Colors.white, fontSize: 11.0)),
								),
							]
						),
					),
					Text('${balance}', style: TextStyle(fontSize: 12.0)),
				]
			),
		);
	}
	
	Widget setTitle(String title) {
		return Container(
			padding: EdgeInsets.all(5.0),
			child: Row(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				children: [
					Text(title, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
					Icon(Icons.keyboard_arrow_down)
				]
			)
		);
	}
	
	Widget infoProfile() {
		return Container(
			padding: EdgeInsets.all(5.0),
			color: Colors.white,
			child: Column(
				children: [
					record('Nama', '${result['profile']['fullName']}'),
					record('Nama Panggil', '${result['profile']['nickName']}'),
					record('OVO ID', '${result['profile']['ovoId']}'),
					record('No Handphone', handphone),
					record('Email', email),
					record('Status', '${result['profile']['state']}'),
				]
			),
		);
	}
	
	Widget record(String name, String value) {
		return Container(
			padding: EdgeInsets.all(5.0),
			child: Row(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				children: [
					Text(name, style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
					Text(value, style: TextStyle(fontSize: 12.0)),
				]
			),
		);
	}
}
