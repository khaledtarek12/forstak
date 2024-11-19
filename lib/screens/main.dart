import 'package:active_ecommerce_seller_app/custom/CommonFunctoins.dart';
import 'package:active_ecommerce_seller_app/custom/common_style.dart';
import 'package:active_ecommerce_seller_app/custom/customDateTimes.dart';
import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:active_ecommerce_seller_app/helpers/shop_info_helper.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/screens/account.dart';
import 'package:active_ecommerce_seller_app/screens/home.dart';
import 'package:active_ecommerce_seller_app/screens/orders.dart';
import 'package:active_ecommerce_seller_app/screens/product/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:route_transitions/route_transitions.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  MainState createState() => MainState();
}

class MainState extends State<Main> {
  int _currentIndex = 0;
  String title = "";
  final _children = [
    const Home(
      fromBottombar: true,
    ),
    const Products(
      fromBottomBar: true,
    ),
    const Orders(fromBottomBar: true),
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void onTapped(int i) {
    if (i == 3) {
      // setState(() {
      //   _scaffoldKey.currentState.openEndDrawer();
      // });
      //
      slideRightWidget(
          newPage: const Account(), context: context, opaque: false);
    } else {
      setState(() {
        _currentIndex = i;
      });
    }
  }

  @override
  void initState() {
    ShopInfoHelper().setShopInfo();
    //re appear statusbar in case it was not there in the previous page
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.initState();
  }

  onPop(value) {}

  _onBackPressed() {
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });
    } else {
      CommonFunctions(context).appExitDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) => _onBackPressed(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: buildAppBar(),
        // drawer: MainDrawer(index: _currentIndex,),
        extendBody: true,
        body: _children[_currentIndex],
        //specify the location of the FAB
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          // landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
          onTap: onTapped,
          currentIndex: _currentIndex,
          backgroundColor: Colors.white.withOpacity(1),
          fixedColor: MyTheme.app_accent_color,
          unselectedItemColor: const Color.fromRGBO(153, 153, 153, 1),
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Image.asset(
                  "assets/icon/dashboard.png",
                  color: _currentIndex == 0
                      ? MyTheme.app_accent_color
                      : const Color.fromRGBO(153, 153, 153, 1),
                  height: 20,
                ),
              ),
              label: LangText(context: context).getLocal().dashboard_ucf,
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Image.asset(
                  "assets/icon/products.png",
                  color: _currentIndex == 1
                      ? MyTheme.app_accent_color
                      : const Color.fromRGBO(153, 153, 153, 1),
                  height: 20,
                ),
              ),
              label: LangText(context: context).getLocal().products_ucf,
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Image.asset(
                  "assets/icon/orders.png",
                  color: _currentIndex == 2
                      ? MyTheme.app_accent_color
                      : const Color.fromRGBO(153, 153, 153, 1),
                  height: 20,
                ),
              ),
              label: LangText(context: context).getLocal().orders_ucf,
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Image.asset(
                  "assets/icon/account.png",
                  color: _currentIndex == 3
                      ? MyTheme.app_accent_color
                      : const Color.fromRGBO(153, 153, 153, 1),
                  height: 20,
                ),
              ),
              label: LangText(context: context).getLocal().account_ucf,
            ),
          ],
        ),
        /*floatingActionButton: FloatingActionButton(
          //backgroundColor: MyTheme.app_accent_color,
          onPressed: () {
              MyTransaction(context: context).push(Conversation());

          },
          child: Container(
              margin: EdgeInsets.all(0.0),
              child: IconButton(
                  icon: new Image.asset(
                    'assets/icon/chat.png',
                    height: 16,
                    width: 16,
                  ),
                  tooltip: 'Action',
                  onPressed: () {
                    MyTransaction(context: context).push(Conversation());
                  })),
          elevation: 0.0,
        ),*/
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leadingWidth: 0.0,
      backgroundColor: Colors.white,
      elevation: 5,
      centerTitle: false,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /*InkWell(child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                'assets/icon/back_arrow.png',
                height: 14,
                width: 14,
                //color: MyTheme.dark_grey,
              ),
            ),
              onTap: (){
              setState(() {
                _currentIndex = 0;
              });
            },),*/
          _currentIndex == 0
              ? Image.asset(
                  'assets/logo/app_logo.png',
                  height: 34,
                  width: 26,
                  //color: MyTheme.dark_grey,
                )
              : SizedBox(
                  width: 24,
                  height: 24,
                  child: IconButton(
                    splashRadius: 15,
                    padding: const EdgeInsets.all(0.0),
                    onPressed: () {
                      setState(() {
                        _currentIndex = 0;
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: MyTheme.app_accent_color,
                    ),
                  ),
                ),
          const SizedBox(
            width: 10,
          ),
          Text(
            getTitle(),
            style: MyTextStyle()
                .appbarText()
                .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      actions: [
        Visibility(
          visible: _currentIndex == 0,
          child: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    CustomDateTime.getDate,
                    style: const TextStyle(
                        color: MyTheme.app_accent_color,
                        fontSize: 10,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    CustomDateTime.getDayName,
                    style: const TextStyle(
                        color: MyTheme.app_accent_color,
                        fontSize: 10,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              )),
        ),
        const SizedBox(
          width: 20,
        ),
      ],
    );
  }

  String getTitle() {
    switch (_currentIndex) {
      case 0:
        title = AppLocalizations.of(context)!.dashboard_ucf;
        break;
      case 1:
        title = AppLocalizations.of(context)!.products_ucf;
        break;
      case 2:
        title = AppLocalizations.of(context)!.orders_ucf;
        break;
      case 3:
        title = AppLocalizations.of(context)!.profile_ucf;
        break;
    }
    return title;
  }
}
