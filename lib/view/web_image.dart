import 'package:flutter/material.dart';

class WebImage extends StatelessWidget {
  final String url;
  final double? height;
  const WebImage({required this.url, this.height, super.key});
  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      height: height ?? 50.0,
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Icon(
          Icons.error,
          size: height,
        );
      },
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          );
        }
      },
    );
  }
}