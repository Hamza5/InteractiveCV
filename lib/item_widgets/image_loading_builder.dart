import 'package:flutter/material.dart';

Widget imageLoadingBuilder(BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
  if (loadingProgress?.cumulativeBytesLoaded == loadingProgress?.expectedTotalBytes) {
    return child;
  } else {
    return Center(
      child: CircularProgressIndicator(
        value: (loadingProgress?.cumulativeBytesLoaded ?? 0) / (loadingProgress?.expectedTotalBytes ?? 1),
      ),
    );
  }
}
