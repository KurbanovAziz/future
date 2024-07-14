import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 16),
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
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    )
                ),
              ),
              Image.asset(
                  Assets.imagesPaywall
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    "Get Premium",
                    style: TextStyle(
                        color: FsaColor.blue,
                        fontSize: 32,
                        fontWeight: FontWeight.w400
                    )
                ),
              ),
              const SizedBox(height: 16),
              _buildFeatureRow('Access Endless Calculations'),
              _buildFeatureRow('Create Unlimited Funds'),
              const SizedBox(height: 24),
              const Text(
                  "Unlock all features just for ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w400
                  )
              ),
              const Text(
                  "\$0.99",
                  style: TextStyle(
                    color: FsaColor.blue,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  )
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 56,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: FsaColor.blue,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'GET PREMIUM',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: FsaColor.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          // todo
                        },
                        child: const Text(
                            "Terms of Use",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            )
                        )
                    ),
                    TextButton(
                        onPressed: () {
                          // todo
                        },
                        child: const Text(
                            "Restore",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            )
                        )
                    ),
                    TextButton(
                      onPressed: () {
                        //todo
                      },
                      child: const Text(
                          "Privacy Policy",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14
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
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            CupertinoIcons.check_mark_circled,
            color: CupertinoColors.activeBlue,
          ),
          const SizedBox(width: 10),
          Text(
            feature,
            style: const TextStyle(
              fontSize: 16,
              color: CupertinoColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
