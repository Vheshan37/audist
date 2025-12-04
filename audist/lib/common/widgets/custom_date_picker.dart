import 'package:audist/core/color.dart';
import 'package:audist/core/sizes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatelessWidget {
  final TextEditingController textEditingController;
  final String name;
  final String? Function(String?)? validatorFunction;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;
  final String dateFormat;
  final Function(DateTime)? onDateSelected;

  const CustomDatePicker({
    super.key,
    required this.textEditingController,
    required this.name,
    this.validatorFunction,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.dateFormat = 'yyyy-MM-dd',
    this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: textEditingController,
        readOnly: true, // Prevent keyboard input
        // expands: true,
        maxLines: null,
        // minLines: null,
        decoration: InputDecoration(
          label: Text(name, style: TextStyle(color: AppColors.darkGreyColor)),
          hintText: "Hello",
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          suffixIcon: Icon(Icons.calendar_today, color: AppColors.brandAccent),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.brandAccent),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.brandAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.brandAccent, width: 2.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.errorColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.errorColor, width: 2.0),
          ),
        ),
        onTap: () => _selectDate(context),
        validator: validatorFunction,
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    // Hide keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      // firstDate: firstDate ?? DateTime.now().subtract(Duration(days: 1)),
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime.now().add(Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.darkGreyColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      textEditingController.text = DateFormat(dateFormat).format(picked);

      if (onDateSelected != null) {
        onDateSelected!(picked);
      }
    }
  }
}
