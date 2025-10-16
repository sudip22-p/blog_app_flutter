// App URLs and deep link paths.
class Urls {
  Urls._();

  //Settings URLs
  static const termsService =
      "https://yhh-it-solutions.github.io/rudrakx/terms.html";
  static const privacyPolicy =
      "https://yhh-it-solutions.github.io/rudrakx/privacy.html";
  static const contactEmail = "contact@yhhits.com";
  static String appReferalLink(String appPackageName, String userReferalCode) =>
      "https://rudrakxapi.rudrakx.com/validate/?url_name=$appPackageName&utm_source=$userReferalCode";
  static const yesHelpingHandUrl =
      "https://yeshelpinghand.com/shop/men-collection";
  static const personalUrl = "https://bimalkhatri.com.np";
}
