import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class BasicInfoItem extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? description;
  final Uri? url;
  final bool shrink;
  const BasicInfoItem({super.key, this.icon, required this.title, this.description, this.url, this.shrink = false});

  @override
  Widget build(BuildContext context) {
    final listTile = ListTile(
      leading: icon != null ? FaIcon(icon) : null,
      title: Text(title),
      subtitle: description != null ? Text(description!) : null,
    );
    return Card(
      child: InkWell(
        onTap: url != null ? () => launchUrl(url!) : null,
        child: Padding(padding: const EdgeInsets.all(5), child: shrink ? IntrinsicWidth(child: listTile) : listTile),
      ),
    );
  }
}