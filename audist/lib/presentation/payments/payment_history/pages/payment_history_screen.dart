import 'package:audist/common/widgets/custom_app_bar.dart';
import 'package:audist/common/widgets/custom_background.dart';
import 'package:audist/common/widgets/custom_button.dart';
import 'package:audist/common/widgets/custom_input.dart';
import 'package:audist/common/widgets/drawer.dart';
import 'package:audist/core/color.dart';
import 'package:audist/core/fake_database/ledger_table.dart';
import 'package:audist/core/sizes.dart';
import 'package:audist/core/string.dart';
import 'package:audist/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserCollection users = UserCollection();
    final verticalScrollController = ScrollController();
    final horizontalScrollController = ScrollController();

    TextEditingController caseNumberController = TextEditingController();

    return CustomBackground(
      child: Consumer<LanguageProvider>(
        builder: (context, value, child) => Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(title: Strings.ledger.title),
          drawer: CustomDrawer(),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(AppSizes.paddingMedium),
            child: Column(
              children: [
                // * 1st row (case number input + select button)
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
                      child: CustomButton(
                        content: Text(
                          Strings.ledger.select,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppSizes.bodyMedium,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSizes.spacingMedium),

                // * 2nd row (case information)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingSmall,
                  ),
                  child: Column(
                    spacing: AppSizes.spacingSmall,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${Strings.ledger.id} :',
                              style: TextStyle(color: AppColors.surfaceDark),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'value',
                              style: TextStyle(color: AppColors.surfaceDark),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${Strings.ledger.name} :',
                              style: TextStyle(color: AppColors.surfaceDark),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'value',
                              style: TextStyle(color: AppColors.surfaceDark),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${Strings.ledger.organization} :',
                              style: TextStyle(color: AppColors.surfaceDark),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'value',
                              style: TextStyle(color: AppColors.surfaceDark),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${Strings.ledger.value} :',
                              style: TextStyle(color: AppColors.surfaceDark),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'value',
                              style: TextStyle(color: AppColors.surfaceDark),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSizes.spacingMedium),
                Divider(),
                SizedBox(height: AppSizes.spacingMedium),

                // * 3rd row (table section) - Dynamic width based on content
                Container(
                  height: 460,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.surfaceDark.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Use available width or minimum width for table
                      final tableWidth = constraints.maxWidth < 600
                          ? 600.0
                          : constraints.maxWidth;

                      return Scrollbar(
                        controller: horizontalScrollController,
                        scrollbarOrientation: ScrollbarOrientation.bottom,
                        child: SingleChildScrollView(
                          controller: horizontalScrollController,
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: tableWidth,
                            child: Column(
                              children: [
                                // Fixed Table Header
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.brandAccent,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: _buildHeaderCell(Strings.ledger.date),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: _buildHeaderCell(Strings.ledger.description),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: _buildHeaderCell(Strings.ledger.payment),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: _buildHeaderCell(Strings.ledger.balance),
                                      ),
                                    ],
                                  ),
                                ),

                                // Scrollable Table Body (only vertical scroll)
                                Expanded(
                                  child: Scrollbar(
                                    controller: verticalScrollController,
                                    thumbVisibility: true,
                                    child: ListView.builder(
                                      controller: verticalScrollController,
                                      itemCount: users.users.length,
                                      itemBuilder: (context, index) {
                                        final user = users.users[index];
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: index % 2 == 0
                                                ? Colors.transparent
                                                : AppColors.surfaceDark.withOpacity(0.05),
                                            border: Border(
                                              bottom: BorderSide(
                                                color: AppColors.surfaceDark.withOpacity(0.2),
                                              ),
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 12,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: _buildDataCell(user.date),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: _buildDataCell(user.description),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: _buildDataCell(user.payment),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: _buildDataCell(user.balance),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
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

                // * 4th Row
                CustomButton(
                  content: Text(
                    Strings.ledger.download,
                    style: TextStyle(color: AppColors.surfaceLight),
                  ),
                  onPressed: () {
                    // TODO: implement pdf download process
                  },
                ),
              ],
            ),
          ),
        ),
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
        style: TextStyle(
          color: AppColors.surfaceDark,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }
}