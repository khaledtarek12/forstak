// ignore_for_file: avoid_init_to_null, avoid_print, sized_box_for_whitespace, no_leading_underscores_for_local_identifiers, prefer_interpolation_to_compose_strings

import 'dart:developer';

import 'package:active_ecommerce_seller_app/const/DeliveryStatus.dart';
import 'package:active_ecommerce_seller_app/const/PaymentStatus.dart';
import 'package:active_ecommerce_seller_app/custom/device_info.dart';
import 'package:active_ecommerce_seller_app/custom/loading.dart';
import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:active_ecommerce_seller_app/custom/my_app_bar.dart';
import 'package:active_ecommerce_seller_app/custom/my_widget.dart';
import 'package:active_ecommerce_seller_app/custom/toast_component.dart';
import 'package:active_ecommerce_seller_app/data_model/order_detail_response.dart';
import 'package:active_ecommerce_seller_app/helpers/main_helper.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_seller_app/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/repositories/order_repository.dart';
import 'package:active_ecommerce_seller_app/screens/main.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'dart:async';

// ignore: must_be_immutable
class OrderDetails extends StatefulWidget {
  int? id;
  bool go_back;

  OrderDetails({super.key, this.id, this.go_back = true});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final ScrollController _mainScrollController = ScrollController();
  final _steps = [
    'pending',
    'confirmed',
    'on_delivery',
    'picked_up',
    'on_the_way',
    'delivered'
  ];

  final TextEditingController _refundReasonController = TextEditingController();

  //init
  int _stepIndex = 0;
  DetailedOrder? _orderDetails;
  List<DeliveryBoy>? deliveryBoys;

  bool _orderItemsInit = false;
  final bool _showReasonWarning = false;
  bool _hasShownPendingPopup = false; // Track if popup was already shown
  bool Order = true;

  List<DropdownMenuItem<PaymentStatus>>? _dropdownPaymentStatusItems;
  List<DropdownMenuItem<DeliveryStatus>>? _dropdownDeliveryStatusItems;
  List<DropdownMenuItem<DeliveryBoy>>? dropdownDeliveryBoys;
  PaymentStatus? _selectedPaymentStatus;
  DeliveryStatus? _selectedDeliveryStatus;
  DeliveryBoy? selectedDeliveryBoy;

  Loading loading = Loading();

  //= DeliveryStatus('pending', LangText(context: OneContext().context).getLocal().order_list_screen_pending);

  final List<PaymentStatus> _paymentStatusList =
      PaymentStatus.getPaymentStatusListForUpdater();
  final List<DeliveryStatus> _deliveryStatusList =
      DeliveryStatus.getDeliveryStatusListForUpdate();

  @override
  void initState() {
    fetchAll();
    super.initState();

    print(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  fetchAll() {
    _dropdownPaymentStatusItems =
        buildDropdownPaymentStatusItems(_paymentStatusList);
    _dropdownDeliveryStatusItems =
        buildDropdownDeliveryStatusItems(_deliveryStatusList);
    _selectedDeliveryStatus = _deliveryStatusList[0];
    fetchOrderDetails();
  }

  fetchOrderDetails() async {
    _selectedPaymentStatus = _paymentStatusList.first;
    var orderDetailsResponse =
        await OrderRepository().getOrderDetails(id: widget.id);

    if (orderDetailsResponse.order != null) {
      _orderDetails = orderDetailsResponse.order!;
      deliveryBoys = orderDetailsResponse.deliveryBoy;
      log(_orderDetails!.id.toString());
      dropdownDeliveryBoys = buildDropdownDeliveryBoyItems(deliveryBoys!);
      selectedDeliveryBoy = deliveryBoys!.isNotEmpty ? deliveryBoys![0] : null;

      // Debug print to check if dropdown items are populated correctly
      log('Dropdown Items: $dropdownDeliveryBoys');
      log("Selected Delivery Boy: ${selectedDeliveryBoy?.id}");

      // Matching delivery status with the list
      for (var element in _deliveryStatusList) {
        if (element.option_key == _orderDetails!.deliveryStatus) {
          _selectedDeliveryStatus = element;
          break;
        }
      }

      // Matching payment status with the list
      for (var element in _paymentStatusList) {
        if (element.option_key == _orderDetails!.paymentStatus) {
          _selectedPaymentStatus = element;
          break;
        }
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_orderDetails?.deliveryStatus == "pending" &&
          !_hasShownPendingPopup) {
        _showPendingStatusPopup(context);
        _hasShownPendingPopup =
            true; // Set flag to true after showing the popup
      }
    });

    setState(() {});
  }

  setStepIndex(key) {
    _stepIndex = _steps.indexOf(key);
    setState(() {});
  }

  reset() {
    _stepIndex = 0;
    _orderDetails = null;
    _orderItemsInit = false;
    setState(() {});
  }

  Future<void> _onPageRefresh() async {
    reset();
    fetchAll();
  }

  _updateDeliveryStatus(String status) async {
    loading.show();
    var response = await OrderRepository().updateDeliveryStatus(
        id: widget.id,
        status: status,
        paymentType: _orderDetails!.paymentType ?? '');
    ToastComponent.showDialog(response.message,
        gravity: Toast.center, duration: Toast.lengthLong);

    loading.hide();
  }

  Future<void> _updateDeliveryBoy(int id) async {
    try {
      // Show loading indicator
      loading.show();

      // Make API call and get the response
      final response = await OrderRepository().sendOrderIdAndDeliveryBoy(
        orderId: _orderDetails!.id!, // Ensure _orderDetails is not null
        deliveryBoy: id,
      );

      // Hide loading indicator
      loading.hide();

      // Display message from the response
      ToastComponent.showDialog(
        response['message'] ?? "Unexpected error occurred.",
        gravity: Toast.center,
        duration: Toast.lengthLong,
      );
    } catch (e) {
      // Hide loading indicator and handle errors
      loading.hide();
      log("Error in _updateDeliveryBoy: $e");
      ToastComponent.showDialog(
        "An error occurred: $e",
        gravity: Toast.center,
        duration: Toast.lengthLong,
      );
    }
  }

  _updatePaymentStatus(String status) async {
    loading.show();
    var response = await OrderRepository()
        .updatePaymentStatus(id: widget.id, status: status);
    loading.hide();
    ToastComponent.showDialog(response.message,
        gravity: Toast.center, duration: Toast.lengthLong);
  }

  onPopped(value) async {
    reset();
    fetchAll();
  }

  void _showPendingStatusPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection:
              app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
          child: AlertDialog(
            title: Text(
              textAlign: TextAlign.center,
              "انتباه",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(
              'لم يتم تحديد فتي توصيل بعد يرجي اختيار الاًن',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              Center(
                  child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    backgroundColor: MyTheme.app_accent_color_extra_light),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.blue),
                ),
              )),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Loading.getInstance() == null) {
      Loading.setInstance(context);
    }
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: MyAppBar(
          context: context,
          title: LangText(context: context).getLocal().order_details_ucf,
        ).show(),
        body: RefreshIndicator(
          color: MyTheme.app_accent_color,
          backgroundColor: Colors.white,
          onRefresh: _onPageRefresh,
          child: CustomScrollView(
            controller: _mainScrollController,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverToBoxAdapter(
                child: !seller_product_manage_admin.$
                    ? _orderDetails?.deliveryStatus == "pending"
                        ? Padding(
                            padding: const EdgeInsets.only(top: 20.0, left: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: DeviceInfo(context).getWidth() * .2,
                                  child: Text(
                                    LangText(context: context)
                                        .getLocal()
                                        .payment_status_ucf,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: MyTheme.font_grey),
                                  ),
                                ),
                                Container(
                                  width: DeviceInfo(context).getWidth() * .2,
                                  child: Text(
                                    LangText(context: context)
                                        .getLocal()
                                        .delivery_status_ucf,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: MyTheme.font_grey),
                                  ),
                                ),
                                Container(
                                  width: DeviceInfo(context).getWidth() * .2,
                                  child: Text(
                                    'فتي التوصيل',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: MyTheme.font_grey),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container()
                    : SizedBox(),
              ),
              SliverToBoxAdapter(
                child: !seller_product_manage_admin.$
                    ? _orderDetails?.deliveryStatus == "pending"
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _orderDetails != null
                                ? buildPaymentAndDeliveryChangeSection(context)
                                : buildTimeLineShimmer())
                        : Container()
                    : SizedBox(),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _orderDetails != null
                      ? buildOrderDetailsTopCard()
                      : ShimmerHelper().buildBasicShimmer(height: 150.0),
                ),
              ])),
              SliverList(
                  delegate: SliverChildListDelegate([
                Center(
                  child: Text(
                    LangText(context: context).getLocal().ordered_product_ucf,
                    style: TextStyle(
                        color: MyTheme.font_grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                buildOrderedProductSection(context)
              ])),
              SliverList(
                  delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 75,
                      ),
                      buildBottomSection()
                    ],
                  ),
                )
              ])),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOrderedProductSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _orderDetails != null
          ? buildOrderedProductList()
          : ShimmerHelper().buildBasicShimmer(height: 150.0),
      // _orderedItemList.length == 0 && _orderItemsInit
      //     ? ShimmerHelper().buildBasicShimmer(height: 100.0)
      //     : (_orderedItemList.length > 0
      //         ? buildOrderedProductList()
      //         : Container(
      //             height: 100,
      //             child: Text(
      //               LangText(context: context)
      //                   .getLocal()
      //                   .order_details_screen_ordered_product,
      //               style: TextStyle(color: MyTheme.font_grey),
      //             ),
      //           )),
    );
  }

  buildBottomSection() {
    return Expanded(
      child: _orderDetails != null
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 120,
                        child: Text(
                          LangText(context: context)
                              .getLocal()
                              .sub_total_all_capital,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Spacer(),
                      Text(
                        _orderDetails!.grandTotal
                            .toString(), // Use the subtotal from the order details
                        style: TextStyle(
                            color: MyTheme.font_grey,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 120,
                        child: Text(
                          LangText(context: context).getLocal().tax_all_capital,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Spacer(),
                      Text(
                        _orderDetails!.orderDetails!.price.toString(),
                        style: TextStyle(
                            color: MyTheme.font_grey,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 120,
                        child: Text(
                          LangText(context: context)
                              .getLocal()
                              .shipping_cost_all_capital,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Spacer(),
                      Text(
                        _orderDetails!.orderDetails!.total.toString(),
                        style: TextStyle(
                            color: MyTheme.font_grey,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 120,
                        child: Text(
                          LangText(context: context)
                              .getLocal()
                              .discount_all_capital,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Spacer(),
                      Text(
                        _orderDetails!.couponDiscount.toString(),
                        style: TextStyle(
                            color: MyTheme.font_grey,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 120,
                        child: Text(
                          LangText(context: context)
                              .getLocal()
                              .grand_total_all_capital,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Spacer(),
                      Text(
                        _orderDetails!.grandTotal.toString(),
                        style: TextStyle(
                            color: MyTheme.app_accent_color,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : ShimmerHelper().buildBasicShimmer(height: 100.0),
    );
  }

  buildTimeLineShimmer() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: ShimmerHelper().buildBasicShimmer(height: 20, width: 250.0),
        )
      ],
    );
  }

  /*buildTimeLineTiles() {
    print(_orderDetails.delivery_status);
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.end,
            isFirst: true,
            startChild: Container(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: _orderDetails.delivery_status == "pending" ? 36 : 30,
                    height:
                        _orderDetails.delivery_status == "pending" ? 36 : 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.redAccent, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.list_alt,
                      color: Colors.redAccent,
                      size: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                        height: 1.0,
                        width: MediaQuery.of(context).size.width * .4,
                        color: MyTheme.medium_grey_50),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      LangText(context: context).getLocal()
                          .order_details_screen_timeline_tile_order_placed,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: MyTheme.font_grey),
                    ),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 0 ? Colors.green : MyTheme.medium_grey,
              padding: const EdgeInsets.all(0),
              iconStyle: _stepIndex >= 0
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            afterLineStyle: _stepIndex >= 1
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
          ),
          TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.end,
            startChild: Container(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width:
                        _orderDetails.delivery_status == "confirmed" ? 36 : 30,
                    height:
                        _orderDetails.delivery_status == "confirmed" ? 36 : 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.blue, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.thumb_up_sharp,
                      color: Colors.blue,
                      size: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                        height: 1.0,
                        width: MediaQuery.of(context).size.width * .4,
                        color: MyTheme.medium_grey_50),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      LangText(context: context).getLocal()
                          .order_details_screen_timeline_tile_confirmed,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: MyTheme.font_grey),
                    ),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 1 ? Colors.green : MyTheme.medium_grey,
              padding: const EdgeInsets.all(0),
              iconStyle: _stepIndex >= 1
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            beforeLineStyle: _stepIndex >= 1
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
            afterLineStyle: _stepIndex >= 2
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
          ),
          TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.end,
            startChild: Container(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: _orderDetails.delivery_status == "on_delivery"
                        ? 36
                        : 30,
                    height: _orderDetails.delivery_status == "on_delivery"
                        ? 36
                        : 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.amber, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.local_shipping_outlined,
                      color: Colors.amber,
                      size: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                        height: 1.0,
                        width: MediaQuery.of(context).size.width * .4,
                        color: MyTheme.medium_grey_50),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      LangText(context: context).getLocal()
                          .order_details_screen_timeline_tile_on_delivery,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: MyTheme.font_grey),
                    ),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 2 ? Colors.green : MyTheme.medium_grey,
              padding: const EdgeInsets.all(0),
              iconStyle: _stepIndex >= 2
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            beforeLineStyle: _stepIndex >= 2
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
            afterLineStyle: _stepIndex >= 5
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
          ),
          TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.end,
            isLast: true,
            startChild: Container(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width:
                        _orderDetails.delivery_status == "delivered" ? 36 : 30,
                    height:
                        _orderDetails.delivery_status == "delivered" ? 36 : 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.purple, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.done_all,
                      color: Colors.purple,
                      size: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                        height: 1.0,
                        width: MediaQuery.of(context).size.width * .4,
                        color: MyTheme.medium_grey_50),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      LangText(context: context).getLocal()
                          .order_details_screen_timeline_tile_delivered,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: MyTheme.font_grey),
                    ),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 5 ? Colors.green : MyTheme.medium_grey,
              padding: const EdgeInsets.all(0),
              iconStyle: _stepIndex >= 5
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            beforeLineStyle: _stepIndex >= 5
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
          ),
        ],
      ),
    );
  }*/

  List<DropdownMenuItem<PaymentStatus>> buildDropdownPaymentStatusItems(
      List _paymentStatusList) {
    List<DropdownMenuItem<PaymentStatus>> items = [];
    for (PaymentStatus item in _paymentStatusList as Iterable<PaymentStatus>) {
      items.add(
        DropdownMenuItem(
          value: item,
          child: Text(item.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<DeliveryBoy>> buildDropdownDeliveryBoyItems(
      List<DeliveryBoy> delivery) {
    List<DropdownMenuItem<DeliveryBoy>> items = [];
    for (DeliveryBoy item in delivery) {
      items.add(
        DropdownMenuItem(
          value: item,
          child: Text(item.name.toString()),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<DeliveryStatus>> buildDropdownDeliveryStatusItems(
      List _deliveryStatusList) {
    List<DropdownMenuItem<DeliveryStatus>> items = [];
    for (DeliveryStatus item
        in _deliveryStatusList as Iterable<DeliveryStatus>) {
      items.add(
        DropdownMenuItem(
          value: item,
          child: Text(item.name),
        ),
      );
    }
    return items;
  }

  Widget buildPaymentAndDeliveryChangeSection(BuildContext context) {
    return Column(
      children: [
        Container(
          color: MyTheme.white,
          height: 40,
          child: Row(
            mainAxisAlignment:
                Order ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.start,
            children: [
              // Payment Status Dropdown
              Order
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.0),
                        border: Border.all(color: MyTheme.light_grey),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      height: 36,
                      width: MediaQuery.of(context).size.width / 3 - 20,
                      child: DropdownButton<PaymentStatus>(
                        isExpanded: true,
                        icon: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(Icons.expand_more, color: Colors.black54),
                        ),
                        hint: Text(
                          _selectedPaymentStatus!.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                        iconSize: 14,
                        underline: SizedBox(),
                        value: _selectedPaymentStatus!.option_key == "paid"
                            ? null
                            : _selectedPaymentStatus,
                        items: _selectedPaymentStatus!.option_key == "paid"
                            ? null
                            : _dropdownPaymentStatusItems,
                        onChanged: (PaymentStatus? selectedFilter) {
                          setState(() {
                            _selectedPaymentStatus = selectedFilter;
                          });
                          _updatePaymentStatus(
                              _selectedPaymentStatus!.option_key);
                        },
                      ),
                    )
                  : Container(),

              // Delivery Status Dropdown
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(color: MyTheme.light_grey),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                height: 36,
                width: MediaQuery.of(context).size.width / 3 - 20,
                child: DropdownButton<DeliveryStatus>(
                  isExpanded: true,
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Icon(Icons.expand_more, color: Colors.black54),
                  ),
                  hint: Text(
                    _selectedDeliveryStatus!.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                  iconSize: 14,
                  underline: SizedBox(),
                  value: _selectedDeliveryStatus!.option_key == "cancelled"
                      ? null
                      : _selectedDeliveryStatus,
                  items: _selectedDeliveryStatus!.option_key == "cancelled" ||
                          _selectedDeliveryStatus!.option_key == "delivered"
                      ? null
                      : _dropdownDeliveryStatusItems,
                  onChanged: (DeliveryStatus? selectedFilter) {
                    setState(() {
                      _selectedDeliveryStatus = selectedFilter;
                    });
                  },
                ),
              ),

              // Delivery Boy Dropdown
              Container(
                width: MediaQuery.of(context).size.width /
                    3, // Define a width for the container
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(color: MyTheme.light_grey),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                height: 36,
                child: DropdownButton<DeliveryBoy>(
                  isExpanded: true,
                  icon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.expand_more, color: Colors.black54),
                  ),
                  hint: Text(
                    _orderDetails?.deliveryStatus == "pending"
                        ? "فتي التوصيل"
                        : selectedDeliveryBoy?.name ?? "غير معرف",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                  iconSize: 14,
                  underline: const SizedBox(),
                  value: selectedDeliveryBoy,
                  items: dropdownDeliveryBoys,
                  onChanged: (DeliveryBoy? newDeliveryBoy) {
                    setState(() {
                      selectedDeliveryBoy = newDeliveryBoy;
                    });
                    _updateDeliveryBoy(selectedDeliveryBoy!.id!);
                    print(
                        "Selected Delivery Boy: ${selectedDeliveryBoy?.name}");
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: MyTheme.light_grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              // Check for null values and update delivery status
              if (selectedDeliveryBoy != null) {
                _updateDeliveryStatus(_selectedDeliveryStatus!.option_key);
                _onPageRefresh();
                // _updateDeliveryBoy(
                //     selectedDeliveryBoy!.id!); // Ensure 'id' is not null
              } else {
                ToastComponent.showDialog("Please select a delivery boy.",
                    gravity: Toast.center, duration: Toast.lengthLong);
              }
            },
            child: Text(
              'تاكيد',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
        )
      ],
    );
  }

  Card buildOrderDetailsTopCard() {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: MyTheme.light_grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  getLocal(context).order_code_ucf,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  getLocal(context).shipping_method_ucf,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 2),
              child: Row(
                children: [
                  Text(
                    _orderDetails!.code.toString(),
                    style: TextStyle(
                        color: MyTheme.app_accent_color,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    _orderDetails!.shippingType.toString(),
                    style: TextStyle(
                      color: MyTheme.grey_153,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  getLocal(context).order_date_ucf,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  getLocal(context).payment_method_ucf,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 2),
              child: Row(
                children: [
                  Text(
                    _orderDetails!.deliveryHistoryDate.toString(),
                    style: TextStyle(
                        color: MyTheme.grey_153,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                  Spacer(),
                  Text(
                    _orderDetails!.paymentType ?? '',
                    style: TextStyle(
                        color: MyTheme.grey_153,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  getLocal(context).payment_status_ucf,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  getLocal(context).delivery_status_ucf,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 2),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      _orderDetails!.paymentStatus.toString().replaceRange(
                          0,
                          1,
                          _orderDetails!.paymentStatus
                              .toString()
                              .characters
                              .first
                              .toString()
                              .toUpperCase()),
                      style: TextStyle(
                          color: _orderDetails!.paymentStatus == "paid"
                              ? MyTheme.green
                              : MyTheme.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Spacer(),
                  Text(
                    _orderDetails!.deliveryStatus.toString(),
                    style: TextStyle(
                        color: MyTheme.grey_153,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  _orderDetails!.shippingAddress != null
                      ? getLocal(context).shipping_address_ucf
                      : getLocal(context).pickup_point_ucf,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  getLocal(context).total_amount_ucf,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width - (32.0)) / 2,
                    // (total_screen_width - padding)/2
                    child: _orderDetails!.shippingAddress != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _orderDetails!.shippingAddress?.name != null
                                  ? Text(
                                      "${LangText(context: context).getLocal().name_ucf}: ${_orderDetails!.shippingAddress?.name}",
                                      maxLines: 3,
                                      style: TextStyle(
                                          color: MyTheme.grey_153,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    )
                                  : Container(),
                              _orderDetails!.shippingAddress?.email != null
                                  ? Text(
                                      "${LangText(context: context).getLocal().email_ucf}: ${_orderDetails!.shippingAddress?.email}",
                                      maxLines: 3,
                                      style: TextStyle(
                                          color: MyTheme.grey_153,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    )
                                  : Container(),
                              Text(
                                "${LangText(context: context).getLocal().address_ucf}: ${_orderDetails!.shippingAddress?.address}",
                                maxLines: 3,
                                style: TextStyle(
                                    color: MyTheme.grey_153,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "${LangText(context: context).getLocal().city_ucf}: ${_orderDetails!.shippingAddress?.city}",
                                maxLines: 3,
                                style: TextStyle(
                                    color: MyTheme.grey_153,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "${LangText(context: context).getLocal().country_ucf}: ${_orderDetails!.shippingAddress?.country}",
                                maxLines: 3,
                                style: TextStyle(
                                    color: MyTheme.grey_153,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "${LangText(context: context).getLocal().state_ucf}: ${_orderDetails!.shippingAddress?.state}",
                                maxLines: 3,
                                style: TextStyle(
                                    color: MyTheme.grey_153,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "${LangText(context: context).getLocal().phone_ucf}: ${_orderDetails!.shippingAddress?.phone}",
                                maxLines: 3,
                                style: TextStyle(
                                    color: MyTheme.grey_153,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "${LangText(context: context).getLocal().postal_code_ucf}: ${_orderDetails!.shippingAddress?.postalCode}",
                                maxLines: 3,
                                style: TextStyle(
                                    color: MyTheme.grey_153,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: 20),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _orderDetails!.orderDetails?.shippingAddress
                                          ?.name !=
                                      null
                                  ? Text(
                                      "${LangText(context: context).getLocal().name_ucf}: ${_orderDetails!.orderDetails?.shippingAddress?.name}",
                                      maxLines: 3,
                                      style: TextStyle(
                                          color: MyTheme.grey_153,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    )
                                  : Container(),
                              Text(
                                "${LangText(context: context).getLocal().address_ucf}: ${_orderDetails!.orderDetails?.shippingAddress?.address}",
                                maxLines: 3,
                                style: TextStyle(
                                    color: MyTheme.grey_153,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "${LangText(context: context).getLocal().phone_ucf}: ${_orderDetails!.orderDetails?.shippingAddress?.phone}",
                                maxLines: 3,
                                style: TextStyle(
                                    color: MyTheme.grey_153,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                  ),
                  Spacer(),
                  Text(
                    _orderDetails!.grandTotal.toString(),
                    style: TextStyle(
                        color: MyTheme.app_accent_color,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // SizedBox(
            //     width: double.infinity,
            //     child: ElevatedButton(
            //         style: ElevatedButton.styleFrom(
            //             backgroundColor: Colors.white,
            //             shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(8))),
            //         onPressed: () {
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (_) => DelvieryBoyScreen(
            //                       boyId: _orderDetails!.assignDeliveryBoy!,
            //                       deliveryBoys: deliveryBoys!)));
            //         },
            //         child: Text(
            //           'فتي الطلبات',
            //           style: TextStyle(fontSize: 18, color: Colors.blue),
            //         )))
          ],
        ),
      ),
    );
  }

  Widget buildOrderedProductItemsCard(int index) {
    // Ensure _orderDetails and its properties are not null
    return MyWidget().productContainer(
      width: DeviceInfo(context).getWidth(),
      height: 120,
      borderRadius: 10,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      margin: EdgeInsets.only(bottom: 10),
      borderColor: MyTheme.light_grey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Product Name
          Text(
            maxLines: 2,
            _orderDetails?.orderDetails?.productName ?? "Unknown Product",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: MyTheme.font_grey,
            ),
          ),
          // Description and Price Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Description
              Expanded(
                child: Text(
                  _orderDetails?.orderDetails?.quantity.toString() ??
                      "No description available",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.font_grey,
                  ),
                ),
              ),
              SizedBox(width: 10),
              // Price
              Text(
                _orderDetails?.orderDetails?.price != null
                    ? "\$${_orderDetails?.orderDetails?.price}"
                    : "N/A",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: MyTheme.app_accent_color,
                ),
              ),
            ],
          ),
          // Delivery Status
          Text(
            _orderDetails?.deliveryStatus ?? "Status not available",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: MyTheme.font_grey,
            ),
          ),
        ],
      ),
    );
  }

  getRefundRequestLabelColor(status) {
    if (status == 0) {
      return Colors.blue;
    } else if (status == 2) {
      return Colors.orange;
    } else if (status == 1) {
      return Colors.green;
    } else {
      return MyTheme.font_grey;
    }
  }

  buildOrderedProductList() {
    if (_orderDetails == null || _orderDetails!.orderDetails == null) {
      return Center(child: Text("No orders found."));
    }

    return ListView.builder(
      itemCount: 1,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: buildOrderedProductItemsCard(index),
        );
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
            icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
            onPressed: () {
              if (widget.go_back == false) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Main();
                }));
              } else {
                return Navigator.of(context).pop();
              }
            }),
      ),
      title: Text(
        LangText(context: context).getLocal().order_details_ucf,
        style: TextStyle(fontSize: 16, color: MyTheme.app_accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  Container buildPaymentStatusCheckContainer(String payment_status) {
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: payment_status == "paid" ? Colors.green : Colors.red),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Icon(payment_status == "paid" ? Icons.check : Icons.close,
            color: Colors.white, size: 10),
      ),
    );
  }
}
