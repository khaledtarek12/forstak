import 'dart:convert';

PosCustomerListResponse posCustomerListResponseFromJson(String str) =>
    PosCustomerListResponse.fromJson(json.decode(str));

String posCustomerListResponseToJson(PosCustomerListResponse data) =>
    json.encode(data.toJson());

class PosCustomerListResponse {
  List<Datum>? data;

  PosCustomerListResponse({
    this.data,
  });

  factory PosCustomerListResponse.fromJson(List<dynamic> json) =>
      PosCustomerListResponse(
        data: List<Datum>.from(json.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
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
  int? identityVerification;
  String? verificationCode;
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

  Datum({
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
    this.identityVerification,
    this.verificationCode,
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

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        referredBy: json["referred_by"].toString(),
        provider: json["provider"],
        providerId: json["provider_id"],
        refreshToken: json["refresh_token"],
        accessToken: json["access_token"],
        userType: json["user_type"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        identityVerification: json["identity_verification"],
        verificationCode: json["verification_code"],
        newEmailVerificationCode: json["new_email_verificiation_code"],
        deviceToken: json["device_token"],
        avatar: json["avatar"],
        avatarOriginal: json["avatar_original"],
        address: json["address"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        postalCode: json["postal_code"],
        phone: json["phone"],
        balance: json["balance"] != null ? json["balance"].toDouble() : 0.0,
        banned: json["banned"],
        referralCode: json["referral_code"],
        customerPackageId: json["customer_package_id"].toString(),
        remainingUploads: json["remaining_uploads"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        whatsappAuthEnabled: json["whatsapp_auth_enabled"],
        whatsappAuthCode: json["whatsapp_auth_code"],
        referredByUser: json["referredByUser"] ?? '',
        whatsappAuthCodeRequested: json["whatsapp_auth_code_requested"],
        categories: json["Categories"] ?? '',
        serviceType: json["service_type"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "referred_by": referredBy,
        "provider": provider,
        "provider_id": providerId,
        "refresh_token": refreshToken,
        "access_token": accessToken,
        "user_type": userType,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "identity_verification": identityVerification,
        "verification_code": verificationCode,
        "new_email_verificiation_code": newEmailVerificationCode,
        "device_token": deviceToken,
        "avatar": avatar,
        "avatar_original": avatarOriginal,
        "address": address,
        "country": country,
        "state": state,
        "city": city,
        "postal_code": postalCode,
        "phone": phone,
        "balance": balance,
        "banned": banned,
        "referral_code": referralCode,
        "customer_package_id": customerPackageId,
        "remaining_uploads": remainingUploads,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "whatsapp_auth_enabled": whatsappAuthEnabled,
        "whatsapp_auth_code": whatsappAuthCode,
        "referredByUser": referredByUser,
        "whatsapp_auth_code_requested": whatsappAuthCodeRequested,
        "Categories": categories,
        "service_type": serviceType,
      };
}
