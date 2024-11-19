import 'package:active_ecommerce_seller_app/custom/device_info.dart';
import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:active_ecommerce_seller_app/custom/my_app_bar.dart';
import 'package:active_ecommerce_seller_app/custom/route_transaction.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/screens/shop_settings/shop_banner_settings.dart';
import 'package:active_ecommerce_seller_app/screens/shop_settings/shop_delivery_boy_pickup_point_setting.dart';
import 'package:active_ecommerce_seller_app/screens/shop_settings/shop_general_setting.dart';
import 'package:active_ecommerce_seller_app/screens/shop_settings/shop_social_media_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../const/app_style.dart';
import '../../custom/chart2.dart';
import '../../custom/my_widget.dart';
import '../../data_model/category_wise_product_response.dart';
import '../../data_model/top_12_product_response.dart';
import '../../helpers/shimmer_helper.dart';
import '../../helpers/shop_info_helper.dart';
import '../../repositories/shop_repository.dart';
import '../home.dart';
import '../packages.dart';

class ShopSettings extends StatefulWidget {
  const ShopSettings({super.key});

  @override
  ShopSettingsState createState() => ShopSettingsState();
}

class ShopSettingsState extends State<ShopSettings> {
  bool _faceTopProducts = false;
  bool _faceCategoryWiseProducts = false;

  // double variables
  double mHeight = 0.0, mWidht = 0.0;

  //List
  List<ChartData> chartValues = [];
  List<ProductOfTop> product = [];
  List<String> logoSliders = [];
  List<CategoryWiseProductResponse> categoryWiseProducts = [];

  String? productsCount = '...',
      rattingCount = "...",
      totalOrdersCount = "...",
      totalSalesCount = '...',
      soldOutProducts = "...",
      lowStockProducts = "...",
      currentPackageName = "...",
      prodcutUploadLimit = "...",
      pacakgeExpDate = "...";

  Future<bool> _getTop12Product() async {
    var response = await ShopRepository().getTop12ProductRequest();
    product.addAll(response.data!);
    _faceTopProducts = true;
    setState(() {});

    return true;
  }

  Future<bool> _getCategoryWiseProduct() async {
    var response = await ShopRepository().getCategoryWiseProductRequest();
    categoryWiseProducts.addAll(response);
    _faceCategoryWiseProducts = true;
    setState(() {});
    return true;
  }

  Future<bool> _getShopInfo() async {
    var response = await ShopRepository().getShopInfo();

    productsCount = response.shopInfo!.products.toString();
    rattingCount = response.shopInfo!.rating.toString();
    totalOrdersCount = response.shopInfo!.orders.toString();
    totalSalesCount = response.shopInfo!.sales.toString();
    pacakgeExpDate = response.shopInfo!.packageInvalidAt;
    currentPackageName = response.shopInfo!.sellerPackage;
    prodcutUploadLimit = response.shopInfo!.productUploadLimit.toString();
    logoSliders.addAll(response.shopInfo!.sliders!);

    ShopInfoHelper().setShopInfo();
    setState(() {});
    return true;
  }

  cleanAll() {
    productsCount = '...';
    rattingCount = "...";
    totalOrdersCount = "...";
    totalSalesCount = '...';
    soldOutProducts = "...";
    lowStockProducts = "...";
    currentPackageName = "...";
    prodcutUploadLimit = "...";
    pacakgeExpDate = "...";
    chartValues = [];
    product = [];
    categoryWiseProducts = [];
    _faceTopProducts = false;
    _faceCategoryWiseProducts = false;
    setState(() {});
  }

  Future<void> reFresh() {
    cleanAll();
    facingAll();
    return Future.delayed(const Duration(seconds: 1));
  }

  facingAll() async {
    _getTop12Product();
    _getCategoryWiseProduct();
    _getShopInfo();
  }

  @override
  void initState() {
    facingAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
              title: AppLocalizations.of(context)!.shop_settings_ucf,
              context: context)
          .show(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          child: Column(
            children: [
              top4Boxes(),
              SizedBox(
                height: AppStyles.listItemsMargin,
              ),
              chartContainer(),
              packageContainer(),
              const SizedBox(
                height: 20,
              ),
              feature2Container(),
              const SizedBox(
                height: 20,
              ),
              categoryWiseProduct(),
              Container(
                height: AppStyles.listItemsMargin,
              ),
              topProductsContainer(),
              SizedBox(
                height: AppStyles.listItemsMargin,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget feature2Container() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var features = ShopFeaturesList.featuresData(context)
              .where((feature) => feature["visible"])
              .toList();
          var feature = features[index];
          return InkWell(
            onTap: feature["onTap"],
            child: MyWidget.customCardView(
              borderWidth: 1,
              borderRadius: 10,
              borderColor: MyTheme.app_accent_border,
              backgroundColor: MyTheme.app_accent_color_extra_light,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    feature["title"],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: MyTheme.app_accent_color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Image.asset(
                    feature["icon"],
                    color: MyTheme.app_accent_color,
                    height: 32,
                    width: 32,
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: ShopFeaturesList.featuresData(context)
            .where((feature) => feature["visible"])
            .length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 1.5,
        ),
      ),
    );
  }

  Widget chartContainer() {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 10),
      child: MyWidget.customCardView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        elevation: 5,
        height: 190,
        shadowColor: MyTheme.app_accent_color_extra_light,
        backgroundColor: MyTheme.white,
        width: DeviceInfo(context).getWidth(),
        borderRadius: 10,
        child: Stack(
          children: [
            // Positioned(
            //   right: 5,
            //   child: Text(
            //     "20-26 Feb, 2022",
            //     style: TextStyle(
            //         fontSize: 10, color: MyTheme.app_accent_color),
            //   ),
            // ),
            Positioned(
              left: 0,
              child: Text(
                LangText(context: context).getLocal().sales_stat_ucf,
                style: const TextStyle(
                    fontSize: 14,
                    color: MyTheme.app_accent_color,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: SizedBox(
                  height: 190,
                  width: DeviceInfo(context).getWidth(),
                  child: const MChart()),
            ),
          ],
        ),

        /*Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LangText(context: context)
                        .getLocal()
                        .dashboard_sales_stat,
                    style: TextStyle(
                        fontSize: 14, color: MyTheme.app_accent_color),
                  ),
                  Text(
                    "20-26 Feb, 2022",
                    style: TextStyle(
                        fontSize: 10,
                        color: MyTheme.app_accent_color),
                  ),
                ],
              ),
              Center(
                  child: Container(
                //padding: EdgeInsets.all(8),
                child: Container(
                  height: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 20),
                        width: 20,
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("4K"),
                            Text("3K"),
                            Text("2K"),
                            Text("1K"),
                            Text("0"),
                          ],
                        ),
                      ),
                      _isTopProductsData?Container(
                        child: Column(
                          children: [
                            Container(
                              height: 130,
                              child: Stack(
                                children: [

                                  Container(
                                    width:
                                        DeviceInfo(context).getWidth() / 1.5,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          color:
                                              MyTheme.app_accent_color,
                                          height: 1,
                                        ),
                                        Container(
                                          color:
                                              MyTheme.app_accent_color,
                                          height: 1,
                                        ),
                                        Container(
                                          color:
                                              MyTheme.app_accent_color,
                                          height: 1,
                                        ),
                                        Container(
                                          color:
                                              MyTheme.app_accent_color,
                                          height: 1,
                                        ),
                                        Container(
                                          color:
                                              MyTheme.app_accent_color,
                                          height: 1,
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    width:
                                        DeviceInfo(context).getWidth() / 1.5,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: 130,
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            height: 130*chartValues[0].salesValue/4000,
                                            width: 10,
                                            decoration: BoxDecoration(
                                              color: MyTheme.app_accent_color,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(2),
                                                topRight: Radius.circular(2),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 130,
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            height: 130*chartValues[1].salesValue/4000,
                                            width: 10,
                                            decoration: BoxDecoration(
                                              color: MyTheme.app_accent_color,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(2),
                                                topRight: Radius.circular(2),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 130,
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            height: 130*chartValues[2].salesValue/4000,
                                            width: 10,
                                            decoration: BoxDecoration(
                                              color: MyTheme.app_accent_color,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(2),
                                                topRight: Radius.circular(2),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 130,
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            height: 130*chartValues[3].salesValue/4000,
                                            width: 10,
                                            decoration: BoxDecoration(
                                              color: MyTheme.app_accent_color,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(2),
                                                topRight: Radius.circular(2),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 130,
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            height: 130*chartValues[4].salesValue/4000,
                                            width: 10,
                                            decoration: BoxDecoration(
                                              color: MyTheme.app_accent_color,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(2),
                                                topRight: Radius.circular(2),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 130,
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            height: 130*chartValues[5].salesValue/4000,
                                            width: 10,
                                            decoration: BoxDecoration(
                                              color: MyTheme.app_accent_color,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(2),
                                                topRight: Radius.circular(2),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 130,
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            height: 130*chartValues[6].salesValue/4000,
                                            width: 10,
                                            decoration: BoxDecoration(
                                              color: MyTheme.app_accent_color,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(2),
                                                topRight: Radius.circular(2),
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  )

                                ],
                              ),
                            ),
                            Container(
                             width: DeviceInfo(context).getWidth() / 1.5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(chartValues[0].date),
                                  Text(chartValues[0].date),
                                  Text(chartValues[0].date),
                                  Text(chartValues[0].date),
                                  Text(chartValues[0].date),
                                  Text(chartValues[0].date),
                                  Text(chartValues[0].date),

                                ],
                              ),
                            )
                          ],
                        ),
                      ):chartShimmer(),
                    ],
                  ),
                ),
              ))
            ],
          )*/
      ),
    );
  }

  Container categoryWiseProduct() {
    return MyWidget.customContainer(
        alignment: Alignment.topLeft,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 17,
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                "${LangText(context: context).getLocal().your_categories_ucf} (${categoryWiseProducts.length})",
                style: const TextStyle(
                    fontSize: 14,
                    color: MyTheme.app_accent_color,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            _faceCategoryWiseProducts
                ? product.isEmpty
                    ? Container(
                        alignment: Alignment.center,
                        height: 112,
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          LangText(context: context)
                              .getLocal()
                              .no_data_is_available,
                          style: const TextStyle(
                              fontSize: 14,
                              color: MyTheme.app_accent_color,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : SizedBox(
                        height: 112,
                        child: ListView.separated(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppStyles.itemMargin),
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                width: AppStyles.itemMargin,
                              );
                            },
                            scrollDirection: Axis.horizontal,
                            itemCount: categoryWiseProducts.length,
                            itemBuilder: (context, index) {
                              return buildCategoryItem(index);
                            }),
                      )
                : buildCategoriesShimmer(),
          ],
        ));
  }

  Widget buildCategoriesShimmer() {
    return SizedBox(
      height: 112,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return ShimmerHelper()
                .buildBasicShimmer(height: 112.0, width: 89.0);
          }),
    );
  }

  Widget buildCategoryItem(int index) {
    return MyWidget.customCardView(
        backgroundColor: MyTheme.noColor,
        elevation: 5,
        blurSize: 20,
        height: 112,
        width: 89,
        // borderRadius: 12.0,
        shadowColor: MyTheme.app_accent_shado,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              child: MyWidget.imageWithPlaceholder(
                url: categoryWiseProducts[index].banner,
                width: 89.0,
                height: 112.0,
                fit: BoxFit.cover,
                radius: BorderRadius.circular(12),
              ),
            ),
            Container(
              height: 112,
              width: 89,
              decoration: BoxDecoration(
                  color: MyTheme.app_accent_tranparent,
                  borderRadius: BorderRadius.circular(12)),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      categoryWiseProducts[index].name!,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      style: TextStyle(
                          fontSize: 10,
                          color: MyTheme.white,
                          fontWeight: FontWeight.normal),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  Text(
                    "(${categoryWiseProducts[index].cntProduct})",
                    style: TextStyle(
                        fontSize: 10,
                        color: MyTheme.white,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Container topProductsContainer() {
    return Container(
        padding: const EdgeInsets.only(left: 15.0, right: 15),
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 17,
              child: Text(
                LangText(context: context).getLocal().top_products_ucf,
                style: const TextStyle(
                    fontSize: 14,
                    color: MyTheme.app_accent_color,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: AppStyles.itemMargin,
            ),
            _faceTopProducts
                ? product.isEmpty
                    ? Container(
                        alignment: Alignment.center,
                        height: 205,
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          LangText(context: context)
                              .getLocal()
                              .no_data_is_available,
                          style: const TextStyle(
                              fontSize: 14,
                              color: MyTheme.app_accent_color,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: product.length,
                        itemBuilder: (context, index) {
                          return buildTopProductItem(index);
                        },
                      )
                : buildTopProductsShimmer(),
          ],
        ));
  }

  Widget buildTopProductsShimmer() {
    return SizedBox(
      height: DeviceInfo(context).getHeight(),
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(
                  bottom: 15, top: index == product.length - 1 ? 15 : 0),
              child: MyWidget.customCardView(
                elevation: 5,
                height: 112,
                width: DeviceInfo(context).getWidth(),
                borderRadius: 10.0,
                borderColor: MyTheme.light_grey,
                child: ShimmerHelper().buildBasicShimmer(
                    height: 112.0, width: DeviceInfo(context).getWidth()),
              ),
            );
          }),
    );
  }

  Widget buildTopProductItem(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: MyWidget.customCardView(
        backgroundColor: MyTheme.white,
        elevation: 5,
        height: 112,
        width: DeviceInfo(context).getWidth(),
        borderRadius: 10.0,
        borderColor: MyTheme.light_grey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyWidget.imageWithPlaceholder(
                url: product[index].thumbnailImg,
                width: 112.0,
                height: 112.0,
                radius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                )),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Spacer(),
                SizedBox(
                  width: DeviceInfo(context).getWidth() * 0.5,
                  child: Text(
                    product[index].name!,
                    maxLines: 2,
                    style:
                        const TextStyle(fontSize: 12, color: MyTheme.font_grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  product[index].category!,
                  style: const TextStyle(
                      fontSize: 10,
                      color: MyTheme.grey_153,
                      fontWeight: FontWeight.normal),
                ),
                const Spacer(),
                Text(
                  product[index].price!,
                  style: const TextStyle(
                      fontSize: 12,
                      color: MyTheme.app_accent_color,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget packageContainer() {
    return seller_package_addon.$
        ? Column(
            children: [
              SizedBox(
                height: AppStyles.listItemsMargin,
              ),
              MyWidget.customCardView(
                  width: DeviceInfo(context).getWidth(),
                  height: 128,
                  borderRadius: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  backgroundColor: MyTheme.white,
                  elevation: 5,
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(),
                      Image.asset(
                        'assets/icon/package.png',
                        width: 64,
                        height: 64,
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                LangText(context: context)
                                    .getLocal()
                                    .current_package_ucf,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: MyTheme.app_accent_color,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                currentPackageName!,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: MyTheme.app_accent_color,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Text(
                                LangText(context: context)
                                    .getLocal()
                                    .product_upload_limit_ucf,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: MyTheme.grey_153,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "${prodcutUploadLimit!} ${LangText(context: context).getLocal().times_all_lower}",
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: MyTheme.grey_153,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                LangText(context: context)
                                    .getLocal()
                                    .package_expires_at_ucf,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: MyTheme.grey_153,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                pacakgeExpDate!,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: MyTheme.grey_153,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          InkWell(
                            onTap: () {
                              MyTransaction(context: context)
                                  .push(const Packages());
                            },
                            child: MyWidget().myContainer(
                                bgColor: MyTheme.app_accent_color,
                                borderRadius: 6,
                                height: 36,
                                width: DeviceInfo(context).getWidth() / 2.2,
                                child: Text(
                                  LangText(context: context)
                                      .getLocal()
                                      .upgrade_package_ucf,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: MyTheme.white,
                                      fontWeight: FontWeight.w400),
                                )),
                          )
                        ],
                      ),
                      const Spacer(),
                    ],
                  )),
            ],
          )
        : Container();
  }

  Widget top4Boxes() {
    return Stack(
      children: [
        /* Container(
          height: 240,
          child: Column(
            children: [
              Container(
                height: 170,
                width: DeviceInfo(context).getWidth(),
                child: MyWidget.imageSlider(
                    imageUrl: logoSliders, context: context),
              ),
              Container(

                height: 70,
                width: DeviceInfo(context).getWidth(),
              ),
            ],
          ),
        ),*/
        Positioned(
          top: 0,
          right: 0,
          child: SizedBox(
            height: 170,
            width: DeviceInfo(context).getWidth() - 20,
            child:
                MyWidget.imageSlider(imageUrl: logoSliders, context: context),
          ),
        ),

        // this container only for transparent color
        Container(
          height: 180,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(255, 255, 255, 0),
                Color.fromRGBO(255, 255, 255, .15),
                Color.fromRGBO(255, 255, 255, .25),
                Color.fromRGBO(255, 255, 255, .50),
                Color.fromRGBO(255, 255, 255, .9),
                Color.fromRGBO(255, 255, 255, 1),
                Color.fromRGBO(255, 255, 255, 1),
                Color.fromRGBO(255, 255, 255, 1),
              ],
            ),
          ),
        ),

        Positioned(
          bottom: 0,
          child: Container(
              color: Colors.transparent,
              //color: MyTheme.red,
              //height: 190,
              width: DeviceInfo(context).getWidth(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      MyWidget.homePageTopBox(context,
                          elevation: 5,
                          title: LangText(context: context)
                              .getLocal()
                              .products_ucf,
                          counter: productsCount,
                          iconUrl: 'assets/icon/products.png'),
                      MyWidget.homePageTopBox(context,
                          title:
                              LangText(context: context).getLocal().rating_ucf,
                          counter: rattingCount,
                          iconUrl: 'assets/icon/rating.png'),
                    ],
                  ),
                  Row(
                    children: [
                      MyWidget.homePageTopBox(context,
                          elevation: 5,
                          title: LangText(context: context)
                              .getLocal()
                              .total_orders_ucf,
                          counter: totalOrdersCount,
                          iconUrl: 'assets/icon/orders.png'),
                      MyWidget.homePageTopBox(context,
                          elevation: 5,
                          title: LangText(context: context)
                              .getLocal()
                              .total_sales_ucf,
                          counter: totalSalesCount,
                          iconUrl: 'assets/icon/sales.png'),
                    ],
                  )
                ],
              )

              /*
            GridView.count(
              physics: NeverScrollableScrollPhysics(),
              primary: false,
              padding:  EdgeInsets.all(AppStyles.layoutMargin),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              crossAxisCount: 2,
              childAspectRatio:DeviceInfo(context).getHeightInPercent(),
              children: <Widget>[
                MyWidget.homePageTopBox(context,
                    elevation: 5,
                    title: LangText(context: context)
                        .getLocal()
                        .product_screen_products,
                    counter: _productsCount,
                    iconUrl: 'assets/icon/products.png'),
                MyWidget.homePageTopBox(context,
                    title:
                    LangText(context: context).getLocal().common_rating,
                    counter: _rattingCount,
                    iconUrl: 'assets/icon/rating.png'),

                MyWidget.homePageTopBox(context,
                    elevation: 5,
                    title: LangText(context: context)
                        .getLocal()
                        .common_total_orders,
                    counter: _totalOrdersCount,
                    iconUrl: 'assets/icon/orders.png'),
                MyWidget.homePageTopBox(context,
                    elevation: 5,
                    title: LangText(context: context)
                        .getLocal()
                        .common_total_sales,
                    counter: _totalSalesCount,
                    iconUrl: 'assets/icon/sales.png')
              ],
            ),*/

              ),
        ),
      ],
    );
  }
}

class ShopFeaturesList {
  static List<Map<String, dynamic>> featuresData(BuildContext context) {
    return [
      {
        "title": LangText(context: context).getLocal().general_setting_ucf,
        "icon": "assets/icon/general_setting.png",
        "visible": true,
        "onTap": () {
          MyTransaction(context: context).push(const ShopGeneralSetting());
        },
      },
      {
        "title":
            LangText(context: context).getLocal().delivery_boy_pickup_point,
        "icon": "assets/icon/delivery_boy_setting.png",
        "visible": delivery_boy_addon.$,
        "onTap": () {
          MyTransaction(context: context)
              .push(const ShopDeliveryBoyPickupPoint());
        },
      },
      {
        "title": LangText(context: context).getLocal().banner_settings,
        "icon": "assets/icon/banner_setting.png",
        "visible": true,
        "onTap": () {
          MyTransaction(context: context).push(const ShopBannerSettings());
        },
      },
      {
        "title": LangText(context: context).getLocal().social_media_link,
        "icon": "assets/icon/social_setting.png",
        "visible": true,
        "onTap": () {
          MyTransaction(context: context).push(const ShopSocialMedialSetting());
        },
      },
    ];
  }
}
