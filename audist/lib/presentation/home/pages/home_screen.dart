import 'package:audist/common/widgets/custom_background.dart';
import 'package:audist/core/color.dart';
import 'package:audist/core/color.dart';
import 'package:audist/core/color.dart';
import 'package:audist/core/default_data.dart';
import 'package:audist/core/navigation/app_navigator.dart';
import 'package:audist/core/navigation/app_routes.dart';
import 'package:audist/core/sizes.dart';
import 'package:audist/core/string.dart';
import 'package:audist/common/widgets/drawer.dart';
import 'package:audist/presentation/home/blocs/cases/fetch_case_bloc.dart';
import 'package:audist/presentation/home/blocs/cases/fetch_case_bloc.dart';
import 'package:audist/presentation/splash/bloc/authorization_bloc.dart';
import 'package:audist/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  initState() async {
    await Future.delayed(const Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) => CustomBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          drawer: CustomDrawer(),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actionsPadding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingLarge,
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            actions: [
              Builder(
                builder: (context) => Row(
                  spacing: AppSizes.spacingMedium,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // TODO: Open drawer
                        Scaffold.of(context).openDrawer();
                      },
                      child: Icon(Icons.menu, color: AppColors.surfaceLight),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/header_devicer_home.png',
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingMedium,
                  ),
                  child: SafeArea(child: _mainContent(context)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _mainContent(BuildContext context) {
    return Column(
      children: [
        // * home header box
        Container(
          width: double.infinity,
          // height: 200,
          padding: EdgeInsets.all(AppSizes.paddingMedium),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                Strings.home.title,
                style: TextStyle(
                  fontSize: AppSizes.titleMedium,
                  fontWeight: FontWeight.w600,
                  color: AppColors.brandDark,
                ),
              ),

              Text(
                Strings.home.subTitle,
                style: TextStyle(color: AppColors.brandAccent),
              ),

              SizedBox(height: AppSizes.spacingMedium),

              // * date section
              GestureDetector(
                onTap: () {
                  debugPrint('Logout requested');
                  context.read<AuthorizationBloc>().add(RequestLogout());
                },
                child: BlocListener<AuthorizationBloc, AuthorizationState>(
                  listener: (context, state) {
                    debugPrint('State: $state');
                    if (state is Logout) {
                      AppNavigator.pushReplacement(AppRoutes.languageChooser);
                    }
                  },
                  child: Row(
                    spacing: AppSizes.spacingSmall,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        spacing: AppSizes.spacingMedium,
                        children: [
                          Text(
                            '17',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              color: AppColors.brandDark,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Wednesday',
                                style: TextStyle(
                                  color: AppColors.brandDark,
                                  fontSize: AppSizes.bodyLarge,
                                ),
                              ),
                              Text(
                                'August  2025',
                                style: TextStyle(
                                  color: AppColors.brandDark,
                                  fontSize: AppSizes.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Icon(Icons.today, color: AppColors.surfaceSecondary),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: AppSizes.spacingMedium),

        // * home middle box
        Container(
          // height: 200,
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.paddingMedium,
            vertical: AppSizes.paddingMedium,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              // * case summary
              BlocBuilder<FetchCaseBloc, FetchCaseState>(
                builder: (context, state) {
                  int todayCount = 0;
                  int totalCount = 0;
                  if (state is FetchCaseLoaded) {
                    todayCount = state.todayCount!;
                    totalCount = state.totalCount!;
                  }
                  return Row(
                    spacing: AppSizes.spacingMedium,
                    children: [
                      // * today's cases
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(AppSizes.paddingMedium),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(
                              AppSizes.borderRadiusLarge,
                            ),
                          ),
                          height: 120,
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                todayCount.toString(),
                                style: TextStyle(
                                  fontSize: AppSizes.titleLarge,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.surfaceLight,
                                ),
                              ),
                              Text(
                                Strings.home.todayCases,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: AppSizes.bodyMedium,
                                  color: AppColors.surfaceLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // * total cases
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(AppSizes.paddingMedium),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(
                              AppSizes.borderRadiusLarge,
                            ),
                          ),
                          height: 120,
                          child: Column(
                            children: [
                              Text(
                                totalCount.toString(),
                                style: TextStyle(
                                  fontSize: AppSizes.titleLarge,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.surfaceLight,
                                ),
                              ),
                              Text(
                                Strings.home.totalCases,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: AppSizes.bodyMedium,
                                  color: AppColors.surfaceLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              SizedBox(height: AppSizes.spacingMedium),

              // * menu items
              // add list view of menu items here
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  final item = DefaultData.getMenuItems()[index];

                  return GestureDetector(
                    onTap: () {
                      AppNavigator.push(item['route']);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: AppSizes.marginMedium),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingMedium,
                      ),
                      height: 65,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(
                          AppSizes.borderRadiusMedium,
                        ),
                        border: Border.all(color: AppColors.brandAccent),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.25),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            spacing: AppSizes.spacingSmall,
                            children: [
                              Icon(item['icon'], color: AppColors.brandAccent),
                              Text(
                                item['title'],
                                style: TextStyle(color: AppColors.brandAccent),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: AppColors.brandAccent,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
