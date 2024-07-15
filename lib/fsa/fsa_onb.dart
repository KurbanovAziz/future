import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:future_savings_app_29_t/fsa/fsa_color.dart';
import 'package:future_savings_app_29_t/fsa/fsa_mot.dart';
import 'package:future_savings_app_29_t/fsa/paywall_screen.dart';

import '../generated/assets.dart';

class OnboardingData {
  final String title;
  final String image;

  const OnboardingData({
    required this.title,
    required this.image,
  });
}

const List<OnboardingData> dataFsaBoard = [
  OnboardingData(
    title: 'Simplify your retirement\nplanning',
    image: Assets.imagesOnboard1,
  ),
  OnboardingData(
    title: ' Diversify your\ninvestments',
    image: Assets.imagesOnboard2,
  ),
  OnboardingData(
    title: '  Your review would help\nus a lot',
    image: Assets.imagesOnboard3,
  ),
  OnboardingData(
    title: ' Ensure a bright future\ntoday',
    image: Assets.imagesOnboard4,
  ),
];

class TBConBording extends StatefulWidget {
  const TBConBording({super.key});

  @override
  State<TBConBording> createState() => _SenseOnbState();
}

class _SenseOnbState extends State<TBConBording> {
  final PageController _controller = PageController();
  int introIndex = 0;
  bool showIndicators = true;
  final ValueNotifier<int> _ratingNotifier = ValueNotifier<int>(0);
  int rating = 0;

  void _showRatingDialog() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0.r),
                  child: Image.asset(
                    Assets.imagesLogo,
                    height: 60.h,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Rate the app',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.black,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Tap a star to rate. You can also leave a comment',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: CupertinoColors.black,
                ),
              ),
              SizedBox(height: 16.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ValueListenableBuilder<int>(
                  valueListenable: _ratingNotifier,
                  builder: (context, rating, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                            (index) =>
                            IconButton(
                              icon: Icon(
                                index < rating
                                    ? CupertinoIcons.star_fill
                                    : CupertinoIcons.star,
                                color: FsaColor.blue,
                                size: 24.sp,
                              ),
                              onPressed: () {
                                _ratingNotifier.value = index + 1;
                              },
                            ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: FsaColor.blue,
                ),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                // todo: handle submit action
              },
              child: Text(
                'Submit',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: FsaColor.blue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  introIndex = index;
                });
                if (index == dataFsaBoard.length - 1) {
                  _showRatingDialog();
                }
              },
              itemCount: dataFsaBoard.length,
              itemBuilder: (context, index) {
                return OnboardingPageItem(
                  dataRPBoard: dataFsaBoard[index],
                  currentIndex: introIndex,
                  itemCount: dataFsaBoard.length,
                );
              },
            ),
          ),
          if (showIndicators)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: FsaMot(
                onPressed: () {
                  if (introIndex < dataFsaBoard.length - 1) {
                    _controller.animateToPage(
                      introIndex + 1,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaywallScreen(),
                      ),
                    );
                  }
                },
                child: Container(
                  height: 56.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: FsaColor.blue,
                    borderRadius: BorderRadius.circular(32.r),
                  ),
                  child: Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: FsaColor.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}

class OnboardingPageItem extends StatelessWidget {
  final OnboardingData dataRPBoard;
  final int currentIndex;
  final int itemCount;

  const OnboardingPageItem({
    super.key,
    required this.dataRPBoard,
    required this.currentIndex,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.all(20.0.h),
        child: Column(
          children: [
            ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  dataRPBoard.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                dataRPBoard.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.sp,
                  color: FsaColor.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
