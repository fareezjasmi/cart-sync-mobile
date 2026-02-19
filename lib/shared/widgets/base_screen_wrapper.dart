import 'package:flutter/material.dart';
import 'package:cartsync/shared/widgets/loading_indicator.dart';
import 'package:cartsync/utils/app_colors.dart';

class BaseScreenWrapper extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isLoading;
  final Widget child;
  final bool hasBack;
  final double paddingHorizontal;
  final double paddingVertical;
  final VoidCallback? onClickBack;
  final Color bgColor;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomWidget;

  const BaseScreenWrapper({
    super.key,
    required this.title,
    required this.isLoading,
    required this.child,
    this.subtitle,
    this.hasBack = true,
    this.paddingHorizontal = 16.0,
    this.paddingVertical = 20.0,
    this.onClickBack,
    this.bgColor = AppColors.background,
    this.actions,
    this.floatingActionButton,
    this.bottomWidget,
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
            elevation: 0,
            title: subtitle != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )
                : Text(title),
            leading: hasBack
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                    onPressed: onClickBack ?? () => Navigator.pop(context),
                  )
                : null,
            automaticallyImplyLeading: hasBack,
            actions: actions,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              paddingHorizontal,
              paddingVertical,
              paddingHorizontal,
              floatingActionButton != null ? 96 : paddingVertical,
            ),
            child: child,
          ),
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: bottomWidget,
        ),
        if (isLoading) const LoadingIndicator(),
      ],
    );
  }
}
