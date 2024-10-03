import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../Models/bank_branch_model.dart';
import '../Models/bank_model.dart';
import '../Models/credit_card.dart';
import '../Models/credit_status.dart';
import '../Models/dedaction_model.dart';
import '../Models/e_wallet.dart';
import '../Models/fawatrak_payment_methods.dart';
import '../Models/list_of_available_payment_gateways.dart';
import '../Models/meeza_card.dart';
import '../Models/opay_model.dart';
import '../Models/transaction.dart';
import '../Models/transaction_data.dart';
import '../Screens/fragment/credit_record/credit_deduction_request.dart';
import '../Screens/fragment/credit_record/credit_recent.dart';
import '../Screens/fragment/credit_record/credit_requests.dart';
import '../Screens/fragment/deposit_sub_widget/deposit_add_amount.dart';
import '../Screens/fragment/deposit_sub_widget/deposit_choose_payment.dart';
import '../Screens/fragment/deposit_sub_widget/deposit_done.dart';
import '../Screens/fragment/deposit_sub_widget/deposit_wallet_fawery.dart';
import '../Screens/fragment/withdrawal_record/approved_withdrawal_request.dart';
import '../Screens/fragment/withdrawal_record/declined_withdrawal_request.dart';
import '../Screens/fragment/withdrawal_record/pending_withdrawal_request.dart';
import '../Screens/fragment/withdrawal_record/transferred_withdrawal_request.dart';
import '../Screens/fragment/withdrawal_record/withdrawal_recent.dart';
import '../Screens/fragment/withdrawal_sub_widget/withdrawal_add_amount.dart';
import '../Screens/fragment/withdrawal_sub_widget/withdrawal_bank_account.dart';
import '../Screens/fragment/withdrawal_sub_widget/withdrawal_done.dart';
import '../Screens/fragment/withdrawal_sub_widget/withdrawal_e_wallet.dart';
import '../Screens/fragment/withdrawal_sub_widget/withdrawal_meza_card.dart';
import '../Screens/fragment/withdrawal_sub_widget/withdrawal_payment.dart';
import '../Utilits/constants.dart';
import '../Widgets/wallet_deposit.dart';
import '../Widgets/wallet_home.dart';
import '../Widgets/wallet_withdrawal.dart';
import '../core/httpHelper/http_helper.dart';
import '../core/networking/api_constants.dart';

class WalletProvider with ChangeNotifier {
  int _mainIndex = 0;
  int _depositIndex = 0;
  int _withdrawalIndex = 0;
  int _creditMainIndex = 0;
  int _withdrawMainIndex = 0;
  Widget _mainWidget = const WalletHome();
  Widget _depositWidget = const DepositAddAmount();
  Widget _withdrawalWidget = const WithdrawalAddAmount();
  Widget _creditMainWidget = const CreditRequests();
  Widget _withdrawMainWidget = const PendingWithdrawalRequests();
  int? _withdrawalAmount;
  int? _depositAmount;
  int? agreedAmount;
  ListOfAvailablePaymentGateways? _item;
  int? _accountWithdrawalTypeIndex;
  NetworkState? _state;
  NetworkState? _creditState;
  NetworkState? _paymentState;
  NetworkState? _pendingWithdrawState;
  NetworkState? _approvedWithdrawState;
  NetworkState? _declinedWithdrawState;
  NetworkState? _transferredWithdrawState;
  NetworkState? _listOfAvailablePaymentGatewaysState;
  int _pendingWithdrawPage = 1;
  int _approvedWithdrawPage = 1;
  int _declinedWithdrawPage = 1;
  int _transferredWithdrawPage = 1;
  int _creditDeductionPage = 1;
  int? _pendingWithdrawLastPage;
  int? _approvedWithdrawLastPage;
  int? _creditDeductionLastPage;
  int? _declinedWithdrawLastPage;
  int? _transferredWithdrawLastPage;
  bool _pendingWithdrawPaging = false;
  bool _approvedWithdrawPaging = false;
  bool _declinedWithdrawPaging = false;
  bool fromOfferPage = false;
  bool _transferredWithdrawPaging = false;
  bool _pendingWithdrawEmpty = false;
  bool _approvedWithdrawEmpty = false;
  bool _declinedWithdrawEmpty = false;
  bool _transferredWithdrawEmpty = false;
  String? creditDateFrom;
  String? creditDateTo;
  String? paymentDateFrom;
  String? paymentDateTo;
  String? creditDeductionDateFrom;
  String? creditDeductionDateTo;
  String? approvedWithdrawDateFrom;
  String? approvedWithdrawDateTo;
  String? pendingWithdrawDateFrom;
  String? pendingWithdrawDateTo;
  String? declinedWithdrawDateFrom;
  String? declinedWithdrawDateTo;
  String? transferredWithdrawDateFrom;
  String? transferredWithdrawDateTo;
  List<TransactionData> _pendingWithdrawList = [];
  List<TransactionData> _approvedWithdrawList = [];
  List<TransactionData> _declinedWithdrawList = [];
  List<TransactionData> _transferredWithdrawList = [];
  List<Data> _creditDeductionList = [];
  String? _currentBalance;
  bool _loading = false;
  final int _paymentPage = 1;
  int? _creditPage = 1;
  int? _paymentLastPage;
  int? _creditLastPage;
  CreditCard? _creditCard;
  OpayModel? _opayModel;

  CreditStatus? _creditStatus;
  NetworkState? _creditDeductionState;
  MeezaCard? _meezaCard;
  EWallet? _eWallet;
  final List<TransactionData> _paymentTransactionList = [];
  List<TransactionData> _creditTransactionList = [];
  bool _creditPaging = false;
  final bool _paymentPaging = false;
  final bool _paymentListEmpty = false;
  bool _creditDeductionPaging = false;
  bool _creditDeductionListEmpty = false;

  bool _creditListEmpty = false;

  int? get withdrawalAmount => _withdrawalAmount;
  String? errorMessage;

  void setWithdrawalAmount(int? value) {
    _withdrawalAmount = value;
  }

  int? get depositAmount => _depositAmount;

  void setDepositAmount(int? value) {
    _depositAmount = value;
  }

  Widget get depositWidget => _depositWidget;

  void setAccountTypeIndex(ListOfAvailablePaymentGateways? item) {
    _item = item;
  }

  void setWithdrawalAccountTypeIndex(int i) {
    _accountWithdrawalTypeIndex = i;
  }

  int? get accountWithdrawalTypeIndex => _accountWithdrawalTypeIndex;

  bool get loading => _loading;

  void setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  List<ListOfAvailablePaymentGateways>? _listOfAvailablePaymentGateways;
  List<FawatrakPaymentMethodsModel>? fawatrakAvailablePaymentGateways;

  List<ListOfAvailablePaymentGateways>? get listOfAvailablePaymentGateways =>
      _listOfAvailablePaymentGateways;

  NetworkState? get listOfAvailablePaymentGatewaysState =>
      _listOfAvailablePaymentGatewaysState;

  String? get currentBalance => _currentBalance;

  NetworkState? get state => _state;

  ListOfAvailablePaymentGateways? get item => _item;

  void setDepositIndex(int i) {
    _depositIndex = i;
    getCurrentDepositWidget();
    notifyListeners();
  }

  int? paymentId;

  void setPaymentId(int value) {
    paymentId = value;
  }

  void setWithdrawalIndex(int i) {
    _withdrawalIndex = i;
    getCurrentWithdrawalWidget();
    notifyListeners();
  }

  int get depositIndex => _depositIndex;

  void setCreditMainIndex(int i) {
    _creditMainIndex = i;
    getCreditCurrentWidget();
    notifyListeners();
  }

  int get withdrawMainIndex => _withdrawMainIndex;

  int get creditMainIndex => _creditMainIndex;

  int get pendingWithdrawPage => _pendingWithdrawPage;

  void getCreditCurrentWidget() {
    switch (_creditMainIndex) {
      case 0:
        _creditMainWidget = const CreditRequests();
        break;
      case 1:
        _creditMainWidget = const DeductionRequest();
        break;
    }
  }

  Future<void> creditDeductionListOfTransaction({
    required bool paging,
    required bool refreshing,
    required bool isFilter,
  }) async {
    try {
      if (!paging && !refreshing) {
        _creditDeductionList = [];
        _creditDeductionState = NetworkState.waiting;
        _creditDeductionPage = 1;
      }
      if (isFilter) {
        _creditDeductionState = NetworkState.waiting;
        notifyListeners();
      }
      Response r = await HttpHelper.instance.httpGet(
        'wallet/transactions?type=debit&${creditDeductionDateFrom != null ? 'created_at_from=$creditDeductionDateFrom&' : ''}${creditDeductionDateTo != null ? 'created_at_to=$creditDeductionDateFrom&' : ''}page=$_creditDeductionPage',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        DeductionModel transaction =
            DeductionModel.fromJson(jsonDecode(r.body));
        _creditDeductionList.addAll(transaction.data!);
        _creditDeductionLastPage = transaction.lastPage;
        _creditDeductionListEmpty = _creditDeductionList.isEmpty;
        _creditDeductionState = NetworkState.success;
      } else {
        _creditDeductionState = NetworkState.error;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
    }
    notifyListeners();
  }

  Widget get creditMainWidget => _creditMainWidget;

  Widget get withdrawMainWidget => _withdrawMainWidget;

  void setWithdrawMainIndex(int i) {
    _withdrawMainIndex = i;
    getWithdrawCurrentWidget();
    notifyListeners();
  }

  void getWithdrawCurrentWidget() {
    switch (_withdrawMainIndex) {
      case 0:
        _withdrawMainWidget = const PendingWithdrawalRequests();
        break;
      case 1:
        _withdrawMainWidget = const ApprovedWithdrawalRequests();
        break;
      case 2:
        _withdrawMainWidget = const TransferredWithdrawalRequests();
        break;
      case 3:
        _withdrawMainWidget = const DeclinedWithdrawalRequests();
    }
  }

  void setMainIndex(int i) {
    _mainIndex = i;
    getCurrentWidget();
    notifyListeners();
  }

  void getCurrentWidget() {
    switch (_mainIndex) {
      case 0:
        _mainWidget = const WalletHome();
        break;
      case 1:
        _mainWidget = const WalletDeposit();
        break;
      case 2:
        _mainWidget = const WalletWithdrawal();
        break;
      case 3:
        _mainWidget = const WalletCreditRecord();
        break;
      case 4:
        _mainWidget = const WalletWithdrawalRecord();
    }
  }

  void getCurrentDepositWidget() {
    switch (_depositIndex) {
      case 0:
        _depositWidget = const DepositAddAmount();
        break;
      case 1:
        _depositWidget = const DepositChoosePayment();
        break;
      case 2:
        _depositWidget = const DepositWaletFaweryPayment();
        break;
      case 3:
        _depositWidget = const DepositDone();
        break;
      // case 6:
      // _depositWidget = DepositOpay();
      // break;
    }
  }

  void getCurrentWithdrawalWidget() {
    switch (_withdrawalIndex) {
      case 0:
        _withdrawalWidget = const WithdrawalAddAmount();
        break;
      case 1:
        _withdrawalWidget = const WithdrawPayment();
        break;
      case 2:
        _withdrawalWidget = const WithdrawalBankAccount();
        break;
      case 3:
        _withdrawalWidget = const WithdrawEWallet();
        break;
      case 4:
        _withdrawalWidget = const WithdrawalMezaCard();
        break;
      case 5:
        _withdrawalWidget = const WithdrawalDone();
        break;
    }
  }

  Future<void> addCreditWithMeeza({
    double? amount,
    String? method,
    required String pan,
    required String expirationDate,
    required String cvv,
  }) async {
    try {
      _state = NetworkState.waiting;
      notifyListeners();
      Response r = await HttpHelper.instance.httpPost(
        'wallet/transactions/credit',
        true,
        body: {
          'amount': amount,
          'method': method,
          'PAN': pan,
          'DateExpiration': expirationDate,
          'cvv2': cvv,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _meezaCard = MeezaCard.fromJson(json.decode(r.body));
        log('meezaCard -> ${_meezaCard?.transaction?.id}');
        log('meezaCard -> ${_meezaCard?.transaction?.details?.transactionId}');
        _state = NetworkState.success;
      } else {
        _state = NetworkState.error;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
    }
    notifyListeners();
  }

  Future<void> addCreditWithCreditCard({
    double? amount,
    String? method,
  }) async {
    try {
      _state = NetworkState.waiting;
      notifyListeners();
      Response r = await HttpHelper.instance.httpPost(
        'wallet/transactions/credit',
        true,
        body: {
          'amount': amount,
          'method': method,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _creditCard = CreditCard.fromJson(json.decode(r.body));
        _state = NetworkState.success;
      } else {
        _state = NetworkState.error;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
    }
    notifyListeners();
  }

  dynamic initPaymentModel;
  int? initPaymentId;

  Future<void> initPayment({
    num? amount,
    int? paymentId,
    String? phone,
  }) async {
    initPaymentId = paymentId;
    try {
      _state = NetworkState.waiting;
      notifyListeners();
      Response r = await HttpHelper.instance.httpPost(
        'wallet/transactions/credit/fawaterak/initiate-payment?payment_method_id=$paymentId&amount=$amount${phone != null ? '&phone=$phone' : ''}',
        true,
      );
      log(r.body);
      log('${r.statusCode}');
      log('${r.request?.url}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        initPaymentModel = json.decode(r.body);
        _state = NetworkState.success;
      } else {
        _state = NetworkState.error;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
    }
    notifyListeners();
  }

  Future<void> bankAccountWithdrawal({
    required double amount,
    required String bankId,
    required String branchId,
    required String ownerName,
    required String accountNumber,
    required String accountIban,
  }) async {
    try {
      _state = NetworkState.waiting;
      Response r = await HttpHelper.instance.httpPost(
        'wallet/transactions/withdraw',
        true,
        body: {
          "cashout_type": "bank",
          "title": "bank title",
          "payload": {"reference": "1212"},
          "amount": amount,
          "bank_data": {
            "bank_id": bankId,
            "bank_branch_id": branchId,
            "account_owner": ownerName,
            "account_number": accountNumber,
            "account_iban": accountIban
          }
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _state = NetworkState.success;
      } else {
        errorMessage = json.decode(r.body)['message'];
        _state = NetworkState.error;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
    }
    notifyListeners();
  }

  Future<void> walletWithdrawal(
      {required double amount,
      required String walletOwner,
      required String walletNumber}) async {
    try {
      _state = NetworkState.waiting;
      Response r = await HttpHelper.instance.httpPost(
        'wallet/transactions/withdraw',
        true,
        body: {
          "cashout_type": "wallet",
          "title": "wallet title",
          "payload": {
            "reference": "1212",
          },
          "amount": amount,
          "wallet_data": {
            "wallet_owner": walletOwner,
            "wallet_number": walletNumber
          }
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _state = NetworkState.success;
      } else {
        errorMessage = json.decode(r.body)['message'];
        _state = NetworkState.error;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
    }
    notifyListeners();
  }

  List<BankModel>? banks;
  List<BankBranchModel>? branches;

  Future<void> banksApi() async {
    try {
      Response r = await HttpHelper.instance.httpGet(
        '${ApiConstants.baseUrl}/api/v1/fawaterak/banks',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        banks = (json.decode(r.body) as List)
            .map((e) => BankModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      log('error -> ${e.toString()}');
    }
    notifyListeners();
  }

  Future<void> branchesApi(int id) async {
    try {
      Response r = await HttpHelper.instance.httpGet(
        '${ApiConstants.baseUrl}/api/v1/fawaterak/bank/branches?bank_id=$id',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        branches = (json.decode(r.body) as List)
            .map((e) => BankBranchModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      log('error -> ${e.toString()}');
    }
    notifyListeners();
  }

  Future<void> mezaWithdrawal(
      {required double amount,
      required String cardOwner,
      required String cardNumber}) async {
    try {
      _state = NetworkState.waiting;
      Response r = await HttpHelper.instance.httpPost(
        'wallet/transactions/withdraw',
        true,
        body: {
          "cashout_type": "meeza",
          "title": "meeza title",
          "payload": {
            "reference": "1212",
          },
          "amount": 21,
          "meeza_data": {
            "card_owner": cardOwner,
            "card_number": num.parse(cardNumber).toInt(),
          }
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _state = NetworkState.success;
      } else {
        errorMessage = json.decode(r.body)['message'];
        _state = NetworkState.error;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
    }
    notifyListeners();
  }

  Future<void> getCurrentPaymentGateway() async {
    try {
      _state = NetworkState.waiting;
      notifyListeners();
      Response r = await HttpHelper.instance.httpGet(
        'wallet/transactions/credit',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _state = NetworkState.success;
      } else {
        _state = NetworkState.error;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
    }
    notifyListeners();
  }

  Future<void> addCreditWithOpay({
    double? amount,
    String? method,
    required String paymentGetWay,
  }) async {
    try {
      _state = NetworkState.waiting;
      notifyListeners();
      Response r = await HttpHelper.instance.httpPost(
        'wallet/transactions/credit',
        true,
        body: {
          'amount': amount,
          'method': method,
          'payment-gateway-handler': paymentGetWay,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _opayModel = OpayModel.fromJson(json.decode(r.body));
        _state = NetworkState.success;
      } else {
        _state = NetworkState.error;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
    }
    notifyListeners();
  }

  Future<void> addCreditWithEWallet({
    double? amount,
    String? method,
    String? mobileNumber,
  }) async {
    try {
      _state = NetworkState.waiting;
      notifyListeners();
      Response r = await HttpHelper.instance.httpPost(
        'wallet/transactions/credit',
        true,
        body: {
          'amount': amount,
          'method': method,
          'MobileNumber': mobileNumber,
        },
      );
      log('addCredit with wallet -> ${r.body}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _eWallet = EWallet.fromJson(json.decode(r.body));
        _state = NetworkState.success;
      } else {
        _state = NetworkState.error;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
    }
    notifyListeners();
  }

  Future<void> withdraw({
    double? amount,
    String? method,
    String? authorization,
  }) async {
    try {
      _state = NetworkState.waiting;
      Response r = await HttpHelper.instance.httpPost(
        'wallet/transactions/withdraw',
        true,
        body: {
          'amount': amount,
          'method': method,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _state = NetworkState.success;
      } else {
        _state = NetworkState.error;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
      _state = NetworkState.error;
    }
    notifyListeners();
  }

  List<TransactionData> get creditTransactionList => _creditTransactionList;

  void nextCreditPage({required String authorization}) async {
    if (_creditPage! < _creditLastPage!) {
      _creditPaging = true;
      notifyListeners();
      _creditPage = _creditPage! + 1;
      await creditListOfTransaction(
        authorization: authorization,
        paging: true,
        refreshing: false,
        isFilter: false,
      );
      _creditPaging = false;
      notifyListeners();
    }
  }

  Future<void> clearCreditList(String authorization) async {
    creditDateFrom = null;
    creditDateTo = null;
    _creditTransactionList.clear();
    notifyListeners();
    _creditPage = 1;
    await creditListOfTransaction(
      authorization: authorization,
      paging: false,
      refreshing: true,
      isFilter: false,
    );
  }

  NetworkState? get creditState => _creditState;

  resetCreditFilter() {
    creditDateFrom = null;
    creditDateTo = null;
  }

  resetPaymentFilter() {
    paymentDateFrom = null;
    paymentDateTo = null;
  }

  resetApprovedWithdrawFilter() {
    approvedWithdrawDateFrom = null;
    approvedWithdrawDateTo = null;
  }

  resetPendingWithdrawFilter() {
    pendingWithdrawDateFrom = null;
    pendingWithdrawDateTo = null;
  }

  resetDeclinedWithdrawFilter() {
    declinedWithdrawDateFrom = null;
    declinedWithdrawDateTo = null;
  }

  resetTransferredWithdrawFilter() {
    transferredWithdrawDateFrom = null;
    transferredWithdrawDateTo = null;
  }

  Future<void> creditListOfTransaction({
    String? authorization,
    required bool paging,
    required bool refreshing,
    required bool isFilter,
  }) async {
    try {
      if (!paging && !refreshing) {
        _creditTransactionList = [];
        _creditState = NetworkState.waiting;
        _creditPage = 1;
      }
      if (isFilter) {
        _creditState = NetworkState.waiting;
        notifyListeners();
      }
      Response r = await HttpHelper.instance.httpGet(
        'wallet/transactions?type=credit&${creditDateFrom != null ? 'created_at_from=$creditDateFrom&' : ''}${creditDateTo != null ? 'created_at_to=$creditDateTo&' : ''}page=$_creditPage&status=approved',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        Transaction transaction = Transaction.fromJson(jsonDecode(r.body));
        _creditTransactionList.addAll(transaction.data!);
        _creditLastPage = transaction.lastPage;
        _creditListEmpty = _creditTransactionList.isEmpty;
        log('_creditTransactionList -> ${_creditTransactionList.length}');
        log('_creditTransactionList -> $_creditPage');
        _creditState = NetworkState.success;
      } else {
        _creditState = NetworkState.error;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
      _creditState = NetworkState.error;
    }
    notifyListeners();
  }

  double getTotalResultFromOfferPage() {
    double totalResult = depositAmount!.toDouble();
    return totalResult;
  }

  double getTotalCommision() {
    double totalResult =
        ((depositAmount!.toDouble() * item!.depositionBankChargeValue! / 100) +
            item!.depositionAlwaysAppliedFixedBankChargeAmount!);

    return totalResult;
  }

  Future<void> getCurrentBalance({
    String? authorization,
    required bool fromRefresh,
  }) async {
    _currentBalance = '0.0';
    try {
      _state = NetworkState.waiting;
      if (fromRefresh) {
        notifyListeners();
      }
      Response r = await HttpHelper.instance.httpGet(
        'wallet/balance',
        true,
      );
      log('getCurrentBalanceStatusCode -> ${r.statusCode}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _currentBalance = json.decode(r.body).toString();
        _state = NetworkState.success;
      } else {
        _state = NetworkState.error;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
      _state = NetworkState.error;
    }
    notifyListeners();
  }

  int get withdrawalIndex => _withdrawalIndex;

  Widget get withdrawalWidget => _withdrawalWidget;

  Widget get mainWidget => _mainWidget;

  int get mainIndex => _mainIndex;

  bool get creditPaging => _creditPaging;

  List<TransactionData> get paymentTransactionList => _paymentTransactionList;

  bool get paymentPaging => _paymentPaging;

  bool get paymentListEmpty => _paymentListEmpty;

  bool get creditListEmpty => _creditListEmpty;

  NetworkState? get paymentState => _paymentState;

  Future<void> approvedWithdrawTransactions({
    String? authorization,
    required bool paging,
    required bool refreshing,
    required bool isFilter,
  }) async {
    try {
      if (!paging && !refreshing) {
        _approvedWithdrawList = [];
        _approvedWithdrawState = NetworkState.waiting;
        _approvedWithdrawPage = 1;
      }
      if (isFilter) {
        _approvedWithdrawState = NetworkState.waiting;
        notifyListeners();
      }
      Response r = await HttpHelper.instance.httpGet(
        'wallet/transactions?type=debitWithdraw&status=approved&${approvedWithdrawDateFrom != null ? 'created_at_from=$approvedWithdrawDateFrom&' : ''}${approvedWithdrawDateTo != null ? 'created_at_to=$approvedWithdrawDateTo&' : ''}page=$_approvedWithdrawPage',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        Transaction transaction = Transaction.fromJson(jsonDecode(r.body));
        _approvedWithdrawList.addAll(transaction.data!);
        _approvedWithdrawLastPage = transaction.lastPage;
        _approvedWithdrawEmpty = _approvedWithdrawList.isEmpty;
        _approvedWithdrawState = NetworkState.success;
      } else {
        _approvedWithdrawState = NetworkState.error;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
      _approvedWithdrawState = NetworkState.error;
    }
    notifyListeners();
  }

  Future<void> pendingWithdrawTransactions({
    String? authorization,
    required bool paging,
    required bool refreshing,
    required bool isFilter,
  }) async {
    try {
      if (!paging && !refreshing) {
        _pendingWithdrawList = [];
        _pendingWithdrawState = NetworkState.waiting;
        _pendingWithdrawPage = 1;
      }
      if (isFilter) {
        _pendingWithdrawState = NetworkState.waiting;
        notifyListeners();
      }
      Response r = await HttpHelper.instance.httpGet(
        'wallet/transactions?type=debitWithdraw&status=pending&${pendingWithdrawDateFrom != null ? 'created_at_from=$pendingWithdrawDateFrom&' : ''}${pendingWithdrawDateTo != null ? 'created_at_to=$pendingWithdrawDateTo&' : ''}page=$_pendingWithdrawPage',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        Transaction transaction = Transaction.fromJson(jsonDecode(r.body));
        _pendingWithdrawList.addAll(transaction.data!);
        _pendingWithdrawLastPage = transaction.lastPage;
        _pendingWithdrawEmpty = _pendingWithdrawList.isEmpty;
        _pendingWithdrawState = NetworkState.success;
      } else {
        _pendingWithdrawState = NetworkState.error;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
      _pendingWithdrawState = NetworkState.error;
    }
    notifyListeners();
  }

  CreditCard? get creditCard => _creditCard;

  OpayModel? get opayModel => _opayModel;

  Future<void> declinedWithdrawTransactions({
    String? authorization,
    required bool paging,
    required bool refreshing,
    required bool isFilter,
  }) async {
    try {
      if (!paging && !refreshing) {
        _declinedWithdrawList = [];
        _declinedWithdrawState = NetworkState.waiting;
        _declinedWithdrawPage = 1;
      }
      if (isFilter) {
        _declinedWithdrawState = NetworkState.waiting;
        notifyListeners();
      }
      Response r = await HttpHelper.instance.httpGet(
        'wallet/transactions?type=debitWithdraw&status=declined&${declinedWithdrawDateFrom != null ? 'created_at_from=$declinedWithdrawDateFrom&' : ''}${declinedWithdrawDateTo != null ? 'created_at_to=$declinedWithdrawDateTo&' : ''}page=$_declinedWithdrawPage',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        Transaction transaction = Transaction.fromJson(jsonDecode(r.body));
        _declinedWithdrawList.addAll(transaction.data!);
        _declinedWithdrawLastPage = transaction.lastPage;
        _declinedWithdrawEmpty = _declinedWithdrawList.isEmpty;
        _declinedWithdrawState = NetworkState.success;
      } else {
        _declinedWithdrawState = NetworkState.error;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
      _declinedWithdrawState = NetworkState.error;
    }
    notifyListeners();
  }

  Future<void> transferredWithdrawTransactions({
    String? authorization,
    required bool paging,
    required bool refreshing,
    required bool isFilter,
  }) async {
    try {
      if (!paging && !refreshing) {
        _transferredWithdrawList = [];
        _transferredWithdrawState = NetworkState.waiting;
        _transferredWithdrawPage = 1;
      }
      if (isFilter) {
        _transferredWithdrawState = NetworkState.waiting;
        notifyListeners();
      }
      Response r = await HttpHelper.instance.httpGet(
        'wallet/transactions?type=debitWithdraw&status=transferred&${transferredWithdrawDateFrom != null ? 'created_at_from=$transferredWithdrawDateFrom&' : ''}${transferredWithdrawDateTo != null ? 'created_at_to=$transferredWithdrawDateTo&' : ''}page=$_transferredWithdrawPage',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        Transaction transaction = Transaction.fromJson(jsonDecode(r.body));
        _transferredWithdrawList.addAll(transaction.data!);
        _transferredWithdrawLastPage = transaction.lastPage;
        _transferredWithdrawEmpty = _transferredWithdrawList.isEmpty;
        _transferredWithdrawState = NetworkState.success;
      } else {
        _transferredWithdrawState = NetworkState.error;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
      _transferredWithdrawState = NetworkState.error;
    }
    notifyListeners();
  }

  Future<void> clearApprovedWithdrawList(String authorization) async {
    approvedWithdrawDateFrom = null;
    approvedWithdrawDateTo = null;
    _approvedWithdrawList.clear();
    notifyListeners();
    _approvedWithdrawPage = 1;
    await approvedWithdrawTransactions(
      authorization: authorization,
      paging: false,
      refreshing: true,
      isFilter: false,
    );
  }

  Future<void> clearPendingWithdrawList(String authorization) async {
    pendingWithdrawDateFrom = null;
    pendingWithdrawDateTo = null;
    _pendingWithdrawList.clear();
    notifyListeners();
    _pendingWithdrawPage = 1;
    await pendingWithdrawTransactions(
      authorization: authorization,
      paging: false,
      refreshing: true,
      isFilter: false,
    );
  }

  Future<void> clearDeclinedWithdrawList(String authorization) async {
    declinedWithdrawDateFrom = null;
    declinedWithdrawDateTo = null;
    _declinedWithdrawList.clear();
    notifyListeners();
    _declinedWithdrawPage = 1;
    await declinedWithdrawTransactions(
      authorization: authorization,
      paging: false,
      refreshing: true,
      isFilter: false,
    );
  }

  Future<void> clearTransferredWithdrawList(String authorization) async {
    transferredWithdrawDateFrom = null;
    transferredWithdrawDateTo = null;
    _transferredWithdrawList.clear();
    notifyListeners();
    _transferredWithdrawPage = 1;
    await transferredWithdrawTransactions(
      authorization: authorization,
      paging: false,
      refreshing: true,
      isFilter: false,
    );
  }

// type (oPay or BankMasr)
  Future<void> weevoListOfAvailablePaymentGateways() async {
    _listOfAvailablePaymentGatewaysState = NetworkState.waiting;
    try {
      Response r = await HttpHelper.instance.httpGet(
        'list-of-available-payment-gateways',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _listOfAvailablePaymentGateways = (json.decode(r.body) as List)
            .map((e) => ListOfAvailablePaymentGateways.fromJson(e))
            .toList();
        _listOfAvailablePaymentGatewaysState = NetworkState.success;
      } else {
        _listOfAvailablePaymentGatewaysState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }

    notifyListeners();
  }

  Future<void> getFawatrakAvailablePaymentGateways() async {
    _listOfAvailablePaymentGatewaysState = NetworkState.waiting;
    try {
      Response r = await HttpHelper.instance.httpGet(
        '${ApiConstants.baseUrl}/api/v1/fawaterak/payment-methods',
        false,
        hasBase: false,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        fawatrakAvailablePaymentGateways = (json.decode(r.body) as List)
            .map((e) => FawatrakPaymentMethodsModel.fromJson(e))
            .toList();
        _listOfAvailablePaymentGatewaysState = NetworkState.success;
      } else {
        _listOfAvailablePaymentGatewaysState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  void nextApprovedWithdrawPage({required String authorization}) async {
    if (_approvedWithdrawPage < _approvedWithdrawLastPage!) {
      _approvedWithdrawPaging = true;
      notifyListeners();
      _approvedWithdrawPage++;
      await approvedWithdrawTransactions(
        authorization: authorization,
        paging: true,
        refreshing: false,
        isFilter: false,
      );
      _approvedWithdrawPaging = false;
      notifyListeners();
    }
  }

  void nextPendingWithdrawPage({required String authorization}) async {
    if (_pendingWithdrawPage < _pendingWithdrawLastPage!) {
      _pendingWithdrawPaging = true;
      notifyListeners();
      _pendingWithdrawPage++;
      await pendingWithdrawTransactions(
        authorization: authorization,
        paging: true,
        refreshing: false,
        isFilter: false,
      );
      _pendingWithdrawPaging = false;
      notifyListeners();
    }
  }

  void nextDeclinedWithdrawPage({required String authorization}) async {
    if (_declinedWithdrawPage < _declinedWithdrawLastPage!) {
      _declinedWithdrawPaging = true;
      notifyListeners();
      _declinedWithdrawPage++;
      await declinedWithdrawTransactions(
        authorization: authorization,
        paging: true,
        refreshing: false,
        isFilter: false,
      );
      _declinedWithdrawPaging = false;
      notifyListeners();
    }
  }

  void nextTransferredWithdrawPage({required String authorization}) async {
    if (_transferredWithdrawPage < _transferredWithdrawLastPage!) {
      _transferredWithdrawPaging = true;
      notifyListeners();
      _transferredWithdrawPage++;
      await transferredWithdrawTransactions(
        authorization: authorization,
        paging: true,
        refreshing: false,
        isFilter: false,
      );
      _transferredWithdrawPaging = false;
      notifyListeners();
    }
  }

  Future<void> checkPaymentStatus({
    required String systemReferenceNumber,
    required int transactionId,
  }) async {
    try {
      _state = NetworkState.waiting;
      Response r = await HttpHelper.instance.httpPost(
        'wallet/transactions/credit/check-upg-transaction-status',
        true,
        body: {
          'SystemReference': systemReferenceNumber,
          'transaction_id': transactionId,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _creditStatus = CreditStatus.fromJson(json.decode(r.body));
        _state = NetworkState.success;
      } else {
        _state = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> clearCreditDeductionList() async {
    creditDeductionDateFrom = null;
    creditDeductionDateTo = null;
    _creditDeductionList.clear();
    notifyListeners();
    _creditDeductionPage = 1;
    await creditDeductionListOfTransaction(
      paging: false,
      refreshing: true,
      isFilter: false,
    );
  }

  void nextCreditDeductionPage() async {
    if (_creditDeductionPage < _creditDeductionLastPage!) {
      _creditDeductionPaging = true;
      notifyListeners();
      _creditDeductionPage++;
      await creditDeductionListOfTransaction(
        paging: true,
        refreshing: false,
        isFilter: false,
      );
      _creditDeductionPaging = false;
      notifyListeners();
    }
  }

  List<TransactionData> get transferredWithdrawList => _transferredWithdrawList;

  List<TransactionData> get declinedWithdrawList => _declinedWithdrawList;

  List<TransactionData> get approvedWithdrawList => _approvedWithdrawList;

  List<TransactionData> get pendingWithdrawList => _pendingWithdrawList;

  bool get declinedWithdrawEmpty => _declinedWithdrawEmpty;

  bool get approvedWithdrawEmpty => _approvedWithdrawEmpty;

  bool get pendingWithdrawEmpty => _pendingWithdrawEmpty;

  bool get transferredWithdrawEmpty => _transferredWithdrawEmpty;

  bool get transferredWithdrawPaging => _transferredWithdrawPaging;

  bool get declinedWithdrawPaging => _declinedWithdrawPaging;

  bool get approvedWithdrawPaging => _approvedWithdrawPaging;

  bool get pendingWithdrawPaging => _pendingWithdrawPaging;

  CreditStatus? get creditStatus => _creditStatus;

  NetworkState? get transferredWithdrawState => _transferredWithdrawState;

  NetworkState? get declinedWithdrawState => _declinedWithdrawState;

  NetworkState? get approvedWithdrawState => _approvedWithdrawState;

  NetworkState? get pendingWithdrawState => _pendingWithdrawState;

  MeezaCard? get meezaCard => _meezaCard;

  EWallet? get eWallet => _eWallet;

  int get approvedWithdrawPage => _approvedWithdrawPage;

  int get declinedWithdrawPage => _declinedWithdrawPage;

  int get transferredWithdrawPage => _transferredWithdrawPage;

  int get creditDeductionPage => _creditDeductionPage;

  int? get pendingWithdrawLastPage => _pendingWithdrawLastPage;

  int? get approvedWithdrawLastPage => _approvedWithdrawLastPage;

  int? get creditDeductionLastPage => _creditDeductionLastPage;

  int? get declinedWithdrawLastPage => _declinedWithdrawLastPage;

  int? get transferredWithdrawLastPage => _transferredWithdrawLastPage;

  List<Data> get creditDeductionList => _creditDeductionList;

  int get paymentPage => _paymentPage;

  int? get creditPage => _creditPage;

  int? get paymentLastPage => _paymentLastPage;

  int? get creditLastPage => _creditLastPage;

  NetworkState? get creditDeductionState => _creditDeductionState;

  bool get creditDeductionPaging => _creditDeductionPaging;

  bool get creditDeductionListEmpty => _creditDeductionListEmpty;
}
