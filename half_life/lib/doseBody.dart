//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:scroll_to_index/scroll_to_index.dart';

//internal
import 'package:half_life/shared/scrollToTop.dart';
import 'package:half_life/struct/doses.dart';
import 'package:half_life/doseRefresh.dart';

//body
class DosesBody extends StatefulWidget {
  DosesBody({
    @required this.doses,
  });

  final List<Dose> doses;

  @override
  _DosesBodyState createState() => _DosesBodyState();
}

class _DosesBodyState extends State<DosesBody> {
  //scroll to top function
  final AutoScrollController scrollController = new AutoScrollController();
  final ValueNotifier<bool> onTop = new ValueNotifier(true);
  final ValueNotifier<double> overScroll = new ValueNotifier<double>(0);

  //If we scroll down have the scroll up button come up
  updateOnTopValue() {
    ScrollPosition position = scrollController.position;
    //double currentOffset = scrollController.offset;

    //update overscroll to cover pill bottle if possible
    double curr = position.pixels;
    double max = position.maxScrollExtent;
    overScroll.value = (curr < max) ? 0 : curr - max;

    //Determine whether we are on the top of the scroll area
    if (curr <= position.minScrollExtent) {
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
            autoScrollController: scrollController,
            doses: widget.doses,
          ),
          ScrollToTopButton(
            onTop: onTop,
            overScroll: overScroll,
            scrollController: scrollController,
          ),
        ],
      ),
    );
  }
}
