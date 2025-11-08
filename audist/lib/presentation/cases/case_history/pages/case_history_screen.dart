import 'package:audist/common/helpers/pop_up.dart';
import 'package:audist/common/widgets/custom_app_bar.dart';
import 'package:audist/common/widgets/custom_background.dart';
import 'package:audist/common/widgets/custom_button.dart';
import 'package:audist/common/widgets/custom_date_picker.dart';
import 'package:audist/common/widgets/drawer.dart';
import 'package:audist/core/color.dart';
import 'package:audist/core/sizes.dart';
import 'package:audist/core/string.dart';
import 'package:audist/domain/cases/entities/case_entity.dart';
import 'package:audist/providers/case_filter_provider.dart';
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
                // * Dropdown + Date picker row
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 🔽 Dropdown (Filter Cases)
                    Consumer2<CaseFilterProvider, LanguageProvider>(
                      builder:
                          (context, caseFilterProvider, languageProvider, _) {
                            final isEnglish = languageProvider.isEnglish;

                            return DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: isEnglish
                                    ? "Filter Cases"
                                    : "නඩු වර්ගය තෝරන්න",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.borderRadiusMedium,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              value: caseFilterProvider.localizedSelectedFilter(
                                isEnglish,
                              ),
                              items: caseFilterProvider
                                  .localizedFilterOptions(isEnglish)
                                  .map(
                                    (filter) => DropdownMenuItem<String>(
                                      value: filter,
                                      child: Text(filter),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  // Find the English key for the selected value
                                  final selectedEng = caseFilterProvider
                                      .filterOptions
                                      .firstWhere(
                                        (opt) =>
                                            opt[isEnglish ? 'eng' : 'sin'] ==
                                            value,
                                      )['eng']!;
                                  caseFilterProvider.setFilter(selectedEng);
                                  caseFilterProvider.setList(selectedEng);
                                }
                              },
                            );
                          },
                    ),

                    SizedBox(height: AppSizes.spacingMedium),

                    // 📅 Date Picker
                    CustomDatePicker(
                      textEditingController: dateController,
                      name: 'DD/MM/YYYY',
                    ),
                  ],
                ),

                SizedBox(height: AppSizes.spacingMedium),
                // * 2nd row
                Expanded(
                  child: Consumer<CaseFilterProvider>(
                    builder: (context, caseFilter, child) {
                      final list = caseFilter.caseList;

                      debugPrint(
                        'Building ListView with ${list.length} items',
                      );

                      if (list.isEmpty) {
                        return Container(
                          alignment: Alignment.center,
                          child: Text(
                            '${languageProvider.isEnglish ? "No" : ""} ${caseFilter.localizedSelectedFilter(languageProvider.isEnglish)} ${languageProvider.isEnglish ? "to view" : "නැත"}',
                            style: TextStyle(fontSize: AppSizes.bodyLarge),
                          ),
                        );
                      }

                      return Container(
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
                          itemCount: list.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              CaseEntity caseEntity = CaseEntity(
                                caseNumber: list[index].caseNumber,
                                refereeNo: list[index].refereeNo,
                                name: list[index].name,
                                organization: list[index].organization,
                                value: list[index].value,
                                caseDate: list[index].caseDate,
                                createdAt: null,
                                image: "",
                                nic: list[index].nic,
                                userId: null,
                              );
                              PopUp(
                                isNextCase: false,
                                caseInformation: caseEntity,
                                caseType:
                                    context.read<LanguageProvider>().isEnglish
                                    ? "Pending Case"
                                    : "ඉදිරි නඩුවක්",
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
                      );
                    },
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
