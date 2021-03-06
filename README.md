## <center>Un-Official ovoid API Wrapper for Flutter</center>
Repository berikut ini merupakan porting dari [ovoid](https://github.com/lintangtimur/ovoid/) untuk Flutter

| Method  | Result  |
|---|---|
| `login2FA`  | Ok |
| `login2FAVerify`  | Ok |
| `loginSecurityCode`  | Ok  |
| `getBudget`  | Ok  |
| `balanceModel`  | Ok  |
| `logout`  | Ok  |
| `unreadHistory`  | Ok  |
| `getWalletTransaction`  | In Progress  |
| `generateTrxId`  | In Progress  |
| `transferOvo`  | In Progress  |

### Ambil paket

```js
flutter pub get
```

### Jalankan pada folder example

```js
flutter run
```

### Dokumentasi
```js
import 'package:ovoid_flutter/ovoid_flutter.dart';

OvoidFlutter ovoid = new OvoidFlutter();
```
#### Login
##### Langkah 1
```js
final refId = (await ovoid.login2FA('<mobilePhone>'))['refId'];
```
##### Langkah 2
```js
final accessToken = (await ovoid.login2FAVerify(refId, '<OTP>', '<mobilePhone>'))['updateAccessToken'];
```
##### Langkah 3
```js
final token = (await ovoid.loginSecurityCode('<PINOVO>', accessToken))['token'];
```
#### Mendapatkan jumlah notifikasi yang belum terbaca
##### Mendapatkan jumlah notifikasi akun ovo anda
```js
ovoid.authToken = token;
final total = (await ovoid.unreadHistory())['total'];
```
#### Mendapatkan notifikasi
##### Mendapatkan notifikasi akun ovo anda
```js
ovoid.authToken = token;
final notifikasi = (await ovoid.allNotification())['allNotification'];
```
#### Mendapatkan balance
```js
ovoid.authToken = token;
final response = await ovoid.balanceModel();
```
#### Logout
```js
ovoid.authToken = token;
await ovoid.logout();
```
#### Contoh
##### login
- masukan nomor handphone
- dialog OTP
- dialog PIN

![login](https://github.com/maulana20/ovoid-flutter/blob/master/screen/login.jpg)
##### menu utama
![login](https://github.com/maulana20/ovoid-flutter/blob/master/screen/dashboard.jpg)
##### profil
![profile](https://github.com/maulana20/ovoid-flutter/blob/master/screen/profile.jpg)
##### anggaran
![budget](https://github.com/maulana20/ovoid-flutter/blob/master/screen/budget.jpg)
##### notifikasi
![notification](https://github.com/maulana20/ovoid-flutter/blob/master/screen/notification.jpg)

### Author

[Maulana Saputra](mailto:maulanasaputra11091082@gmail.com)
