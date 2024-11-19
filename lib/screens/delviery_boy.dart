import 'package:active_ecommerce_seller_app/custom/my_app_bar.dart';
import 'package:active_ecommerce_seller_app/data_model/order_detail_response.dart';
import 'package:flutter/material.dart';

class DelvieryBoyScreen extends StatelessWidget {
  const DelvieryBoyScreen(
      {super.key, required this.deliveryBoys, required this.boyId});

  final List<DeliveryBoy> deliveryBoys;
  final int boyId;

  @override
  Widget build(BuildContext context) {
    // Filter delivery boys where the id matches the assigned delivery boy's id
    final filteredDeliveryBoys =
        deliveryBoys.where((deliveryBoy) => deliveryBoy.id == boyId).toList();

    return Scaffold(
      appBar: MyAppBar(
        context: context,
        title: 'فتي التوصيل',
      ).show(),
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: filteredDeliveryBoys.isEmpty
            ? const Center(
                child: Text(
                  "لم يتم اضافه بيانات فتي التوصيل المطلوب",
                  style: TextStyle(fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: filteredDeliveryBoys.length,
                itemBuilder: (context, index) {
                  final deliveryBoy = filteredDeliveryBoys[index];
                  return DeliveryBoyCard(
                    userType: deliveryBoy.userType ?? "N/A",
                    name: deliveryBoy.name ?? "N/A",
                    email: deliveryBoy.email ?? "N/A",
                    address: deliveryBoy.address ?? "N/A",
                    country: deliveryBoy.country ?? "N/A",
                    state: deliveryBoy.state ?? "N/A",
                    city: deliveryBoy.city ?? "N/A",
                    phone: deliveryBoy.phone ?? "N/A",
                    postalCode: deliveryBoy.postalCode ?? "N/A",
                  );
                },
              ),
      ),
    );
  }
}

class DeliveryBoyCard extends StatelessWidget {
  final String userType;
  final String name;
  final String email;
  final String address;
  final String country;
  final String state;
  final String city;
  final String phone;
  final String? postalCode;

  const DeliveryBoyCard({
    super.key,
    required this.userType,
    required this.name,
    required this.email,
    required this.address,
    required this.country,
    required this.state,
    required this.city,
    required this.phone,
    this.postalCode,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRow("User Type:", userType),
              _buildRow("Name:", name),
              _buildRow("Email:", email),
              _buildRow("Address:", address),
              _buildRow("Country:", country),
              _buildRow("State:", state),
              _buildRow("City:", city),
              _buildRow("Phone:", phone),
              _buildRow("Postal Code:", postalCode ?? "N/A"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title   ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
