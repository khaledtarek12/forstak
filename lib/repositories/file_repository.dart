// ignore_for_file: non_constant_identifier_names

import 'package:active_ecommerce_seller_app/api_request.dart';
import 'package:active_ecommerce_seller_app/app_config.dart';
import 'package:active_ecommerce_seller_app/data_model/simple_image_upload_response.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'dart:convert';

class FileRepository {
  Future<SimpleImageUploadResponse> getSimpleImageUploadResponse(
      String image, String filename) async {
    var post_body = jsonEncode({"image": image, "filename": filename});
    //print(post_body.toString());

    String url = ("${AppConfig.BASE_URL}/file/image-upload");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: post_body);

    //print(response.body.toString());
    return simpleImageUploadResponseFromJson(response.body);
  }
}
