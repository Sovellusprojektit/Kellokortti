import 'package:flutter/material.dart';

 class ThemedSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  

  const ThemedSwitch({super.key, required this.value, required this.onChanged, });

  @override
  Widget build(BuildContext context) {
    return Switch(
      trackColor: MaterialStateProperty.all<Color>(Theme.of(context).switchTheme.trackColor!.resolve({MaterialState.selected}) ?? Colors.blue),
      thumbColor: MaterialStateProperty.all<Color>(Theme.of(context).switchTheme.thumbColor!.resolve({MaterialState.selected}) ?? Colors.white),
      value: value,
      onChanged: onChanged,
    );
  }
}

