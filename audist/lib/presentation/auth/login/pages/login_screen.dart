import 'package:audist/common/helpers/app_alert.dart';
import 'package:audist/common/widgets/custom_button.dart';
import 'package:audist/common/widgets/custom_input.dart';
import 'package:audist/core/color.dart';
import 'package:audist/core/navigation/app_navigator.dart';
import 'package:audist/core/navigation/app_routes.dart';
import 'package:audist/core/sizes.dart';
import 'package:audist/core/string.dart';
import 'package:audist/presentation/auth/login/bloc/login_bloc.dart';
import 'package:audist/presentation/home/blocs/cases/fetch_case_bloc.dart';
import 'package:audist/providers/common_data_provider.dart';
import 'package:audist/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
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
                          key: formKey,
                          child: Column(
                            spacing: AppSizes.spacingMedium,
                            children: [
                              Custominput(
                                // * email field
                                textEditingController: emailController,
                                name: Strings.login.emailHint,
                                validatorFunction: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email is required';
                                  }
                                  final emailRegex = RegExp(
                                    r'^[^@]+@[^@]+\.[^@]+',
                                  );
                                  if (!emailRegex.hasMatch(value)) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              Custominput(
                                // * password field
                                textEditingController: passwordController,
                                name: Strings.login.passwordHint,
                                secure: true,
                                validatorFunction: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password is required';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              BlocConsumer<LoginBloc, LoginState>(
                                listener: (context, state) {
                                  if (state is LoginSuccess) {
                                    context.read<FetchCaseBloc>().add(
                                      RequestFetchCase(uid: state.userId!),
                                    );
                                    context.read<FetchCaseBloc>().add(
                                      RequestFetchCase(uid: state.userId!),
                                    );
                                    context.read<CommonDataProvider>().saveUser(
                                      state.userId!,
                                    );
                                    AppNavigator.pushReplacement(
                                      AppRoutes.home,
                                    );
                                  } else if (state is LoginEmailSended) {
                                    AppAlert.show(
                                      context,
                                      type: AlertType.info,
                                      title: "Verify your email",
                                      description: state.message,
                                    );
                                  } else if (state is LoginFailed) {
                                    debugPrint(
                                      'Something else happened: ${state.message}',
                                    );
                                    AppAlert.show(
                                      context,
                                      type: AlertType.error,
                                      title: "Login Failed",
                                      description: state.message,
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  if (state is LoginLoading) {
                                    debugPrint('login loading');
                                    return CustomButton(
                                      content: CircularProgressIndicator(
                                        color: AppColors.surfaceLight,
                                      ),
                                      onPressed: () {},
                                    );
                                  }
                                  return CustomButton(
                                    content: Text(
                                      Strings.login.buttonText,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.surfaceLight,
                                      ),
                                    ),
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        context.read<LoginBloc>().add(
                                          RequestLogin(
                                            emailController.text.trim(),
                                            passwordController.text.trim(),
                                          ),
                                        );
                                      }
                                      // AppNavigator.pushReplacement(AppRoutes.home);
                                    },
                                  );
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
