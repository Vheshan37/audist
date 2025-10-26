import 'package:audist/common/widgets/custom_button.dart';
import 'package:audist/common/widgets/custom_input.dart';
import 'package:audist/core/color.dart';
import 'package:audist/core/navigation/app_navigator.dart';
import 'package:audist/core/navigation/app_routes.dart';
import 'package:audist/core/sizes.dart';
import 'package:audist/core/string.dart';
import 'package:audist/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            AppNavigator.pop();
          },
          child: Icon(Icons.arrow_back, color: AppColors.brandDark),
        ),
      ),
      body: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) => SingleChildScrollView(
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

                // * Bottom statement
                SafeArea(
                  child: Container(
                    padding: EdgeInsets.only(bottom: AppSizes.paddingMedium),
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

                // * Transparent logo at the center
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

                // * main content
                SafeArea(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${Strings.login.title},',
                          style: TextStyle(
                            fontSize: AppSizes.titleMedium,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            color: AppColors.surfaceDark,
                          ),
                        ),
                        Text(
                          Strings.login.subTitle,
                          style: TextStyle(
                            fontSize: AppSizes.bodyMedium,
                            fontFamily: 'Poppins',
                            color: AppColors.surfaceSecondary,
                          ),
                        ),
                        SizedBox(height: AppSizes.marginLarge),

                        // * Login form
                        Form(
                          child: Column(
                            spacing: AppSizes.spacingMedium,
                            children: [
                              Custominput(
                                // * email field
                                textEditingController: emailController,
                                name: Strings.login.emailHint,
                              ),
                              Custominput(
                                // * password field
                                textEditingController: passwordController,
                                name: Strings.login.passwordHint,
                              ),
                              CustomButton(
                                content: Text(
                                  Strings.login.buttonText,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.surfaceLight,
                                  ),
                                ),
                                onPressed: () {
                                  // TODO: implement login action
                                  AppNavigator.pushReplacement(AppRoutes.home);
                                },
                              ),
                              // SizedBox();
                              Row(
                                children: [
                                  Text(
                                    Strings.login.doNotHaveAccount,
                                    style: TextStyle(
                                      fontSize: AppSizes.bodyMedium,
                                      color: AppColors.surfaceDark,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // TODO: implement contact admin action
                                    },
                                    child: Text(
                                      Strings.login.contactAdmin,
                                      style: TextStyle(
                                        fontSize: AppSizes.bodyMedium,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.surfaceDark,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
}
