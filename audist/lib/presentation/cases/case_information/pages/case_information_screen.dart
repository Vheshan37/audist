import 'dart:io';

import 'package:audist/common/helpers/case_information_confirm_popup.dart';
import 'package:audist/common/widgets/custom_app_bar.dart';
import 'package:audist/common/widgets/custom_background.dart';
import 'package:audist/common/widgets/custom_button.dart';
import 'package:audist/common/widgets/custom_date_picker.dart';
import 'package:audist/common/widgets/custom_input.dart';
import 'package:audist/common/widgets/drawer.dart';
import 'package:audist/core/color.dart';
import 'package:audist/core/model/case_information/case_Information_response_model.dart';
import 'package:audist/core/model/case_information/case_information_request_model.dart'
    as request_model;
import 'package:audist/core/sizes.dart';
import 'package:audist/core/string.dart';
import 'package:audist/domain/cases/entities/case_entity.dart';
import 'package:audist/presentation/cases/case_information/blocs/details/case_information_detail_bloc.dart';
import 'package:audist/providers/case_information_checkbox_provider.dart';
import 'package:audist/providers/common_data_provider.dart';
import 'package:audist/providers/image_picker_provider.dart';
import 'package:audist/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CaseInformationScreen extends StatefulWidget {
  const CaseInformationScreen({super.key});

  @override
  State<CaseInformationScreen> createState() => _CaseInformationScreenState();
}

class _CaseInformationScreenState extends State<CaseInformationScreen> {
  late TextEditingController datePickerController;
  late TextEditingController todaysPaymentController;
  late TextEditingController installmentController;
  late TextEditingController nextCaseDateController;

  @override
  void initState() {
    super.initState();
    datePickerController = TextEditingController();
    todaysPaymentController = TextEditingController();
    installmentController = TextEditingController();
    nextCaseDateController = TextEditingController();
  }

  @override
  void dispose() {
    datePickerController.dispose();
    todaysPaymentController.dispose();
    installmentController.dispose();
    nextCaseDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CaseInformationResponseModel caseInformation =
        ModalRoute.of(context)!.settings.arguments
            as CaseInformationResponseModel;

    final CaseEntity caseEntity = CaseEntity(
      caseNumber: caseInformation.caseInformationResponseCase?.caseNumber,
      refereeNo: caseInformation.caseInformationResponseCase?.refereeNo,
      name: caseInformation.caseInformationResponseCase?.name,
      organization: caseInformation.caseInformationResponseCase?.organization,
      value: double.tryParse(
        caseInformation.caseInformationResponseCase!.value!.toString(),
      ),
      caseDate: caseInformation.caseInformationResponseCase?.date,
      createdAt: null,
      image: null,
      nic: caseInformation.caseInformationResponseCase?.nic,
      userId: caseInformation.caseInformationResponseCase?.userId,
    );

    return CustomBackground(
      child: Consumer2<LanguageProvider, ImagePickerProvider>(
        builder: (context, languageProvider, imageProvider, child) => Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(title: Strings.caseInformation.title),
          drawer: const CustomDrawer(),
          body:
              BlocConsumer<
                CaseInformationDetailBloc,
                CaseInformationDetailState
              >(
                listener: (context, state) {
                  // * Case information loading process
                  debugPrint("Case information screen bloc consumer");
                  debugPrint("Case information screen bloc consumer");
                  debugPrint("Case information screen bloc consumer");
                  debugPrint("Case information screen bloc consumer");
                  debugPrint("Case information screen bloc consumer");
                  debugPrint("Case information screen bloc consumer");
                  debugPrint("Case information screen bloc consumer");

                  if (state is CaseInformationDetailSuccess) {
                    debugPrint(
                      "Case information loaded to case information screen",
                    );
                    debugPrint(
                      "Case information loaded to case information screen",
                    );
                    debugPrint(
                      "Case information loaded to case information screen",
                    );
                    debugPrint(
                      "Case information loaded to case information screen",
                    );
                    debugPrint(
                      "Case information loaded to case information screen",
                    );
                    debugPrint(
                      "Case information loaded to case information screen",
                    );
                    debugPrint(
                      "Case information loaded to case information screen",
                    );
                    debugPrint(
                      "Case information loaded to case information screen",
                    );
                    debugPrint(
                      "Case information loaded to case information screen",
                    );
                    debugPrint(
                      "Case information loaded to case information screen",
                    );
                    debugPrint(
                      "Case information loaded to case information screen",
                    );
                    debugPrint(
                      "Case information loaded to case information screen",
                    );
                    debugPrint(
                      "Case information loaded to case information screen",
                    );
                    final data = state.response;

                    // --- FILL TEXT FIELDS ---
                    todaysPaymentController.text =
                        data.information?.settlementFee?.toString() ?? "";

                    installmentController.text =
                        data.information?.settlementFee?.toString() ?? "";

                    nextCaseDateController.text =
                        data.information?.nextSettlementDate != null
                        ? DateFormat(
                            'dd/MM/yyyy',
                          ).format(data.information!.nextSettlementDate!)
                        : "";

                    datePickerController.text =
                        data.information?.nextSettlementDate != null
                        ? DateFormat(
                            'dd/MM/yyyy',
                          ).format(data.information!.nextSettlementDate!)
                        : "";

                    // --- CHECKBOXES / STATUSES ---
                    final checkboxProvider = context
                        .read<CaseInformationCheckboxProvider>();

                    checkboxProvider.setStatus(
                      1,
                      data.respondent?.person1?.status,
                    );

                    checkboxProvider.setStatus(
                      2,
                      data.respondent?.person2?.status,
                    );

                    checkboxProvider.setStatus(
                      3,
                      data.respondent?.person3?.status,
                    );

                    checkboxProvider.setWithdraw(
                      data.information?.phase == "withdraw",
                    );

                    checkboxProvider.setTestimony(
                      data.information?.phase == "testimony",
                    );

                    // --- IMAGE ---
                    if (data.information?.image != null) {
                      context.read<ImagePickerProvider>().setSecondImage(
                        File(data.information!.image!),
                      );
                    }
                  }

                  debugPrint(
                    "Case information not loaded to case information screen",
                  );
                  debugPrint(
                    "Case information not loaded to case information screen",
                  );
                  debugPrint(
                    "Case information not loaded to case information screen",
                  );
                  debugPrint(
                    "Case information not loaded to case information screen",
                  );
                  debugPrint(
                    "Case information not loaded to case information screen",
                  );
                  debugPrint(
                    "Case information not loaded to case information screen",
                  );
                  debugPrint(
                    "Case information not loaded to case information screen",
                  );
                  debugPrint(
                    "Case information not loaded to case information screen",
                  );
                  debugPrint(
                    "Case information not loaded to case information screen",
                  );
                  debugPrint(
                    "Case information not loaded to case information screen",
                  );
                  debugPrint(
                    "Case information not loaded to case information screen",
                  );
                  debugPrint(
                    "Case information not loaded to case information screen",
                  );

                  // * Case information loading process
                },
                builder: (context, state) {
                  if (state is CaseInformationDetailLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.brandDark,
                      ),
                    );
                  }
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(AppSizes.paddingMedium),
                    child: Column(
                      children: [
                        // * case information
                        _caseInformations(context, caseEntity),

                        // * space & horizontal divider
                        SizedBox(height: AppSizes.spacingSmall),
                        const Divider(),

                        // * check boxes
                        _caseStatuses(context),

                        SizedBox(height: AppSizes.spacingSmall),

                        // * next case date picker
                        _nextCaseDatePicker(context, datePickerController),

                        SizedBox(height: AppSizes.spacingLarge),

                        Row(
                          spacing: AppSizes.spacingSmall,
                          children: [
                            Text(
                              Strings.caseInformation.judgement,
                              style: TextStyle(
                                fontSize: AppSizes.bodyLarge,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(child: const Divider()),
                          ],
                        ),

                        SizedBox(height: AppSizes.spacingSmall),
                        // * judgment section
                        _judgmentSection(
                          context,
                          todaysPaymentController,
                          installmentController,
                          nextCaseDateController,
                        ),

                        // Add some bottom padding for better scrolling
                        SizedBox(height: AppSizes.spacingLarge),

                        Row(
                          spacing: AppSizes.spacingSmall,
                          children: [
                            Text(
                              Strings.caseInformation.otherInformation,
                              style: TextStyle(
                                fontSize: AppSizes.bodyLarge,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(child: const Divider()),
                          ],
                        ),

                        // * other information section
                        _otherInformation(context),

                        SizedBox(height: AppSizes.spacingMedium),

                        // * image picker section
                        _imagePickerSection(context, imageProvider),

                        SizedBox(height: AppSizes.spacingMedium),

                        // * action button
                        _actionButton(
                          context,
                          caseEntity,
                          datePickerController,
                          todaysPaymentController,
                          installmentController,
                          nextCaseDateController,
                        ),
                      ],
                    ),
                  );
                },
              ),
        ),
      ),
    );
  }

  Widget _actionButton(
    BuildContext context,
    CaseEntity caseInformation,
    TextEditingController newDate,
    TextEditingController todaysPaymentController,
    TextEditingController installmentController,
    TextEditingController nextCaseDateController,
  ) {
    debugPrint("New Date: ${newDate.text}");
    debugPrint("Next Case Date: ${nextCaseDateController.text}");

    return CustomButton(
      content: Text(
        Strings.caseInformation.registerButtonText,
        style: TextStyle(color: AppColors.surfaceLight),
      ),
      onPressed: () {
        final checkBoxProvider = context
            .read<CaseInformationCheckboxProvider>();

        final respondent = request_model.Respondent(
          person1: checkBoxProvider.getSelectedType(1),
          person2: checkBoxProvider.getSelectedType(2),
          person3: checkBoxProvider.getSelectedType(3),
        );

        final dateFormat = DateFormat('dd/MM/yyyy');
        DateTime? parsedNextCaseDate;
        try {
          parsedNextCaseDate = dateFormat.parseStrict(
            nextCaseDateController.text,
          );
        } catch (_) {
          parsedNextCaseDate = null;
        }
        final request_model.Judgement judgement = request_model.Judgement(
          settlementFee: int.tryParse(installmentController.text),
          nextSettlementDate: parsedNextCaseDate,
          todayPayment: int.tryParse(todaysPaymentController.text),
        );

        final request_model.Other other = request_model.Other(
          withdraw: context.read<CaseInformationCheckboxProvider>().withdraw,
          testimony: context.read<CaseInformationCheckboxProvider>().testimony,
          image: null,
        );

        try {
          parsedNextCaseDate = dateFormat.parseStrict(newDate.text);
        } catch (_) {
          parsedNextCaseDate = null;
        }

        debugPrint("parsedNextCaseDate: $parsedNextCaseDate");

        final request_model.CaseInformationRequestModel requestModel =
            request_model.CaseInformationRequestModel(
              userId: context.read<CommonDataProvider>().uid,
              caseId: caseInformation.caseNumber,
              respondent: respondent,
              nextCaseDate: parsedNextCaseDate,
              judgement: judgement,
              other: other,
            );

        debugPrint("Case InformationRequestModel: ${requestModel.toJson()}");

        CustomPopUp().openConfirmationPopUp(context, requestModel);

        // context.read<CaseInformationUpdateBloc>().add(
        //   RequestCaseInformationUpdate(request: requestModel),
        // );
      },
    );
  }

  Widget _imagePickerSection(
    BuildContext context,
    ImagePickerProvider imageProvider,
  ) {
    final image = imageProvider.secondImage != null
        ? Image.file(imageProvider.secondImage!)
        : Image.asset('assets/images/place_holder_image.webp');

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        return Container(
          width: maxWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Dynamically sized image
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: FittedBox(fit: BoxFit.contain, child: image),
                  ),
                ),

                // Upload button always on top
                Positioned(
                  top: 10,
                  left: 10,
                  child: GestureDetector(
                    onTap: imageProvider.pickSecondImageFromFilePicker,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(64),
                        color: Colors.black38,
                      ),
                      child: Icon(Icons.upload_outlined, color: Colors.white),
                    ),
                  ),
                ),

                // Overlay text only if placeholder, and does not block gestures
                if (imageProvider.secondImage == null)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        color: Colors.black45,
                        alignment: Alignment.center,
                        child: Text(
                          Strings.newCase.noImageSelected,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _otherInformation(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(flex: 2, child: Text(Strings.caseInformation.withdraw)),
            Expanded(
              flex: 3,
              child: Consumer<CaseInformationCheckboxProvider>(
                builder: (context, checkBoxProvider, child) {
                  return Checkbox(
                    value: checkBoxProvider.withdraw,
                    onChanged: (value) {
                      context
                          .read<CaseInformationCheckboxProvider>()
                          .toggleWithdraw();
                    },
                  );
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(flex: 2, child: Text(Strings.caseInformation.testimony)),
            Expanded(
              flex: 3,
              child: Consumer<CaseInformationCheckboxProvider>(
                builder: (context, checkBoxProvider, child) {
                  return Checkbox(
                    value: checkBoxProvider.testimony,
                    onChanged: (value) {
                      context
                          .read<CaseInformationCheckboxProvider>()
                          .toggleTestimony();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _judgmentSection(
    BuildContext context,
    TextEditingController todaysPaymentController,
    TextEditingController installmentController,
    TextEditingController nextCaseDateController,
  ) {
    return Column(
      spacing: AppSizes.spacingSmall,
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(Strings.caseInformation.todaysPayment),
            ),
            Expanded(
              flex: 3,
              child: Custominput(
                textEditingController: todaysPaymentController,
                name: '',
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(flex: 2, child: Text(Strings.caseInformation.installment)),
            Expanded(
              flex: 3,
              child: Custominput(
                textEditingController: installmentController,
                name: '',
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(Strings.caseInformation.nextPayableDate),
            ),
            Expanded(
              flex: 3,
              child: CustomDatePicker(
                textEditingController: nextCaseDateController,
                name: 'DD/MM/YYYY',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _nextCaseDatePicker(
    BuildContext context,
    TextEditingController datePickerController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.caseInformation.nextCaseDate),
        SizedBox(height: AppSizes.spacingSmall),
        CustomDatePicker(
          textEditingController: datePickerController,
          name: "DD/MM/YYYY",
        ),
      ],
    );
  }

  Widget _caseStatuses(BuildContext context) {
    return Consumer<CaseInformationCheckboxProvider>(
      builder: (context, checkBoxProvider, child) => Table(
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1),
          3: FlexColumnWidth(1),
        },
        border: TableBorder.symmetric(
          inside: BorderSide(width: 0.5, color: Colors.transparent),
        ),
        children: [
          // Header Row
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  Strings.caseInformation.respondent,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              for (var i = 1; i <= 3; i++)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text("$i")),
                ),
            ],
          ),

          // Checkbox Rows
          _buildCheckboxRow(
            checkBoxProvider,
            Strings.caseInformation.summons,
            "summon",
          ),
          _buildCheckboxRow(
            checkBoxProvider,
            Strings.caseInformation.newAddress,
            "newAddress",
          ),
          _buildCheckboxRow(
            checkBoxProvider,
            Strings.caseInformation.warrant,
            "warrant",
          ),
        ],
      ),
    );
  }

  TableRow _buildCheckboxRow(
    CaseInformationCheckboxProvider provider,
    String label,
    String type,
  ) {
    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.all(8.0), child: Text(label)),
        for (var index = 1; index <= 3; index++)
          Center(
            child: Checkbox(
              value: provider.getValue(index, type),
              onChanged: (_) => provider.toggle(index, type),
            ),
          ),
      ],
    );
  }

  Widget _caseInformations(BuildContext context, CaseEntity caseInformation) {
    return Column(
      children: [
        SizedBox(height: AppSizes.spacingSmall),
        Row(
          children: [
            Expanded(flex: 2, child: Text(Strings.caseInformation.caseNumber)),
            Expanded(flex: 3, child: Text(caseInformation.caseNumber ?? 'N/A')),
          ],
        ),
        SizedBox(height: AppSizes.spacingSmall),
        Row(
          children: [
            Expanded(flex: 2, child: Text(Strings.caseInformation.id)),
            Expanded(flex: 3, child: Text(caseInformation.refereeNo ?? 'N/A')),
          ],
        ),
        SizedBox(height: AppSizes.spacingSmall),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(Strings.caseInformation.organization),
            ),
            Expanded(
              flex: 3,
              child: Text(caseInformation.organization ?? 'N/A'),
            ),
          ],
        ),
        SizedBox(height: AppSizes.spacingSmall),
        Row(
          children: [
            Expanded(flex: 2, child: Text(Strings.caseInformation.name)),
            Expanded(flex: 3, child: Text(caseInformation.name ?? 'N/A')),
          ],
        ),
        SizedBox(height: AppSizes.spacingSmall),
        Row(
          children: [
            Expanded(flex: 2, child: Text(Strings.caseInformation.value)),
            Expanded(
              flex: 3,
              child: Text(caseInformation.value?.toString() ?? 'N/A'),
            ),
          ],
        ),
      ],
    );
  }
}
