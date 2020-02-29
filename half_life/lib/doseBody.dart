//flutter
import 'package:flutter/material.dart';
import 'package:half_life/main.dart';

//internal
import 'package:half_life/shared/scrollToTop.dart';
import 'package:half_life/struct/doses.dart';
import 'package:half_life/doseRefresh.dart';

//body
class DosesBody extends StatefulWidget {
  DosesBody({
    @required this.doses,
    @required this.halfLife,
  });

  final List<Dose> doses;
  final Duration halfLife;

  @override
  _DosesBodyState createState() => _DosesBodyState();
}

class _DosesBodyState extends State<DosesBody> {
  //scroll to top function
  final ScrollController scrollController = new ScrollController();
  final ValueNotifier<bool> onTop = new ValueNotifier(true);

  //If we scroll down have the scroll up button come up
  updateOnTopValue() {
    ScrollPosition position = scrollController.position;
    double currentOffset = scrollController.offset;

    //Determine whether we are on the top of the scroll area
    if (currentOffset <= position.minScrollExtent) {
      onTop.value = true;
    } else
      onTop.value = false;
  }

  //init
  @override
  void initState() {
    //super init
    super.initState();

    //show or hide the to top button
    scrollController.addListener(updateOnTopValue);
  }

  //dipose
  @override
  void dispose() {
    //remove listener
    scrollController.removeListener(updateOnTopValue);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          DosesRefresh(
            softHeaderColor: MyApp.softHeaderColor,
            scrollController: scrollController,
            halfLife: widget.halfLife,
            doses: widget.doses,
          ),
          ScrollToTopButton(
            onTop: onTop,
            color: MyApp.softHeaderColor,
            scrollController: scrollController,
          ),
        ],
      ),
    );
  }
}
