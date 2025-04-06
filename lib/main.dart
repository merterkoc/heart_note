import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:heart_note/app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

FirebaseAnalytics analytics = FirebaseAnalytics.instance;
FirebaseAnalyticsObserver observer =
    FirebaseAnalyticsObserver(analytics: analytics);

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    MobileAds.instance.initialize();
    await Firebase.initializeApp();

    // Crashlytics'i başlatın
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    const fatalError = true;
    if (kDebugMode) {
      // Force disable Crashlytics collection while doing every day development.
      // Temporarily toggle this to true if you want to test crash reporting in your app.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      PlatformDispatcher.instance.onError = (error, stack) {
        if (fatalError) {
          // If you want to record a "fatal" exception
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          // ignore: dead_code
        } else {
          // If you want to record a "non-fatal" exception
          FirebaseCrashlytics.instance.recordError(error, stack);
        }
        return true;
      };
    }
    runApp(HeartNoteApp(prefs: prefs, analytics: analytics));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}
