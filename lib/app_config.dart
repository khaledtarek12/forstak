// ignore_for_file: constant_identifier_names

var this_year = DateTime.now().year.toString();

class AppConfig {
  //this shows in the splash screen
  static String copyright_text = "@ ActiveItZone $this_year";

  //this shows in the splash screen
  static String app_name = "فرصتك للبائعين";

  //enter your purchase code for the app from codecanyon
  static String purchase_code = "";

  /// Put your system key generated from this site https://activeitzone.com/activation
  ///  Just replace the system-key with your key

  static String system_key = r"system-key";

  //Default language config
  static String default_language = "ar";
  static String mobile_app_code = "ar";
  static bool app_language_rtl = true;

  //configure this
  //localhost
  static const bool HTTPS = true;
  static const DOMAIN_PATH = "forsatc.com";
  // static const DOMAIN_PATH = "forsetac.online";

  //do not configure these below
  static const String API_ENDPATH = "api/v2";
  static const String PUBLIC_FOLDER = "public";
  static const String PROTOCOL = HTTPS ? "https://" : "https://";
  static const String SELLER_PREFIX = "seller";
  static const String RAW_BASE_URL = "$PROTOCOL$DOMAIN_PATH";
  static const String BASE_URL = "$RAW_BASE_URL/$API_ENDPATH";
  static const String BASE_URL_WITH_PREFIX = "$BASE_URL/$SELLER_PREFIX";
}

// https://forsatc.com/api/v2/seller/order/$id