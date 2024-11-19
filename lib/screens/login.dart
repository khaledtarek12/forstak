// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, avoid_print, prefer_final_fields

import 'package:active_ecommerce_seller_app/custom/buttons.dart';
import 'package:active_ecommerce_seller_app/custom/input_decorations.dart';
import 'package:active_ecommerce_seller_app/custom/intl_phone_input.dart';
import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:active_ecommerce_seller_app/custom/my_widget.dart';
import 'package:active_ecommerce_seller_app/custom/toast_component.dart';
import 'package:active_ecommerce_seller_app/helpers/auth_helper.dart';
import 'package:active_ecommerce_seller_app/helpers/main_helper.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/repositories/address_repository.dart';
import 'package:active_ecommerce_seller_app/repositories/auth_repository.dart';
import 'package:active_ecommerce_seller_app/screens/main.dart';
import 'package:active_ecommerce_seller_app/screens/password_forget.dart';
import 'package:active_ecommerce_seller_app/screens/verify_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:one_context/one_context.dart';
import 'package:toast/toast.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _login_by = "email"; //phone or email
  String initialCountry = 'US';
  PhoneNumber phoneCode = PhoneNumber(isoCode: 'US', dialCode: "+1");
  String? _phone = "";
  late BuildContext loadingContext;
  var countries_code = <String?>[];
  // bool _faceData = false;
  // String? _url = "",
  //     _name = "...",
  //     _email = "...",
  //     _rating = "...",
  //     _verified = "..",
  //     _package = "",
  //     _packageImg = "";

  // Future<bool> _getAccountInfo() async {
  //   ShopInfoHelper().setShopInfo();
  //   setData();
  //   return true;
  // }

  // setData() {
  //   //Map<String, dynamic> json = jsonDecode(shop_info.$.toString());
  //   _url = shop_logo.$;
  //   _name = shop_name.$;
  //   _email = seller_email.$;
  //   _verify = shop_verify.$;
  //   _verified = _verify!
  //       ? LangText(context: OneContext().context).getLocal().verified_ucf
  //       : LangText(context: OneContext().context).getLocal().unverified_ucf;
  //   _rating = shop_rating.$;
  //   _faceData = true;
  //   setState(() {});
  // }

  //controllers
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  MyWidget? myWidget;

  fetch_country() async {
    var data = await AddressRepository().getCountryList();
    data.countries!.forEach((c) => countries_code.add(c.code));
    phoneCode = PhoneNumber(isoCode: data.countries!.first.code);
    setState(() {});
  }

  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    super.initState();
    if (otp_addon_installed.$) {
      fetch_country();
    }
    // Load the value of shop_verify when the screen is initialized
    verify_form_submitted.load();
    // _getAccountInfo();
    /*if (is_logged_in.value == true) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Main();
      }));
    }*/
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  onPressedLogin() async {
    var email = _emailController.text.toString();
    var password = _passwordController.text.toString();

    if (_login_by == 'email' && email == "") {
      ToastComponent.showDialog(
          LangText(context: OneContext().context).getLocal().enter_email,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    } else if (_login_by == 'phone' && _phone == "") {
      ToastComponent.showDialog(
          LangText(context: OneContext().context).getLocal().enter_phone_number,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    } else if (password == "" || password.isEmpty) {
      ToastComponent.showDialog(
          LangText(context: OneContext().context).getLocal().enter_password,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }

    loading();

    var loginResponse = await AuthRepository().getLoginResponse(
        _login_by == 'email' ? email : _phone, password, _login_by);

    Navigator.pop(loadingContext);

    if (loginResponse.result == true) {
      if (loginResponse.message.runtimeType == List) {
        ToastComponent.showDialog(loginResponse.message!.join("\n"),
            gravity: Toast.center, duration: 3);
        return;
      }

      ToastComponent.showDialog(loginResponse.message!,
          gravity: Toast.center, duration: Toast.lengthLong);

      // Save user data and access token
      AuthHelper().setUserData(loginResponse);

      // Check if the access token is loaded and not empty
      if (access_token.$!.isNotEmpty) {
        // Ensure the shop_verify value is loaded only once during the session
        await verify_form_submitted.load();
        await shop_verify.load();

        // Navigate based on the verification status
        if (verify_form_submitted.$ == true || shop_verify.$ == true) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Main()), // Main screen
            (route) => false,
          );
        } else {
          ToastComponent.showDialog('متجرك غير موثق',
              gravity: Toast.center, duration: Toast.lengthLong);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    VerifyCheckScreen()), // Verification screen
            (route) => false,
          );
        }
      } else {
        ToastComponent.showDialog(loginResponse.message!,
            gravity: Toast.center, duration: Toast.lengthLong);
      }
    } else {
      ToastComponent.showDialog(loginResponse.message,
          gravity: Toast.bottom, duration: Toast.lengthLong);
    }
  }

  @override
  Widget build(BuildContext context) {
    myWidget = MyWidget(myContext: context);
    return InkWell(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        onPopInvokedWithResult: (didPop, result) async => false,
        child: Scaffold(
          backgroundColor: MyTheme.login_reg_screen_color,
          body: buildBody(context),
        ),
      ),
    );
  }

  buildBody(context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(200),
              ),
              child: Image.asset(
                "assets/logo/app_logo.png",
                fit: BoxFit.cover,
                height: 450,
                width: screenWidth,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),

                  Text(
                    LangText(context: context)
                        .getLocal()
                        .hi_welcome_to_all_lower,
                    style: const TextStyle(
                        color: MyTheme.app_accent_border,
                        fontSize: 20,
                        fontWeight: FontWeight.w300),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 20.0,
                    ),
                    child: Text(
                      LangText(context: context)
                          .getLocal()
                          .login_to_your_account_all_lower,
                      style: const TextStyle(
                          color: MyTheme.app_accent_border,
                          fontSize: 20,
                          fontWeight: FontWeight.w300),
                    ),
                  ),

                  // login form container
                  SizedBox(
                    width: screenWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            _login_by == "email"
                                ? LangText(context: context)
                                    .getLocal()
                                    .email_ucf
                                : LangText(context: context)
                                    .getLocal()
                                    .login_screen_phone,
                            style: const TextStyle(
                                color: MyTheme.app_accent_border,
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                          ),
                        ),
                        if (_login_by == "email")
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  height: 36,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 0.5)),
                                  child: TextField(
                                    cursorColor: MyTheme.app_accent_color,
                                    style: TextStyle(color: MyTheme.white),
                                    controller: _emailController,
                                    autofocus: false,
                                    decoration:
                                        InputDecorations.buildInputDecoration_1(
                                            borderColor: MyTheme.noColor,
                                            hint_text:
                                                LangText(context: context)
                                                    .getLocal()
                                                    .sellerexample,
                                            hintTextColor: MyTheme.dark_grey),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 0.5)),
                                  height: 36,
                                  child: CustomInternationalPhoneNumberInput(
                                    countries: countries_code,
                                    onInputChanged: (PhoneNumber number) {
                                      print(number.phoneNumber);
                                      setState(() {
                                        _phone = number.phoneNumber;
                                      });
                                    },
                                    onInputValidated: (bool value) {
                                      print('on input validation $value');
                                    },
                                    selectorConfig: const SelectorConfig(
                                      selectorType:
                                          PhoneInputSelectorType.DIALOG,
                                    ),
                                    ignoreBlank: false,
                                    autoValidateMode: AutovalidateMode.disabled,
                                    selectorTextStyle: const TextStyle(
                                        color: MyTheme.font_grey),
                                    textStyle:
                                        const TextStyle(color: Colors.white54),
                                    initialValue: phoneCode,
                                    textFieldController: _phoneNumberController,
                                    formatInput: true,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            signed: true, decimal: true),
                                    inputDecoration: InputDecorations
                                        .buildInputDecoration_phone(
                                            hint_text: "01XXX XXX XXX"),
                                    onSaved: (PhoneNumber number) {
                                      print('On Saved: $number');
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (otp_addon_installed.$)
                          Row(
                            children: [
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _login_by = _login_by == "email"
                                        ? "phone"
                                        : "email";
                                  });
                                },
                                child: Text(
                                  "or, Login with ${_login_by == "email" ? 'a phone' : 'an email'}",
                                  style: TextStyle(
                                      color: MyTheme.white,
                                      fontStyle: FontStyle.italic,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ],
                          ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            getLocal(context).password_ucf,
                            style: const TextStyle(
                                color: MyTheme.app_accent_border,
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color.fromRGBO(
                                        255, 255, 255, 0.5)),
                                height: 36,
                                child: TextField(
                                  cursorColor: MyTheme.app_accent_color,
                                  controller: _passwordController,
                                  autofocus: false,
                                  obscureText: true,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  style: TextStyle(color: MyTheme.white),
                                  decoration:
                                      InputDecorations.buildInputDecoration_1(
                                          borderColor: MyTheme.noColor,
                                          hint_text: "• • • • • • • •",
                                          hintTextColor: MyTheme.dark_grey),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return PasswordForget();
                                    }));
                                  },
                                  child: Text(
                                    getLocal(context).forget_password_ucf,
                                    style: TextStyle(
                                        color: MyTheme.white,
                                        fontStyle: FontStyle.italic,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: MyTheme.app_accent_border, width: 1),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0))),
                            child: Buttons(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              color: Colors.white.withOpacity(0.8),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(11.0),
                                ),
                              ),
                              child: Text(
                                getLocal(context).log_in,
                                style: const TextStyle(
                                    color: MyTheme.app_accent_color,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              ),
                              onPressed: () {
                                onPressedLogin();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        LangText(context: context)
                            .getLocal()
                            .in_case_of_any_difficulties_contact_with_admin,
                        style: const TextStyle(
                            fontSize: 12, color: MyTheme.app_accent_border),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //     top: 20,
            //   ),
            //   child: Container(
            //     alignment: Alignment.center,
            //     child: Text(
            //       LangText(context: context).getLocal()!.or,
            //       style:
            //           TextStyle(fontSize: 12, color: MyTheme.app_accent_border),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 10.0),
            //   child: Container(
            //     alignment: Alignment.center,
            //     height: 45,
            //     child: Buttons(
            //       alignment: Alignment.center,
            //       //width: MediaQuery.of(context).size.width,
            //       height: 50,
            //       //color: Colors.white.withOpacity(0.8),
            //       child: Text(
            //         LangText(context: context).getLocal()!.registration,
            //         style: TextStyle(
            //             color: MyTheme.white,
            //             fontSize: 17,
            //             fontWeight: FontWeight.w500,
            //             decoration: TextDecoration.underline),
            //       ),
            //       onPressed: () {
            //         Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => Registration()));
            //       },
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  loading() {
    showDialog(
        context: context,
        builder: (context) {
          loadingContext = context;
          return AlertDialog(
              content: Row(
            children: [
              const CircularProgressIndicator(
                color: MyTheme.app_accent_color,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(AppLocalizations.of(context)!.please_wait_ucf),
            ],
          ));
        });
  }
}
