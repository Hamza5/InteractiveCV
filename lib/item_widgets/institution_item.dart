import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InstitutionItem extends StatelessWidget {
  final ImageProvider logo;
  final String title;
  final List<Widget> items;
  final Uri? url;
  const InstitutionItem({super.key, required this.logo, required this.title, required this.items, this.url});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Padding(
          padding: const EdgeInsets.all(5),
          child: Center(
            child: IconButton(
              icon: ImageIcon(logo),
              iconSize: 128,
              onPressed: url != null ? () => launchUrl(url!) : null,
            ),
          ),
        ),
        subtitle: Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
        initiallyExpanded: true,
        children: items,
      ),
    );
  }
}