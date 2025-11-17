import 'package:audist/common/helpers/app_alert.dart';
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
import 'package:audist/presentation/home/blocs/allcase/all_case_bloc.dart';
import 'package:audist/presentation/home/blocs/cases/fetch_case_bloc.dart';
import 'package:audist/presentation/home/blocs/cases/fetch_case_bloc.dart';
import 'package:audist/presentation/splash/bloc/authorization_bloc.dart';
import 'package:audist/providers/case_filter_provider.dart';
import 'package:audist/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
                  child: SafeArea(
                    child: BlocListener<AllCaseBloc, AllCaseState>(
                      listener: (context, state) {
                        if (state is AllCaseLoaded) {
                          // ✅ Sync Bloc data into Provider
                          context.read<CaseFilterProvider>().saveAllCasesObject(
                            state.allCaseModel,
                          );
                          debugPrint('All cases synced to CaseFilterProvider');
                        }
                      },
                      child: _mainContent(context),
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

  Widget _mainContent(BuildContext context) {
    DateTime now = DateTime.now();

    String dayNumber = DateFormat('dd').format(now); // e.g., 17
    String weekDay = DateFormat('EEEE').format(now); // e.g., Wednesday
    String monthYear = DateFormat('MMMM yyyy').format(now); // e.g., August 2025
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
                            dayNumber,
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
                                weekDay,
                                style: TextStyle(
                                  color: AppColors.brandDark,
                                  fontSize: AppSizes.bodyLarge,
                                ),
                              ),
                              Text(
                                monthYear,
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

        // _testAlert(context),

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
              BlocConsumer<FetchCaseBloc, FetchCaseState>(
                listener: (context, state) {
                  if (state is FetchCaseLoaded) {
                    final authState = context.read<AuthorizationBloc>().state;

                    if (authState is Authorized) {
                      final uid = authState.uid;
                      context.read<AllCaseBloc>().add(RequestAllCase(uid: uid));
                    } else {
                      debugPrint(
                        'Tried to fetch all cases, but user not authorized',
                      );
                    }
                  }
                },
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
                                style: TextStyle(
                                  color: AppColors.brandAccent,
                                  fontWeight: FontWeight.w500,
                                  fontSize: AppSizes.bodyMedium
                                ),
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

  Widget _testAlert(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            AppAlert.show(
              context,
              type: AlertType.error,
              title: "Error",
              description: "Alert Description for Error",
            );
          },
          child: Text('Error'),
        ),
        TextButton(
          onPressed: () {
            AppAlert.show(
              context,
              type: AlertType.warning,
              title: "Warning",
              description: "Alert Description for Warning",
            );
          },
          child: Text('Warning'),
        ),
        TextButton(
          onPressed: () {
            AppAlert.show(
              context,
              type: AlertType.info,
              title: "Info",
              description: "Alert Description for Info",
            );
          },
          child: Text('Info'),
        ),
        TextButton(
          onPressed: () {
            AppAlert.show(
              context,
              type: AlertType.success,
              title: "Success",
              description: "Alert Description for Success",
            );
          },
          child: Text('Success'),
        ),
      ],
    );
  }
}
