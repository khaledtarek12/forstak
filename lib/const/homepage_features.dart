import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:active_ecommerce_seller_app/screens/product_queries/product_queries.dart';
import 'package:flutter/material.dart';

import '../custom/route_transaction.dart';
import '../helpers/shared_value_helper.dart';
import '../my_theme.dart';
import '../screens/chat_list.dart';
import '../screens/coupon/coupons.dart';
import '../screens/money_withdraw.dart';
import '../screens/payment_history.dart';
import '../screens/refund_request.dart';

class FeaturesList {
  BuildContext context;

  FeaturesList(this.context);

  static List<Map<String, dynamic>> featuresData(BuildContext context) {
    return [
      {
        "title": LangText(context: context).getLocal().product_queries_ucf,
        "icon": 'assets/icon/pos_system.png',
        "visible": product_query_activation.$,
        "onTap": () {
          MyTransaction(context: context).push(const ProductQueries());
        }
      },
      {
        "title": LangText(context: context).getLocal().messages_ucf,
        "icon": 'assets/icon/chat.png',
        "visible": conversation_activation.$,
        "onTap": () {
          MyTransaction(context: context).push(const ChatList());
        }
      },
      {
        "title": LangText(context: context).getLocal().refund_requests_ucf,
        "icon": 'assets/icon/refund.png',
        "visible": true,
        "onTap": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const RefundRequest()));
        }
      },
      {
        "title": LangText(context: context).getLocal().coupons_ucf,
        "icon": 'assets/icon/coupon.png',
        "visible": coupon_activation.$,
        "onTap": () {
          MyTransaction(context: context).push(const Coupons());
        }
      },
      {
        "title": LangText(context: context).getLocal().money_withdraw_ucf,
        "icon": 'assets/icon/withdraw.png',
        "visible": true,
        "onTap": () {
          MyTransaction(context: context).push(const MoneyWithdraw());
        }
      },
      {
        "title": LangText(context: context).getLocal().payment_history_ucf,
        "icon": 'assets/icon/payment_history.png',
        "visible": true,
        "onTap": () {
          MyTransaction(context: context).push(const PaymentHistory());
        }
      }
    ];
  }

  static List<Widget> getFeatureList(BuildContext context) {
    List<Map<String, dynamic>> features = featuresData(context);
    List<Widget> featureList = [];

    for (var feature in features) {
      featureList.add(
        Visibility(
          visible: feature["visible"],
          child: InkWell(
            onTap: feature["onTap"],
            child: SizedBox(
              height: 40,
              child: Column(
                children: [
                  Image.asset(
                    feature["icon"],
                    width: 16,
                    height: 16,
                    color: MyTheme.white,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    feature["title"],
                    style: TextStyle(fontSize: 12, color: MyTheme.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return featureList;
  }

// List<Map<String, String>> getFeatureList() {
  //   List<Map<String, String>> featureList = [];
  //
  //   featureList.add({
  //     'image': 'assets/icon/pos_system.png',
  //     'title': 'Pos Manager',
  //   });
  //
  //   featureList.add({
  //     'image': 'assets/icon/chat.png',
  //     'title': LangText(context: context).getLocal().messages_ucf,
  //   });
  //
  //   featureList.add({
  //     'image': 'assets/icon/refund.png',
  //     'title': LangText(context: context).getLocal().refund_requests_ucf,
  //   });
  //
  //   featureList.add({
  //     'image': 'assets/icon/coupon.png',
  //     'title': LangText(context: context).getLocal().coupons_ucf,
  //   });
  //
  //   featureList.add({
  //     'image': 'assets/icon/withdraw.png',
  //     'title': LangText(context: context).getLocal().money_withdraw_ucf,
  //   });
  //
  //   featureList.add({
  //     'image': 'assets/icon/payment_history.png',
  //     'title': LangText(context: context).getLocal().payment_history_ucf,
  //   });
  //
  //   return featureList;
  // }

  ///------///
// List<Widget> getFeatureList() {
//     List<Widget> featureList = [];
//     featureList.add(Visibility(
//       visible: pos_manager_activation.$,
//       child: InkWell(
//           onTap: () {
//             MyTransaction(context: context).push(const PosManager());
//           },
//           child: SizedBox(
//             height: 40,
//             child: Column(
//               children: [
//                 Image.asset(
//                   'assets/icon/pos_system.png',
//                   width: 16,
//                   height: 16,
//                   color: MyTheme.white,
//                 ),
//                 const SizedBox(
//                   height: 5,
//                 ),
//                 Text(
//                   "Pos Manager",
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: MyTheme.white,
//                   ),
//                 ),
//               ],
//             ),
//           )),
//     ));
//     featureList.add(Visibility(
//       visible: conversation_activation.$,
//       child: InkWell(
//           onTap: () {
//             MyTransaction(context: context).push(ChatList());
//           },
//           child: Container(
//             height: 40,
//             child: Column(
//               children: [
//                 Image.asset(
//                   'assets/icon/chat.png',
//                   width: 16,
//                   height: 16,
//                   color: MyTheme.white,
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Text(
//                   LangText(context: context).getLocal()!.messages_ucf,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: MyTheme.white,
//                   ),
//                 ),
//               ],
//             ),
//           )),
//     ));
//     featureList.add(
//       Visibility(
//         visible: refund_addon.$,
//         child: InkWell(
//             onTap: () {
//               //MyTransaction(context: context).push(RefundRequest());
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => RefundRequest()));
//             },
//             child: Container(
//               height: 40,
//               child: Column(
//                 children: [
//                   Image.asset(
//                     'assets/icon/refund.png',
//                     width: 16,
//                     height: 16,
//                     color: MyTheme.white,
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Text(
//                     LangText(context: context).getLocal()!.refund_requests_ucf,
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: MyTheme.white,
//                     ),
//                   ),
//                 ],
//               ),
//             )),
//       ),
//     );
//     /*featureList.add(InkWell(
//           onTap: () {
//             MyTransaction(context: context).push(SupportTicket());
//           },
//           child: Container(
//             width: DeviceInfo(context).getWidth() / 3.5,
//             height:40,
//             child: Column(
//               children: [
//                 Image.asset(
//                   'assets/icon/support_ticket.png',
//                   width: 16,
//                   height: 16,
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Text(
//                   LangText(context: context)
//                       .getLocal()
//                       .dashboard_support_tickets,
//                   style:
//                   TextStyle(fontSize: 12, color: Colors.white),
//                 ),
//               ],
//             ),
//           )),);*/
//     featureList.add(
//       Visibility(
//         visible: coupon_activation.$,
//         child: InkWell(
//             onTap: () {
//               MyTransaction(context: context).push(Coupons());
//             },
//             child: Container(
//               height: 40,
//               child: Column(
//                 children: [
//                   Image.asset(
//                     'assets/icon/coupon.png',
//                     width: 16,
//                     height: 16,
//                     color: MyTheme.white,
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Text(
//                     LangText(context: context).getLocal()!.coupons_ucf,
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: MyTheme.white,
//                     ),
//                   ),
//                 ],
//               ),
//             )),
//       ),
//     );
//     featureList.add(
//       InkWell(
//           onTap: () {
//             MyTransaction(context: context).push(MoneyWithdraw());
//           },
//           child: Container(
//             height: 40,
//             child: Column(
//               children: [
//                 Image.asset(
//                   'assets/icon/withdraw.png',
//                   width: 16,
//                   height: 16,
//                   color: MyTheme.white,
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Text(
//                   LangText(context: context).getLocal()!.money_withdraw_ucf,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: MyTheme.white,
//                   ),
//                 ),
//               ],
//             ),
//           )),
//     );
//     featureList.add(
//       InkWell(
//           onTap: () {
//             MyTransaction(context: context).push(PaymentHistory());
//           },
//           child: Container(
//             height: 40,
//             child: Column(
//               children: [
//                 Image.asset(
//                   'assets/icon/payment_history.png',
//                   width: 16,
//                   height: 16,
//                   color: MyTheme.white,
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Text(
//                   LangText(context: context).getLocal()!.payment_history_ucf,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: MyTheme.white,
//                   ),
//                 ),
//               ],
//             ),
//           )),
//     );
//     return featureList;
//   }
}
