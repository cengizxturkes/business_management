import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final String label;
  final String? Function(T?)? validator;
  final void Function(T?)? onChanged;
  final bool isLoading;
  final Widget? prefix;
  final Widget? suffix;
  final double? width;
  final EdgeInsetsGeometry? contentPadding;
  final BorderRadius? borderRadius;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final TextStyle? labelStyle;
  final TextStyle? itemStyle;
  final double? itemHeight;
  final bool isDense;
  final bool isExpanded;

  const CustomDropdown({
    super.key,
    this.value,
    required this.items,
    required this.label,
    this.validator,
    this.onChanged,
    this.isLoading = false,
    this.prefix,
    this.suffix,
    this.width,
    this.contentPadding,
    this.borderRadius,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.labelStyle,
    this.itemStyle,
    this.itemHeight,
    this.isDense = false,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<T>(
        value: value,
        items: isLoading ? [] : items,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: labelStyle ??
              TextStyle(
                color: AppColors.dark50,
                fontSize: 14,
              ),
          border: OutlineInputBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(16),
            borderSide: BorderSide(
              color: borderColor ?? AppColors.dark25,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(16),
            borderSide: BorderSide(
              color: focusedBorderColor ?? AppColors.primary,
            ),
          ),
          filled: true,
          fillColor: fillColor ?? AppColors.white,
          contentPadding: contentPadding ??
              const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
          prefixIcon: prefix,
          suffixIcon: isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                )
              : suffix,
        ),
        onChanged: isLoading ? null : onChanged,
        validator: validator,
        style: itemStyle ??
            TextStyle(
              color: AppColors.dark,
              fontSize: 14,
            ),
        icon: isLoading
            ? const SizedBox.shrink()
            : Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.dark50,
              ),
        isDense: isDense,
        isExpanded: isExpanded,
        itemHeight: itemHeight ?? kMinInteractiveDimension,
        dropdownColor: AppColors.white,
      ),
    );
  }
}
