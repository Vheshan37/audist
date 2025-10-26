import 'package:audist/common/widgets/custom_background.dart';
import 'package:audist/core/color.dart';
import 'package:audist/core/navigation/app_navigator.dart';
import 'package:audist/core/navigation/app_routes.dart';
import 'package:audist/core/sizes.dart';
import 'package:audist/core/string.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // TODO: enable navigation to next page after splash
    _goToNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: Image.asset(
                    'assets/images/header_devider_splash.png',
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ),
                SafeArea(
                  child: Container(
                    // color: Colors.red,
                    padding: EdgeInsets.only(bottom: AppSizes.paddingMedium),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          Strings.copyright,
                          style: TextStyle(
                            color: AppColors.surfaceSecondary,
                            fontSize: AppSizes.bodySmall,
                          ),
                        ),
                        Text(
                          Strings.appDeveloper,
                          style: TextStyle(
                            color: AppColors.surfaceSecondary,
                            fontSize: AppSizes.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: Opacity(
                      opacity: 0.5,
                      child: Image.asset(
                        'assets/images/transparent_logo_large.png',
                        fit: BoxFit.contain,
                        color: AppColors.brandDark,
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Strings.splash.title,
                          style: TextStyle(
                            fontSize: AppSizes.titleMedium,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            color: AppColors.surfaceDark,
                          ),
                        ),
                        Text(
                          Strings.splash.subTitle,
                          style: TextStyle(
                            fontSize: AppSizes.bodyMedium,
                            fontFamily: 'Poppins',
                            color: AppColors.surfaceDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goToNextPage() async {
    await Future.delayed(const Duration(seconds: 3));
    AppNavigator.pushReplacement(AppRoutes.languageChooser);
  }
}
