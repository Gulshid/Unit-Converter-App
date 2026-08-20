import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:unit_converter/Routes/Routes.dart';
import 'package:unit_converter/Routes/RoutesName.dart';
import 'package:unit_converter/ViewModel/UnitProvider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: getdesignSize(context),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create:(_)=> Unitprovider()),
          ],

          child: Builder(
            builder: (BuildContext context) {
              return Consumer<Unitprovider>(
                builder: (context, provider, _) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Unit Converter',
                    themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                    theme: ThemeData(
                      applyElevationOverlayColor: true,
                      brightness: Brightness.light,
                      colorScheme: ColorScheme.fromSeed(
                        seedColor: Colors.teal,
                        brightness: Brightness.light,
                      ),
                      appBarTheme: const AppBarTheme(backgroundColor: Colors.teal),
                      textTheme: Typography.englishLike2018.apply(
                        fontSizeFactor: 1.sp,
                      ),
                    ),
                    darkTheme: ThemeData(
                      brightness: Brightness.dark,
                      colorScheme: ColorScheme.fromSeed(
                        seedColor: Colors.teal,
                        brightness: Brightness.dark,
                      ),
                      appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF0F3D3E)),
                      textTheme: Typography.englishLike2018.apply(
                        fontSizeFactor: 1.sp,
                        bodyColor: Colors.white,
                        displayColor: Colors.white,
                      ),
                    ),
                    initialRoute: Routesname.home,
                    onGenerateRoute: Routes.generate_Route,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

Size getdesignSize(BuildContext context) {
  double width = MediaQuery.of(context).size.width;

  if (width < 600) {
    return Size(360, 690);
  } else if (width < 1200) {
    return Size(834, 1194);
  } else {
    return Size(1440, 1024);
  }
}