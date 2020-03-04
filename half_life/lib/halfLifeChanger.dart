//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';

//internal
import 'package:half_life/shared/halfLifeIcon.dart';

//build
class HalfLifeChanger extends StatefulWidget {
  const HalfLifeChanger({
    @required this.halfLife,
    Key key,
  }) : super(key: key);

  final ValueNotifier<Duration> halfLife;

  @override
  _HalfLifeChangerState createState() => _HalfLifeChangerState();
}

class _HalfLifeChangerState extends State<HalfLifeChanger> {
  updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    widget.halfLife.addListener(updateState);
  }

  @override
  void dispose() {
    widget.halfLife.removeListener(updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      highlightedBorderColor: Theme.of(context).accentColor,
      borderSide: BorderSide(
        color: ThemeData.dark().cardColor,
      ),
      padding: EdgeInsets.all(0),
      child: DefaultTextStyle(
        style: TextStyle(
          color: Theme.of(context).accentColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                left: 12.0,
                right: 8,
              ),
              child: Text("36hrs"),
            ),
            Container(
              color: Theme.of(context).accentColor,
              height: 56.0 - (8 * 2),
              width: 36,
              padding: EdgeInsets.only(
                right: 12,
                left: 8,
              ),
              child: HalfLifeIcon(),
            ),
          ],
        ),
      ),
      onPressed: () {
        showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
              ),
              contentPadding: EdgeInsets.all(0),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  /*
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(12.0),
                                      topRight: const Radius.circular(12.0),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom: 36,
                                      top: 24,
                                    ),
                                    child: Container(
                                      height: 140,
                                      child: PlayGifOnce(
                                        assetName: "assets/delete.gif",
                                        runTimeMS: 6120,
                                        frameCount: 98,
                                      ),
                                    ),
                                  ),
                                ),
                                */
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16.0,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: DefaultTextStyle(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black,
                        ),
                        child: Text("Delete Dose?"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(),

                    /*SingleCircularSlider(

                                  )*/
                  ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: ThemeData.dark().scaffoldBackgroundColor,
                    ),
                  ),
                ),
                RaisedButton(
                  color: Colors.red,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Update",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
