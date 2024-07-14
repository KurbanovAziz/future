import 'package:apphud/apphud.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:future_savings_app_29_t/floor/dao/appdatabase/app_database.dart';
import 'package:future_savings_app_29_t/fsa/fsa_color.dart';
import 'package:future_savings_app_29_t/fsa/fsa_dok.dart';
import 'package:future_savings_app_29_t/fsa/fsa_onb.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///Floor
  AppDatabase database =
  await $FloorAppDatabase.databaseBuilder('app_database.db').build();

  GetIt.I.registerSingleton(database);
  GetIt.I.registerSingleton(EventBus());

  runApp(const MyApp());

  await Apphud.start(apiKey: FsaDokm.aPpHadK);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Future savings app',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: FsaColor.black,
          ),
          scaffoldBackgroundColor: FsaColor.black,
          fontFamily: 'Inter',
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
        ),
        home: const SplashScreen(
          seconds: 3,
          navigateAfterSeconds: TBConBording(),
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final int seconds;
  final Widget navigateAfterSeconds;

  const SplashScreen({
    super.key,
    required this.seconds,
    required this.navigateAfterSeconds,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: widget.seconds), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (BuildContext context) => widget.navigateAfterSeconds),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FsaColor.black,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 87.w),
          child: Image.asset(
            'assets/images/logo.png',
          ),
        ),
      ),
    );
  }
}
