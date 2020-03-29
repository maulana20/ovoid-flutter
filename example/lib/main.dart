import 'dart:async';

import 'package:ovoid_flutter/ovoid_flutter.dart';

void main() async {
	OvoidFlutter ovoid = new OvoidFlutter();
	
	final refId = await ovoid.login2FA('<mobilePhone>');
}
