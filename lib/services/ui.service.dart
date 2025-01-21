

import 'package:flutter/material.dart';

import '../components/tok-tok-dialog.component.dart';

class UIService {
  static bool isMobileScreen(BuildContext context) {
    // Get the screen width and height
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Set reasonable thresholds for mobile screen sizes
    const double maxMobileWidth = 600; // Maximum width for mobile
    const double maxMobileHeight = 900; // Maximum height for mobile

    // Return true if both the width and height are within mobile limits
    return screenWidth <= maxMobileWidth && screenHeight <= maxMobileHeight;
  }

  static bool isTabletScreen(BuildContext context) {
    // Get the screen width and height
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Define thresholds for tablet screen sizes
    const double minTabletWidth = 600;  // Minimum width for tablets
    const double maxTabletWidth = 1200; // Maximum width for tablets
    const double minTabletHeight = 900; // Minimum height for tablets
    const double maxTabletHeight = 1600; // Maximum height for tablets

    // Return true if the width and height fall within the tablet range
    return screenWidth >= minTabletWidth &&
        screenWidth <= maxTabletWidth &&
        screenHeight >= minTabletHeight &&
        screenHeight <= maxTabletHeight;
  }

  static void showErrorDialog({ required String title, required dynamic body, required BuildContext context }) {
    final refinedMessage = body is List ? body[0] : body;
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), // Semi-transparent background
      barrierDismissible: true, // Allows dismiss on touch outside
      builder: (BuildContext context) {
        return TikTokDialog(
          title: title,
          body: refinedMessage,
          primaryBtnLabel: "Close",
          onPrimaryBtnPress: () {

          },
        ); // Custom animated dialog
      },
    );
  }
}