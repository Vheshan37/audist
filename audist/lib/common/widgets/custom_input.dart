import 'package:audist/core/color.dart';
import 'package:audist/core/sizes.dart';
import 'package:flutter/material.dart';

class Custominput extends StatelessWidget {
  final TextEditingController textEditingController;
  final String name;
  final bool secure;
  final String? Function(String?)? validatorFunction;
  final bool enabled;
  const Custominput({
    super.key,
    required this.textEditingController,
    required this.name,
    this.secure = false,
    this.enabled = true,
    this.validatorFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // consistent spacing
      child: TextFormField(
        enabled: enabled,
        controller: textEditingController,
        obscureText: secure,
        maxLines: secure ? 1 : null,
        minLines: secure ? 1 : null,
        decoration: InputDecoration(
          labelText: name,
          labelStyle: TextStyle(color: AppColors.darkGreyColor),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 18.0,
          ),
          errorStyle: const TextStyle(
            height: 0.9, // keeps field from shrinking
            fontSize: 12,
          ),
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
