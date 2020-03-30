class Action {
	static String login2FA = 'v2.0/api/auth/customer/login2FA';
	static String login2FAVerify = 'v2.0/api/auth/customer/login2FA/verify';
	static String loginSecurityCode = 'v2.0/api/auth/customer/loginSecurityCode/verify';
	static String getBudget = 'v1.0/budget/detail';
	static String balanceModel = 'v1.0/api/front/';
	static String logout = 'v1.0/api/auth/customer/logout';
	static String unreadHistory = 'v1.0/notification/status/count/UNREAD';
	static String getWalletTransaction = 'wallet/v2/transaction';
	static String generateTrxId = 'v1.0/api/auth/customer/genTrxId';
	static String transferOvo = 'v1.0/api/customers/transfer';
	static String isOVO = 'v1.1/api/auth/customer/isOVO';
	static String transferBank = 'transfer/direct';
	static String transferInquiry = 'transfer/inquiry';
	static String getRefBank = 'v1.0/reference/master/ref_bank';
	static String allNotification = 'v1.0/notification/status/all';
}
