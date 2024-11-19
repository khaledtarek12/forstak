// ignore_for_file: use_build_context_synchronously, unused_field, prefer_final_fields
import 'dart:developer';

import 'package:active_ecommerce_seller_app/custom/buttons.dart';
import 'package:active_ecommerce_seller_app/custom/device_info.dart';
import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:active_ecommerce_seller_app/custom/my_widget.dart';
import 'package:active_ecommerce_seller_app/custom/route_transaction.dart';
import 'package:active_ecommerce_seller_app/custom/toast_component.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_seller_app/helpers/shop_info_helper.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/repositories/auth_repository.dart';
import 'package:active_ecommerce_seller_app/repositories/shop_repository.dart';
import 'package:active_ecommerce_seller_app/screens/change_language.dart';
import 'package:active_ecommerce_seller_app/screens/commission_history.dart';
import 'package:active_ecommerce_seller_app/screens/login.dart';
import 'package:active_ecommerce_seller_app/screens/main.dart';
import 'package:active_ecommerce_seller_app/screens/orders.dart';
import 'package:active_ecommerce_seller_app/screens/pos/pos_config.dart';
import 'package:active_ecommerce_seller_app/screens/pos/pos_manager.dart';
import 'package:active_ecommerce_seller_app/screens/product/products.dart';
import 'package:active_ecommerce_seller_app/screens/profile.dart';
import 'package:active_ecommerce_seller_app/screens/uploads/upload_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:toast/toast.dart';
import '../data_model/login_response.dart';
import 'product_queries/product_queries.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  AccountState createState() => AccountState();
}

class AccountState extends State<Account> with TickerProviderStateMixin {
  late Future<LoginResponse> futureLoginResponse;

  late AnimationController controller;
  Animation? animation;

  bool _verify = shop_verify.$; // Initialize it only once
  bool _faceData = false;
  final bool _auctionExpand = false;
  bool _posExpand = false;

  String? _url = "",
      _name = "...",
      _email = "...",
      _rating = "...",
      _verified = "..",
      _package = "",
      _packageImg = "";

  Future<bool> _getAccountInfo() async {
    ShopInfoHelper().setShopInfo();
    setData(); // Set data but don't reload `shop_verify` unnecessarily
    return true;
  }

  getSellerPackage() async {
    var shopInfo = await ShopRepository().getShopInfo();
    _package = shopInfo.shopInfo!.sellerPackage;
    _packageImg = shopInfo.shopInfo!.sellerPackageImg;
    if (kDebugMode) {
      print(_packageImg);
    }
    setState(() {});
  }

  setData() {
    _url = shop_logo.$;
    _name = shop_name.$;
    _email = seller_email.$;
    _rating = shop_rating.$;
    _faceData = true;
    log("shop_verify: $_verify"); // Debugging line
    setState(() {});
  }

  final ExpansionTileController expansionTileController =
      ExpansionTileController();

  logoutReq() async {
    var response = await AuthRepository().getLogoutResponse();

    if (response.result!) {
      access_token.$ = "";
      access_token.save();
      is_logged_in.$ = false;
      is_logged_in.save();
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => Login(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            }),
        (route) => false,
      );
    } else {
      ToastComponent.showDialog(
        response.message!,
        gravity: Toast.center,
        duration: 3,
        textStyle: const TextStyle(color: MyTheme.black),
      );
    }
  }

  faceData() {
    _getAccountInfo();
    getSellerPackage();
  }

  loadData() async {
    if (shop_name.$ == "") {
      _getAccountInfo();
    } else {
      setData();
    }
  }

  @override
  void initState() {
    shop_verify.load();
    log('${shop_verify.$}');
    futureLoginResponse = AuthRepository().getUserByTokenResponse();

    if (seller_package_addon.$) {
      getSellerPackage();
    }
    loadData();
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = Tween(begin: 0.5, end: 1.0).animate(controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LoginResponse>(
      future: futureLoginResponse,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: MyTheme.app_accent_color,
          ));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          LoginResponse? userData = snapshot.data;
          return Container(
            color: MyTheme.white,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    color: Colors.white,
                    height: DeviceInfo(context).getHeight() +
                        DeviceInfo(context).getHeight() * 0.07,
                    child: Container(
                      color: MyTheme.app_accent_color,
                      width: double.infinity,
                      height: DeviceInfo(context).getHeight(),
                      margin: EdgeInsets.only(
                        bottom: DeviceInfo(context).getHeight() / 2,
                      ),
                      child: Card(
                        color: MyTheme.app_accent_color,
                        elevation: 10,
                        child: SafeArea(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // This is the back button
                              buildBackButtonContainer(context),

                              ///--- header ---///
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        MyWidget.roundImageWithPlaceholder(
                                            width: 48.0,
                                            height: 48.0,
                                            borderRadius: 24.0,
                                            url: userData?.user?.avatar,
                                            backgroundColor: MyTheme.noColor),
                                        /*Container(
                                      height: 48,
                                      width: 48,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(24),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  "https://demo.activeitzone.com/ecommerce_flutter_demo/public/uploads/all/999999999920220118113113.jpg"),
                                              fit: BoxFit.cover)),
                                    ),*/
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              userData?.user?.name ?? "Unknown",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: MyTheme.white),
                                            ),
                                            Text(
                                              userData?.user?.email ??
                                                  "Unknown",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: MyTheme
                                                      .app_accent_border
                                                      .withOpacity(0.8)),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Image.asset(
                                                  'assets/icon/star.png',
                                                  width: 16,
                                                  height: 15,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  _rating!,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: MyTheme
                                                          .app_accent_border),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                // MyWidget.roundImageWithPlaceholder(width: 16.0,height: 16.0,borderRadius:10.0,url: _verifiedImg ),

                                                Image.asset(
                                                  _verify == true
                                                      ? 'assets/icon/verify.png'
                                                      : 'assets/icon/unverify.png',
                                                  width: 16,
                                                  height: 15,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  _verify == true
                                                      ? LangText(
                                                              context: context)
                                                          .getLocal()
                                                          .verified_ucf
                                                      : LangText(
                                                              context: context)
                                                          .getLocal()
                                                          .unverified_ucf,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: MyTheme
                                                        .app_accent_border,
                                                  ),
                                                ),

                                                seller_package_addon.$ &&
                                                        _package!.isNotEmpty
                                                    ? Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          MyWidget.roundImageWithPlaceholder(
                                                              width: 16.0,
                                                              height: 15.0,
                                                              borderRadius: 0.0,
                                                              url: _packageImg,
                                                              backgroundColor:
                                                                  MyTheme
                                                                      .noColor,
                                                              fit: BoxFit.fill),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            _package!,
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                color: MyTheme
                                                                    .app_accent_border),
                                                          ),
                                                        ],
                                                      )
                                                    : Container(),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Row(
                                  children: [
                                    FirstPart(
                                        title: LangText(context: context)
                                            .getLocal()
                                            .my_orders_ucf,
                                        image: "assets/icon/orders.png",
                                        onTap: () {
                                          MyTransaction(context: context)
                                              .push(const Orders());
                                        }),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    FirstPart(
                                        title: LangText(context: context)
                                            .getLocal()
                                            .my_products_ucf,
                                        image: "assets/icon/products.png",
                                        onTap: () {
                                          MyTransaction(context: context)
                                              .push(const Products());
                                        }),
                                    const SizedBox(
                                      width: 10,
                                    ),

                                    /*FirstPart*/
                                    // FirstPart(
                                    //     title: LangText(context: context)
                                    //         .getLocal()
                                    //         .digital_product_ucf,
                                    //     image: "assets/icon/download.png",
                                    //     onTap: () {
                                    //       MyTransaction(context: context)
                                    //           .push(const DigitalProducts());
                                    //     }),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SecondPart(
                                      imageName: 'assets/icon/dashboard.png',
                                      title: LangText(context: context)
                                          .getLocal()
                                          .dashboard_ucf,
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                      secondaryAnimation) =>
                                                  Main(),
                                              transitionsBuilder: (context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child) {
                                                return FadeTransition(
                                                  opacity: animation,
                                                  child: child,
                                                );
                                              }),
                                          (route) => false,
                                        );
                                      },
                                    ),
                                    SecondPart(
                                      onPressed: () {
                                        MyTransaction(context: context)
                                            .push(const ProfileEdit());
                                      },
                                      imageName: 'assets/icon/profile.png',
                                      title: LangText(context: context)
                                          .getLocal()
                                          .profile_ucf,
                                    ),
                                    SecondPart(
                                      onPressed: () {
                                        MyTransaction(context: context)
                                            .push(ChangeLanguage());
                                      },
                                      imageName: 'assets/icon/language.png',
                                      title: LangText(context: context)
                                          .getLocal()
                                          .change_language_ucf,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 310,
                    right: 0,
                    left: 0,
                    child: buildItemFeature(context),
                  ),
                  Positioned(
                    bottom: 150,
                    right: 130,
                    child: GestureDetector(
                      onTap: () {
                        logoutReq();
                      },
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                            color: MyTheme.app_accent_color,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            border: Border.all(
                                color: MyTheme.app_accent_color, width: 5)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Text(
                          textAlign: TextAlign.center,
                          LangText(context: context).getLocal().logout_ucf,
                          style: TextStyle(fontSize: 18, color: MyTheme.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }

  Container buildBackButtonContainer(BuildContext context) {
    return Container(
      height: 47,
      alignment: Alignment.topRight,
      child: SizedBox(
        width: 47,
        child: Buttons(
          padding: EdgeInsets.zero,
          onPressed: () {
            pop(context);
          },
          child: const Icon(
            Icons.close,
            size: 24,
            color: MyTheme.app_accent_border,
          ),
        ),
      ),
    );
  }

  Widget buildItemFeature(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: MyWidget.customCardView(
        borderWidth: 1,
        width: DeviceInfo(context).getWidth(),
        height: DeviceInfo(context).getHeight() * .25,
        borderRadius: 10,
        borderColor: MyTheme.app_accent_border,
        backgroundColor: MyTheme.app_accent_color_extra_light,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  MyTransaction(context: context)
                      .push(const CommissionHistory());
                },
                child: CardRow(
                  isIcon: false,
                  assetsName: 'assets/icon/commission_history.png',
                  title: LangText(context: context)
                      .getLocal()
                      .commission_history_ucf,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: MyTheme.app_accent_color,
                height: 1,
                endIndent: 10,
                indent: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  MyTransaction(context: context).push(const UploadFile());
                },
                child: CardRow(
                  iconData: Icons.upload_file,
                  assetsName: 'assets/icon/commission_history.png',
                  title: LangText(context: context).getLocal().upload_file_ucf,
                ),
              ),
              if (product_query_activation.$)
                const SizedBox(
                  height: 10,
                ),
              if (product_query_activation.$)
                const Divider(
                  color: MyTheme.app_accent_color,
                  height: 1,
                  endIndent: 10,
                  indent: 10,
                ),
              if (product_query_activation.$)
                const SizedBox(
                  height: 10,
                ),
              if (product_query_activation.$)
                GestureDetector(
                  onTap: () {
                    MyTransaction(context: context)
                        .push(const ProductQueries());
                  },
                  child: CardRow(
                    iconData: Icons.question_mark_rounded,
                    title: LangText(context: context)
                        .getLocal()
                        .product_queries_ucf,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox optionModel(String title, String logo, Widget route) {
    return SizedBox(
      height: 40,
      child: Buttons(
        onPressed: () {
          MyTransaction(context: context).push(route);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(logo,
                    width: 16, height: 16, color: MyTheme.app_accent_border),
                const SizedBox(
                  width: 26,
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: MyTheme.white),
                ),
              ],
            ),
            const Icon(
              Icons.navigate_next_rounded,
              size: 20,
              color: MyTheme.app_accent_border,
            )
          ],
        ),
      ),
    );
  }

  buildPosSystem() {
    return Container(
      height: _posExpand ? 100 : 44,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(top: 10.0),
      child: InkWell(
        onTap: () {
          _posExpand = !_posExpand;
          setState(() {});
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('assets/icon/pos_system.png',
                        width: 16,
                        height: 16,
                        color: MyTheme.app_accent_border),
                    //Image.asset('assets/icon/commission_history.png',width: 16,height: 16,color: MyTheme.app_accent_border),
                    const SizedBox(
                      width: 26,
                    ),
                    Text(
                      "POS System",
                      style: TextStyle(
                        fontSize: 14,
                        color: MyTheme.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Icon(
                  _posExpand
                      ? Icons.keyboard_arrow_down
                      : Icons.navigate_next_rounded,
                  size: 20,
                  color: MyTheme.app_accent_border,
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Visibility(
              visible: _posExpand,
              child: Container(
                padding: const EdgeInsets.only(left: 40),
                width: DeviceInfo(context).getWidth(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => MyTransaction(context: context)
                          .push(const PosManager()),
                      child: Row(
                        children: [
                          Text(
                            '-',
                            style: TextStyle(
                              color: MyTheme.white,
                            ),
                          ),
                          Text(
                            '  Pos Manager',
                            style: TextStyle(
                              fontSize: 14,
                              color: MyTheme.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () => MyTransaction(context: context)
                          .push(const PosConfig()),
                      child: Row(
                        children: [
                          Text(
                            '-',
                            style: TextStyle(
                              color: MyTheme.white,
                            ),
                          ),
                          Text(
                            '  Pos Configuration',
                            style: TextStyle(
                              fontSize: 14,
                              color: MyTheme.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FirstPart extends StatelessWidget {
  final String title;
  final String image;
  final Function()? onTap;

  const FirstPart(
      {super.key, required this.title, required this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: MyWidget.customCardView(
          borderWidth: 1,
          height: 85,
          borderRadius: 10,
          borderColor: MyTheme.app_accent_border,
          backgroundColor: MyTheme.app_accent_color_extra_light,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  image,
                  color: MyTheme.app_accent_color,
                  height: 30,
                  width: 30,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: DeviceInfo(context).getWidth() * .3,
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: MyTheme.app_accent_color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SecondPart extends StatelessWidget {
  final String imageName;
  final String title;
  final Function()? onPressed;

  const SecondPart(
      {super.key,
      required this.imageName,
      required this.title,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Buttons(
        onPressed: onPressed,
        child: Column(
          children: [
            Image.asset(
              imageName,
              width: 16,
              height: 16,
              color: MyTheme.app_accent_border,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: MyTheme.white),
            ),
          ],
        ),
      ),
    );
  }
}

class CardRow extends StatelessWidget {
  final String? assetsName;
  final String title;
  final bool isIcon;
  final IconData? iconData;

  const CardRow(
      {super.key,
      this.assetsName,
      required this.title,
      this.isIcon = true,
      this.iconData});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isIcon
            ? Icon(
                iconData!,
                size: 25,
                color: MyTheme.app_accent_color,
              )
            : Image.asset(assetsName!,
                width: 20, height: 20, color: MyTheme.app_accent_color),
        const SizedBox(
          width: 20,
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: MyTheme.app_accent_color,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
