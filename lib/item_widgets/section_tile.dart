import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SectionTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final List<Widget> items;
  final bool wrapped;
  const SectionTile({super.key, required this.icon, required this.text, required this.items, this.wrapped = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        leading: FaIcon(icon),
        title: Text(text, style: Theme.of(context).textTheme.titleLarge),
        iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
        initiallyExpanded: true,
        children: wrapped ?
        [Wrap(alignment: WrapAlignment.center, children: items)] :
        items,
      ),
    );
  }
}