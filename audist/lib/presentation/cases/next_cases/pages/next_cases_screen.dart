import 'package:audist/common/helpers/date_formatter.dart';
import 'package:audist/common/helpers/pop_up.dart';
import 'package:audist/common/widgets/custom_app_bar.dart';
import 'package:audist/common/widgets/custom_background.dart';
import 'package:audist/common/widgets/custom_button.dart';
import 'package:audist/common/widgets/custom_date_picker.dart';
import 'package:audist/common/widgets/drawer.dart';
import 'package:audist/core/color.dart';
import 'package:audist/core/navigation/app_navigator.dart';
import 'package:audist/core/navigation/app_routes.dart';
import 'package:audist/core/sizes.dart';
import 'package:audist/core/string.dart';
import 'package:audist/domain/cases/entities/case_entity.dart';
import 'package:audist/presentation/cases/next_cases/bloc/filter_next_case_bloc.dart';
import 'package:audist/presentation/home/blocs/cases/fetch_case_bloc.dart';
import 'package:audist/providers/common_data_provider.dart';
import 'package:audist/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class NextCasesScreen extends StatelessWidget {
  const NextCasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController dateController = TextEditingController();
    return CustomBackground(
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) => Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(title: Strings.nextCase.title),
          drawer: CustomDrawer(),
          body: Container(
            padding: EdgeInsets.all(AppSizes.paddingMedium),
            child: Column(
              children: [
                // * 1st row date picker
                BlocConsumer<FetchCaseBloc, FetchCaseState>(
                  listener: (context, state) => {
                    if (state is FetchCaseLoaded)
                      {
                        context.read<CommonDataProvider>().modifyCaseList(
                          value: state.caseList,
                          today: state.todayCount!,
                          total: state.totalCount!,
                        ),
                      },
                  },
                  builder: (context, state) {
                    List<CaseEntity> list = [];
                    if (state is FetchCaseLoaded) {
                      list = state.caseList;

                    } else if (state is FilteredCasesByDate) {
                      list = state.caseList;
                    }

                    if (list.isNotEmpty) {
                      return Row(
                        children: [
                          Expanded(child: Text(Strings.nextCase.selectDate)),
                          Expanded(
                            child: CustomDatePicker(
                              textEditingController: dateController,
                              name: 'DD/MM/YYYY',
                              onDateSelected: (date) {
                                context.read<FilterNextCaseBloc>().add(
                                  FilterCasesByDate(
                                    selectedDate: date,
                                    list: list,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }

                    return Container();
                  },
                ),

                SizedBox(height: AppSizes.spacingMedium),

                // * 2nd row
                Expanded(
                  child: Container(
                    // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      // color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(
                        AppSizes.borderRadiusMedium,
                      ),
                    ),
                    child: BlocBuilder<FetchCaseBloc, FetchCaseState>(
                      builder: (context, state) {
                        List<CaseEntity> list = [];
                        if (state is FetchCaseLoaded) {
                          list = state.caseList;
                        } else if (state is FilteredCasesByDate) {
                          debugPrint(
                            "Filtered List Length: ${state.caseList.length}",
                          );
                          list = state.caseList;
                        }

                        if (list.isEmpty) {
                          return Container(
                            padding: EdgeInsets.all(AppSizes.paddingMedium),
                            child: Column(
                              spacing: AppSizes.spacingSmall,
                              children: [
                                Text(
                                  "Don't have any pending cases...",
                                  style: TextStyle(
                                    fontSize: AppSizes.bodyLarge,
                                  ),
                                ),
                                CustomButton(
                                  content: Text(
                                    "Back to home",
                                    style: TextStyle(
                                      color: AppColors.surfaceLight,
                                      fontSize: AppSizes.bodyLarge,
                                    ),
                                  ),
                                  onPressed: () {
                                    AppNavigator.pushReplacement(
                                      AppRoutes.home,
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        }

                        // * case list
                        return BlocBuilder<
                          FilterNextCaseBloc,
                          FilterNextCaseState
                        >(
                          builder: (context, state) {
                            if (state is FilterNextCaseLoaded) {
                              list = state.caseList;
                              // TODO: I want to pass the date if filtered items are shown
                              // controller name is dateController
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                dateController.text = DateFormatter.formatDate(
                                  state.date,
                                );
                              });
                            } else if (state is ResetFilterNextCase) {
                              list = state.caseList;
                              debugPrint(
                                "Reset Filtered List Length: ${list.length}",
                              );
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                dateController.text = "";
                              });
                            }

                            return ListView.separated(
                              // padding: EdgeInsets.all(AppSizes.paddingMedium),
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 10),
                              itemCount: list.length,
                              itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  PopUp(
                                    isNextCase: true,
                                    caseInformation: list[index],
                                    caseType:
                                        context
                                            .read<LanguageProvider>()
                                            .isEnglish
                                        ? "Pending Case"
                                        : "ඉදිරි නඩුවක්",
                                    caseStatus: "pending",
                                  ).openPopUp(context);
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundLight,
                                    borderRadius: BorderRadius.circular(
                                      AppSizes.borderRadiusMedium,
                                    ),
                                    border: Border.all(
                                      color: AppColors.backgroundMuted,
                                    ),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.grey.withOpacity(0.25),
                                    //     spreadRadius: 2,
                                    //     blurRadius: 7,
                                    //     offset: Offset(
                                    //       0,
                                    //       3,
                                    //     ), // changes position of shadow
                                    //   ),
                                    // ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          DateFormatter.formatDate(
                                            list[index].caseDate,
                                          ),
                                          style: TextStyle(
                                            color: AppColors.secondaryColor,
                                            fontSize: AppSizes.bodySmall,
                                          ),
                                        ),
                                      ),
                                      // Divider(),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              Strings.nextCase.caseNumber,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: AppSizes.bodyMedium,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              list[index].caseNumber!,
                                              style: TextStyle(
                                                // fontWeight: FontWeight.w500,
                                                fontSize: AppSizes.bodyMedium,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: AppSizes.spacingSmall),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              Strings.nextCase.name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: AppSizes.bodyMedium,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              list[index].name!,
                                              style: TextStyle(
                                                // fontWeight: FontWeight.w500,
                                                fontSize: AppSizes.bodyMedium,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(height: AppSizes.spacingMedium),

                CustomButton(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: AppSizes.spacingSmall,
                    children: [
                      Icon(
                        Icons.change_circle_outlined,
                        color: AppColors.surfaceLight,
                      ),
                      Text(
                        Strings.nextCase.actionButton,
                        style: TextStyle(color: AppColors.surfaceLight),
                      ),
                    ],
                  ),
                  onPressed: () {
                    debugPrint(
                      "Reset Filtered Cases sending size: ${context.read<CommonDataProvider>().list!.length}",
                    );
                    context.read<FilterNextCaseBloc>().add(
                      ResetFilterNextCaseEvent(
                        list: context.read<CommonDataProvider>().list!,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
