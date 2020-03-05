import 'package:flutter/material.dart';
import 'package:half_life/shared/rotatingIcon.dart';

class DoseAddButtons extends StatefulWidget {
  DoseAddButtons({
    @required this.addingDose,
  });

  final ValueNotifier<bool> addingDose;

  @override
  _DoseAddButtonsState createState() => _DoseAddButtonsState();
}

class _DoseAddButtonsState extends State<DoseAddButtons> 
  with SingleTickerProviderStateMixin {
  updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    widget.addingDose.addListener(updateState);
  }

  @override
  void dispose() {
    widget.addingDose.removeListener(updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 8.0,
      ),
      child: IconButton(
        onPressed: (){
          widget.addingDose.value = !widget.addingDose.value;
        },
        icon: RotatingIcon(
          color: Colors.black, 
          duration: Duration(milliseconds: 300), 
          isOpen: widget.addingDose,
          start: Icons.add,
          end: Icons.close,
        ),
      ),
    );
  }
}