import 'package:audist/common/helpers/app_alert.dart';
import 'package:audist/common/helpers/converter_helper.dart';
import 'package:audist/common/widgets/custom_app_bar.dart';
import 'package:audist/common/widgets/custom_background.dart';
import 'package:audist/common/widgets/custom_button.dart';
import 'package:audist/common/widgets/custom_date_picker.dart';
import 'package:audist/common/widgets/custom_input.dart';
import 'package:audist/common/widgets/custom_text_area.dart';
import 'package:audist/common/widgets/drawer.dart';
import 'package:audist/core/color.dart';
import 'package:audist/core/model/add_payment/add_payment_request_model.dart';
import 'package:audist/core/model/fetch_payment/fetch_payment_request.dart';
import 'package:audist/core/sizes.dart';
import 'package:audist/core/string.dart';
import 'package:audist/domain/cases/entities/case_entity.dart';
import 'package:audist/presentation/payments/add_payment/blocs/add_payment/add_payment_bloc.dart';
import 'package:audist/presentation/payments/add_payment/blocs/fetch_payment/fetch_payment_bloc.dart';
import 'package:audist/providers/common_data_provider.dart';
import 'package:audist/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddPaymentScreen extends StatefulWidget {
  const AddPaymentScreen({super.key});

  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  late TextEditingController caseNumberController;
  late TextEditingController idController;
  late TextEditingController nameController;
  late TextEditingController organizationController;
  late TextEditingController valueController;
  late TextEditingController dateController;
  late TextEditingController amountController;
  late TextEditingController balanceController;
  late TextEditingController otherController;
  late TextEditingController paidAmountController;
  late TextEditingController payableAmountController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    caseNumberController = TextEditingController();
    idController = TextEditingController();
    nameController = TextEditingController();
    organizationController = TextEditingController();
    valueController = TextEditingController();
    dateController = TextEditingController();
    amountController = TextEditingController();
    balanceController = TextEditingController();
    otherController = TextEditingController();
    paidAmountController = TextEditingController();
    payableAmountController = TextEditingController();

    amountController.addListener(_updateBalance);
    // final initialNextPayment = DateTime.now().add(Duration(days: 30));
    // dateController.text = ConverterHelper.dateTimeToString(initialNextPayment);
  }

  void _clearForm() {
    caseNumberController.clear();
    idController.clear();
    nameController.clear();
    organizationController.clear();
    valueController.clear();
    dateController.clear();
    amountController.clear();
    balanceController.clear();
    otherController.clear();
    paidAmountController.clear();
    payableAmountController.clear();
  }

  @override
  void dispose() {
    _clearForm();
    // Dispose all controllers to prevent memory leaks
    caseNumberController.dispose();
    idController.dispose();
    nameController.dispose();
    organizationController.dispose();
    valueController.dispose();
    dateController.dispose();
    amountController.dispose();
    balanceController.dispose();
    otherController.dispose();
    paidAmountController.dispose();
    payableAmountController.dispose();
    super.dispose();
  }

  // TODO: implement this method to get the payment information when press the select button
  void _fetchCasePayment(
    BuildContext context,
    FetchPaymentRequest fetchPaymentRequest,
  ) {
    context.read<FetchPaymentBloc>().add(
      RequestFetchPayment(request: fetchPaymentRequest),
    );
  }

  void _loadData(CaseEntity caseEntity) {
    caseNumberController.text = caseEntity.caseNumber!;
    idController.text = caseEntity.refereeNo!;
    nameController.text = caseEntity.name!;
    organizationController.text = caseEntity.organization!;
    valueController.text = NumberFormat.currency(
      locale: 'en_US',
      symbol: 'Rs.',
    ).format(caseEntity.value!);
    paidAmountController.text = "";
    payableAmountController.text = "";
  }

  double payableAmount = 0;

  void _updateBalance() {
    final enteredAmount =
        double.tryParse(
          amountController.text.replaceAll(RegExp(r'[^0-9.]'), ''),
        ) ??
        0.0;

    final balance = payableAmount - enteredAmount;

    balanceController.text = balance.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final Object? arguiment = ModalRoute.of(context)?.settings.arguments;

    CaseEntity? caseEntity;

    if (arguiment is CaseEntity) {
      caseEntity = arguiment;
      _loadData(caseEntity);

      FetchPaymentRequest fetchPaymentRequest = FetchPaymentRequest(
        caseNumb: caseEntity.caseNumber!,
        userId: context.read<CommonDataProvider>().uid!,
        includePayments: true,
      );
      _fetchCasePayment(context, fetchPaymentRequest);
    }

    debugPrint("Case Entity: ${caseEntity != null}");

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
            child: Form(key: formKey, child: _formFields(context, formKey)),
          ),
        ),
      ),
    );
  }

  Widget _formFields(BuildContext context, GlobalKey<FormState> formKey) {
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
              child: BlocConsumer<FetchPaymentBloc, FetchPaymentState>(
                listener: (context, state) {
                  if (state is FetchPaymentSuccess) {
                    AppAlert.show(
                      context,
                      type: AlertType.success,
                      title: "Case Details Retrieved",
                      description:
                          "Payment information has been successfully loaded.",
                    );

                    paidAmountController.text = ConverterHelper.formatCurrency(
                      ConverterHelper.objectToDouble(
                        state.data.fetchPaymentResponseCase?.totalPaid,
                      ),
                    );

                    payableAmount = ConverterHelper.objectToDouble(
                      state.data.fetchPaymentResponseCase?.remaining,
                    );

                    payableAmountController.text =
                        ConverterHelper.formatCurrency(payableAmount);
                  }
                  if (state is FetchPaymentFailed) {
                    AppAlert.show(
                      context,
                      type: AlertType.warning,
                      title: "Unable to Retrieve Case",
                      description: state.message,
                    );
                  }
                  // TODO: implement listener
                },
                builder: (context, state) {
                  if (state is FetchPaymentLoading) {
                    return CustomButton(
                      content: CircularProgressIndicator(
                        color: AppColors.surfaceLight,
                      ),
                      onPressed: () {
                        // TODO: Implement add payment functionality
                      },
                    );
                  }
                  return CustomButton(
                    content: Text(
                      Strings.addPayment.select,
                      style: TextStyle(color: AppColors.surfaceLight),
                    ),
                    onPressed: () {
                      if (caseNumberController.text.isEmpty) {
                        AppAlert.show(
                          context,
                          type: AlertType.warning,
                          title: "Case Number Required",
                          description:
                              "Please enter a valid case number before continuing.",
                        );
                        return;
                      }
                      FetchPaymentRequest fetchPaymentRequest =
                          FetchPaymentRequest(
                            caseNumb: caseNumberController.text,
                            userId: context.read<CommonDataProvider>().uid!,
                            includePayments: true,
                          );
                      _fetchCasePayment(context, fetchPaymentRequest);
                    },
                  );
                },
              ),
            ),
          ],
        ),

        // * 2nd row
        Custominput(
          textEditingController: idController,
          name: Strings.addPayment.id,
          enabled: false,
        ),

        // * 2nd row
        Custominput(
          textEditingController: nameController,
          name: Strings.addPayment.name,
          enabled: false,
        ),

        // * 2nd row
        Custominput(
          textEditingController: organizationController,
          name: Strings.addPayment.organization,
          enabled: false,
        ),

        // * 2nd row
        Custominput(
          textEditingController: valueController,
          name: Strings.addPayment.value,
          enabled: false,
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
                enabled: false,
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
                textEditingController: payableAmountController,
                name: 'Rs. 0.00',
                enabled: false,
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
                Strings.addPayment.amount,
                style: TextStyle(fontSize: AppSizes.bodyLarge),
              ),
            ),
            Expanded(
              flex: 3,
              child: Custominput(
                textEditingController: amountController,
                name: 'Rs. 0.00',
                validatorFunction: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Amount is required';
                  }

                  final number = double.tryParse(value);

                  if (number == null) {
                    return 'Enter a valid number';
                  }

                  return null;
                },
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
                name: 'Rs. 0.00',
                enabled: false,
              ),
            ),
          ],
        ),

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
                validatorFunction: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Next payment date is required';
                  }

                  // Check if it contains placeholder year
                  if (value.contains('YYYY')) {
                    return 'Please select a valid date';
                  }

                  return null;
                },
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

        BlocConsumer<AddPaymentBloc, AddPaymentState>(
          listener: (context, state) {
            if (state is AddPaymentFailed) {
              AppAlert.show(
                context,
                type: AlertType.error,
                title: "Payment Failed",
                description: state.message,
              );
            }

            if (state is AddPaymentSuccess) {
              AppAlert.show(
                context,
                type: AlertType.success,
                title: "Payment Added",
                description: "The payment was successfully recorded.",
              );

              // OPTIONAL: Clear fields or navigate back
              // Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state is AddPaymentLoading) {
              return CustomButton(
                content: CircularProgressIndicator(
                  color: AppColors.surfaceLight,
                ),
                onPressed: () {},
              );
            }

            return CustomButton(
              content: Text(
                Strings.addPayment.addButtonText,
                style: TextStyle(color: AppColors.surfaceLight),
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final AddPaymentRequestModel request = AddPaymentRequestModel(
                    caseNumber: caseNumberController.text,
                    payment: ConverterHelper.stringToInt(amountController.text),
                    paymentDate: DateTime.now(),
                    nextPaymentDate: ConverterHelper.parseDate(
                      dateController.text,
                    ),
                    description: otherController.text,
                    userId: context.read<CommonDataProvider>().uid!,
                  );

                  context.read<AddPaymentBloc>().add(
                    RequestAddPayment(request: request),
                  );
                }
              },
            );
          },
        ),
      ],
    );
  }
}
