import 'package:audist/common/widgets/custom_background.dart';
import 'package:audist/core/color.dart';
import 'package:audist/core/navigation/app_navigator.dart';
import 'package:audist/core/navigation/app_routes.dart';
import 'package:audist/core/sizes.dart';
import 'package:audist/core/string.dart';
import 'package:audist/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) => CustomBackground(
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
                      padding: EdgeInsets.only(bottom: AppSizes.paddingMedium),
                      // color: Colors.red,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            Strings.copyright,
                            style: TextStyle(
                              color: AppColors.surfaceDark,
                              fontSize: AppSizes.bodySmall,
                            ),
                          ),
                          Text(
                            Strings.appDeveloper,
                            style: TextStyle(
                              color: AppColors.surfaceDark,
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
                            Strings.languageChooser.title,
                            style: TextStyle(
                              fontSize: AppSizes.titleMedium,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              color: AppColors.brandDark,
                            ),
                          ),
                          Text(
                            Strings.languageChooser.subTitle,
                            style: TextStyle(
                              fontSize: AppSizes.bodyMedium,
                              fontFamily: 'Poppins',
                              color: AppColors.brandDark,
                            ),
                          ),

                          // * language selection buttons
                          SizedBox(height: AppSizes.spacingMedium),
                          Row(
                            spacing: AppSizes.spacingSmall,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    // bool changedLanguage = context
                                    //     .read<LanguageProvider>()
                                    //     .toggleLanguage();
                                    // isEnglish = changedLanguage;
                                    if (!languageProvider.isEnglish) {
                                      context
                                          .read<LanguageProvider>()
                                          .changeLanguage(
                                            true,
                                          ); // * convert to english
                                    }
                                  },
                                  child: Container(
                                    // padding: EdgeInsets.symmetric(vertical: 8),
                                    alignment: Alignment.center,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: AppColors.brandAccent,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.borderRadiusSmall,
                                      ),
                                      gradient: languageProvider.isEnglish
                                          ? AppColors.primaryGradient
                                          : null,
                                    ),
                                    child: Text(
                                      Strings.languageChooser.english,
                                      style: languageProvider.isEnglish
                                          ? TextStyle(
                                              color: AppColors.surfaceLight,
                                            )
                                          : TextStyle(
                                              color: AppColors.brandDark,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    // bool changedLanguage = context
                                    //     .read<LanguageProvider>()
                                    //     .toggleLanguage();
                                    // isEnglish = changedLanguage;
                                    if (languageProvider.isEnglish) {
                                      context
                                          .read<LanguageProvider>()
                                          .changeLanguage(
                                            false,
                                          ); // * convert to sinhala
                                    }
                                  },
                                  child: Container(
                                    // padding: EdgeInsets.symmetric(vertical: 8),
                                    alignment: Alignment.center,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: AppColors.brandAccent,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.borderRadiusSmall,
                                      ),
                                      gradient: !languageProvider.isEnglish
                                          ? AppColors.primaryGradient
                                          : null,
                                    ),
                                    child: Text(
                                      Strings.languageChooser.sinhala,
                                      style: !languageProvider.isEnglish
                                          ? TextStyle(
                                              color: AppColors.surfaceLight,
                                            )
                                          : TextStyle(
                                              color: AppColors.brandDark,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSizes.spacingSmall),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await context
                                      .read<LanguageProvider>()
                                      .saveLanguageToLocal();
                                  AppNavigator.push(AppRoutes.login);
                                },
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(42),
                                    gradient: AppColors.primaryGradient,
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: AppColors.surfaceLight,
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
