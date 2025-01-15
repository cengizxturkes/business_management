import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomSnackbar extends SnackBar {
  CustomSnackbar({
    super.key,
    required String message,
    bool isError = false,
    bool isSuccess = false,
    Duration duration = const Duration(milliseconds: 2500),
  }) : super(
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isError
                          ? AppColors.error.withOpacity(0.1)
                          : isSuccess
                              ? AppColors.success.withOpacity(0.1)
                              : AppColors.warning.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isError
                          ? Icons.error_outline
                          : isSuccess
                              ? Icons.check_circle_outline
                              : Icons.info_outline,
                      color: isError
                          ? AppColors.error
                          : isSuccess
                              ? AppColors.success
                              : AppColors.warning,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(20 * (1 - value), 0),
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: isError
              ? AppColors.error
              : isSuccess
                  ? AppColors.success
                  : AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: duration,
          dismissDirection: DismissDirection.horizontal,
          margin: const EdgeInsets.all(16),
          elevation: 0,
          animation: CurvedAnimation(
            parent: const AlwaysStoppedAnimation(1),
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          ),
        );

  static void show({
    required BuildContext context,
    required String message,
    bool isError = false,
    bool isSuccess = false,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackbar(
        message: message,
        isError: isError,
        isSuccess: isSuccess,
        duration: duration ?? const Duration(milliseconds: 2500),
      ),
    );
  }
}
