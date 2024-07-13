import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:future_savings_app_29_t/calacul/calacul_screen.dart';
import 'package:future_savings_app_29_t/fsa/fsa_color.dart';
import 'package:future_savings_app_29_t/fsa/fsa_mot.dart';
import 'package:future_savings_app_29_t/phochinki/phochinki_screen.dart';
import 'package:future_savings_app_29_t/res/res_screen.dart';
import 'package:future_savings_app_29_t/trak/trak_screen.dart';

class FsaBotmBarState extends State<TBCBotmBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.indexScr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: ClipRRect(
          child: Container(
            height: 100.h,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: FsaColor.black,
              border: Border(
                top: BorderSide(
                  color: Colors.black
                      .withOpacity(0.3), // Change this to the desired color
                  width: 0.5.h,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    child: buildNavItem(
                        0, 'assets/icons/calacul.svg', 'calculator')),
                Expanded(
                    child:
                        buildNavItem(1, 'assets/icons/trak.svg', 'tracker')),
                Expanded(
                    child:
                        buildNavItem(2, 'assets/icons/res.svg', 'resources')),
                Expanded(
                    child:
                        buildNavItem(3, 'assets/icons/phochinki.svg', 'settings')),
              ],
            ),
          ),
        ));
  }

  Widget buildNavItem(int index, String iconPath, String label) {
    return FsaMot(
      onPressed: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 28.sp,
            height: 28.sp,
            color:
                _currentIndex == index ? FsaColor.blue : Colors.white.withOpacity(0.6),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color:
                  _currentIndex == index ? FsaColor.blue : Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  final _pages = <Widget>[
    CalaculScreen(),
    TrakScreen(),
    ResScreen(),
    PhochinkiScreen(),
  ];
}

class TBCBotmBar extends StatefulWidget {
  const TBCBotmBar({super.key, this.indexScr = 0});
  final int indexScr;

  @override
  State<TBCBotmBar> createState() => FsaBotmBarState();
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TBCBotmBar(),
    );
  }
}
