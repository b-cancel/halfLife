import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';

//grab gif duration http://gifduration.konstochvanligasaker.se/
//grab gif frame count https://ezgif.com/

class PlayGifOnce extends StatefulWidget {
  PlayGifOnce({
    @required this.assetName,
    //both of the values must be extracted manually
    @required this.frameCount,
    @required this.runTimeMS,
    //optional
    this.colorWhite: true,
  });

  final String assetName;
  final int frameCount;
  final int runTimeMS;
  final bool colorWhite;

  @override
  _PlayGifOnceState createState() => _PlayGifOnceState();
}

class _PlayGifOnceState extends State<PlayGifOnce> with SingleTickerProviderStateMixin{
  GifController controller;

  @override
  void initState() { 
    super.initState();
    controller = GifController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_){
      Duration runTime = Duration(milliseconds: widget.runTimeMS);
      controller.animateTo(
        //32 frame but the index starts at 0 so -1
        widget.frameCount.toDouble() - 1,
        duration: runTime,
      );
    });
  }

  @override
  void dispose() { 
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.colorWhite){
      return GifImage(
        color: Colors.white,
        controller: controller,
        image: AssetImage(widget.assetName),
      );
    }
    else{
      return GifImage(
        controller: controller,
        image: AssetImage(widget.assetName),
      );
    }
  }
}