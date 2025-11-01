import 'package:audist/common/widgets/custom_app_bar.dart';
import 'package:audist/common/widgets/custom_background.dart';
import 'package:audist/common/widgets/custom_button.dart';
import 'package:audist/common/widgets/custom_date_picker.dart';
import 'package:audist/common/widgets/custom_input.dart';
import 'package:audist/common/widgets/drawer.dart';
import 'package:audist/core/color.dart';
import 'package:audist/core/sizes.dart';
import 'package:audist/core/string.dart';
import 'package:audist/providers/case_information_checkbox_provider.dart';
import 'package:audist/providers/image_picker_provider.dart';
import 'package:audist/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CaseInformationScreen extends StatelessWidget {
  const CaseInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      child: Consumer2<LanguageProvider, ImagePickerProvider>(
        builder: (context, languageProvider, imageProvider, child) => Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(title: Strings.caseInformation.title),
          drawer: const CustomDrawer(),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(AppSizes.paddingMedium),
            child: Column(
              children: [
                // * case information
                _caseInformations(context),

                // * space & horizontal divider
                SizedBox(height: AppSizes.spacingSmall),
                const Divider(),

                // * check boxes
                _caseStatuses(context),

                SizedBox(height: AppSizes.spacingSmall),

                // * next case date picker
                _nextCaseDatePicker(context),

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
                _judgmentSection(context),

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
                _actionButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionButton(BuildContext context) {
    return CustomButton(
      content: Text(
        Strings.caseInformation.registerButtonText,
        style: TextStyle(color: AppColors.surfaceLight),
      ),
      onPressed: () {},
    );
  }

  Widget _imagePickerSection(
    BuildContext context,
    ImagePickerProvider imageProvider,
  ) {
    return Stack(
      children: [
        // * 7th row - image preview & picker
        if (imageProvider.secondImage != null)
          Container(
            width: double.infinity,
            height: 460,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400),
              image: DecorationImage(
                image: FileImage(imageProvider.secondImage!),
                fit: BoxFit.contain,
              ),
            ),
          )
        else
          Container(
            width: double.infinity,
            height: 460,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.black87,
              image: DecorationImage(
                image: AssetImage('assets/images/place_holder_image.webp'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(
                Strings.newCase.noImageSelected,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

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
      ],
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
              child: Checkbox(value: false, onChanged: (value) {}),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(flex: 2, child: Text(Strings.caseInformation.testimony)),
            Expanded(
              flex: 3,
              child: Checkbox(value: false, onChanged: (value) {}),
            ),
          ],
        ),
      ],
    );
  }

  Widget _judgmentSection(BuildContext context) {
    TextEditingController todaysPaymentController = TextEditingController();
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
                textEditingController: todaysPaymentController,
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
              child: Custominput(
                textEditingController: todaysPaymentController,
                name: '',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _nextCaseDatePicker(BuildContext context) {
    TextEditingController datePickerController = TextEditingController();
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

  Widget _caseInformations(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: AppSizes.spacingSmall),
        Row(
          children: [
            Expanded(flex: 2, child: Text(Strings.caseInformation.caseNumber)),
            const Expanded(flex: 3, child: Text("data")),
          ],
        ),
        SizedBox(height: AppSizes.spacingSmall),
        Row(
          children: [
            Expanded(flex: 2, child: Text(Strings.caseInformation.id)),
            const Expanded(flex: 3, child: Text("data")),
          ],
        ),
        SizedBox(height: AppSizes.spacingSmall),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(Strings.caseInformation.organization),
            ),
            const Expanded(flex: 3, child: Text("data")),
          ],
        ),
        SizedBox(height: AppSizes.spacingSmall),
        Row(
          children: [
            Expanded(flex: 2, child: Text(Strings.caseInformation.name)),
            const Expanded(flex: 3, child: Text("data")),
          ],
        ),
        SizedBox(height: AppSizes.spacingSmall),
        Row(
          children: [
            Expanded(flex: 2, child: Text(Strings.caseInformation.value)),
            const Expanded(flex: 3, child: Text("data")),
          ],
        ),
      ],
    );
  }
}
