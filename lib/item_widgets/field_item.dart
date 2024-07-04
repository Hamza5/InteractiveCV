import 'package:flutter/material.dart';

class FieldItem extends StatelessWidget {
  final String title;
  final String trailing;
  final List<Widget> items;
  const FieldItem({super.key, required this.title, required this.trailing, this.items = const []});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: items.isNotEmpty ? ExpansionTile(
          title: Text(title, textAlign: TextAlign.center),
          trailing: Text(trailing),
          children: items,
        ) : ListTile(
          title: Text(title, textAlign: TextAlign.center),
          trailing: Text(trailing),
        )
    );
  }
}
