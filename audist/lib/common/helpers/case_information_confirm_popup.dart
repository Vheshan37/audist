import 'package:audist/common/helpers/app_alert.dart';
import 'package:audist/common/widgets/custom_button.dart';
import 'package:audist/core/color.dart';
import 'package:audist/core/navigation/app_routes.dart';
import 'package:audist/core/sizes.dart';
import 'package:audist/core/string.dart';
import 'package:audist/core/navigation/app_navigator.dart';
import 'package:audist/presentation/cases/case_information/blocs/update/case_information_update_bloc.dart';
import 'package:audist/presentation/home/blocs/allcase/all_case_bloc.dart';
import 'package:audist/presentation/home/blocs/cases/fetch_case_bloc.dart';
import 'package:audist/providers/common_data_provider.dart';
import 'package:audist/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:audist/core/model/case_information/case_information_request_model.dart';
import 'package:provider/provider.dart';

class CustomPopUp {
  void openConfirmationPopUp(
    BuildContext context,
    CaseInformationRequestModel requestModel,
  ) {
    final dateFormatter = DateFormat('yyyy-MM-dd');

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              return Container(
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Center(
                        child: Text(
                          Strings.caseInformation.popUpTitle,
                          style: TextStyle(
                            fontSize: AppSizes.titleSmall,
                            fontWeight: FontWeight.bold,
                            color: AppColors.brandDark,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(),

                      const SizedBox(height: 16),

                      // Case Details
                      _infoRow(
                        Strings.caseInformation.caseNumber,
                        requestModel.caseId ?? "-",
                      ),
                      _infoRow(
                        Strings.caseInformation.nextCaseDate,
                        requestModel.nextCaseDate != null
                            ? dateFormatter.format(requestModel.nextCaseDate!)
                            : "-",
                      ),
                      const Divider(),

                      // Respondents
                      Text(
                        Strings.caseInformation.respondents,
                        style: _sectionTitleStyle(),
                      ),
                      const SizedBox(height: 6),
                      _infoRow(
                        "${Strings.caseInformation.respondent} 1",
                        requestModel.respondent?.person1 ?? "-",
                      ),
                      _infoRow(
                        "${Strings.caseInformation.respondent} 2",
                        requestModel.respondent?.person2 ?? "-",
                      ),
                      _infoRow(
                        "${Strings.caseInformation.respondent} 3",
                        requestModel.respondent?.person3 ?? "-",
                      ),
                      const Divider(),

                      // Judgement
                      Text(
                        Strings.caseInformation.judgement,
                        style: _sectionTitleStyle(),
                      ),
                      const SizedBox(height: 6),
                      _infoRow(
                        Strings.caseInformation.installment,
                        requestModel.judgement?.settlementFee?.toString() ??
                            "-",
                      ),
                      _infoRow(
                        Strings.caseInformation.nextPayableDate,
                        requestModel.judgement?.nextSettlementDate != null
                            ? dateFormatter.format(
                                requestModel.judgement!.nextSettlementDate!,
                              )
                            : "-",
                      ),
                      _infoRow(
                        Strings.caseInformation.todaysPayment,
                        requestModel.judgement?.todayPayment?.toString() ?? "-",
                      ),
                      const Divider(),

                      // Other
                      Text(
                        Strings.caseInformation.otherInformation,
                        style: _sectionTitleStyle(),
                      ),
                      const SizedBox(height: 6),
                      _infoRow(
                        Strings.caseInformation.withdraw,
                        requestModel.other?.withdraw == true
                            ? languageProvider.isEnglish
                                  ? "Yes"
                                  : "ඔව්"
                            : languageProvider.isEnglish
                            ? "No"
                            : "නැත",
                      ),
                      _infoRow(
                        Strings.caseInformation.testimony,
                        requestModel.other?.testimony == true
                            ? languageProvider.isEnglish
                                  ? "Yes"
                                  : "ඔව්"
                            : languageProvider.isEnglish
                            ? "No"
                            : "නැත",
                      ),
                      const SizedBox(height: 20),

                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: CustomButton(
                              content: Text(
                                languageProvider.isEnglish
                                    ? "Cancel"
                                    : "අවලංගු කරන්න",
                                style: TextStyle(color: AppColors.surfaceLight),
                              ),
                              onPressed: () => AppNavigator.pop(context),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child:
                                BlocConsumer<
                                  CaseInformationUpdateBloc,
                                  CaseInformationUpdateState
                                >(
                                  listener: (context, state) {
                                    if (state is CaseInformationUpdateSuccess) {
                                      AppNavigator.pop(context);
                                      AppAlert.show(
                                        context,
                                        type: AlertType.success,
                                        title:
                                            "Case Information Updated Successfully",
                                        description:
                                            "All details have been saved and the case record has been updated.",
                                      );
                                      Future.delayed(Duration(seconds: 2));
                                      AppNavigator.pushReplacement(
                                        AppRoutes.home,
                                      );

                                      // * fetch all case after case information updated
                                      context.read<AllCaseBloc>().add(
                                        RequestAllCase(
                                          uid: context
                                              .read<CommonDataProvider>()
                                              .uid!,
                                        ),
                                      );

                                      // * fetch case after case information updated
                                      context.read<FetchCaseBloc>().add(
                                        RequestFetchCase(
                                          uid: context
                                              .read<CommonDataProvider>()
                                              .uid!,
                                        ),
                                      );
                                    }
                                    if (state is CaseInformationUpdateFailed) {
                                      AppNavigator.pop(context);
                                      AppAlert.show(
                                        context,
                                        type: AlertType.error,
                                        title: "Update Failed",
                                        description: state.message,
                                      );
                                      Future.delayed(Duration(seconds: 2));
                                    }
                                  },
                                  builder: (context, state) {
                                    return CustomButton(
                                      content: Text(
                                        languageProvider.isEnglish
                                            ? "Confirm"
                                            : "තහවුරු කරන්න",
                                        style: TextStyle(
                                          color: AppColors.surfaceLight,
                                        ),
                                      ),
                                      onPressed: () {
                                        AppNavigator.pop(context);
                                        // 🔥 Trigger your bloc or API call here
                                        // Example:
                                        debugPrint(
                                          "==========================================",
                                        );
                                        debugPrint(
                                          "Request Model: ${requestModel.toJson()}",
                                        );
                                        debugPrint(
                                          "==========================================",
                                        );
                                        context
                                            .read<CaseInformationUpdateBloc>()
                                            .add(
                                              RequestCaseInformationUpdate(
                                                request: requestModel,
                                              ),
                                            );
                                      },
                                    );
                                  },
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // helper widget for displaying rows
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(flex: 3, child: Text(": $value")),
        ],
      ),
    );
  }

  TextStyle _sectionTitleStyle() {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: AppSizes.bodyMedium,
      color: AppColors.brandDark,
    );
  }
}
