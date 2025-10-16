import 'package:blog_app/core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class SvgViewer {
  const SvgViewer._();
  static Widget fromAsset({
    required String path,
    ColorFilter? colorFilter,
    String? semanticsLabel,

    /// if [size] is given then height and width are equal
    double? size,

    /// if [height] and [width] is given then [size] is ignored
    double? height,

    /// if [height] and [width] is given then [size] is ignored
    double? width,
  }) {
    return height != null && width != null
        ? SvgPicture.asset(
            path,
            colorFilter: colorFilter,
            semanticsLabel: semanticsLabel,
            height: height,
            width: width,
          )
        : SizedBox.square(
            dimension: size ?? 30.r,
            child: SvgPicture.asset(
              path,
              colorFilter: colorFilter,
              semanticsLabel: semanticsLabel,
            ),
          );
  }

  static SizedBox fromNetwork({
    required String path,
    ColorFilter? colorFilter,
    String? semanticsLabel,
    double? size,
  }) {
    return SizedBox.square(
      dimension: size ?? 30.r,
      child: SvgPicture.network(
        path,
        colorFilter: colorFilter,
        semanticsLabel: semanticsLabel,
        placeholderBuilder: (BuildContext context) => Container(
          padding: EdgeInsets.all(30.0.r),
          child: const CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}
