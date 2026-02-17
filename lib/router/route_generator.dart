import 'package:flutter/material.dart';
import 'package:cartsync/features/auth/presentation/pages/login_page.dart';
import 'package:cartsync/features/auth/presentation/pages/register_page.dart';
import 'package:cartsync/features/checklist/presentation/pages/checklist_detail_page.dart';
import 'package:cartsync/features/checklist/presentation/pages/create_checklist_page.dart';
import 'package:cartsync/features/family/presentation/pages/create_family_page.dart';
import 'package:cartsync/features/family/presentation/pages/family_page.dart';
import 'package:cartsync/features/item/presentation/pages/create_item_page.dart';
import 'package:cartsync/features/session/presentation/pages/create_session_page.dart';
import 'package:cartsync/features/session/presentation/pages/session_detail_page.dart';
import 'package:cartsync/features/main/main_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/main':
        return MaterialPageRoute(builder: (_) => const MainScreen());

      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterPage());

      case '/create-family':
        return MaterialPageRoute(builder: (_) => const CreateFamilyPage());

      case '/create-session':
        return MaterialPageRoute(builder: (_) => const CreateSessionPage());

      case '/session-detail':
        final sessionId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => SessionDetailPage(sessionId: sessionId),
        );

      case '/create-checklist':
        final sessionId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => CreateChecklistPage(sessionId: sessionId),
        );

      case '/checklist-detail':
        final checklistId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ChecklistDetailPage(checklistId: checklistId),
        );

      case '/create-item':
        final checklistId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => CreateItemPage(checklistId: checklistId),
        );

      default:
        return MaterialPageRoute(builder: (_) => const LoginPage());
    }
  }
}
