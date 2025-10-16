import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/core.dart';
import 'package:flutter/material.dart';

class ErrorScreenWidget extends StatelessWidget {
  final Widget? imageWidget;
  final String? svgImagePath;

  final String? errorTitle;
  final TextStyle? errorTextStyle;
  final String? errorDescription;
  final TextStyle? errorDescriptionTextStyle;
  final bool showButton;
  final Widget? iconWidget;
  final bool showAnotherButton;
  final Widget? anotherButton;
  final String? buttonText;
  final VoidCallback? onButtonTap;
  final Widget? buttonInsideWidget;
  const ErrorScreenWidget({
    super.key,
    this.imageWidget,
    this.svgImagePath,
    this.errorTitle,
    this.errorDescription,
    this.showButton = true,
    this.showAnotherButton = false,
    this.anotherButton,
    this.buttonText,
    this.onButtonTap,
    this.buttonInsideWidget,
    this.errorTextStyle,
    this.errorDescriptionTextStyle,

    this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // imageWidget ?? Image.asset(AssetRoutes.errorImage),
          imageWidget ??
              SvgViewer.fromAsset(
                path: svgImagePath ?? "AssetRoutes.errorFolderImage",
                size: 160.r,
              ),
          AppGaps.gapH8,
          Text(
            errorTitle ?? "Oops! Something went wrong",
            style:
                errorTextStyle ??
                context.textTheme.titleLarge?.copyWith(
                  color: context.customTheme.contentPrimary,
                  fontFamily: AppConstants.englishFont,
                ),
            textAlign: TextAlign.center,
          ),

          if (errorDescription != null) ...[
            AppGaps.gapH4,
            Text(
              errorDescription ??
                  "The page you're looking for doesn't exist or may have been moved.",
              style:
                  errorDescriptionTextStyle ??
                  context.textTheme.bodySmall?.copyWith(
                    color: context.customTheme.contentPrimary,
                    fontWeight: AppFontWeight.regular,
                    fontFamily: AppConstants.englishFont,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
          if (showButton) ...[
            AppGaps.gapH8,
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                  borderRadius: AppBorderRadius.mediumBorderRadius,
                ),
                backgroundColor: context.customTheme.contentPrimary,
                foregroundColor: context.customTheme.background,
              ),
              onPressed: onButtonTap,
              icon: iconWidget,
              label:
                  buttonInsideWidget ??
                  Text(
                    buttonText ?? "Refresh",
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.customTheme.background,
                      fontWeight: AppFontWeight.semiBold,
                      fontFamily: AppConstants.englishFont,
                    ),
                  ),
            ),
          ],
          if (showAnotherButton) ...[anotherButton ?? SizedBox.shrink()],
        ],
      ),
    );
  }
}
