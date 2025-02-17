import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static TextStyle get _vt323Style => GoogleFonts.vt323();

  static const Color primaryColor = CupertinoColors.systemPink;
  static const Color backgroundColor = CupertinoColors.systemBackground;
  static const Color secondaryBackgroundColor = CupertinoColors.systemGrey6;
  static const Color textColor = CupertinoColors.label;
  static const Color secondaryTextColor = CupertinoColors.secondaryLabel;

  static CupertinoThemeData get cupertinoLightTheme {
    return const CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      barBackgroundColor: backgroundColor,
      textTheme: CupertinoTextThemeData(
        primaryColor: primaryColor,
        textStyle: TextStyle(
          color: textColor,
          fontSize: 16,
          fontFamily: 'SF Pro Text',
        ),
        actionTextStyle: TextStyle(
          color: primaryColor,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro Text',
        ),
        tabLabelTextStyle: TextStyle(
          color: secondaryTextColor,
          fontSize: 12,
          fontFamily: 'SF Pro Text',
        ),
        navTitleTextStyle: TextStyle(
          color: textColor,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro Text',
        ),
        navLargeTitleTextStyle: TextStyle(
          color: textColor,
          fontSize: 34,
          fontWeight: FontWeight.w700,
          fontFamily: 'SF Pro Display',
        ),
        navActionTextStyle: TextStyle(
          color: primaryColor,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro Text',
        ),
        pickerTextStyle: TextStyle(
          color: textColor,
          fontSize: 21,
          fontWeight: FontWeight.w400,
          fontFamily: 'SF Pro Display',
        ),
        dateTimePickerTextStyle: TextStyle(
          color: textColor,
          fontSize: 21,
          fontWeight: FontWeight.w400,
          fontFamily: 'SF Pro Display',
        ),
      ),
    );
  }

  static CupertinoThemeData get cupertinoDarkTheme {
    return const CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: CupertinoColors.black,
      barBackgroundColor: CupertinoColors.black,
      textTheme: CupertinoTextThemeData(
        primaryColor: primaryColor,
        textStyle: TextStyle(
          color: CupertinoColors.white,
          fontSize: 16,
          fontFamily: 'SF Pro Text',
        ),
        actionTextStyle: TextStyle(
          color: primaryColor,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro Text',
        ),
        tabLabelTextStyle: TextStyle(
          color: CupertinoColors.systemGrey,
          fontSize: 12,
          fontFamily: 'SF Pro Text',
        ),
        navTitleTextStyle: TextStyle(
          color: CupertinoColors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro Text',
        ),
        navLargeTitleTextStyle: TextStyle(
          color: CupertinoColors.white,
          fontSize: 34,
          fontWeight: FontWeight.w700,
          fontFamily: 'SF Pro Display',
        ),
        navActionTextStyle: TextStyle(
          color: primaryColor,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro Text',
        ),
        pickerTextStyle: TextStyle(
          color: CupertinoColors.white,
          fontSize: 21,
          fontWeight: FontWeight.w400,
          fontFamily: 'SF Pro Display',
        ),
        dateTimePickerTextStyle: TextStyle(
          color: CupertinoColors.white,
          fontSize: 21,
          fontWeight: FontWeight.w400,
          fontFamily: 'SF Pro Display',
        ),
      ),
    );
  }
}
