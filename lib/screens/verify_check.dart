import 'package:active_ecommerce_seller_app/const/app_style.dart';
import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/screens/login.dart';
import 'package:active_ecommerce_seller_app/screens/verify_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerifyCheckScreen extends StatelessWidget {
  const VerifyCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyTheme.shimmer_highlighted,
        bottomNavigationBar: BottmBar(),
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: MyTheme.shimmer_base,
          leading: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              "assets/icon/orders.png",
            ),
          ),
          title: Text(
            'فرصتك للبائعين',
            style: GoogleFonts.notoSansArabic(fontWeight: AppStyles.extraBold),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "assets/logo/app_logo.png",
                    ),
                    fit: BoxFit.cover)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    LangText(context: context).getLocal().verfy_email,
                    style: GoogleFonts.notoSansArabic(
                      fontSize: 20,
                      fontWeight: AppStyles.extraBold,
                      color: MyTheme.red,
                    ),
                  ),
                  SizedBox(height: 16),
                  InfoWidget(
                    title: LangText(context: context).getLocal().title1,
                    desc: LangText(context: context).getLocal().descTitle1,
                  ),
                  SizedBox(height: 16),
                  InfoWidget(
                    title: LangText(context: context).getLocal().title2,
                    desc: LangText(context: context).getLocal().descTitle2,
                  ),
                  SizedBox(height: 16),
                  InfoWidget(
                    title: LangText(context: context).getLocal().title3,
                    desc: LangText(context: context).getLocal().descTitle3,
                  ),
                  SizedBox(height: 16),
                  InfoWidget(
                    title: LangText(context: context).getLocal().title4,
                    desc: LangText(context: context).getLocal().descTitle4,
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ));
  }
}

class InfoWidget extends StatelessWidget {
  const InfoWidget({
    super.key,
    required this.title,
    required this.desc,
  });

  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5), // Shadow color
            spreadRadius: 2, // Spread of the shadow
            blurRadius: 5, // Blur effect for shadow
            offset: Offset(0, 4), // Shadow offset (x, y)
          ),
          BoxShadow(
            color: Colors.blue.withOpacity(0.1), // Shadow color
            spreadRadius: 2, // Spread of the shadow
            blurRadius: 10, // Blur effect for shadow
            offset: Offset(0, 4), // Shadow offset (x, y)
          ),
        ],
      ),
      padding: const EdgeInsets.only(right: 10.0, bottom: 10.0, top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.notoSansArabic(
                fontWeight: AppStyles.bold, fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(
            desc,
            style: GoogleFonts.notoSansArabic(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class BottmBar extends StatelessWidget {
  const BottmBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 0,
      color: MyTheme.shimmer_base,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  foregroundColor: Colors.white,
                  backgroundColor: MyTheme.login_reg_screen_color,
                  disabledForegroundColor: Colors.grey,
                  disabledBackgroundColor: Colors.grey,
                  side: BorderSide(
                    color: MyTheme.login_reg_screen_color,
                  ),
                  padding: const EdgeInsets.only(
                      left: 18, right: 18, bottom: 18, top: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) {
                    return VerifyPage();
                  },
                ), (route) => false);
              },
              child: Text(
                LangText(context: context).getLocal().verify_account,
                style: GoogleFonts.notoSansArabic(
                    fontWeight: AppStyles.bold, fontSize: 20),
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    elevation: 0,
                    side: const BorderSide(color: Colors.grey, width: 2),
                    padding: const EdgeInsets.only(
                        left: 18, right: 18, bottom: 18, top: 11),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14))),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (context) {
                      return Login();
                    },
                  ), (route) => false);
                },
                child: Text(
                  textAlign: TextAlign.center,
                  LangText(context: context).getLocal().logout_ucf,
                  style: GoogleFonts.notoSansArabic(
                    fontWeight: AppStyles.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
