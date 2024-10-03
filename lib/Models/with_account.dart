import 'wallet_account_model.dart';

class WithBankAccount {
  BankAccount? bankAccount;
  bool? isUpdated;

  WithBankAccount({
    this.bankAccount,
    required this.isUpdated,
  });
}
