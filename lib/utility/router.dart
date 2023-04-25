import 'package:flutter/material.dart';
import '../pages/homepage.dart';
import '../pages/loginpage.dart';
import '../pages/adminhomepage.dart';
import '../pages/settings.dart';
import '../pages/accountinfopage.dart';
import '../pages/menupage.dart';
import '../pages/manage_employees.dart';
import '../pages/registerpage.dart';
import '../pages/add_employees.dart';
import '../pages/calendar_admin.dart';
import '../pages/add_events_page.dart';
import '../pages/calendar_page.dart';
import '../pages/salaryinfo.dart';
import '../pages/workHistory.dart';



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

Route<dynamic> controller(RouteSettings destination) {
  switch (destination.name) {
    case homePage:
      return MaterialPageRoute(builder: (context) => const HomePage());
    case loginPage:
      return MaterialPageRoute(builder: (context) => const LoginPage());
    case adminHomePage:
      return MaterialPageRoute(builder: (context) => const AdminHomePage());
    case menuPage:
      return MaterialPageRoute(builder: (context) => const MenuPage());
    case settingsPage:
      return MaterialPageRoute(builder: (context) => const SettingsPage());
    case profilePage:
      return MaterialPageRoute(builder: (context) => const AccountInfoPage());
    case manageEmployees:
      return MaterialPageRoute(builder: (context) => const EmployeeManager());
    case registerpage:
      return MaterialPageRoute(builder: (context) => const RegisterPage());
    case addEmployees:
      return MaterialPageRoute(builder: (context) => const AddEmployee());
    case calendarAdmin:
      return MaterialPageRoute(builder: (context) => const CalendarAdmin());
    case addEvent:
      return MaterialPageRoute(builder: (context) => const AddEventsPage());
    case calendarPage:
      return MaterialPageRoute(builder: (context) => const CalendarPage());
    case salaryInfo:
      return MaterialPageRoute(builder: (context) => const SalaryInfo());
      case workHistory:
      return MaterialPageRoute(builder: (context) => const Workhistory());


    default:
      throw ('This route does not exist');
  }
}
