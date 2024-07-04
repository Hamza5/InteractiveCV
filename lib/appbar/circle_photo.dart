import 'package:flutter/material.dart';

class CirclePhoto extends StatelessWidget {
  final ImageProvider photo;

  const CirclePhoto({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Theme.of(context).colorScheme.primaryContainer,
            boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5), blurRadius: 5)]
        ),
        child: CircleAvatar(foregroundImage: photo, radius: 48),
      ),
    );
  }
}