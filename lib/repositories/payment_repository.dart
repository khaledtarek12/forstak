// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:active_ecommerce_seller_app/api_request.dart';
import 'package:active_ecommerce_seller_app/app_config.dart';
import 'package:active_ecommerce_seller_app/data_model/offline_payment_response.dart';
import 'package:active_ecommerce_seller_app/data_model/payment_type_response.dart';
import 'package:active_ecommerce_seller_app/data_model/payments/bkash_begin_response.dart';
import 'package:active_ecommerce_seller_app/data_model/payments/bkash_payment_process_response.dart';
import 'package:active_ecommerce_seller_app/data_model/payments/flutterwave_url_response.dart';
import 'package:active_ecommerce_seller_app/data_model/payments/iyzico_payment_success_response.dart';
import 'package:active_ecommerce_seller_app/data_model/payments/nagad_begin_response.dart';
import 'package:active_ecommerce_seller_app/data_model/payments/nagad_payment_process_response.dart';
import 'package:active_ecommerce_seller_app/data_model/payments/paypal_url_response.dart';
import 'package:active_ecommerce_seller_app/data_model/payments/paystack_payment_success_response.dart';
import 'package:active_ecommerce_seller_app/data_model/payments/razorpay_payment_success_response.dart';
import 'package:active_ecommerce_seller_app/data_model/payments/sslcommerz_begin_response.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';

class PaymentRepository {
  Future<List<PaymentTypeResponse>> getPaymentResponseList(
      {mode = "", list = "both"}) async {
    String url =
        ("${AppConfig.BASE_URL}/payment-types?mode=$mode&list=$list");
    // print(url.toString() + " url.toString()");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}"
    });

    // print("payment-types"+response.body.toString());

    return paymentTypeResponseFromJson(response.body);
  }

  Future<PaypalUrlResponse> getPaypalUrlResponse(
      String payment_type,
       int combined_order_id,
       var package_id,
       double amount) async {
    String url =
        ("${AppConfig.BASE_URL}/paypal/payment/url?payment_type=$payment_type&combined_order_id=$combined_order_id&amount=$amount&user_id=${seller_id.$}&package_id=$package_id");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });

    return paypalUrlResponseFromJson(response.body);
  }

  Future<FlutterwaveUrlResponse> getFlutterwaveUrlResponse(
       String payment_type,
       int combined_order_id,
       var package_id,
       double amount) async {
    String url =
        ("${AppConfig.BASE_URL}/flutterwave/payment/url?payment_type=$payment_type&combined_order_id=$combined_order_id&amount=$amount&user_id=${seller_id.$}&package_id=$package_id");

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });

    //print(url);
    //print(response.body.toString());
    return flutterwaveUrlResponseFromJson(response.body);
  }

  Future<RazorpayPaymentSuccessResponse> getRazorpayPaymentSuccessResponse(
       payment_type,
       double amount,
       int combined_order_id,
       String? payment_details) async {
    var post_body = jsonEncode({
      "user_id": "${seller_id.$}",
      "payment_type": "$payment_type",
      "combined_order_id": "$combined_order_id",
      "amount": "$amount",
      "payment_details": "$payment_details"
    });

    // print(post_body.toString());

    String url = ("${AppConfig.BASE_URL}/razorpay/success");

    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: post_body);

    //print(response.body.toString());
    return razorpayPaymentSuccessResponseFromJson(response.body);
  }

  Future<PaystackPaymentSuccessResponse> getPaystackPaymentSuccessResponse(
       payment_type,
       double amount,
       int combined_order_id,
       String? payment_details) async {
    var post_body = jsonEncode({
      "user_id": "${seller_id.$}",
      "payment_type": "$payment_type",
      "combined_order_id": "$combined_order_id",
      "amount": "$amount",
      "payment_details": "$payment_details"
    });

    String url = ("${AppConfig.BASE_URL}/paystack/success");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}"
        },
        body: post_body);

    //print(response.body.toString());
    return paystackPaymentSuccessResponseFromJson(response.body);
  }

  Future<IyzicoPaymentSuccessResponse> getIyzicoPaymentSuccessResponse(
       payment_type,
       double amount,
       int combined_order_id,
       String? payment_details) async {
    var post_body = jsonEncode({
      "user_id": "${seller_id.$}",
      "payment_type": "$payment_type",
      "combined_order_id": "$combined_order_id",
      "amount": "$amount",
      "payment_details": "$payment_details"
    });

    String url = ("${AppConfig.BASE_URL}/paystack/success");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}"
        },
        body: post_body);

    //print(response.body.toString());
    return iyzicoPaymentSuccessResponseFromJson(response.body);
  }

  Future<BkashBeginResponse> getBkashBeginResponse(
       String payment_type,
       int combined_order_id,
       var package_id,
       double amount) async {
    String url =
        ("${AppConfig.BASE_URL}/bkash/begin?payment_type=$payment_type&combined_order_id=$combined_order_id&amount=$amount&user_id=${seller_id.$}&package_id=$package_id");

    final response = await ApiRequest.get(
      url: url,
      headers: {"Authorization": "Bearer ${access_token.$}"},
    );

    // print(response.body.toString());
    return bkashBeginResponseFromJson(response.body);
  }

  Future<BkashPaymentProcessResponse> getBkashPaymentProcessResponse({
    required payment_type,
    required double amount,
    required int combined_order_id,
    required String? payment_id,
    required String? token,
    required String? package_id,
  }) async {
    var post_body = jsonEncode({
      "user_id": "${seller_id.$}",
      "payment_type": "$payment_type",
      "combined_order_id": "$combined_order_id",
      "package_id": "$package_id",
      "amount": "$amount",
      "payment_id": "$payment_id",
      "token": "$token"
    });

    String url = ("${AppConfig.BASE_URL}/bkash/api/success");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        body: post_body);

    //print(response.body.toString());
    return bkashPaymentProcessResponseFromJson(response.body);
  }

  Future<SslcommerzBeginResponse> getSslcommerzBeginResponse(
       String payment_type,
       int combined_order_id,
       String package_id,
       double amount) async {
    String url =
        ("${AppConfig.BASE_URL}/sslcommerz/begin?payment_type=$payment_type&combined_order_id=$combined_order_id&amount=$amount&user_id=${seller_id.$}&package_id=$package_id");

    final response = await ApiRequest.get(
      url: url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!
      },
    );

    // print(response.body.toString());
    return sslcommerzBeginResponseFromJson(response.body);
  }

  Future<NagadBeginResponse> getNagadBeginResponse(
       String payment_type,
       int combined_order_id,
       var package_id,
       double amount) async {
    String url =
        ("${AppConfig.BASE_URL}/nagad/begin?payment_type=$payment_type&combined_order_id=$combined_order_id&amount=$amount&user_id=${seller_id.$}&package_id=$package_id");

    final response = await ApiRequest.get(
      url: url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!
      },
    );

    // print(response.body.toString());
    return nagadBeginResponseFromJson(response.body);
  }

  Future<NagadPaymentProcessResponse> getNagadPaymentProcessResponse(
       payment_type,
       double amount,
       int combined_order_id,
       String? payment_details) async {
    var post_body = jsonEncode({
      "user_id": "${seller_id.$}",
      "payment_type": "$payment_type",
      "combined_order_id": "$combined_order_id",
      "amount": "$amount",
      "payment_details": "$payment_details"
    });

    String url = ("${AppConfig.BASE_URL}/nagad/process");

    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        body: post_body);

    //print(response.body.toString());
    return nagadPaymentProcessResponseFromJson(response.body);
  }

  Future<OfflinePaymentResponse> getOfflinePaymentResponse(
      {required String amount,
      required String name,
      required String trx_id,
      required int? package_id,
      required int? photo}) async {
    var post_body = jsonEncode({
      "package_id": package_id,
      "amount": amount,
      "payment_option": "Offline Payment",
      "trx_id": trx_id,
      "photo": "$photo",
    });
    String url =
        ("${AppConfig.BASE_URL_WITH_PREFIX}/seller-package/offline-payment");
    // print("offline payment url " + url.toString());

    // print("offline payment url " + post_body.toString());
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: post_body);

    // print("hello Offline wallet recharge" + response.body.toString());
    return offlinePaymentResponseFromJson(response.body);
  }
}
