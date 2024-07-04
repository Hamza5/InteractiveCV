import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'image_loading_builder.dart';


class KnowledgeItem extends StatelessWidget {
  final ImageProvider? image;
  final String name;
  final String description;
  final double progress;
  final bool dropImageShadow;
  final bool rectangularImage;
  final Uri? url;
  const KnowledgeItem({
    super.key, this.image, required this.name, required this.description, required this.progress,
    this.dropImageShadow = false, this.rectangularImage = false, this.url
  });

  int get _totalSteps => 10;
  int get _currentStep => (progress * _totalSteps).round();
  Color get _progressColor {
    switch (_currentStep) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.deepOrange;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.orangeAccent;
      case 5:
        return Colors.yellow;
      case 6:
        return Colors.lime;
      case 7:
        return Colors.lightGreen;
      case 8:
        return Colors.green;
      case 9:
        return Colors.green.shade700;
      case 10:
        return Colors.green.shade900;
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: url != null ? () => launchUrl(url!) : null,
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (image != null) ...[
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: dropImageShadow ?
                        [BoxShadow(color: Theme.of(context).colorScheme.shadow, blurRadius: 1)] : null,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image(
                        image: image!, fit: BoxFit.fill, width: rectangularImage ? 65 : 50, height: 50,
                        loadingBuilder: imageLoadingBuilder,
                      ),
                    ),
                    const SizedBox(width: 5)
                  ],
                  SizedBox(
                    width: 120,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 35,
                          child: Text(name, style: Theme.of(context).textTheme.titleLarge),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 40,
                          child: Text(description, textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 190,
                child: StepProgressIndicator(
                  progressDirection: Directionality.of(context),
                  totalSteps: _totalSteps,
                  size: 10,
                  roundedEdges: const Radius.circular(5),
                  customColor: (i) {
                    if (Directionality.of(context) == TextDirection.rtl) {
                      i = _totalSteps - i - 1;
                    }
                    return i < _currentStep ? _progressColor : Theme.of(context).colorScheme.surfaceVariant;
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}