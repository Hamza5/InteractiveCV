import 'package:flutter/material.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';

import 'image_loading_builder.dart';

class CertificationList extends StatelessWidget {
  final List<ImageProvider> certifications;
  final double? height;
  final double? width;
  const CertificationList({super.key, required this.certifications, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 5,
        runSpacing: 5,
        children: [
          for (var (index, image) in certifications.indexed) SizedBox(
              height: height,
              width: width,
              child: OutlinedButton(
                style: ButtonStyle(
                  padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 15, horizontal: 5)),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                ),
                onPressed: () async {
                  final imageProvider = MultiImageProvider(certifications, initialIndex: index);
                  await showImageViewerPager(
                    context, imageProvider, swipeDismissible: true, doubleTapZoomable: true,
                    backgroundColor: Theme.of(context).colorScheme.background.withOpacity(0.75),
                    closeButtonColor: Theme.of(context).colorScheme.onBackground,
                  );
                },
                child: Image(image: image, loadingBuilder: imageLoadingBuilder),
              )
          )
        ],
      ),
    );
  }
}
