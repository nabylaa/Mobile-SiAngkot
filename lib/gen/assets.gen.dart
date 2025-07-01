/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsPngGen {
  const $AssetsPngGen();

  /// File path: assets/png/android_splash_logo.png
  AssetGenImage get androidSplashLogo =>
      const AssetGenImage('assets/png/android_splash_logo.png');

  /// File path: assets/png/branding.png
  AssetGenImage get branding => const AssetGenImage('assets/png/branding.png');

  /// File path: assets/png/branding_1.png
  AssetGenImage get branding1 =>
      const AssetGenImage('assets/png/branding_1.png');

  /// File path: assets/png/icon.png
  AssetGenImage get icon => const AssetGenImage('assets/png/icon.png');

  /// File path: assets/png/icon_dinas_perhubungan.png
  AssetGenImage get iconDinasPerhubungan =>
      const AssetGenImage('assets/png/icon_dinas_perhubungan.png');

  /// File path: assets/png/splashscreen_logo.png
  AssetGenImage get splashscreenLogo =>
      const AssetGenImage('assets/png/splashscreen_logo.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    androidSplashLogo,
    branding,
    branding1,
    icon,
    iconDinasPerhubungan,
    splashscreenLogo,
  ];
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/add.svg
  SvgGenImage get add => const SvgGenImage('assets/svg/add.svg');

  /// File path: assets/svg/arrow_left.svg
  SvgGenImage get arrowLeft => const SvgGenImage('assets/svg/arrow_left.svg');

  /// File path: assets/svg/arrow_right.svg
  SvgGenImage get arrowRight => const SvgGenImage('assets/svg/arrow_right.svg');

  /// File path: assets/svg/bottom_nav_history.svg
  SvgGenImage get bottomNavHistory =>
      const SvgGenImage('assets/svg/bottom_nav_history.svg');

  /// File path: assets/svg/bottom_nav_home.svg
  SvgGenImage get bottomNavHome =>
      const SvgGenImage('assets/svg/bottom_nav_home.svg');

  /// File path: assets/svg/bottom_nav_scan.svg
  SvgGenImage get bottomNavScan =>
      const SvgGenImage('assets/svg/bottom_nav_scan.svg');

  /// File path: assets/svg/bottom_nav_settings.svg
  SvgGenImage get bottomNavSettings =>
      const SvgGenImage('assets/svg/bottom_nav_settings.svg');

  /// File path: assets/svg/checklist.svg
  SvgGenImage get checklist => const SvgGenImage('assets/svg/checklist.svg');

  /// File path: assets/svg/clock.svg
  SvgGenImage get clock => const SvgGenImage('assets/svg/clock.svg');

  /// File path: assets/svg/cross.svg
  SvgGenImage get cross => const SvgGenImage('assets/svg/cross.svg');

  /// File path: assets/svg/edit.svg
  SvgGenImage get edit => const SvgGenImage('assets/svg/edit.svg');

  /// File path: assets/svg/history.svg
  SvgGenImage get history => const SvgGenImage('assets/svg/history.svg');

  /// File path: assets/svg/password_off.svg
  SvgGenImage get passwordOff =>
      const SvgGenImage('assets/svg/password_off.svg');

  /// File path: assets/svg/password_on.svg
  SvgGenImage get passwordOn => const SvgGenImage('assets/svg/password_on.svg');

  /// File path: assets/svg/settings.svg
  SvgGenImage get settings => const SvgGenImage('assets/svg/settings.svg');

  /// File path: assets/svg/sign_out.svg
  SvgGenImage get signOut => const SvgGenImage('assets/svg/sign_out.svg');

  /// File path: assets/svg/upload.svg
  SvgGenImage get upload => const SvgGenImage('assets/svg/upload.svg');

  /// File path: assets/svg/user_plus.svg
  SvgGenImage get userPlus => const SvgGenImage('assets/svg/user_plus.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
    add,
    arrowLeft,
    arrowRight,
    bottomNavHistory,
    bottomNavHome,
    bottomNavScan,
    bottomNavSettings,
    checklist,
    clock,
    cross,
    edit,
    history,
    passwordOff,
    passwordOn,
    settings,
    signOut,
    upload,
    userPlus,
  ];
}

class MyAssets {
  const MyAssets._();

  static const $AssetsPngGen png = $AssetsPngGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
