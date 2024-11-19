// To parse this JSON data, do
//
//     final orderListResponse = orderListResponseFromJson(jsonString);

import 'dart:convert';

OrderListResponse orderListResponseFromJson(String str) =>
    OrderListResponse.fromJson(json.decode(str));

String orderListResponseToJson(OrderListResponse data) =>
    json.encode(data.toJson());

class OrderListResponse {
  OrderListResponse({
    this.data,
    this.links,
    this.currentPage,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int? currentPage;
  List<Order>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  factory OrderListResponse.fromJson(Map<String, dynamic> json) {
    return OrderListResponse(
      data: json["data"] != null
          ? List<Order>.from(json["data"].map((x) => Order.fromJson(x)))
          : [],
      links: json["links"] != null
          ? List<Link>.from(json["links"].map((x) => Link.fromJson(x)))
          : [],
      currentPage: json["current_page"],
      firstPageUrl: json["first_page_url"],
      from: json["from"],
      lastPage: json["last_page"],
      lastPageUrl: json["last_page_url"],
      nextPageUrl: json["next_page_url"],
      path: json["path"],
      perPage: json["per_page"],
      prevPageUrl: json["prev_page_url"],
      to: json["to"],
      total: json["total"],
    );
  }

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "links": List<dynamic>.from(links!.map((x) => x.toJson())),
        "current_page": currentPage,
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Order {
  Order({
    this.id,
    this.combinedOrderId,
    this.userId,
    this.guestId,
    this.sellerId,
    this.assignDeliveryBoy,
    this.shippingAddress,
    this.additionalInfo,
    this.shippingType,
    this.orderFrom,
    this.pickupPointId,
    this.carrierId,
    this.deliveryStatus,
    this.paymentType,
    this.manualPayment,
    this.manualPaymentData,
    this.paymentStatus,
    this.verificationInfo,
    this.paymentDetails,
    this.grandTotal,
    this.couponDiscount,
    this.code,
    this.trackingCode,
    this.date,
    this.viewed,
    this.deliveryViewed,
    this.cancelRequest,
    this.cancelRequestAt,
    this.paymentStatusViewed,
    this.commissionCalculated,
    this.deliveryHistoryDate,
    this.createdAt,
    this.updatedAt,
    this.type,
  });

  int? id;
  int? combinedOrderId;
  int? userId;
  int? guestId;
  int? sellerId;
  int? assignDeliveryBoy;
  String?
      shippingAddress; // This could be a String or a Map depending on your needs
  String? additionalInfo;
  String? shippingType;
  String? orderFrom;
  int? pickupPointId;
  int? carrierId;
  String? deliveryStatus;
  String? paymentType;
  int? manualPayment;
  String?
      manualPaymentData; // This can be a String or a more complex structure depending on the data
  String? paymentStatus;
  String? verificationInfo;
  String? paymentDetails;
  double? grandTotal;
  double? couponDiscount;
  String? code;
  String? trackingCode;
  int? date; // Timestamp
  bool? viewed;
  bool? deliveryViewed;
  bool? cancelRequest;
  int? cancelRequestAt;
  bool? paymentStatusViewed;
  bool? commissionCalculated;
  String? deliveryHistoryDate;
  String? createdAt;
  String? updatedAt;
  int? type;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        combinedOrderId: json["combined_order_id"],
        userId: json["user_id"],
        guestId: json["guest_id"],
        sellerId: json["seller_id"],
        assignDeliveryBoy: json["assign_delivery_boy"],
        shippingAddress: json["shipping_address"],
        additionalInfo: json["additional_info"],
        shippingType: json["shipping_type"],
        orderFrom: json["order_from"],
        pickupPointId: json["pickup_point_id"],
        carrierId: json["carrier_id"],
        deliveryStatus: json["delivery_status"],
        paymentType: json["payment_type"],
        manualPayment: json["manual_payment"],
        manualPaymentData: json["manual_payment_data"],
        paymentStatus: json["payment_status"],
        verificationInfo: json["verification_info"],
        paymentDetails: json["payment_details"],
        grandTotal: json["grand_total"]?.toDouble(),
        couponDiscount: json["coupon_discount"]?.toDouble(),
        code: json["code"],
        trackingCode: json["tracking_code"],
        date: json["date"],
        viewed: json["viewed"] == 1,
        deliveryViewed: json["delivery_viewed"] == 1,
        cancelRequest: json["cancel_request"] == 1,
        cancelRequestAt: json["cancel_request_at"],
        paymentStatusViewed: json["payment_status_viewed"] == 1,
        commissionCalculated: json["commission_calculated"] == 1,
        deliveryHistoryDate:
            DateTime.parse(json["delivery_history_date"]).toString(),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "combined_order_id": combinedOrderId,
        "user_id": userId,
        "guest_id": guestId,
        "seller_id": sellerId,
        "assign_delivery_boy": assignDeliveryBoy,
        "shipping_address": shippingAddress,
        "additional_info": additionalInfo,
        "shipping_type": shippingType,
        "order_from": orderFrom,
        "pickup_point_id": pickupPointId,
        "carrier_id": carrierId,
        "delivery_status": deliveryStatus,
        "payment_type": paymentType,
        "manual_payment": manualPayment,
        "manual_payment_data": manualPaymentData,
        "payment_status": paymentStatus,
        "verification_info": verificationInfo,
        "payment_details": paymentDetails,
        "grand_total": grandTotal,
        "coupon_discount": couponDiscount,
        "code": code,
        "tracking_code": trackingCode,
        "date": date,
        "viewed": viewed == true ? 1 : 0,
        "delivery_viewed": deliveryViewed == true ? 1 : 0,
        "cancel_request": cancelRequest == true ? 1 : 0,
        "cancel_request_at": cancelRequestAt,
        "payment_status_viewed": paymentStatusViewed == true ? 1 : 0,
        "commission_calculated": commissionCalculated == true ? 1 : 0,
        "delivery_history_date": deliveryHistoryDate,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "type": type,
      };
}

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  String? url;
  String? label;
  bool? active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
