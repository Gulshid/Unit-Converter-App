import 'package:flutter/material.dart';
import 'package:unit_converter/Routes/RoutesName.dart';
import 'package:unit_converter/Views_/Home_view.dart';

class Routes {
  static Route<dynamic> generate_Route(RouteSettings route) {
    switch (route.name) {
      case Routesname.home:
        {
          return MaterialPageRoute(
            builder: (BuildContext context) => HomeView(),
          );
        }

      default:
      {
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('There is no route which i can Navigate'),),
          ),
        );
      }
    }
  }
}
