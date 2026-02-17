import 'package:flutter/material.dart';
import 'package:cartsync/shared/widgets/loading_indicator.dart';
import 'package:cartsync/utils/app_colors.dart';

class BaseScreenWrapper extends StatelessWidget {
  final String title;
  final bool isLoading;
  final Widget child;
  final bool hasBack;
  final double paddingHorizontal;
  final double paddingVertical;
  final VoidCallback? onClickBack;
  final Color bgColor;
  final List<Widget>? actions;

  const BaseScreenWrapper({
    super.key,
    required this.title,
    required this.isLoading,
    required this.child,
    this.hasBack = true,
    this.paddingHorizontal = 16.0,
    this.paddingVertical = 24.0,
    this.onClickBack,
    this.bgColor = AppColors.background,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            title: Text(title),
            leading: hasBack
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed:
                        onClickBack ?? () => Navigator.pop(context),
                  )
                : null,
            automaticallyImplyLeading: hasBack,
            actions: actions,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontal,
              vertical: paddingVertical,
            ),
            child: child,
          ),
        ),
        if (isLoading) const LoadingIndicator(),
      ],
    );
  }
}
