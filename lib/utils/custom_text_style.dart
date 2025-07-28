import 'package:flutter/material.dart';
import 'package:login_portal/utils/size_utils.dart';
import 'package:login_portal/utils/theme_helper.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Body text style
  static get bodyLargeBluegray300 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.blueGray300,
      );
  static get bodyLargeBluegray90001 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.blueGray90001,
      );
  static get bodyLargeGray600 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.gray600,
      );
  static get bodyLargeGray600_1 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.gray600,
      );
  static get bodyLargeGray700 => theme.textTheme.bodyLarge!.copyWith(
    color:appTheme.gray700,
    fontSize: 16.fSize,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w400,
    // height: 0.09,
      );
  static get bodyLargeWhiteA700 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.whiteA700,
      );
  static get bodyMediumBlack900 => theme.textTheme.bodyMedium!.copyWith(
        // color: appTheme.black900,

    color: Colors.black,
    fontSize: 14.fSize,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w400,
    // height: 0.12,
      );
  static get bodyMediumNunitoSans => theme.textTheme.bodyMedium!.nunitoSans;
  static get bodyMediumNunitoSansBlack900 =>
      theme.textTheme.bodyMedium!.nunitoSans.copyWith(
        color: appTheme.black900,
      );
  static get bodySmallBlack900 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.black900,
      );
  // Label text style
  static get labelLargeAmber700 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.amber700,
      );
  static get labelLargeBlack900 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeRed70001 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.red70001,
      );
  static get labelSmallGray800 => theme.textTheme.labelSmall!.copyWith(
        color: appTheme.gray800,
      );
  // Title text style
  static get titleLarge22 => theme.textTheme.titleLarge!.copyWith(
        fontSize: 22.fSize,
    color: Colors.black,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w700,
    // height: 0.07,
      );
  static get titleLargeBluegray90001 => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.blueGray90001,
      );
  static get titleMediumMedium => theme.textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w500,
      );
  static get titleMediumNunitoSans => theme.textTheme.titleMedium!.nunitoSans;
  static get titleMediumNunitoSansPrimary =>
      theme.textTheme.titleMedium!.nunitoSans.copyWith(
        color: theme.colorScheme.primary,
      );
  static get titleMediumOpenSans =>
      theme.textTheme.titleMedium!.openSans.copyWith(
        fontSize: 18.fSize,
        fontWeight: FontWeight.w600,
      );
  static get titleMediumPrimary => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.primary,
      );
  static get titleMediumWhiteA700 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.whiteA700,
        fontSize: 18.fSize,
      );
  static get titleSmallBluegray300 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.blueGray300,
      );
  static get titleSmallGray700 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.gray700,
      );
  static get titleSmallPrimary => theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.primary,
      );
  static get titleSmallRed70001 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.red70001,
        fontSize: 15.fSize,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallRed70001_1 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.red70001,
      );
  static get titleSmallWhiteA700 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.whiteA700,
        fontSize: 15.fSize,
      );
}

extension on TextStyle {
  TextStyle get nunitoSans {
    return copyWith(
      fontFamily: 'Nunito Sans',
    );
  }

  TextStyle get openSans {
    return copyWith(
      fontFamily: 'Open Sans',
    );
  }

}
