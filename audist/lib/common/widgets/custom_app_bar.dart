import 'package:audist/core/color.dart';
import 'package:audist/core/sizes.dart';
import 'package:audist/core/string.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // automaticallyImplyLeading: true,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.brandAccent),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: AppSizes.bodyLarge,
          fontWeight: FontWeight.w600,
          color: AppColors.brandDark,
        ),
      ),
      actionsPadding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: AppColors.brandAccent),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
