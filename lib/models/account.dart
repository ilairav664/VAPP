class Account {
  final int accountId;
  final String accountName;
  final int balance;
  final String cardNumber;


  const Account({
    required this.accountId,
    required this.accountName,
    required this.balance,
    required this.cardNumber
  });

  factory Account.fromJson(Map<dynamic, dynamic> json) {
    return Account(
        accountId: json['accountId'],
        accountName: json['accountName'],
        balance: json['balance'],
        cardNumber: json['cardNumber']
    );
  }
}