//dart
import 'package:vector_math/vector_math_64.dart' as vect;

//flutter
import 'package:flutter/material.dart';

//widget
class ScrollToTopButton extends StatefulWidget {
  const ScrollToTopButton({
    Key key,
    @required this.color,
    @required this.onTop,
    @required this.scrollController,
  }) : super(key: key);

  final Color color;
  final ValueNotifier<bool> onTop;
  final ScrollController scrollController;

  @override
  _ScrollToTopButtonState createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<ScrollToTopButton> {
  updateState(){
    if(mounted) setState((){});
  }

  @override
  void initState() {
    widget.onTop.addListener(updateState);
    super.initState();
  }

  @override
  void dispose() {
    widget.onTop.removeListener(updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(bottom: 16),
        child:  AnimatedContainer(
          duration: Duration(milliseconds: 200),
          transform: Matrix4.translation(
            vect.Vector3(
              0, 
              (widget.onTop.value) ? (16.0 + 56) : 0.0, 
              0,
            ),
          ),
          child: FloatingActionButton(
            heroTag: 'toTop',
            backgroundColor: widget.color,
            onPressed: (){
              widget.scrollController.jumpTo(0);
            },
            //slightly shift the combo of the two icons
            child: FittedBox(
              fit: BoxFit.contain,
              child: Transform.translate(
                offset: Offset(0,-12), //-4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: 12,
                      child: Icon(
                        Icons.minimize,
                        color: ThemeData.dark().scaffoldBackgroundColor,
                      ),
                    ),
                    Container(
                      height: 12,
                      child: Icon(
                        Icons.keyboard_arrow_up,
                        color: ThemeData.dark().scaffoldBackgroundColor,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}