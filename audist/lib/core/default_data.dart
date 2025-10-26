import 'package:audist/core/navigation/app_routes.dart';
import 'package:audist/core/string.dart';
import 'package:flutter/material.dart';

class DefaultData {
  DefaultData._();

  static List<Map<String, dynamic>> getMenuItems() {
    return [
      {
        // * add new case
        'icon': Icons.add_box_rounded,
        'title': Strings.home.menuItem1,
        'route': AppRoutes.newCase,
      },
      {
        // * next cases
        'icon': Icons.next_week_rounded,
        'title': Strings.home.menuItem5,
        'route': AppRoutes.caseHistory,
      },
      {
        // * add payments
        'icon': Icons.payments_rounded,
        'title': Strings.home.menuItem2,
        'route': AppRoutes.addPayment,
      },
      {
        // * examined cases
        'icon': Icons.work_history,
        'title': Strings.home.menuItem4,
        'route': AppRoutes.caseHistory,
      },
      {
        // * ledger management
        'icon': Icons.receipt_rounded,
        'title': Strings.home.menuItem3,
        'route': AppRoutes.paymentHistory,
      },
      {
        // * settings
        'icon': Icons.settings,
        'title': Strings.home.menuItem6,
        'route': AppRoutes.caseHistory,
      },
    ];
  }
}
