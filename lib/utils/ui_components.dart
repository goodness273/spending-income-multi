import 'package:flutter/material.dart';
import 'app_theme/colors.dart';
import 'app_theme/text_styles.dart';
import 'app_theme/helpers.dart';
import 'app_theme/button_styles.dart';
import 'package:spending_income/common/widgets/app_modal.dart';

/// Provides reusable UI components for consistent appearance across the app
class UIComponents {
  UIComponents._(); // Private constructor

  /// Standard page loading indicator
  static Widget loadingIndicator(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: CircularProgressIndicator(
        color: isDark ? AppColors.accentYellow : AppColors.primaryBlack,
      ),
    );
  }

  /// Standard error widget with retry option
  static Widget errorWidget({
    required BuildContext context,
    required String message,
    VoidCallback? onRetry,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final errorColor = isDark ? Colors.red.shade300 : Colors.red.shade700;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: errorColor, size: 48),
            const SizedBox(height: 16),
            Text(
              message,
              style: (isDark ? AppTextStyles.darkBodyStyle : AppTextStyles.lightBodyStyle)
                  .copyWith(color: errorColor),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: errorColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Standard empty state widget
  static Widget emptyStateWidget({
    required BuildContext context,
    required String message,
    IconData icon = Icons.info_outline,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: textColor, size: 48),
            const SizedBox(height: 16),
            Text(
              message,
              style: (isDark ? AppTextStyles.darkBodyStyle : AppTextStyles.lightBodyStyle)
                  .copyWith(color: textColor),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onAction,
                style: AppButtonStyles.getPrimaryButtonStyle(context),
                child: Text(actionLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Custom alert dialog - delegates to AppModal.showConfirmation for consistency
  static Future<bool?> showCustomDialog({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    bool isDismissible = true,
    bool isDangerous = false,
  }) async {
    // Use AppModal.showConfirmation for consistency
    bool result = await AppModal.showConfirmation(
      context: context,
      title: title,
      message: message,
      confirmText: confirmText ?? 'Confirm',
      cancelText: cancelText ?? 'Cancel',
      isDangerous: isDangerous,
    );
    
    return result;
  }

  /// Custom snackbar
  static void showSnackBar({
    required BuildContext context,
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    Color backgroundColor;
    IconData icon;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Set the appropriate color and icon based on the type
    switch (type) {
      case SnackBarType.success:
        backgroundColor = Colors.green.shade600;
        icon = Icons.check_circle;
        break;
      case SnackBarType.error:
        backgroundColor = isDark ? Colors.red.shade400 : Colors.red.shade700;
        icon = Icons.error;
        break;
      case SnackBarType.warning:
        backgroundColor =
            isDark ? Colors.amber.shade600 : Colors.amber.shade800;
        icon = Icons.warning;
        break;
      case SnackBarType.info:
        backgroundColor = isDark ? Colors.blue.shade400 : Colors.blue.shade700;
        icon = Icons.info;
        break;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        duration: duration,
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action:
            onAction != null && actionLabel != null
                ? SnackBarAction(
                  label: actionLabel,
                  textColor: Colors.white,
                  onPressed: onAction,
                )
                : null,
      ),
    );
  }

  /// Custom app bar with back button
  static AppBar appBarWithBack({
    required BuildContext context,
    required String title,
    List<Widget>? actions,
    bool centerTitle = true,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: isDark ? AppColors.primaryBlack : AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: isDark ? AppColors.white : AppColors.primaryBlack,
      foregroundColor: isDark ? AppColors.primaryBlack : AppColors.white,
      centerTitle: centerTitle,
      actions: actions,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: isDark ? AppColors.primaryBlack : AppColors.white,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  /// Standard form section header
  static Widget formSectionHeader(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        title,
        style:
            isDark
                ? AppTextStyles.darkSubheadingStyle
                : AppTextStyles.lightSubheadingStyle,
      ),
    );
  }

  /// Standard card with content
  static Widget card({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    Color? backgroundColor,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(12)),
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            (isDark ? AppColors.darkCardBackground : AppColors.white),
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color:
                isDark ? AppColors.darkShadowColor : AppColors.lightShadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Enum for SnackBar types
enum SnackBarType { info, success, warning, error }



