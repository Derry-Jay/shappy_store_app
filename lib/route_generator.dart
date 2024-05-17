import 'package:flutter/material.dart';
import 'package:shappy_store_app/src/models/route_argument.dart';
import 'package:shappy_store_app/src/pages/search_product_categories_page.dart';
import 'package:shappy_store_app/src/pages/search_products_page.dart';
import 'package:shappy_store_app/src/pages/store_registration_page.dart';
import 'package:shappy_store_app/src/pages/approval_pause_page.dart';
import 'package:shappy_store_app/src/pages/category_based_products_page.dart';
import 'package:shappy_store_app/src/pages/home_page.dart';
import 'package:shappy_store_app/src/pages/login_screen.dart';
import 'package:shappy_store_app/src/pages/logo_page.dart';
import 'package:shappy_store_app/src/pages/mobile_verification.dart';
import 'package:shappy_store_app/src/pages/my_store_page.dart';
import 'package:shappy_store_app/src/pages/order_location_page.dart';
import 'package:shappy_store_app/src/pages/order_notification.dart';
import 'package:shappy_store_app/src/pages/orders_page.dart';
import 'package:shappy_store_app/src/pages/products_status_page.dart';
import 'package:shappy_store_app/src/pages/sales_details_page.dart';
import 'package:shappy_store_app/src/pages/settings_page.dart';
import 'package:shappy_store_app/src/pages/splash_screen.dart';
import 'package:shappy_store_app/src/pages/add_store_detail_page.dart';
import 'package:shappy_store_app/src/pages/add_store_location_page.dart';
import 'package:shappy_store_app/src/pages/faq_page.dart';
import 'package:shappy_store_app/src/pages/notifications_page.dart';
import 'package:shappy_store_app/src/pages/store_details_page.dart';
import 'package:shappy_store_app/src/pages/store_profile_page.dart';
import 'package:shappy_store_app/src/pages/customers_page.dart';
import 'package:shappy_store_app/src/pages/category_cum_products_page.dart';
import 'package:shappy_store_app/src/pages/order_details_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case '/Splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/Logo':
        return MaterialPageRoute(builder: (_) => LogoPage());
      case '/Login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/Settings':
        return MaterialPageRoute(builder: (_) => SettingsPage());
      case '/Store_detail':
        return MaterialPageRoute(
            builder: (_) => StoreDetailsPage(args as RouteArgument));
      case '/Store_location':
        return MaterialPageRoute(
            builder: (_) => StoreLocationPage(args as RouteArgument));
      case '/Home':
        return MaterialPageRoute(
            builder: (_) => HomePage(routeArgument: args as RouteArgument));
      case '/Orders':
        return MaterialPageRoute(builder: (_) => OrdersPage(args));
      case '/Faq':
        return MaterialPageRoute(
            builder: (_) => FrequentlyAskedQuestionsPage());
      case '/Notifications':
        return MaterialPageRoute(builder: (_) => NotificationsPage());
      case '/Store_profile':
        return MaterialPageRoute(builder: (_) => StoreProfilePage());
      case '/Customers':
        return MaterialPageRoute(builder: (_) => CustomersPage());
      case '/Products':
        return MaterialPageRoute(builder: (_) => CategoriesAndProductsPage());
      case '/Products_Status':
        return MaterialPageRoute(builder: (_) => ProductsStatusPage());
      case '/order_not':
        return MaterialPageRoute(
            builder: (_) => OrderNotification(args as String));
      case '/OTP':
        return MaterialPageRoute(
            builder: (_) => OTPScreen(routeArgument: args as RouteArgument));
      case '/myStore':
        return MaterialPageRoute(builder: (_) => MyStorePage());
      case '/order_location':
        return MaterialPageRoute(
            builder: (_) => OrderLocationPage(args as RouteArgument));
      case '/waitForApproval':
        return MaterialPageRoute(
            builder: (_) => ApprovalPausePage(args as RouteArgument));
      case '/shopNewRegistration':
        return MaterialPageRoute(
            builder: (_) => StoreRegistrationDetailsPage(args as RouteArgument));
      case '/store_data_edit':
        return MaterialPageRoute(
            builder: (_) => StoreDataEditTabsPage(args as RouteArgument));
      case '/order_details':
        return MaterialPageRoute(
            builder: (_) => OrderDetailsPage(args as RouteArgument));
      case '/salesData':
        return MaterialPageRoute(builder: (_) => SalesDetailsPage());
      case '/CatProduct':
        return MaterialPageRoute(
            builder: (_) => CategoryBasedProductsPage(args as RouteArgument));
      case '/catSearch':
        return MaterialPageRoute(builder: (_) => SearchProductCategoriesPage());
      case '/proSearch':
        return MaterialPageRoute(builder: (_) => SearchProductsPage());
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(
            builder: (_) =>
                Scaffold(body: SafeArea(child: Text('Route Error'))));
    }
  }
}
