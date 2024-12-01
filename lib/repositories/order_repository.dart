// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:active_ecommerce_seller_app/api_request.dart';
import 'package:active_ecommerce_seller_app/app_config.dart';
import 'package:active_ecommerce_seller_app/data_model/common_response.dart';
import 'package:active_ecommerce_seller_app/data_model/order_detail_response.dart';
import 'package:active_ecommerce_seller_app/data_model/order_mini_response.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';

class OrderRepository {
  Future<OrderListResponse> getOrderList(
      {page = 1, payment_status = "", delivery_status = ""}) async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/orders"
        "?page=$page&payment_status=$payment_status&delivery_status=$delivery_status");

    // print("get order list url " + url.toString());

    final response = await ApiRequest.get(url: url, headers: {
      "Authorization": "Bearer ${access_token.$}",
      "App-Language": app_language.$!,
    });
    return orderListResponseFromJson(response.body);
  }

  Future<OrderListResponse> getAuctionOrderList(
      {page = 1, payment_status = "", delivery_status = ""}) async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/auction-products/orders"
        "?page=$page&payment_status=$payment_status&delivery_status=$delivery_status");

    final response = await ApiRequest.get(url: url, headers: {
      "Authorization": "Bearer ${access_token.$}",
      "App-Language": app_language.$!,
    });
    return orderListResponseFromJson(response.body);
  }

  Future<OrderDetailResponse> getOrderDetails({int? id = 0}) async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/order/$id");
    // print("details url:" + url.toString());
    final response = await ApiRequest.get(url: url, headers: {
      "Authorization": "Bearer ${access_token.$}",
      "App-Language": app_language.$!,
    });
    //print("url:" +url.toString());
    // print("order details " + response.body);
    return orderDetailResponseFromJson(response.body);
  }

  Future<CommonResponse> updateDeliveryStatus(
      {int? id = 0, required String status, String? paymentType = ""}) async {
    String url =
        ("${AppConfig.BASE_URL_WITH_PREFIX}/orders/update-delivery-status");

    var post_body = jsonEncode(
        {"order_id": "$id", "status": status, "payment_type": paymentType});
    // print(post_body);

    final response = await ApiRequest.post(url: url, body: post_body, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${access_token.$}",
      "App-Language": app_language.$!,
    });
    // print("update result" + response.body);

    return commonResponseFromJson(response.body);
  }

  //  headers: {
  //       "Content-Type": "application/json",
  //       "Authorization":
  //           "Bearer ${access_token.$}", // Replace with actual token
  //       "App-Language": app_language.$!, // Replace with actual language
  //     },

  Future<Map<String, dynamic>> sendOrderIdAndDeliveryBoy({
    required int orderId,
    required int deliveryBoy,
  }) async {
    final String url = "https://forsatc.com/api/v2/seller/assign-delivery-boy";

    var body = {
      "order_id": "$orderId",
      "delivery_boy": "$deliveryBoy",
    };

    try {
      final response = await ApiRequest.post(
        url: url,
        body: jsonEncode(body), // Convert the body to JSON
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer ${access_token.$}", // Replace with actual token
          "App-Language": app_language.$!, // Replace with actual language
        },
      );

      // Handle success response
      if (response.statusCode == 200) {
        final reeeeesponse = jsonDecode(response.body);
        log('Correct: ${reeeeesponse["message"]}, Status Code: ${response.statusCode}');

        return jsonDecode(response.body); // Parse and return the response
      } else {
        // Log the status and error message
        final errorResponse = jsonDecode(response.body);
        log('Error: ${errorResponse["message"]}, Status Code: ${response.statusCode}');
        return {
          "message": errorResponse["message"] ?? "Unknown error occurred",
          "status": response.statusCode,
          "success": false,
        };
      }
    } catch (e) {
      log('Exception: $e');
      return {
        "message": "An exception occurred: $e",
        "success": false,
      };
    }
  }

  Future<CommonResponse> updatePaymentStatus(
      {int? id = 0, required String status}) async {
    String url =
        ("${AppConfig.BASE_URL_WITH_PREFIX}/orders/update-payment-status");

    var post_body = jsonEncode({"order_id": "$id", "status": status});

    final response = await ApiRequest.post(url: url, body: post_body, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${access_token.$}",
      "App-Language": app_language.$!,
    });
    // print("update result" + response.body);

    return commonResponseFromJson(response.body);
  }
}
