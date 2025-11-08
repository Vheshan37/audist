import 'package:audist/common/widgets/custom_app_bar.dart';
import 'package:audist/common/widgets/custom_background.dart';
import 'package:audist/common/widgets/custom_button.dart';
import 'package:audist/common/widgets/custom_date_picker.dart';
import 'package:audist/common/widgets/custom_input.dart';
import 'package:audist/common/widgets/custom_text_area.dart';
import 'package:audist/common/widgets/drawer.dart';
import 'package:audist/core/color.dart';
import 'package:audist/core/sizes.dart';
import 'package:audist/core/string.dart';
import 'package:audist/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPaymentScreen extends StatelessWidget {
  const AddPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return CustomBackground(
      child: Consumer<LanguageProvider>(
        builder: (context, language, child) => Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(title: Strings.addPayment.title),
          drawer: CustomDrawer(),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMedium,
              vertical: AppSizes.paddingMedium,
            ),
            child: Form(key: formKey, child: _formFields(context)),
          ),
        ),
      ),
    );
  }

  Widget _formFields(BuildContext context) {
    TextEditingController caseNumberController = TextEditingController();
    TextEditingController idController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController organizationController = TextEditingController();
    TextEditingController valueController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    TextEditingController balanceController = TextEditingController();
    TextEditingController otherController = TextEditingController();
    TextEditingController paidAmountController = TextEditingController();
    TextEditingController payableAmountController = TextEditingController();

    return Column(
      spacing: AppSizes.spacingSmall,
      children: [
        // * 1st row
        Row(
          spacing: AppSizes.spacingMedium,
          children: [
            Expanded(
              flex: 2,
              child: Custominput(
                textEditingController: caseNumberController,
                name: Strings.addPayment.caseNumber,
              ),
            ),
            Expanded(
              flex: 1,
              child: CustomButton(
                content: Text(
                  Strings.addPayment.select,
                  style: TextStyle(color: AppColors.surfaceLight),
                ),
                onPressed: () {
                  // TODO: Implement add payment functionality
                },
              ),
            ),
          ],
        ),

        // * 2nd row
        Custominput(
          textEditingController: idController,
          name: Strings.addPayment.id,
        ),

        // * 2nd row
        Custominput(
          textEditingController: nameController,
          name: Strings.addPayment.name,
        ),

        // * 2nd row
        Custominput(
          textEditingController: organizationController,
          name: Strings.addPayment.organization,
        ),

        // * 2nd row
        Custominput(
          textEditingController: valueController,
          name: Strings.addPayment.value,
        ),

        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                Strings.addPayment.paidAmount,
                style: TextStyle(fontSize: AppSizes.bodyLarge),
              ),
            ),
            Expanded(
              flex: 3,
              child: Custominput(
                textEditingController: paidAmountController,
                name: 'Rs. 0.00',
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                Strings.addPayment.dueAmount,
                style: TextStyle(fontSize: AppSizes.bodyLarge),
              ),
            ),
            Expanded(
              flex: 3,
              child: Custominput(
                textEditingController: paidAmountController,
                name: 'Rs. 0.00',
              ),
            ),
          ],
        ),

        Divider(),

        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                Strings.addPayment.paymentDate,
                style: TextStyle(fontSize: AppSizes.bodyLarge),
              ),
            ),
            Expanded(
              flex: 3,
              child: CustomDatePicker(
                textEditingController: dateController,
                name: 'DD/MM/YYYY',
              ),
            ),
          ],
        ),

        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                Strings.addPayment.amount,
                style: TextStyle(fontSize: AppSizes.bodyLarge),
              ),
            ),
            Expanded(
              flex: 3,
              child: Custominput(
                textEditingController: amountController,
                name: '\Rs. 0.00',
              ),
            ),
          ],
        ),

        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                Strings.addPayment.balance,
                style: TextStyle(fontSize: AppSizes.bodyLarge),
              ),
            ),
            Expanded(
              flex: 3,
              child: Custominput(
                textEditingController: balanceController,
                name: '\Rs. 0.00',
              ),
            ),
          ],
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Strings.addPayment.other,
              style: TextStyle(fontSize: AppSizes.bodyLarge),
            ),
            CustomTextArea(
              textEditingController: otherController,
              name: Strings.addPayment.other,
            ),
          ],
        ),

        CustomButton(
          content: Text(
            Strings.addPayment.addButtonText,
            style: TextStyle(color: AppColors.surfaceLight),
          ),
          onPressed: () {
            // TODO: implement add payment action
          },
        ),
      ],
    );
  }
}
