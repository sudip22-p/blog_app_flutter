// import 'package:flutter/material.dart';
// import 'package:upgrader/upgrader.dart';

// class UpgraderAlertWidget extends StatelessWidget {
//   final GlobalKey<NavigatorState>? navigatorKey;
//   final Widget child;
//   const UpgraderAlertWidget({
//     super.key,
//     this.navigatorKey,
//     required this.child,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return UpgradeAlert(
//       showIgnore: false,
//       showLater: false,
//       barrierDismissible: false,
//       navigatorKey: navigatorKey,
//       upgrader: Upgrader(
//         languageCode: "en",
//         durationUntilAlertAgain: Duration(hours: 1),
//       ),
//       child: child,
//     );
//   }
// }
