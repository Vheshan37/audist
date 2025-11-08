import 'package:audist/common/helpers/date_formatter.dart';
import 'package:audist/common/widgets/custom_button.dart';
import 'package:audist/common/widgets/custom_date_picker.dart';
import 'package:audist/core/color.dart';
import 'package:audist/core/navigation/app_navigator.dart';
import 'package:audist/core/navigation/app_routes.dart';
import 'package:audist/core/sizes.dart';
import 'package:audist/core/string.dart';
import 'package:audist/domain/cases/entities/case_entity.dart';
import 'package:flutter/material.dart';

class PopUp {
  TextEditingController datePickerController = TextEditingController();
  final bool isNextCase;
  final String caseType;
  final CaseEntity? caseInformation;
  PopUp({required this.isNextCase, this.caseInformation, required this.caseType});

  void openPopUp(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row (number + date)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: AppSizes.spacingSmall,
                    children: [
                      Text(
                        Strings.casePopUp.caseNumber,
                        style: TextStyle(
                          fontSize: AppSizes.bodyMedium,
                          fontWeight: FontWeight.w600,
                          color: AppColors.brandDark,
                        ),
                      ),
                      Text(":"),
                      Text(
                        caseInformation!.caseNumber!,
                        style: TextStyle(
                          fontSize: AppSizes.bodyMedium,
                          color: AppColors.brandDark,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    DateFormatter.formatDate(caseInformation!.caseDate!),
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: AppSizes.spacingMedium),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  // color: AppColors.brandDark,
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(6),
                  // border: Border.all(color: AppColors.labelBluePrimary),
                ),
                child: Text(
                  caseType,
                  style: TextStyle(
                    fontSize: AppSizes.bodySmall,
                    color: AppColors.surfaceLight,
                  ),
                ),
              ),
              SizedBox(height: AppSizes.spacingSmall),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(flex: 2, child: Text(Strings.casePopUp.id)),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [Text(': '), Text(caseInformation!.refereeNo!)],
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.spacingSmall),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(Strings.casePopUp.organization),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Text(': '),
                        Text(caseInformation!.organization!),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.spacingSmall),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(flex: 2, child: Text(Strings.casePopUp.name)),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [Text(': '), Text(caseInformation!.name!)],
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.spacingSmall),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(flex: 2, child: Text(Strings.casePopUp.value)),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [Text(': '), Text(caseInformation!.value!)],
                    ),
                  ),
                ],
              ),
              if (isNextCase)
                Column(
                  children: [
                    SizedBox(height: AppSizes.spacingLarge),
                    // Buttons
                    CustomDatePicker(
                      textEditingController: datePickerController,
                      name: "DD/MM/YYYY",
                    ),
                    SizedBox(height: AppSizes.spacingSmall),
                    CustomButton(
                      content: Text(
                        Strings.casePopUp.secondaryButton,
                        style: TextStyle(color: AppColors.surfaceLight),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              SizedBox(height: 10),
              Divider(),
              CustomButton(
                content: Text(
                  Strings.casePopUp.primaryButton,
                  style: TextStyle(color: AppColors.surfaceLight),
                ),
                onPressed: () => {
                  // close the model
                  AppNavigator.pop(context),

                  // navigate to case information register page
                  AppNavigator.push(
                    AppRoutes.caseinformation,
                    arguments: caseInformation,
                  ),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
