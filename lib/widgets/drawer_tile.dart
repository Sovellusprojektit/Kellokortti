import 'package:flutter/material.dart';

class ThemedListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const ThemedListTile({super.key, required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).iconTheme.color),
      title: Text(text, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
      onTap: onTap,
    );
  }
}