import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:future_savings_app_29_t/fsa/fsa_color.dart';
import 'package:future_savings_app_29_t/fsa/fsa_mot.dart';



class TBConBording extends StatefulWidget {
  const TBConBording({super.key});

  @override
  State<TBConBording> createState() => _SenseOnbState();
}

class _SenseOnbState extends State<TBConBording> {
  final PageController _controller = PageController();
  int introIndex = 0;
  bool showIndicators = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                introIndex = index;
                if (index == 4) {
                  showIndicators = false;
                } else {
                  showIndicators = true;
                }
              });
            },
            children: const [
             
            ],
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (showIndicators)
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 18.h),
                      ),
                      FsaMot(
                        onPressed: () {
                          if (introIndex < 2) {
                            _controller.animateToPage(
                              introIndex + 1,
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const ServiceScreen(),
                            //   ),
                            // );
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Container(
                            height: 56.h,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: FsaColor.black,
                              borderRadius: BorderRadius.circular(32.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: FsaColor.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
