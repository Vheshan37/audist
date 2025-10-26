import 'package:audist/common/widgets/custom_app_bar.dart';
import 'package:audist/common/widgets/custom_background.dart';
import 'package:audist/common/widgets/custom_button.dart';
import 'package:audist/common/widgets/custom_date_picker.dart';
import 'package:audist/common/widgets/custom_input.dart';
import 'package:audist/common/widgets/drawer.dart';
import 'package:audist/core/color.dart';
import 'package:audist/core/sizes.dart';
import 'package:audist/core/string.dart';
import 'package:audist/providers/image_picker_provider.dart';
import 'package:audist/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewCaseScreen extends StatelessWidget {
  const NewCaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) => CustomBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(title: Strings.newCase.title),
          drawer: CustomDrawer(),
          body: Consumer<ImagePickerProvider>(
            builder: (context, imageProvider, child) => SingleChildScrollView(
              padding: EdgeInsets.all(AppSizes.paddingMedium),
              child: Form(
                key: formKey,
                child: _formSection(context, imageProvider),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formSection(BuildContext context, ImagePickerProvider imageProvider) {
    TextEditingController caseIdController = TextEditingController();
    TextEditingController caseNumberController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController organizationController = TextEditingController();
    TextEditingController valueController = TextEditingController();
    TextEditingController nextHearingDateController = TextEditingController();

    return Column(
      spacing: AppSizes.spacingMedium,
      children: [
        // * 1st row
        Row(
          spacing: AppSizes.spacingMedium,
          children: [
            Expanded(
              child: Custominput(
                textEditingController: caseIdController,
                name: Strings.newCase.id,
              ),
            ),
            Expanded(
              child: Custominput(
                textEditingController: caseNumberController,
                name: Strings.newCase.number,
              ),
            ),
          ],
        ),

        // * 2nd row
        Custominput(
          textEditingController: nameController,
          name: Strings.newCase.name,
        ),

        // * 3rd row
        Custominput(
          textEditingController: nameController,
          name: Strings.newCase.nic,
        ),

        // * 4th row
        Custominput(
          textEditingController: organizationController,
          name: Strings.newCase.organization,
        ),

        // * 5th row
        Custominput(
          textEditingController: valueController,
          name: Strings.newCase.value,
        ),

        // * 6th row next case date label & date picker
        CustomDatePicker(
          textEditingController: nextHearingDateController,
          name: Strings.newCase.nextCaseDate,
          firstDate: DateTime.now(), // Only future dates
          lastDate: DateTime.now().add(Duration(days: 365 * 10)),
          // initialDate: DateTime.now().add(Duration(days: 30)),
          initialDate: DateTime.now(),
          validatorFunction: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a date';
            }
            return null;
          },
        ),

        Stack(
          children: [
            // * 7th row - image preview & picker
            if (imageProvider.pickedImage != null)
              Container(
                width: double.infinity,
                height: 460,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400),
                  image: DecorationImage(
                    image: FileImage(imageProvider.pickedImage!),
                    fit: BoxFit.cover,
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
                    borderRadius: BorderRadius.circular(
                      AppSizes.borderRadiusSmall,
                    ),
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
                onTap: imageProvider.pickImageFromFilePicker,
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
        ),

        // * Submit button
        CustomButton(
          content: Text(
            Strings.newCase.insertCase,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppSizes.bodyMedium,
            ),
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
