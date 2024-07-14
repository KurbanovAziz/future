import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:future_savings_app_29_t/fsa/fsa_btom.dart';
import 'package:future_savings_app_29_t/fsa/fsa_color.dart';

import '../generated/assets.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: FsaColor.black,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 50.0.h, horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const TBCBotmBar()),
                      );
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24.sp,
                    )
                ),
              ),
              Image.asset(
                  Assets.imagesPaywall
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    "Get Premium",
                    style: TextStyle(
                        color: FsaColor.blue,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w400
                    )
                ),
              ),
              SizedBox(height: 16.h),
              _buildFeatureRow('Access Endless Calculations'),
              _buildFeatureRow('Create Unlimited Funds'),
              SizedBox(height: 24.h),
              Text(
                  "Unlock all features just for ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w400
                  )
              ),
              Text(
                  "\$0.99",
                  style: TextStyle(
                    color: FsaColor.blue,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w400,
                  )
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  height: 56.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32.r),
                    color: FsaColor.blue,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'GET PREMIUM',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: FsaColor.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          // todo
                        },
                        child: Text(
                            "Terms of Use",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp
                            )
                        )
                    ),
                    TextButton(
                        onPressed: () {
                          // todo
                        },
                        child: Text(
                            "Restore",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp
                            )
                        )
                    ),
                    TextButton(
                      onPressed: () {
                        //todo
                      },
                      child: Text(
                          "Privacy Policy",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp
                          )
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String feature) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            CupertinoIcons.check_mark_circled,
            color: CupertinoColors.activeBlue,
          ),
          SizedBox(width: 10.w),
          Text(
            feature,
            style: TextStyle(
              fontSize: 16.sp,
              color: CupertinoColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
