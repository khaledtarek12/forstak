import 'dart:convert';

OrderDetailResponse orderDetailResponseFromJson(String str) =>
    OrderDetailResponse.fromJson(json.decode(str));

String orderDetailResponseToJson(OrderDetailResponse data) =>
    json.encode(data.toJson());

class OrderDetailResponse {
  OrderDetailResponse({this.order, this.deliveryBoy});

  DetailedOrder? order;
  List<DeliveryBoy>? deliveryBoy;

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) =>
      OrderDetailResponse(
        order: json["order"] != null
            ? DetailedOrder.fromJson(json["order"])
            : null,
        deliveryBoy: json["delivery_boys"] != null
            ? List<DeliveryBoy>.from(
                json["delivery_boys"].map((x) => DeliveryBoy.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "order": order?.toJson() ?? {},
        "delivery_boys": deliveryBoy != null
            ? List<dynamic>.from(deliveryBoy!.map((x) => x.toJson()))
            : [],
      };
}

class DetailedOrder {
  DetailedOrder({
    this.id,
    this.combinedOrderId,
    this.userId,
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
    this.orderDetails,
    this.verificationInfo,
    this.paymentDetails,
    this.grandTotal,
    this.couponDiscount,
    this.code,
    this.deliveryBoys,
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
  int? sellerId;
  int? assignDeliveryBoy;
  ShippingAddress? shippingAddress;
  OrderItemDatails? orderDetails;
  DeliveryBoy? deliveryBoys;
  String? additionalInfo;
  String? shippingType;
  String? orderFrom;
  int? pickupPointId;
  int? carrierId;
  String? deliveryStatus;
  String? paymentType;
  int? manualPayment;
  String? manualPaymentData;
  String? paymentStatus;
  String? verificationInfo;
  String? paymentDetails;
  double? grandTotal;
  double? couponDiscount;
  String? code;
  String? trackingCode;
  int? date;
  int? viewed;
  int? deliveryViewed;
  int? cancelRequest;
  int? cancelRequestAt;
  int? paymentStatusViewed;
  int? commissionCalculated;
  String? deliveryHistoryDate;
  String? createdAt;
  String? updatedAt;
  int? type;

  factory DetailedOrder.fromJson(Map<String, dynamic> json) => DetailedOrder(
        id: json["id"] ?? 0,
        combinedOrderId: json["combined_order_id"] ?? 0,
        userId: json["user_id"] ?? 0,
        sellerId: json["seller_id"] ?? 0,
        assignDeliveryBoy: json["assign_delivery_boy"] ?? 0,
        orderDetails: OrderItemDatails.fromJson(json["order_details"] ?? '{}'),
        deliveryBoys:
            DeliveryBoy.fromJson(jsonDecode(json["delivery_boys"] ?? '{}')),
        shippingAddress: ShippingAddress.fromJson(
            jsonDecode(json["shipping_address"] ?? '{}')),
        additionalInfo: json["additional_info"] ?? '',
        shippingType: json["shipping_type"] ?? '',
        orderFrom: json["order_from"] ?? '',
        pickupPointId: json["pickup_point_id"] ?? 0,
        carrierId: json["carrier_id"] ?? 0,
        deliveryStatus: json["delivery_status"] ?? '',
        paymentType: json["payment_type"] ?? '',
        manualPayment: json["manual_payment"] ?? 0,
        manualPaymentData: json["manual_payment_data"] ?? '',
        paymentStatus: json["payment_status"] ?? '',
        verificationInfo: json["verification_info"] ?? '',
        paymentDetails: json["payment_details"] ?? '',
        grandTotal: json["grand_total"]?.toDouble() ?? 0.0,
        couponDiscount: json["coupon_discount"]?.toDouble() ?? 0.0,
        code: json["code"] ?? '',
        trackingCode: json["tracking_code"] ?? '',
        date: json["date"] ?? 0,
        viewed: json["viewed"] ?? 0,
        deliveryViewed: json["delivery_viewed"] ?? 0,
        cancelRequest: json["cancel_request"] ?? 0,
        cancelRequestAt: json["cancel_request_at"] ?? 0,
        paymentStatusViewed: json["payment_status_viewed"] ?? 0,
        commissionCalculated: json["commission_calculated"] ?? 0,
        deliveryHistoryDate: json["delivery_history_date"] ?? '',
        createdAt: json["created_at"] ?? '',
        updatedAt: json["updated_at"] ?? '',
        type: json["type"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? 0,
        "combined_order_id": combinedOrderId ?? 0,
        "user_id": userId ?? 0,
        "seller_id": sellerId ?? 0,
        "assign_delivery_boy": assignDeliveryBoy ?? 0,
        "order_details": jsonEncode(orderDetails?.toJson() ?? {}),
        "delivery_boys": jsonEncode(deliveryBoys?.toJson() ?? {}),
        "shipping_address": jsonEncode(shippingAddress?.toJson() ?? {}),
        "additional_info": additionalInfo ?? '',
        "shipping_type": shippingType ?? '',
        "order_from": orderFrom ?? '',
        "pickup_point_id": pickupPointId ?? 0,
        "carrier_id": carrierId ?? 0,
        "delivery_status": deliveryStatus ?? '',
        "payment_type": paymentType ?? '',
        "manual_payment": manualPayment ?? 0,
        "manual_payment_data": manualPaymentData ?? '',
        "payment_status": paymentStatus ?? '',
        "verification_info": verificationInfo ?? '',
        "payment_details": paymentDetails ?? '',
        "grand_total": grandTotal ?? 0.0,
        "coupon_discount": couponDiscount ?? 0.0,
        "code": code ?? '',
        "tracking_code": trackingCode ?? '',
        "date": date ?? 0,
        "viewed": viewed ?? 0,
        "delivery_viewed": deliveryViewed ?? 0,
        "cancel_request": cancelRequest ?? 0,
        "cancel_request_at": cancelRequestAt ?? 0,
        "payment_status_viewed": paymentStatusViewed ?? 0,
        "commission_calculated": commissionCalculated ?? 0,
        "delivery_history_date": deliveryHistoryDate ?? '',
        "created_at": createdAt ?? '',
        "updated_at": updatedAt ?? '',
        "type": type ?? 0,
      };
}

class ShippingAddress {
  ShippingAddress({
    this.name,
    this.email,
    this.address,
    this.country,
    this.state,
    this.city,
    this.postalCode,
    this.phone,
  });

  String? name;
  dynamic email;
  String? address;
  String? country;
  String? state;
  String? city;
  String? postalCode;
  String? phone;

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      ShippingAddress(
        name: json["name"] ?? '',
        email: json["email"] ?? '',
        address: json["address"] ?? '',
        country: json["country"] ?? '',
        state: json["state"] ?? '',
        city: json["city"] ?? '',
        postalCode: json["postal_code"] ?? '',
        phone: json["phone"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "name": name ?? '',
        "email": email ?? '',
        "address": address ?? '',
        "country": country ?? '',
        "state": state ?? '',
        "city": city ?? '',
        "postal_code": postalCode ?? '',
        "phone": phone ?? '',
      };
}

class DeliveryBoy {
  DeliveryBoy({
    this.id,
    this.referredBy,
    this.provider,
    this.providerId,
    this.refreshToken,
    this.accessToken,
    this.userType,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.verificationCode,
    this.identityVerification,
    this.newEmailVerificationCode,
    this.deviceToken,
    this.avatar,
    this.avatarOriginal,
    this.address,
    this.country,
    this.state,
    this.city,
    this.postalCode,
    this.phone,
    this.balance,
    this.banned,
    this.referralCode,
    this.customerPackageId,
    this.remainingUploads,
    this.createdAt,
    this.updatedAt,
    this.whatsappAuthEnabled,
    this.whatsappAuthCode,
    this.referredByUser,
    this.whatsappAuthCodeRequested,
    this.categories,
    this.serviceType,
  });

  int? id;
  String? referredBy;
  String? provider;
  String? providerId;
  String? refreshToken;
  String? accessToken;
  String? userType;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? verificationCode;
  int? identityVerification;
  String? newEmailVerificationCode;
  String? deviceToken;
  String? avatar;
  String? avatarOriginal;
  String? address;
  String? country;
  String? state;
  String? city;
  String? postalCode;
  String? phone;
  double? balance;
  int? banned;
  String? referralCode;
  String? customerPackageId;
  int? remainingUploads;
  String? createdAt;
  String? updatedAt;
  int? whatsappAuthEnabled;
  String? whatsappAuthCode;
  String? referredByUser;
  String? whatsappAuthCodeRequested;
  String? categories;
  String? serviceType;

  factory DeliveryBoy.fromJson(Map<String, dynamic> json) => DeliveryBoy(
        id: json["id"] ?? 0,
        referredBy: json["referred_by"] ?? '',
        provider: json["provider"] ?? '',
        providerId: json["provider_id"] ?? '',
        refreshToken: json["refresh_token"] ?? '',
        accessToken: json["access_token"] ?? '',
        userType: json["user_type"] ?? '',
        name: json["name"] ?? '',
        email: json["email"] ?? '',
        emailVerifiedAt: json["email_verified_at"] ?? '',
        verificationCode: json["verification_code"] ?? '',
        identityVerification: json["identity_verification"] ?? 0,
        newEmailVerificationCode: json["new_email_verificiation_code"] ?? '',
        deviceToken: json["device_token"] ?? '',
        avatar: json["avatar"] ?? '',
        avatarOriginal: json["avatar_original"] ?? '',
        address: json["address"] ?? '',
        country: json["country"] ?? '',
        state: json["state"] ?? '',
        city: json["city"] ?? '',
        postalCode: json["postal_code"] ?? '0',
        phone: json["phone"] ?? '',
        balance: (json["balance"] as num?)?.toDouble() ?? 0.0,
        banned: json["banned"] ?? 0,
        referralCode: json["referral_code"] ?? '',
        customerPackageId: json["customer_package_id"] ?? '',
        remainingUploads: json["remaining_uploads"] ?? 0,
        createdAt: json["created_at"] ?? '',
        updatedAt: json["updated_at"] ?? '',
        whatsappAuthEnabled: json["whatsapp_auth_enabled"] ?? 0,
        whatsappAuthCode: json["whatsapp_auth_code"],
        referredByUser: json["referredByUser"] ?? '',
        whatsappAuthCodeRequested: json["whatsapp_auth_code_requested"] ?? '',
        categories: json["Categories"] ?? '',
        serviceType: json["service_type"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? 0,
        "referred_by": referredBy ?? '',
        "provider": provider ?? '',
        "provider_id": providerId ?? '',
        "refresh_token": refreshToken ?? '',
        "access_token": accessToken ?? '',
        "user_type": userType ?? '',
        "name": name ?? '',
        "email": email ?? '',
        "email_verified_at": emailVerifiedAt ?? '',
        "verification_code": verificationCode ?? '',
        "identity_verification": identityVerification ?? 0,
        "new_email_verificiation_code": newEmailVerificationCode ?? '',
        "device_token": deviceToken ?? '',
        "avatar": avatar ?? '',
        "avatar_original": avatarOriginal ?? '',
        "address": address ?? '',
        "country": country ?? '',
        "state": state ?? '',
        "city": city ?? '',
        "postal_code": postalCode ?? '',
        "phone": phone ?? '',
        "balance": balance ?? 0.0,
        "banned": banned ?? 0,
        "referral_code": referralCode ?? '',
        "customer_package_id": customerPackageId ?? '',
        "remaining_uploads": remainingUploads ?? 0,
        "created_at": createdAt ?? '',
        "updated_at": updatedAt ?? '',
        "whatsapp_auth_enabled": whatsappAuthEnabled ?? 0,
        "whatsapp_auth_code": whatsappAuthCode ?? '',
        "referredByUser": referredByUser ?? '',
        "whatsapp_auth_code_requested": whatsappAuthCodeRequested ?? '',
        "Categories": categories ?? '',
        "service_type": serviceType ?? '',
      };
}

class OrderItemDatails {
  OrderItemDatails({
    this.id,
    this.productName,
    this.quantity,
    this.price,
    this.total,
    this.shippingAddress,
    this.viewed,
  });

  int? id;
  String? productName;
  int? quantity;
  double? price;
  double? total;
  ShippingAddress? shippingAddress;
  int? viewed;

  factory OrderItemDatails.fromJson(Map<String, dynamic> json) =>
      OrderItemDatails(
        id: json["id"] ?? 0,
        productName: json["product_name"] ?? 'Unknown Product',
        quantity: json["quantity"] ?? 0,
        price: (json["price"] as num?)?.toDouble() ?? 0,
        total: (json["total"] as num?)?.toDouble() ?? 0,
        shippingAddress: json["shipping_address"] != null
            ? ShippingAddress.fromJson(json["shipping_address"])
            : null,
        viewed: json["viewed"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_name": productName,
        "quantity": quantity,
        "price": price,
        "total": total,
        "shipping_address": shippingAddress?.toJson(),
        "viewed": viewed,
      };
}

class OrderItem {
  OrderItem({
    this.name,
    this.description,
    this.deliveryStatus,
    this.price,
  });

  String? name;
  String? description;
  String? deliveryStatus;
  String? price;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        name: json["name"] ?? '',
        description: json["description"] ?? '',
        deliveryStatus: json["delivery_status"] ?? '',
        price: json["price"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "name": name ?? '',
        "description": description ?? '',
        "delivery_status": deliveryStatus ?? '',
        "price": price ?? '',
      };
}
