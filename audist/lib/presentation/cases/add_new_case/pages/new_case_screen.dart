import 'package:audist/common/helpers/app_alert.dart';
import 'package:audist/common/helpers/converter_helper.dart';
import 'package:audist/common/widgets/custom_app_bar.dart';
import 'package:audist/common/widgets/custom_background.dart';
import 'package:audist/common/widgets/custom_button.dart';
import 'package:audist/common/widgets/custom_date_picker.dart';
import 'package:audist/common/widgets/custom_input.dart';
import 'package:audist/common/widgets/drawer.dart';
import 'package:audist/core/color.dart';
import 'package:audist/core/navigation/app_navigator.dart';
import 'package:audist/core/navigation/app_routes.dart';
import 'package:audist/core/sizes.dart';
import 'package:audist/core/string.dart';
import 'package:audist/presentation/cases/add_new_case/blocs/add_case/add_case_bloc.dart';
import 'package:audist/presentation/home/blocs/allcase/all_case_bloc.dart';
import 'package:audist/presentation/home/blocs/cases/fetch_case_bloc.dart';
import 'package:audist/providers/common_data_provider.dart';
import 'package:audist/providers/image_picker_provider.dart';
import 'package:audist/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewCaseScreen extends StatefulWidget {
  const NewCaseScreen({super.key});

  @override
  State<NewCaseScreen> createState() => _NewCaseScreenState();
}

class _NewCaseScreenState extends State<NewCaseScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController caseIdController = TextEditingController();
  final TextEditingController caseNumberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicController = TextEditingController();
  final TextEditingController organizationController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  final TextEditingController nextHearingDateController =
      TextEditingController();

  @override
  void dispose() {
    caseIdController.dispose();
    caseNumberController.dispose();
    nameController.dispose();
    nicController.dispose();
    organizationController.dispose();
    valueController.dispose();
    nextHearingDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                key: _formKey,
                child: _formSection(context, imageProvider, languageProvider),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formSection(
    BuildContext context,
    ImagePickerProvider imageProvider,
    LanguageProvider language,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1st row: Referee No & Case Number
        Row(
          children: [
            Expanded(
              child: Custominput(
                textEditingController: caseIdController,
                name: Strings.newCase.id,
                validatorFunction: (value) {
                  if (value == null || value.isEmpty) {
                    return language.isEnglish
                        ? 'Referee no is required'
                        : 'තීරක අංකය අනිවාර්යයි';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: AppSizes.spacingMedium),
            Expanded(
              child: Custominput(
                textEditingController: caseNumberController,
                name: Strings.newCase.number,
                validatorFunction: (value) {
                  if (value == null || value.isEmpty) {
                    return language.isEnglish
                        ? 'Case number is required'
                        : 'නඩු අංකය අනිවාර්යයි';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),

        SizedBox(height: AppSizes.spacingSmall),

        // 2nd row: Name
        Custominput(
          textEditingController: nameController,
          name: Strings.newCase.name,
          validatorFunction: (value) {
            if (value == null || value.isEmpty) {
              return language.isEnglish ? 'Name is required' : 'නම අනිවාර්යයි';
            }
            return null;
          },
        ),

        SizedBox(height: AppSizes.spacingSmall),

        // 3rd row: NIC
        Custominput(
          textEditingController: nicController,
          name: Strings.newCase.nic,
          validatorFunction: (value) {
            if (value == null || value.isEmpty) {
              return language.isEnglish
                  ? 'NIC is required'
                  : 'හැදුනුම්පත් අංකය අනිවාර්යයි';
            }
            return null;
          },
        ),

        SizedBox(height: AppSizes.spacingSmall),

        // 4th row: Organization
        Custominput(
          textEditingController: organizationController,
          name: Strings.newCase.organization,
          validatorFunction: (value) {
            if (value == null || value.isEmpty) {
              return language.isEnglish
                  ? 'Organization name is required'
                  : 'සමිති නාමය අනිවාර්යයි';
            }
            return null;
          },
        ),

        SizedBox(height: AppSizes.spacingSmall),

        // 5th row: Value
        Custominput(
          textEditingController: valueController,
          name: Strings.newCase.value,
          validatorFunction: (value) {
            if (value == null || value.isEmpty) {
              return language.isEnglish
                  ? 'Case value is required'
                  : 'වටිනාකම අනිවාර්යයි';
            }
            return null;
          },
        ),

        SizedBox(height: AppSizes.spacingSmall),

        // 6th row: Next Hearing Date
        CustomDatePicker(
          textEditingController: nextHearingDateController,
          name: Strings.newCase.nextCaseDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365 * 10)),
          initialDate: DateTime.now(),
          validatorFunction: (value) {
            if (value == null || value.isEmpty) {
              return language.isEnglish
                  ? 'Please select a date'
                  : 'ඉදිරි නඩු දිනය අනිවාර්යයි';
            }
            return null;
          },
        ),

        SizedBox(height: AppSizes.spacingSmall),

        // 7th row: Image preview
        _imagePickerSection(imageProvider),

        SizedBox(height: AppSizes.spacingMedium),

        // 8th row: Submit button
        BlocConsumer<AddCaseBloc, AddCaseState>(
          listener: (context, state) {
            if (state is AddCaseLoaded) {
              debugPrint("New Case Added Successful");
              AppAlert.show(
                context,
                type: AlertType.success,
                title: "Case Added Successfully",
                description:
                    "Your new case has been added and is now visible in the case list.",
              );
              context.read<AllCaseBloc>().add(
                RequestAllCase(uid: context.read<CommonDataProvider>().uid!),
              );
              context.read<FetchCaseBloc>().add(
                RequestFetchCase(uid: context.read<CommonDataProvider>().uid!),
              );

              // * refresh the page after successfully adding new case

              // Clear all input fields
              _formKey.currentState?.reset();
              caseIdController.clear();
              caseNumberController.clear();
              nameController.clear();
              nicController.clear();
              organizationController.clear();
              valueController.clear();
              nextHearingDateController.clear();

              // Clear image selection
              final imageProvider = context.read<ImagePickerProvider>();
              context.read<ImagePickerProvider>().clearFirstImage();

              AppNavigator.pushReplacement(AppRoutes.home);
              AppNavigator.push(AppRoutes.nextCase);
            } else if (state is AddCaseFailed) {
              debugPrint("New Case Added Failed");
              AppAlert.show(
                context,
                type: AlertType.error,
                title: "Failed to Add Case",
                description: state.errorMessage,
              );
            } else {
              debugPrint("Something else happened");
            }
          },
          builder: (context, state) {
            if (state is AddCaseLoading) {
              return CustomButton(
                content: CircularProgressIndicator(
                  color: AppColors.surfaceLight,
                ),
                onPressed: () {},
              );
            }
            // Normal & Failed state -> show the action button
            return _actionButton(context);
          },
        ),
      ],
    );
  }

  Widget _imagePickerSection(ImagePickerProvider imageProvider) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        // Use placeholder dimensions if no image is selected
        final image = imageProvider.firstImage != null
            ? Image.file(imageProvider.firstImage!)
            : Image.asset('assets/images/place_holder_image.webp');

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
                    child: FittedBox(
                      fit: BoxFit.contain, // ensures no overflow
                      child: image,
                    ),
                  ),
                ),

                // Upload button
                Positioned(
                  top: 10,
                  left: 10,
                  child: GestureDetector(
                    onTap: imageProvider.pickFirstImageFromFilePicker,
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

                // Overlay text if no image
                if (imageProvider.firstImage == null)
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

  Widget _actionButton(BuildContext context) {
    return CustomButton(
      content: Text(
        Strings.newCase.insertCase,
        style: TextStyle(color: Colors.white, fontSize: AppSizes.bodyMedium),
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          final formattedDate = ConverterHelper.formatDate(
            nextHearingDateController.text,
          );

          context.read<AddCaseBloc>().add(
            RequestAddCaseEvent(
              refereeNo: caseIdController.text,
              caseId: caseNumberController.text,
              name: nameController.text,
              nic: nicController.text,
              organization: organizationController.text,
              value: double.tryParse(valueController.text) ?? 0.0,
              date: formattedDate,
              userId: context.read<CommonDataProvider>().uid!,
              image: "",
            ),
          );
        }
      },
    );
  }
}
