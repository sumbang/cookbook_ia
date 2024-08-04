import 'package:cookbook_ia/core/navigation_service.dart';
import 'package:cookbook_ia/core/setting.dart';
import 'package:cookbook_ia/core/sizeconfig.dart';
import 'package:cookbook_ia/firebase_options.dart';
import 'package:cookbook_ia/presentation/screens/common/onboarding_screen.dart';
import 'package:cookbook_ia/presentation/screens/mobile/dashbord_screen.dart';
import 'package:features_tour/features_tour.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

Future<void> myBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  return MyAppState()._showNotification(message);
}

 Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform,);
  FirebaseMessaging.onBackgroundMessage(myBackgroundHandler);
  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  setupLocator();

  FeaturesTour.setGlobalConfig(
    force: true,
    predialogConfig: PredialogConfig(
      enabled: false,
    ),
    childConfig: ChildConfig(isAnimateChild: false),
    debugLog: false,
  );

  runApp(
       ProviderScope(child: MyApp())
    );
}

class MyApp extends StatefulHookConsumerWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends ConsumerState<MyApp> {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState()  {
      /**
       * Requesting Permission
       */
      requestingPermissionForIOS();

      var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
      );

      final InitializationSettings initializationSettings =
          InitializationSettings(
              android: initializationSettingsAndroid,
              iOS: initializationSettingsIOS);

      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: onDidReceiveNotificationResponse, 
          onDidReceiveBackgroundNotificationResponse: notificationTapBackground
           );

      super.initState();

      FirebaseMessaging.onMessage.listen((message) {
        if (message.data.isNotEmpty) MyAppState()._showNotification(message);
      });

    }

  requestingPermissionForIOS() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
    
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  Future _showNotification(RemoteMessage message) async {

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    Map<String, dynamic> data = message.data;
    AndroidNotification? android = message.notification?.android;

    if (message.notification != null) {

      String payloadData = "";
    
      flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: android?.smallIcon,
          ),
          iOS: const DarwinNotificationDetails(presentAlert: true, presentSound: true),
        ),
        payload: payloadData,
      );
    }
  }

  static void notificationTapBackground(NotificationResponse? notificationResponse) async { 
    String? payload= notificationResponse!.payload.toString();
     final prefs = await SharedPreferences.getInstance();
     prefs.setString("payload",payload.toString());
     String connected = await checkifLogged();
     if(connected == 1) {
        Navigator.of(locator<NavigationService>().navigatorKey.currentContext!).push(
            MaterialPageRoute(
            builder: (context) => DashbordScreen())); 
     } else {
        Navigator.of(locator<NavigationService>().navigatorKey.currentContext!).push(
            MaterialPageRoute(
            builder: (context) => OnboardingScreen())); 
      }
     
  }

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {

    String? payload= notificationResponse!.payload.toString();
     
     final prefs = await SharedPreferences.getInstance();
     prefs.setString("payload",payload.toString());
     String connected = await checkifLogged();
     if(connected == 1) {
        Navigator.of(locator<NavigationService>().navigatorKey.currentContext!).push(
            MaterialPageRoute(
            builder: (context) => DashbordScreen())); 
     } else {
        Navigator.of(locator<NavigationService>().navigatorKey.currentContext!).push(
            MaterialPageRoute(
            builder: (context) => OnboardingScreen())); 
      }
  }

  static Future<String> checkifLogged() async {

    final prefs = await SharedPreferences.getInstance();
    String uuid = prefs.getString("id") ?? "";
    if (FirebaseAuth.instance.currentUser == null) return "0";
    else if(uuid.isEmpty) return "0";
    else return "1";
    
  }

  @override
  Widget build(BuildContext context) {

    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
    
        return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return OverlaySupport(child: MaterialApp(
            title: Setting.appName,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.transparent)
            ),
            navigatorKey: locator<NavigationService>().navigatorKey,
            navigatorObservers: <NavigatorObserver>[observer],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: Setting.allSupportedLocales(),
            home: FutureBuilder<String>(
              future: checkifLogged(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  if(snapshot.data == "0") return UpgradeAlert(child : OnboardingScreen());
                  else return UpgradeAlert(child :  DashbordScreen());
                }

                return Scaffold(
                    body: Container(
                      color: Setting.bgColor,
                      child : const Center(
                      child: CircularProgressIndicator(color: Setting.primaryColor,),
                    )),
                  );
                
              },
             )
            )
                );
              },
          );
      },
    );
    


  }
}
