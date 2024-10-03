import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../Models/bulk_shipment.dart';
import '../Models/display_shipment_details.dart';
import '../Models/merchant_review.dart';
import '../Models/shipment_offer_data.dart';
import '../Models/shipment_response.dart';
import '../Models/shipment_status.dart';
import '../Screens/new_offer_based_shipment.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/constants.dart';
import '../core/httpHelper/http_helper.dart';

class ShipmentProvider with ChangeNotifier {
  final int _currentShipmentIndex = 0;
  // final Widget _currentShipmentWidget = CourierAppliedShipmentHost();
  bool test = false;
  bool isUpdated = false;
  String? _shipmentMessage;
  final bool _isNotEmpty = false;
  bool _isAvailableShipment = false;
  final List<ShipmentOfferData> _courierAppliedShipments = [];
  final List<BulkShipment> _courierOnHisWayToGetShipmentShipments = [];
  final List<BulkShipment> _merchantAcceptedShipments = [];
  List<BulkShipment> _deliveredShipments = [];
  final List<BulkShipment> _onDeliveryShipments = [];
  final List<BulkShipment> _returnedShipments = [];
  final List<BulkShipment> _availableShipments = [];
  List<BulkShipment> _offerBasedShipments = [];
  List<ShipmentStatus> _shipmentStatus = [];
  bool _fromNewShipment = false;
  DisplayShipmentDetails? _shipmentById;
  BulkShipment? _bulkShipmentById;
  bool _noCredit = false;
  NetworkState? _sendShippingOfferState;
  NetworkState? _declineFromShipmentState;
  NetworkState? _applyToAvailableShipmentState;
  NetworkState? _cancelShippingState;
  NetworkState? _availableState;
  NetworkState? _offerBasedState;
  NetworkState? _myReviewsState;
  NetworkState? _courierAppliedState;
  NetworkState? _courierOnHisWayToGetShipmentState;
  NetworkState? _merchantAcceptedShipmentState;
  NetworkState? _returnedState;
  NetworkState? _onDeliveryState;
  NetworkState? _deliveredState;
  NetworkState? _shipmentStatusState;

  int _offerBasedCurrentPage = 1;
  final int _availableCurrentPage = 1;
  final int _courierAppliedCurrentPage = 1;
  final int _courierOnHisWayToGetShipmentCurrentPage = 1;
  final int _merchantAcceptedCurrentPage = 1;
  final int _onDeliveryCurrentPage = 1;
  int _deliveredCurrentPage = 1;
  final int _returnedCurrentPage = 1;
  bool _merchantReviewsEmpty = false;
  bool _myReviewsEmpty = false;
  NetworkState? _merchantReviewState;
  int _offerBasedTotalItems = 0;
  final int _availableTotalItems = 0;
  final int _merchantAcceptedTotalItems = 0;
  final int _courierAppliedTotalItems = 0;
  final int _courierOnHisWatToGetShipmentTotalItems = 0;
  int _deliveredTotalItems = 0;
  final int _onDeliveryTotalItems = 0;
  final int _returnedTotalItems = 0;

  int? _offerBasedLastPage;
  int? _availableLastPage;
  int? _merchantAcceptedLastPage;
  int? _courierAppliedLastPage;
  int? _courierOnHisWayToGetShipmentLastPage;
  int? _onDeliveryLastPage;
  int? _deliveredLastPage;
  int? _returnedLastPage;
  List<MerchantReview> _merchantReviews = [];
  List<MerchantReview> _myReviews = [];
  bool _offerBasedNextPageLoading = false;
  final bool _availableNextPageLoading = false;
  final bool _courierAppliedNextPageLoading = false;
  final bool _courierOnHisWayToGetShipmentNextPageLoading = false;
  final bool _merchantAcceptedNextPageLoading = false;
  final bool _deliveredNextPageLoading = false;
  final bool _onDeliveryNextPageLoading = false;
  final bool _returnedNextPageLoading = false;

  bool _offerBasedShipmentIsEmpty = false;
  final bool _courierAppliedShipmentIsEmpty = false;
  final bool _courierOnHisWayToGetShipmentShipmentIsEmpty = false;
  final bool _availableShipmentIsEmpty = false;
  final bool _merchantAcceptedShipmentIsEmpty = false;
  bool _deliveredShipmentIsEmpty = false;
  final bool _onDeliveryShipmentIsEmpty = false;
  final bool _returnedShipmentIsEmpty = false;
  String? _cancelMessage;
  NetworkState? _shipmentByIdState;
  NetworkState? _bulkShipmentByIdState;
  bool _shipmentFromHome = false;
  final Widget _availableShipment = const NewOfferBasedShipments();
  int _availableShipmentIndex = 1;

  bool get isNotEmpty => _isNotEmpty;

  void setIsUpdated(bool updated) {
    isUpdated = updated;
    notifyListeners();
  }

  void setAvailableShipmentIndex(int i) {
    _availableShipmentIndex = i;
    notifyListeners();
  }

  Widget get availableShipment => _availableShipment;

  NetworkState? get declineFromShipmentState => _declineFromShipmentState;

  String? get cancelMessage => _cancelMessage;

  NetworkState? get cancelShippingState => _cancelShippingState;

  NetworkState? get shipmentByIdState => _shipmentByIdState;

  NetworkState? get applyToAvailableShipment => _applyToAvailableShipmentState;

  void setShipmentFromHome(bool v) {
    _shipmentFromHome = v;
  }

  bool? get noCredit => _noCredit;

  String? get shipmentMessage => _shipmentMessage;

  int? get currentShipmentIndex => _currentShipmentIndex;

  // void changePortion(int i, bool init) {
  //   _currentShipmentIndex = i;
  //   getCurrentShipmentWidget(i);
  //   if (!init) {
  //     notifyListeners();
  //   }
  // }

  // Widget get currentShipmentWidget => _currentShipmentWidget;

  // void getCurrentShipmentWidget(int i) {
  //   switch (_currentShipmentIndex) {
  //     case 0:
  //       _currentShipmentWidget = CourierAppliedShipmentHost(
  //         key: ValueKey('$i'),
  //       );
  //       break;
  //     case 1:
  //       _currentShipmentWidget = MerchantAcceptedShipmentHost(
  //         key: ValueKey('$i'),
  //       );
  //       break;
  //     case 2:
  //       _currentShipmentWidget = CourierOnHisWayToGetShipmentHost(
  //         key: ValueKey('$i'),
  //       );
  //       break;
  //     case 3:
  //       _currentShipmentWidget = OnDeliveryShipmentHost(
  //         key: ValueKey('$i'),
  //       );
  //       break;
  //     case 4:
  //       _currentShipmentWidget = DeliveredShipmentHost(
  //         key: ValueKey('$i'),
  //       );
  //       break;
  //     case 5:
  //       _currentShipmentWidget = ReturnedShipmentHost(
  //         key: ValueKey('$i'),
  //       );
  //       break;
  //   }
  // }

  bool get shipmentFromHome => _shipmentFromHome;

  Future<void> declineFromShipment({int? offerId}) async {
    try {
      _declineFromShipmentState = NetworkState.waiting;
      Response r = await HttpHelper.instance.httpPut(
        'shipping-offers/$offerId/decline',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _declineFromShipmentState = NetworkState.success;
      } else {
        _declineFromShipmentState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> applyToAvailableShipping({int? shipmentId}) async {
    try {
      _applyToAvailableShipmentState = NetworkState.waiting;
      notifyListeners();
      Response r = await HttpHelper.instance.httpPost(
        'available-shipments/apply-to-shipment',
        true,
        body: {
          'shipment_id': '$shipmentId',
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _applyToAvailableShipmentState = NetworkState.success;
      } else {
        if (json.decode(r.body)['message'] ==
            'Your current balance does not allow for this action!') {
          _noCredit = true;
        } else {
          _noCredit = false;
        }
        _applyToAvailableShipmentState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  bool get merchantReviewsEmpty => _merchantReviewsEmpty;

  Future<void> listOfMerchantReviews({int? merchantId}) async {
    _merchantReviewState = NetworkState.waiting;
    try {
      Response r = await HttpHelper.instance.httpPost(
        'list-merchant-reviews',
        true,
        body: {
          'merchant_id': merchantId,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _merchantReviews = (json.decode(r.body) as List)
            .map((e) => MerchantReview.fromJson(e))
            .toList();
        _merchantReviewsEmpty = _merchantReviews.isEmpty;
        _merchantReviewState = NetworkState.success;
      } else {
        _merchantReviewState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> listOfMyReviews(bool retry) async {
    _myReviewsState = NetworkState.waiting;
    if (retry) {
      notifyListeners();
    }
    try {
      Response r = await HttpHelper.instance.httpPost(
        'my-reviews',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _myReviews = (json.decode(r.body) as List)
            .map((e) => MerchantReview.fromJson(e))
            .toList();
        _myReviewsEmpty = _myReviews.isEmpty;
        _myReviewsState = NetworkState.success;
      } else {
        _myReviewsState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  NetworkState? get myReviewsState => _myReviewsState;

  Future<void> getShipmentById({
    required int id,
    required bool isFirstTime,
  }) async {
    _shipmentByIdState = NetworkState.waiting;
    if (!isFirstTime) {
      notifyListeners();
    }
    try {
      Response r = await HttpHelper.instance.httpGet(
        'shipments/$id',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _shipmentById = DisplayShipmentDetails.fromJson(jsonDecode(r.body));
        _shipmentByIdState = NetworkState.success;
      } else {
        String m = json.decode(r.body)['message'];
        if (m.contains('No query results for model')) {
          _isAvailableShipment = true;
        }
        _shipmentByIdState = NetworkState.error;
      }
    } catch (e) {
      _shipmentByIdState = NetworkState.error;
      log(e.toString());
    }
    notifyListeners();
  }

  bool get isAvailableShipment => _isAvailableShipment;

  Future<void> getBulkShipmentById({
    required int id,
    required bool isFirstTime,
  }) async {
    _bulkShipmentByIdState = NetworkState.waiting;
    if (!isFirstTime) {
      notifyListeners();
    }
    try {
      Response r = await HttpHelper.instance.httpGet(
        'shipments/$id',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _bulkShipmentById = BulkShipment.fromJson(jsonDecode(r.body));
        _bulkShipmentByIdState = NetworkState.success;
      } else {
        _bulkShipmentByIdState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  // Future<void> getAvailableShipment({
  //   required bool isPagination,
  //   required bool isRefreshing,
  //   required bool isFirstTime,
  // }) async {
  //   try {
  //     if (!isPagination && !isRefreshing) {
  //       _availableCurrentPage = 1;
  //       _availableState = NetworkState.WAITING;
  //       if (!isFirstTime) {
  //         notifyListeners();
  //       }
  //     }
  //     Response r = await HttpHelper.instance.httpGet(
  //       'available-shipments?&page=$_availableCurrentPage',
  //       true,
  //     );
  //     if (r.statusCode >= 200 && r.statusCode < 300) {
  //       ShipmentResponse main = ShipmentResponse.fromJson(jsonDecode(r.body));
  //       _availableTotalItems = main.total!;
  //       _availableLastPage = main.lastPage;
  //       if (_availableCurrentPage == 1) {
  //         _availableShipments = main.data;
  //       } else {
  //         _availableShipments.addAll(main.data);
  //       }
  //       _availableShipmentIsEmpty = _availableShipments.isEmpty;
  //       _availableState = NetworkState.SUCCESS;
  //     } else {
  //       _availableState = NetworkState.ERROR;
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //     _availableState = NetworkState.ERROR;
  //   }
  //   notifyListeners();
  // }

  // Future<void> getCourierAppliedShipment({
  //   bool isPagination,
  //   bool isRefreshing,
  //   bool isFirstTime,
  // }) async {
  //   try {
  //     if (!isPagination && !isRefreshing) {
  //       _courierAppliedCurrentPage = 1;
  //       _courierAppliedState = NetworkState.WAITING;
  //       if (!isFirstTime) {
  //         notifyListeners();
  //       }
  //     }
  //     Response r = await HttpHelper.instance.httpGet(
  //       'shipping-offers?shipping_offer_status=pending&page=$_courierAppliedCurrentPage',
  //       true,
  //     );
  //     if (r.statusCode >= 200 && r.statusCode < 300) {
  //       ShipmentOffer main = ShipmentOffer.fromJson(jsonDecode(r.body));
  //       _courierAppliedTotalItems = main.total;
  //       _courierAppliedLastPage = main.lastPage;
  //       if (_courierAppliedCurrentPage == 1) {
  //         _courierAppliedShipments = main.data;
  //       } else {
  //         _courierAppliedShipments.addAll(main.data);
  //       }
  //       _courierAppliedShipmentIsEmpty = _courierAppliedShipments.isEmpty;
  //       _courierAppliedState = NetworkState.SUCCESS;
  //     } else {
  //       _courierAppliedState = NetworkState.ERROR;
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  //   notifyListeners();
  // }

  // Future<void> getCourierOnHisWayToGetShipment({
  //   bool isPagination,
  //   bool isRefreshing,
  //   bool isFirstTime,
  // }) async {
  //   try {
  //     if (!isPagination && !isRefreshing) {
  //       _courierOnHisWayToGetShipmentCurrentPage = 1;
  //       _courierOnHisWayToGetShipmentState = NetworkState.WAITING;
  //       if (!isFirstTime) {
  //         log('not firstTime');
  //         notifyListeners();
  //       }
  //     }
  //     Response r = await HttpHelper.instance.httpGet(
  //       'my-shipments?status=on-the-way-to-get-shipment-from-merchant&page=$_courierOnHisWayToGetShipmentCurrentPage',
  //       true,
  //     );
  //     if (r.statusCode >= 200 && r.statusCode < 300) {
  //       ShipmentResponse main = ShipmentResponse.fromJson(jsonDecode(r.body));
  //       _courierOnHisWatToGetShipmentTotalItems = main.total;
  //       _courierOnHisWayToGetShipmentLastPage = main.lastPage;
  //       if (_courierOnHisWayToGetShipmentCurrentPage == 1) {
  //         _courierOnHisWayToGetShipmentShipments = main.data;
  //       } else {
  //         _courierOnHisWayToGetShipmentShipments.addAll(main.data);
  //       }
  //       _courierOnHisWayToGetShipmentShipmentIsEmpty =
  //           _courierOnHisWayToGetShipmentShipments.isEmpty;
  //       _courierOnHisWayToGetShipmentState = NetworkState.SUCCESS;
  //     } else {
  //       _courierOnHisWayToGetShipmentState = NetworkState.ERROR;
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  //   notifyListeners();
  // }

  bool get fromNewShipment => _fromNewShipment;

  void setFromNewShipment(bool v) {
    _fromNewShipment = v;
  }

  // Future<void> getMerchantAcceptedShipment({
  //   bool isPagination,
  //   bool isRefreshing,
  //   bool isFirstTime,
  // }) async {
  //   try {
  //     if (!isPagination && !isRefreshing) {
  //       _merchantAcceptedCurrentPage = 1;
  //       _merchantAcceptedShipmentState = NetworkState.WAITING;
  //       if (!isFirstTime) {
  //         notifyListeners();
  //       }
  //     }
  //     Response r = await HttpHelper.instance.httpGet(
  //       'my-shipments?status=merchant-accepted-shipping-offer,courier-applied-to-shipment&page=$_merchantAcceptedCurrentPage',
  //       true,
  //     );
  //     if (r.statusCode >= 200 && r.statusCode < 300) {
  //       ShipmentResponse main = ShipmentResponse.fromJson(jsonDecode(r.body));
  //       _merchantAcceptedTotalItems = main.total;
  //       _merchantAcceptedLastPage = main.lastPage;
  //       if (_merchantAcceptedCurrentPage == 1) {
  //         _merchantAcceptedShipments = main.data;
  //       } else {
  //         _merchantAcceptedShipments.addAll(main.data);
  //       }
  //       _merchantAcceptedShipmentIsEmpty = _merchantAcceptedShipments.isEmpty;
  //       _merchantAcceptedShipmentState = NetworkState.SUCCESS;
  //     } else {
  //       _merchantAcceptedShipmentState = NetworkState.ERROR;
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //     _merchantAcceptedShipmentState = NetworkState.ERROR;
  //   }
  //   notifyListeners();
  // }

  // Future<void> getOnDeliveryShipment({
  //   bool isPagination,
  //   bool isRefreshing,
  //   bool isFirstTime,
  // }) async {
  //   try {
  //     if (!isPagination && !isRefreshing) {
  //       _onDeliveryCurrentPage = 1;
  //       _onDeliveryState = NetworkState.WAITING;
  //       if (!isFirstTime) {
  //         notifyListeners();
  //       }
  //     }
  //     Response r = await HttpHelper.instance.httpGet(
  //       'my-shipments?status=on-delivery&page=$_onDeliveryCurrentPage',
  //       true,
  //     );
  //     if (r.statusCode >= 200 && r.statusCode < 300) {
  //       ShipmentResponse main = ShipmentResponse.fromJson(jsonDecode(r.body));
  //       _onDeliveryTotalItems = main.total;
  //       _onDeliveryLastPage = main.lastPage;
  //       if (_onDeliveryCurrentPage == 1) {
  //         _onDeliveryShipments = main.data;
  //       } else {
  //         _onDeliveryShipments.addAll(main.data);
  //       }
  //       _onDeliveryShipmentIsEmpty = _onDeliveryShipments.isEmpty;
  //       _onDeliveryState = NetworkState.SUCCESS;
  //     } else {
  //       _onDeliveryState = NetworkState.ERROR;
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //     _onDeliveryState = NetworkState.ERROR;
  //   }
  //   notifyListeners();
  // }

  Future<void> getDeliveryShipment({
    bool? isPagination,
    bool? isRefreshing,
    bool? isFirstTime,
  }) async {
    try {
      if (!isPagination! && !isRefreshing!) {
        _deliveredCurrentPage = 1;
        _deliveredState = NetworkState.waiting;
        if (!isFirstTime!) {
          notifyListeners();
        }
      }
      Response r = await HttpHelper.instance.httpGet(
        'my-shipments?status=delivered,bulk-shipment-closed&page=$_deliveredCurrentPage',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        ShipmentResponse main = ShipmentResponse.fromJson(jsonDecode(r.body));
        _deliveredTotalItems = main.total!;
        _deliveredLastPage = main.lastPage;
        if (_deliveredLastPage == 1) {
          _deliveredShipments = main.data!;
        } else {
          _deliveredShipments.addAll(main.data!);
        }
        _deliveredShipmentIsEmpty = _deliveredShipments.isEmpty;
        _deliveredState = NetworkState.success;
      } else {
        _deliveredState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
      _deliveredState = NetworkState.error;
    }
    notifyListeners();
  }

  // Future<void> getReturnedShipment({
  //   bool isPagination,
  //   bool isRefreshing,
  //   bool isFirstTime,
  // }) async {
  //   try {
  //     if (!isPagination && !isRefreshing) {
  //       _returnedCurrentPage = 1;
  //       _returnedState = NetworkState.WAITING;
  //       if (!isFirstTime) {
  //         notifyListeners();
  //       }
  //     }
  //     Response r = await HttpHelper.instance.httpGet(
  //       'my-shipments?status=returned,bulk-shipment-closed&page=$_returnedCurrentPage',
  //       true,
  //     );
  //     if (r.statusCode >= 200 && r.statusCode < 300) {
  //       ShipmentResponse main = ShipmentResponse.fromJson(jsonDecode(r.body));
  //       _returnedTotalItems = main.total;
  //       _returnedLastPage = main.lastPage;
  //       if (_returnedCurrentPage == 1) {
  //         _returnedShipments = main.data;
  //       } else {
  //         _returnedShipments.addAll(main.data);
  //       }
  //       _returnedShipmentIsEmpty = _returnedShipments.isEmpty;
  //       _returnedState = NetworkState.SUCCESS;
  //     } else {
  //       _returnedState = NetworkState.ERROR;
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //     _returnedState = NetworkState.ERROR;
  //   }
  //   notifyListeners();
  // }

  Future<void> cancelShipping(int shipmentId) async {
    try {
      _cancelShippingState = NetworkState.waiting;
      Response r = await HttpHelper.instance.httpPost(
        'shipments/$shipmentId/cancel-this-shipment',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _cancelMessage = jsonDecode(r.body)['message'];
        _cancelShippingState = NetworkState.success;
      } else {
        _cancelShippingState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> getShipmentStatus(bool retry) async {
    _shipmentStatusState = NetworkState.waiting;
    try {
      Response r = await HttpHelper.instance.httpGet(
        'shipments-stats',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _shipmentStatus = (json.decode(r.body) as List)
            .map((e) => ShipmentStatus.fromJson(e))
            .toList();
        _shipmentStatusState = NetworkState.success;
      } else {
        _shipmentStatusState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  List<ShipmentStatus> get shipmentStatus => _shipmentStatus;

  Future<void> getOfferBasedShipment({
    required bool isPagination,
    required bool isRefreshing,
    required bool isFirstTime,
  }) async {
    try {
      if (!isPagination && !isRefreshing) {
        _offerBasedCurrentPage = 1;
        _offerBasedState = NetworkState.waiting;
        if (!isFirstTime) {
          notifyListeners();
        }
      }
      Response r = await HttpHelper.instance.httpGet(
        'available-offer-based-shipments?page=$_offerBasedCurrentPage',
        true,
      );
      log('body -> ${Preferences.instance.getAccessToken}');
      log('body -> ${json.decode(r.body)}');
      log('body -> ${r.statusCode}');
      log('body -> ${r.request?.url}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        ShipmentResponse main = ShipmentResponse.fromJson(jsonDecode(r.body));
        _offerBasedTotalItems = main.total!;
        _offerBasedLastPage = main.lastPage;
        if (_offerBasedCurrentPage == 1) {
          _offerBasedShipments = main.data!;
        } else {
          _offerBasedShipments.addAll(main.data!);
        }
        _offerBasedShipmentIsEmpty = _offerBasedShipments.isEmpty;
        _offerBasedState = NetworkState.success;
      } else {
        _offerBasedState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  // Future<void> clearAvailableShipmentList() async {
  //   _availableShipments.clear();
  //   notifyListeners();
  //   _availableCurrentPage = 1;
  //   await getAvailableShipment(
  //       isPagination: false, isRefreshing: true, isFirstTime: false);
  //   notifyListeners();
  // }

  // Future<void> clearCourierOnHisWayToGetShipmentShipmentList() async {
  //   _courierOnHisWayToGetShipmentShipments.clear();
  //   notifyListeners();
  //   _courierOnHisWayToGetShipmentCurrentPage = 1;
  //   await getCourierOnHisWayToGetShipment(
  //       isPagination: false, isRefreshing: true, isFirstTime: false);
  //   notifyListeners();
  // }

  // Future<void> clearCourierAppliedShipmentList() async {
  //   _courierAppliedShipments.clear();
  //   notifyListeners();
  //   _courierAppliedCurrentPage = 1;
  //   await getCourierAppliedShipment(
  //       isPagination: false, isRefreshing: true, isFirstTime: false);
  //   notifyListeners();
  // }

  Future<void> clearOfferBasedShipmentList() async {
    _offerBasedShipments.clear();
    notifyListeners();
    _offerBasedCurrentPage = 1;
    await getOfferBasedShipment(
        isPagination: false, isRefreshing: true, isFirstTime: false);
    notifyListeners();
  }

  // Future<void> clearMerchantAcceptedShipmentList() async {
  //   _merchantAcceptedShipments.clear();
  //   notifyListeners();
  //   _merchantAcceptedCurrentPage = 1;
  //   await getMerchantAcceptedShipment(
  //       isPagination: false, isRefreshing: true, isFirstTime: false);
  //   notifyListeners();
  // }

  // Future<void> clearDeliveredShipmentList() async {
  //   _deliveredShipments.clear();
  //   notifyListeners();
  //   _deliveredCurrentPage = 1;
  //   await getDeliveryShipment(
  //       isPagination: false, isRefreshing: true, isFirstTime: false);
  //   notifyListeners();
  // }

  // Future<void> clearOnDeliveryShipmentList() async {
  //   _onDeliveryShipments.clear();
  //   notifyListeners();
  //   _onDeliveryCurrentPage = 1;
  //   await getOnDeliveryShipment(
  //       isPagination: false, isRefreshing: true, isFirstTime: false);
  //   notifyListeners();
  // }

  // Future<void> clearReturnedShipmentList() async {
  //   _returnedShipments.clear();
  //   notifyListeners();
  //   _returnedCurrentPage = 1;
  //   await getReturnedShipment(
  //       isPagination: false, isRefreshing: true, isFirstTime: false);
  //   notifyListeners();
  // }

  Future<void> offerBasedNextPage() async {
    if (_offerBasedCurrentPage < _offerBasedLastPage!) {
      _offerBasedNextPageLoading = true;
      notifyListeners();
      _offerBasedCurrentPage++;
      await getOfferBasedShipment(
          isPagination: true, isRefreshing: false, isFirstTime: false);
      _offerBasedNextPageLoading = false;
      notifyListeners();
    }
  }

  // Future<void> courierOnHisWayToGetShipmentNextPage() async {
  //   if (_courierOnHisWayToGetShipmentCurrentPage <
  //       _courierOnHisWayToGetShipmentLastPage) {
  //     _courierOnHisWayToGetShipmentNextPageLoading = true;
  //     notifyListeners();
  //     _courierOnHisWayToGetShipmentCurrentPage++;
  //     await getCourierOnHisWayToGetShipment(
  //         isPagination: true, isRefreshing: false, isFirstTime: false);
  //     _courierOnHisWayToGetShipmentNextPageLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> courierAppliedNextPage() async {
  //   if (_courierAppliedCurrentPage < _courierAppliedLastPage) {
  //     _courierAppliedNextPageLoading = true;
  //     notifyListeners();
  //     _courierAppliedCurrentPage++;
  //     await getCourierAppliedShipment(
  //         isPagination: true, isRefreshing: false, isFirstTime: false);
  //     _courierAppliedNextPageLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> merchantAcceptedNextPage() async {
  //   if (_merchantAcceptedCurrentPage < _merchantAcceptedLastPage) {
  //     _merchantAcceptedNextPageLoading = true;
  //     notifyListeners();
  //     _merchantAcceptedCurrentPage++;
  //     await getMerchantAcceptedShipment(
  //         isPagination: true, isFirstTime: false, isRefreshing: false);
  //     _merchantAcceptedNextPageLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> availableNextPage() async {
  //   if (_availableCurrentPage < _availableLastPage) {
  //     _availableNextPageLoading = true;
  //     notifyListeners();
  //     _availableCurrentPage++;
  //     await getAvailableShipment(
  //         isPagination: true, isRefreshing: false, isFirstTime: false);
  //     _availableNextPageLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> onDeliveryNextPage() async {
  //   if (_onDeliveryCurrentPage < _onDeliveryLastPage) {
  //     _onDeliveryNextPageLoading = true;
  //     notifyListeners();
  //     _onDeliveryCurrentPage++;
  //     await getOnDeliveryShipment(
  //         isPagination: true, isFirstTime: false, isRefreshing: false);
  //     _onDeliveryNextPageLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> deliveredNextPage() async {
  //   if (_deliveredCurrentPage < _deliveredLastPage) {
  //     _deliveredNextPageLoading = true;
  //     notifyListeners();
  //     _deliveredCurrentPage++;
  //     await getDeliveryShipment(
  //         isPagination: true, isFirstTime: false, isRefreshing: false);
  //     _deliveredNextPageLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> returnedNextPage() async {
  //   if (_returnedCurrentPage < _returnedLastPage) {
  //     _returnedNextPageLoading = true;
  //     notifyListeners();
  //     _returnedCurrentPage++;
  //     await getReturnedShipment(
  //         isPagination: true, isFirstTime: false, isRefreshing: false);
  //     _returnedNextPageLoading = false;
  //     notifyListeners();
  //   }
  // }

  DisplayShipmentDetails? get shipmentById => _shipmentById;

  NetworkState? get sendShippingOfferState => _sendShippingOfferState;

  int get availableShipmentIndex => _availableShipmentIndex;

  bool get returnedShipmentIsEmpty => _returnedShipmentIsEmpty;

  bool get onDeliveryShipmentIsEmpty => _onDeliveryShipmentIsEmpty;

  bool get deliveredShipmentIsEmpty => _deliveredShipmentIsEmpty;

  bool get merchantAcceptedShipmentIsEmpty => _merchantAcceptedShipmentIsEmpty;

  bool get availableShipmentIsEmpty => _availableShipmentIsEmpty;

  bool get courierAppliedShipmentIsEmpty => _courierAppliedShipmentIsEmpty;

  bool get offerBasedShipmentIsEmpty => _offerBasedShipmentIsEmpty;

  bool get returnedNextPageLoading => _returnedNextPageLoading;

  bool get onDeliveryNextPageLoading => _onDeliveryNextPageLoading;

  bool get deliveredNextPageLoading => _deliveredNextPageLoading;

  bool get merchantAcceptedNextPageLoading => _merchantAcceptedNextPageLoading;

  bool get courierAppliedNextPageLoading => _courierAppliedNextPageLoading;

  bool get availableNextPageLoading => _availableNextPageLoading;

  bool get offerBasedNextPageLoading => _offerBasedNextPageLoading;

  int? get returnedLastPage => _returnedLastPage;

  int? get deliveredLastPage => _deliveredLastPage;

  int? get onDeliveryLastPage => _onDeliveryLastPage;

  int? get courierAppliedLastPage => _courierAppliedLastPage;

  int? get merchantAcceptedLastPage => _merchantAcceptedLastPage;

  int? get availableLastPage => _availableLastPage;

  int? get offerBasedLastPage => _offerBasedLastPage;

  int get returnedTotalItems => _returnedTotalItems;

  int get onDeliveryTotalItems => _onDeliveryTotalItems;

  int get deliveredTotalItems => _deliveredTotalItems;

  int get courierAppliedTotalItems => _courierAppliedTotalItems;

  int get merchantAcceptedTotalItems => _merchantAcceptedTotalItems;

  int get availableTotalItems => _availableTotalItems;

  List<BulkShipment> get courierOnHisWayToGetShipmentShipments =>
      _courierOnHisWayToGetShipmentShipments;

  int get offerBasedTotalItems => _offerBasedTotalItems;

  int get returnedCurrentPage => _returnedCurrentPage;

  int get deliveredCurrentPage => _deliveredCurrentPage;

  int get onDeliveryCurrentPage => _onDeliveryCurrentPage;

  int get merchantAcceptedCurrentPage => _merchantAcceptedCurrentPage;

  int get courierAppliedCurrentPage => _courierAppliedCurrentPage;

  int get availableCurrentPage => _availableCurrentPage;

  int get offerBasedCurrentPage => _offerBasedCurrentPage;

  NetworkState? get deliveredState => _deliveredState;

  NetworkState? get onDeliveryState => _onDeliveryState;

  NetworkState? get returnedState => _returnedState;

  NetworkState? get merchantAcceptedShipmentState =>
      _merchantAcceptedShipmentState;

  NetworkState? get courierAppliedState => _courierAppliedState;

  NetworkState? get offerBasedState => _offerBasedState;

  NetworkState? get availableState => _availableState;

  NetworkState? get applyToAvailableShipmentState =>
      _applyToAvailableShipmentState;

  List<BulkShipment> get offerBasedShipments => _offerBasedShipments;

  List<BulkShipment> get availableShipments => _availableShipments;

  List<BulkShipment> get returnedShipments => _returnedShipments;

  List<BulkShipment> get onDeliveryShipments => _onDeliveryShipments;

  List<BulkShipment> get deliveredShipments => _deliveredShipments;

  List<BulkShipment> get merchantAcceptedShipments =>
      _merchantAcceptedShipments;

  List<ShipmentOfferData> get courierAppliedShipments =>
      _courierAppliedShipments;

  NetworkState? get bulkShipmentByIdState => _bulkShipmentByIdState;

  BulkShipment? get bulkShipmentById => _bulkShipmentById;

  NetworkState? get courierOnHisWayToGetShipmentState =>
      _courierOnHisWayToGetShipmentState;

  int get courierOnHisWayToGetShipmentCurrentPage =>
      _courierOnHisWayToGetShipmentCurrentPage;

  int get courierOnHisWatToGetShipmentTotalItems =>
      _courierOnHisWatToGetShipmentTotalItems;

  int? get courierOnHisWayToGetShipmentLastPage =>
      _courierOnHisWayToGetShipmentLastPage;

  bool get courierOnHisWayToGetShipmentNextPageLoading =>
      _courierOnHisWayToGetShipmentNextPageLoading;

  bool get courierOnHisWayToGetShipmentShipmentIsEmpty =>
      _courierOnHisWayToGetShipmentShipmentIsEmpty;

  NetworkState? get merchantReviewState => _merchantReviewState;

  List<MerchantReview> get merchantReviews => _merchantReviews;

  NetworkState? get shipmentStatusState => _shipmentStatusState;

  bool get myReviewsEmpty => _myReviewsEmpty;

  List<MerchantReview> get myReviews => _myReviews;
}
