import 'package:audist/common/helpers/app_alert.dart';
import 'package:audist/common/helpers/converter_helper.dart';
import 'package:audist/common/helpers/ledger_pdf.dart';
import 'package:audist/common/widgets/custom_app_bar.dart';
import 'package:audist/common/widgets/custom_background.dart';
import 'package:audist/common/widgets/custom_button.dart';
import 'package:audist/common/widgets/custom_input.dart';
import 'package:audist/common/widgets/drawer.dart';
import 'package:audist/core/color.dart';
import 'package:audist/core/model/fetch_payment/fetch_payment_request.dart';
import 'package:audist/core/model/fetch_payment/fetch_payment_response.dart';
import 'package:audist/domain/cases/entities/case_entity.dart';
import 'package:audist/presentation/payments/add_payment/blocs/fetch_payment/fetch_payment_bloc.dart';
import 'package:audist/providers/common_data_provider.dart';
import 'package:audist/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:audist/core/sizes.dart';
import 'package:audist/core/string.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  void _fetchCasePayment(
    BuildContext context,
    FetchPaymentRequest fetchPaymentRequest,
  ) {
    context.read<FetchPaymentBloc>().add(
      RequestFetchPayment(request: fetchPaymentRequest),
    );
  }

  @override
  Widget build(BuildContext context) {
    final verticalScrollController = ScrollController();
    final horizontalScrollController = ScrollController();

    TextEditingController caseNumberController = TextEditingController();
    String? caseRefereeNo;
    String? caseName;
    String? caseOrganization;
    String? caseValue;

    // Grab case entity from route arguments
    final Object? object = ModalRoute.of(context)?.settings.arguments;
    List<CashCollection> collection = [];
    if (object is CaseEntity) {
      final caseEntity = object;
      caseNumberController.text = caseEntity.caseNumber!;
      caseRefereeNo = caseEntity.refereeNo!;
      caseName = caseEntity.name!;
      caseOrganization = caseEntity.organization!;
      caseValue = ConverterHelper.formatCurrency(caseEntity.value!);

      FetchPaymentRequest fetchPaymentRequest = FetchPaymentRequest(
        caseNumb: caseEntity.caseNumber!,
        userId: context.read<CommonDataProvider>().uid!,
        includePayments: true,
      );
      _fetchCasePayment(context, fetchPaymentRequest);
    }

    return CustomBackground(
      child: Consumer<LanguageProvider>(
        builder: (context, value, child) => Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(title: Strings.ledger.title),
          drawer: CustomDrawer(),
          body: Padding(
            padding: EdgeInsets.all(AppSizes.paddingMedium),
            child: Column(
              children: [
                // Case number input + select button
                Row(
                  spacing: AppSizes.spacingMedium,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Custominput(
                        textEditingController: caseNumberController,
                        name: Strings.ledger.caseNumber,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: BlocConsumer<FetchPaymentBloc, FetchPaymentState>(
                        listener: (context, state) {
                          if (state is FetchPaymentFailed) {
                            AppAlert.show(
                              context,
                              type: AlertType.warning,
                              title: "Unable to Retrieve Case",
                              description: state.message,
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is FetchPaymentLoading) {
                            return CustomButton(
                              content: CircularProgressIndicator(
                                color: AppColors.surfaceLight,
                              ),
                              onPressed: () {},
                            );
                          }
                          return CustomButton(
                            content: Text(
                              Strings.ledger.select,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppSizes.bodyMedium,
                              ),
                            ),
                            onPressed: () {
                              if (caseNumberController.text.isEmpty) return;
                              _fetchCasePayment(
                                context,
                                FetchPaymentRequest(
                                  caseNumb: caseNumberController.text,
                                  userId: context
                                      .read<CommonDataProvider>()
                                      .uid!,
                                  includePayments: true,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSizes.spacingMedium),

                // Case info
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingSmall,
                  ),
                  child: Column(
                    spacing: AppSizes.spacingSmall,
                    children: [
                      _buildInfoRow(Strings.ledger.id, caseRefereeNo),
                      _buildInfoRow(Strings.ledger.name, caseName),
                      _buildInfoRow(
                        Strings.ledger.organization,
                        caseOrganization,
                      ),
                      _buildInfoRow(Strings.ledger.value, caseValue),
                    ],
                  ),
                ),

                SizedBox(height: AppSizes.spacingMedium),
                Divider(),
                SizedBox(height: AppSizes.spacingMedium),

                // Table -> fills remaining space
                Expanded(
                  child: BlocBuilder<FetchPaymentBloc, FetchPaymentState>(
                    builder: (context, state) {
                      if (state is FetchPaymentSuccess) {
                        collection =
                            state
                                .data
                                .fetchPaymentResponseCase
                                ?.cashCollection ??
                            [];
                      }

                      return Scrollbar(
                        controller: verticalScrollController,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: horizontalScrollController,
                          child: SizedBox(
                            width: 700, // adjust based on column widths
                            child: Column(
                              children: [
                                // Fixed header
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 12,
                                  ),
                                  color: AppColors.brandAccent,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: _buildHeaderCell(
                                          Strings.ledger.date,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: _buildHeaderCell(
                                          Strings.ledger.description,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: _buildHeaderCell(
                                          Strings.ledger.payment,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: _buildHeaderCell(
                                          Strings.ledger.balance,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Body
                                Expanded(
                                  child: collection.isEmpty
                                      ? Center(child: Text("No data"))
                                      : ListView.builder(
                                          controller: verticalScrollController,
                                          itemCount: collection.length,
                                          itemBuilder: (context, index) {
                                            final item = collection[index];
                                            return _buildTableRow(item, index);
                                          },
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: AppSizes.spacingMedium),

                // Download button -> fixed at bottom
                CustomButton(
                  content: Text(
                    Strings.ledger.download,
                    style: TextStyle(color: AppColors.surfaceLight),
                  ),
                  onPressed: () async {
                    // implement PDF download
                    if (collection.isEmpty) {
                      AppAlert.show(
                        context,
                        type: AlertType.warning,
                        title: "No data",
                        description: "There is no ledger data to download.",
                      );
                      return;
                    }

                    await generateLoanLedgerPDF();

                    AppAlert.show(
                      context,
                      type: AlertType.success,
                      title: "PDF Saved",
                      description: "Ledger report saved to documents folder.",
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            '$label :',
            style: TextStyle(color: AppColors.surfaceDark),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value ?? "N/A",
            style: TextStyle(color: AppColors.surfaceDark),
          ),
        ),
      ],
    );
  }

  Widget _buildTableRow(CashCollection item, int index) {
    return Container(
      decoration: BoxDecoration(
        color: index % 2 == 0
            ? Colors.transparent
            : AppColors.surfaceDark.withOpacity(0.05),
        border: Border(
          bottom: BorderSide(color: AppColors.surfaceDark.withOpacity(0.2)),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildDataCell(
              item.collectionDate != null
                  ? ConverterHelper.dateTimeToCustomString(
                      item.collectionDate!,
                      'dd/MM/yyyy',
                    )
                  : "N/A",
            ),
          ),
          Expanded(flex: 5, child: _buildDataCell(item.description ?? "N/A")),
          Expanded(
            flex: 2,
            child: _buildDataCell(
              item.payment != null
                  ? ConverterHelper.formatCurrency(
                      ConverterHelper.objectToDouble(item.payment),
                    )
                  : "N/A",
            ),
          ),
          Expanded(
            flex: 2,
            child: _buildDataCell(
              item.remainingAfterPayment != null
                  ? ConverterHelper.formatCurrency(
                      ConverterHelper.objectToDouble(
                        item.remainingAfterPayment,
                      ),
                    )
                  : "N/A",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.surfaceLight,
          fontWeight: FontWeight.bold,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildDataCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        text,
        style: TextStyle(color: AppColors.surfaceDark),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }
}
