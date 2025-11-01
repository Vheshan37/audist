import 'package:audist/common/helpers/pop_up.dart';
import 'package:audist/common/widgets/custom_app_bar.dart';
import 'package:audist/common/widgets/custom_background.dart';
import 'package:audist/common/widgets/custom_button.dart';
import 'package:audist/common/widgets/custom_date_picker.dart';
import 'package:audist/common/widgets/drawer.dart';
import 'package:audist/core/color.dart';
import 'package:audist/core/sizes.dart';
import 'package:audist/core/string.dart';
import 'package:audist/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CaseHistoryScreen extends StatelessWidget {
  const CaseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController dateController = TextEditingController();
    return CustomBackground(
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) => Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(title: Strings.caseHistory.title),
          drawer: CustomDrawer(),
          body: Container(
            padding: EdgeInsets.all(AppSizes.paddingMedium),
            child: Column(
              children: [
                // * 1st row date picker
                Row(
                  children: [
                    Expanded(child: Text(Strings.caseHistory.selectDate)),
                    Expanded(
                      child: CustomDatePicker(
                        textEditingController: dateController,
                        name: 'DD/MM/YYYY',
                      ),
                    ),
                  ],
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
                    child: ListView.separated(
                      // padding: EdgeInsets.all(AppSizes.paddingMedium),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      itemCount: 10,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          PopUp(isNextCase: false).openPopUp(context);
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
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      Strings.caseHistory.caseNumber,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: AppSizes.bodyMedium,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      '123456',
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
                                      Strings.caseHistory.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: AppSizes.bodyMedium,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      '123456',
                                      style: TextStyle(
                                        // fontWeight: FontWeight.w500,
                                        fontSize: AppSizes.bodyMedium,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '2025-10-28',
                                  style: TextStyle(
                                    color: AppColors.secondaryColor,
                                    fontSize: AppSizes.bodySmall,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                        Strings.caseHistory.actionButton,
                        style: TextStyle(color: AppColors.surfaceLight),
                      ),
                    ],
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
