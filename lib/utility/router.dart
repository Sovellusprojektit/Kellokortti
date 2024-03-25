import 'package:flutter/material.dart';
import '../pages/homepage.dart';
import '../pages/loginpage.dart';
import '../pages/adminhomepage.dart';
import '../pages/settings.dart';
import '../pages/accountinfopage.dart';
import '../pages/menuPage.dart';
import '../pages/manage_employees.dart';
import '../pages/registerpage.dart';
import '../pages/add_employees.dart';
import '../pages/calendar_admin.dart';
import '../pages/add_events_page.dart';
import '../pages/calendar_page.dart';
import '../pages/salaryinfo.dart';
import '../pages/workHistory.dart';
import '../pages/guide.dart';
import '../pages/addClients.dart';

const String homePage = '/';
const String loginPage = '/login';
const String settingsPage = '/settings';
const String menuPage = '/menu';
const String adminHomePage = '/admin';
const String profilePage = '/profile';
const String manageEmployees = '/manageEmployees';
const String registerpage = '/register';
const String addEmployees = '/addEmployees';
const String calendarAdmin = '/calendarAdmin';
const String addEvent = '/addEvent';
const String calendarPage = '/calendarPage';
const String salaryInfo = '/salaryInfo';
const String workHistory = '/workHistory';
const String guide = '/guide';
const String addClients = '/addClients';

Route<dynamic> controller(RouteSettings destination, {required bool isWeb}) {
  switch (destination.name) {
    case homePage:
      return MaterialPageRoute(
          builder: (context) => HomePage(
                isWeb: isWeb,
              ));
    case loginPage:
      return MaterialPageRoute(builder: (context) => LoginPage(isWeb: isWeb));
    case adminHomePage:
      return MaterialPageRoute(
          builder: (context) => AdminHomePage(isWeb: isWeb));
    case menuPage:
      return MaterialPageRoute(builder: (context) => MenuPage(isWeb: isWeb));
    case settingsPage:
      return MaterialPageRoute(
          builder: (context) => SettingsPage(isWeb: isWeb));
    case profilePage:
      return MaterialPageRoute(
          builder: (context) => AccountInfoPage(isWeb: isWeb));
    case manageEmployees:
      return MaterialPageRoute(
          builder: (context) => EmployeeManager(isWeb: isWeb));
    case registerpage:
      return MaterialPageRoute(
          builder: (context) => RegisterPage(isWeb: isWeb));
    case addEmployees:
      return MaterialPageRoute(builder: (context) => AddEmployee(isWeb: isWeb));
    case calendarAdmin:
      return MaterialPageRoute(
          builder: (context) => CalendarAdmin(isWeb: isWeb));
    case addEvent:
      return MaterialPageRoute(
          builder: (context) => AddEventsPage(isWeb: isWeb));
    case calendarPage:
      return MaterialPageRoute(
          builder: (context) => CalendarPage(isWeb: isWeb));
    case salaryInfo:
      return MaterialPageRoute(builder: (context) => SalaryInfo(isWeb: isWeb));
    case workHistory:
      return MaterialPageRoute(builder: (context) => Workhistory(isWeb: isWeb));
    case guide:
      return MaterialPageRoute(builder: (context) => Guide(isWeb: isWeb));
    case addClients:
      return MaterialPageRoute(builder: (context) => AddClients(isWeb: isWeb));


    default:
      throw ('This route does not exist');
  }
}
