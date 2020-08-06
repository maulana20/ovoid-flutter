import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ovoid_flutter/ovoid_flutter.dart';

class BudgetFragment extends StatefulWidget {
	@override
	_BudgetFragmentState createState() => new _BudgetFragmentState();
}

class _BudgetFragmentState extends State<BudgetFragment> {
	OvoidFlutter ovoid = new OvoidFlutter();
	
	bool isError = false;
	String reason;
	
	List summary = [];
	Map<String, dynamic> budget = { 'amount': 0, 'spending': 0 };
	
	Future<String> getPreference(String index) async {
		SharedPreferences preferences = await SharedPreferences.getInstance();
		return preferences.getString(index);
	}
	
	getBudget() async {
		ovoid.authToken = await getPreference('token');
		final response = await ovoid.getBudget();
		
		if (!["", null, false, 0].contains(response['code'])) {
			setState(() => isError = true);
			setState(() => reason = !["", null, false, 0].contains(response['message']) ? response['message'] : " ");
		} else {
			setState(() => summary = response['summary']);
			setState(() => budget = response['budget']);
		}
	}
	
	@override
	void initState() {
		super.initState();
		getBudget();
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
			child: ListView(
				padding: EdgeInsets.zero,
				children: [
					infoBudget(),
					SizedBox(height: 5.0),
					setTitle('Ringkasan'),
					infoSummary()
				]
			),
		);
	}
	
	Widget infoBudget() {
		return Container(
			padding: EdgeInsets.all(5.0),
			color: Colors.white,
			child: Column(
				children: [
					record('Dana', double.parse('${budget['amount']}')),
					record('Pengeluaran', double.parse('${budget['spending']}')),
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
	
	Widget record(String name, double balance) {
		return Container(
			padding: EdgeInsets.all(5.0),
			child: Row(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				children: [
					Text(name, style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
					Text('${balance}', style: TextStyle(fontSize: 12.0)),
				]
			),
		);
	}
	
	Widget infoSummary() {
		return ListView.builder(
			shrinkWrap: true,
			itemCount: summary.length,
			itemBuilder: (context, index) {
				return Card(
					child: Padding(
						padding: EdgeInsets.all(5.0),
						child: Column(
							children: [
								record('Dana', double.parse('${summary[index]['amount']}')),
								record('Pengeluaran', double.parse('${summary[index]['spending']}')),
							]
						),
					),
				);
			},
		);
	}
}
