import 'package:flutter/material.dart';

class Conditional extends StatelessWidget {
  Conditional({
    @required this.condition,
    @required this.ifTrue,
    @required this.ifFalse,
  });

  final bool condition;
  final Widget ifTrue;
  final Widget ifFalse;

  @override
  Widget build(BuildContext context) {
    if(condition) return ifTrue;
    else return ifFalse;
  }
}