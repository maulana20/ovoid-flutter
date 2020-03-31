import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ovoid_flutter/ovoid_flutter.dart';

class LoginPage extends StatefulWidget {
	@override
	_LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
	OvoidFlutter ovoid = new OvoidFlutter();
	
	final mobileController = TextEditingController();
	final OTPController = TextEditingController();
	
	String refId;
	bool _obscureText = true;
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar( title: Center(child: Text('OVOID FLUTTER')), ),
			body: Container(
				color: Colors.white,
				child: ListView(
					shrinkWrap: true,
					padding: EdgeInsets.only(left: 24.0, right: 24.0),
					children: <Widget>[
						SizedBox(height: 40.0),
						Hero(
							tag: 'hero',
							child: CircleAvatar(
								backgroundColor: Colors.transparent,
								radius: 80.0,
								child: Image.asset('assets/images/bat.png'),
							),
						),
						SizedBox(height: 10.0),
						TextFormField(
							keyboardType: TextInputType.number,
							autofocus: true,
							controller: mobileController,
							decoration: InputDecoration(
								hintText: 'Masukan nomor handphone',
								labelText: 'Phone Number',
								contentPadding: EdgeInsets.all(10.0),
								border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))
							),
						),
						SizedBox(height: 15.0),
						Padding(
							padding: EdgeInsets.symmetric(vertical: 20.0),
							child: Material(
								borderRadius: BorderRadius.circular(30.0),
								shadowColor: Colors.lightBlueAccent.shade100,
								elevation: 0.0,
								child: MaterialButton(
									minWidth: 200.0,
									height: 42.0,
									onPressed: () { login2FA(context); },
									color: Colors.lightBlueAccent,
									child: Text('Masuk', style: TextStyle(color: Colors.white)),
								),
							),
						),
					],
				),
			)
		);
	}
	
	Future<void> alert(BuildContext context, String info) {
		return showDialog<void>(
			context: context,
			builder: (BuildContext context) {
				return AlertDialog(
					title: Text('Warning !'),
					content: Text(info),
					actions: <Widget>[
						FlatButton(
							child: Text('Ok'),
							onPressed: () {
							  Navigator.of(context).pop();
							},
						),
					],
				);
			},
		);
	}
	
	// STEP login2FA OVOID FLUTTER
	
	Future<String> login2FA(BuildContext context) async {
		refId = (await ovoid.login2FA(mobileController.text))['refId'];
		
		if (refId == null) {
			alert(context, 'Response refId not found !');
		} else {
			dialogOTP(context);
		}
	}
	
	Future<String> dialogOTP(BuildContext context) async {
		return showDialog<String>(
			context: context,
			barrierDismissible: false, // dialog is dismissible with a tap on the barrier
			builder: (BuildContext context) {
				return AlertDialog(
					title: Text('Masukan kode OTP'),
					content: new Row(
						children: <Widget>[
							Expanded(
								child: new TextField(
									autofocus: true,
									controller: OTPController,
									decoration: InputDecoration(labelText: 'Kode OTP', hintText: 'XXXX'),
								)
							)
						],
					),
					actions: <Widget>[
						FlatButton(
							child: Text('Proses'),
							onPressed: () { login2FAVerify(context); },
						),
					],
				);
			},
		);
	}
	
	// STEP login2FAVerify OVOID FLUTTER
	
	Future<String> login2FAVerify(BuildContext context) async {
		final accessToken = (await ovoid.login2FAVerify(refId, OTPController.text, mobileController.text))['updateAccessToken'];
		
		// PINDAH KE FORM MASUKAN PINOVO
	}
}
