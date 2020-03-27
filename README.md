## <center>Un-Official ovoid API Wrapper for Flutter</center>
Repository berikut ini merupakan porting dari [ovoid](https://github.com/lintangtimur/ovoid/) untuk Flutter

| Method  | Result  |
|---|---|
| `login2FA`  | In Progress |
| `login2FAVerify`  | In Progress |
| `loginSecurityCode`  | In Progress  |
| `getBudget`  | In Progress  |
| `balanceModel`  | In Progress  |
| `logout`  | In Progress  |
| `unreadHistory`  | In Progress  |
| `getWalletTransaction`  | In Progress  |
| `generateTrxId`  | In Progress  |
| `transferOvo`  | In Progress  |

### Instalasi

`flutter pub get`

### Dokumentasi
```js
import 'package:ovoid_flutter/ovoid_flutter.dart';
OvoidFlutter ovoid = new OvoidFlutter();
```
#### Login
##### Langkah 1
```js
let refId = await ovoid.login2FA('nomorhandphone');
```

### Author

[Maulana Saputra](mailto:maulanasaputra11091082@gmail.com)
