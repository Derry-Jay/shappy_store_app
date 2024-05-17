import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shappy_store_app/route_generator.dart';
import 'package:shappy_store_app/src/helpers/bloc.dart';
import 'package:shappy_store_app/src/helpers/helper.dart';
import 'package:shappy_store_app/src/models/route_argument.dart';
import 'package:shappy_store_app/src/pages/Googlemap.dart';
import 'package:shappy_store_app/src/pages/logo_page.dart';
import 'src/helpers/custom_trace.dart';
import 'src/helpers/app_config.dart' as config;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:global_configuration/global_configuration.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("configurations");
  print(CustomTrace(StackTrace.current,
      message:
          "api_base_url: ${GlobalConfiguration().getString('api_base_url')}"));
  Uri url = Uri.parse("https://www.google.com");
  var client = new HttpClient();
  var request = await client.getUrl(url);
  var response = await request.close();
  var responseBytes = (await response.toList()).expand((x) => x);
  print(new String.fromCharCodes(responseBytes));
  client.close();
  print(CustomTrace(StackTrace.current,
      message: "base_url: ${GlobalConfiguration().getString('base_url')}"));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();
  Future<SharedPreferences> _sharePrefs = SharedPreferences.getInstance();
  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  LocalNotification get notification => null;
  @override
  void initState() {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    configureFirebase(firebaseMessaging, context);
    _initLocalNotifications();
    super.initState();
  }

  _initLocalNotifications() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Shappy",
        // initialRoute: '/Logo',
        home: LogoPage(),
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Montserrat',
          primaryColor: Helper.custom_red,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              elevation: 0, foregroundColor: Colors.white),
          brightness: Brightness.light,
          accentColor: config.Colors().mainColor(1),
          dividerColor: config.Colors().accentColor(0.1),
          focusColor: config.Colors().accentColor(1),
          hintColor: config.Colors().secondColor(1),
          textTheme: TextTheme(
            headline5: TextStyle(
                fontSize: 20.0,
                color: config.Colors().secondColor(1),
                height: 1.35),
            headline4: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: config.Colors().secondColor(1),
                height: 1.35),
            headline3: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: config.Colors().secondColor(1),
                height: 1.35),
            headline2: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w700,
                color: config.Colors().mainColor(1),
                height: 1.35),
            headline1: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w300,
                color: config.Colors().secondColor(1),
                height: 1.5),
            subtitle1: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: config.Colors().secondColor(1),
                height: 1.35),
            headline6: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: config.Colors().mainColor(1),
                height: 1.35),
            bodyText2: TextStyle(
                fontSize: 12.0,
                color: config.Colors().secondColor(1),
                height: 1.35),
            bodyText1: TextStyle(
                fontSize: 14.0,
                color: config.Colors().secondColor(1),
                height: 1.35),
            caption: TextStyle(
                fontSize: 12.0,
                color: config.Colors().accentColor(1),
                height: 1.35),
          ),
        ));
  }

  Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    print('AppPush myBackgroundMessageHandler : $message');
    _showNotification(message);
    return Future<void>.value();
  }

  void configureFirebase(
      FirebaseMessaging _firebaseMessaging, BuildContext context) async {
    try {
      final SharedPreferences sharedPrefs = await _sharePrefs;
      _firebaseMessaging.getToken().then((String _deviceToken) {
        sharedPrefs.setString("spDeviceToken", _deviceToken);
        print("Device token:" + _deviceToken);
        sharedPrefs.setInt("appType", Platform.isAndroid ? 0 : 1);
      }).catchError((e) {
        print('Notification not configured');
      });
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          final data = message['data'];
          print("notificationOnMessage");
          print(message);
          // Navigator.of(context).pushNamed('/Home');
          _showNotification(message);
          if (message['data'] != null) {
            final notification = LocalNotification("data", message['data'] as Map);
            NotificationsBloc.instance.newNotification(notification);
            return null;
          }
          print("end------------");
          // Toast.show(data.toString(), context);
        },
        onBackgroundMessage: (Map<String, dynamic> message) async {
          print('AppPush myBackgroundMessageHandler : $message');
          _showNotification(message);
          return Future<void>.value();
        },
        onLaunch: notificationOnLaunch,
        onResume: (Map<String, dynamic> message) async {
          print('@onResume');
          print('onResume: $message');
          print(context);
          print(message['data']['screen']);
          navigator.currentState
              .pushNamed(message['data']['screen'], arguments: 0);
          print('End of Resume');
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  static Future notificationOnResume(Map<String, dynamic> message) async {
    // final context = context;
    try {
      final data = message['data'];
      // Toast.show(data.toString(), context);
      print(data);
      if (message['data']['id'] == "orders") {
        // settingRepo.navigatorKey.currentState.pushReplacementNamed('/Pages', arguments: 3);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future notificationOnLaunch(Map<String, dynamic> message) async {
    final data = message['data'];
    print(data);
    // Toast.show(data.toString(), context);
    _showNotification(message);
  }

  Future notificationOnMessage(Map<String, dynamic> message) async {
    final data = message['data'];
    print("notificationOnMessage");
    print(data);
    // Navigator.of(context).pushNamed('/Home');
    _showNotification(data);
    print("end------------");
    // Toast.show(data.toString(), context);
  }

  Future _showNotification(Map<String, dynamic> message) async {
    var pushTitle;
    var pushText;
    var action;
    print(message);
    if (Platform.isAndroid) {
      pushTitle = message['notification']['title'];
      pushText = message['notification']['body'];
      action = message['data']['screen'];
    } else {
      pushTitle = message['title'];
      pushText = message['body'];
    }
    print("AppPushs params pushTitle : $pushTitle");
    print("AppPushs params pushText : $pushText");
    // Navigator.of(pageContext).pushNamed(action);
    print("AppPushs params pushAction : $action");
    var platformChannelSpecificsAndroid = new AndroidNotificationDetails(
        'fcm_default_channel', 'shappy', 'testing',
        playSound: true,
        enableVibration: false,
        importance: Importance.Max,
        priority: Priority.High);
    var platformChannelSpecificsIos =
        new IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = new NotificationDetails(
        platformChannelSpecificsAndroid, platformChannelSpecificsIos);
    new Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        pushTitle,
        pushText,
        platformChannelSpecifics,
        payload: 'No_Sound',
      );
      // Navigator.of(Helper.bc).pushNamed('/myProfile');
    });
  }
// static Future onMessage(Map<String, dynamic> message) async {
//   // Navigator.of(context).pushNamed('/order_not');
// }
}
