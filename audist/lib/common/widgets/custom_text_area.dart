import 'package:audist/core/color.dart';
import 'package:audist/core/sizes.dart';
import 'package:flutter/material.dart';

class CustomTextArea extends StatelessWidget {
  final TextEditingController textEditingController;
  final String name;
  final bool secure;
  final String? Function(String?)? validatorFunction;
  const CustomTextArea({
    super.key,
    required this.textEditingController,
    required this.name,
    this.secure = false,
    this.validatorFunction,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 160,
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        minLines: null,
        maxLines: 6,
        controller: textEditingController,
        obscureText: secure,
        // expands: false,
        decoration: InputDecoration(
          // hintText: name,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
            borderSide: BorderSide(color: AppColors.brandAccent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
            borderSide: BorderSide(color: AppColors.brandAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
            borderSide: BorderSide(color: AppColors.brandAccent, width: 2.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
            borderSide: BorderSide(color: AppColors.errorColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
            borderSide: BorderSide(color: AppColors.errorColor, width: 2.0),
          ),
        ),
        validator: validatorFunction,
      ),
    );
  }
}
