//dart
import 'dart:math' as math;

//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:animator/animator.dart';
import 'package:half_life/shared/conditional.dart';

//internal
class RotatingIcon extends StatefulWidget {
  RotatingIcon({
    @required this.color,
    @required this.duration,
    @required this.isOpen,
    this.start: Icons.keyboard_arrow_down,
    this.end,
  });

  //passed params
  final Color color;
  final Duration duration;
  final ValueNotifier<bool> isOpen;
  final IconData start;
  final IconData end;

  @override
  _RotatingIconState createState() => _RotatingIconState();
}

class _RotatingIconState extends State<RotatingIcon> {
  final ValueNotifier<double> tweenBeginning = new ValueNotifier<double>(-1);
  final ValueNotifier<double> fractionOfDuration = new ValueNotifier<double>(1);
  final double normalRotation = 0;
  final double otherRotation = (-math.pi / 4) * 4;

  updateState(){
    if(mounted){
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    widget.isOpen.addListener(updateState);
  }
  
  @override
  void dispose() { 
    widget.isOpen.removeListener(updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Animator<double>(
      resetAnimationOnRebuild: true,
      tween: widget.isOpen.value
        ? Tween<double>(
            begin: tweenBeginning.value == -1 ? normalRotation : tweenBeginning.value, 
            end: otherRotation,
        )
        : Tween<double>(
            begin: tweenBeginning.value == -1 ? otherRotation : tweenBeginning.value, 
            end: normalRotation,
        ),
      duration: Duration(
        milliseconds: ((widget.duration.inMilliseconds * fractionOfDuration.value).toInt()),
      ),
      customListener: (animator) {
        tweenBeginning.value = animator.animation.value;
        fractionOfDuration.value = animator.controller.value;
      },
      builder: (anim) => Transform.rotate(
        angle: anim.value,
        child: Conditional(
          condition: widget.end == null, 
          ifTrue: Icon(
            widget.start,
            color: widget.color,
          ), 
          ifFalse: Icon(
            anim.value == 0 ?  widget.start : widget.end,
            color: widget.color,
          ),
        ),
      ),
    );
  }
}