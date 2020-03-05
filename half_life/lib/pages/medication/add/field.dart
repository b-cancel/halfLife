import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:half_life/struct/doses.dart';

class AddDoseField extends StatefulWidget {
  const AddDoseField({
    Key key,
    @required this.pillSize,
    @required this.addingDose,
    @required this.dosesVN,
  }) : super(key: key);

  final double pillSize;
  final ValueNotifier<bool> addingDose;
  final ValueNotifier<List<Dose>> dosesVN;

  @override
  _AddDoseFieldState createState() => _AddDoseFieldState();
}

class _AddDoseFieldState extends State<AddDoseField> {
  final FocusNode focusNode = new FocusNode();
  final TextEditingController newDoseController = new TextEditingController();
  DateTime newDateTime = DateTime.now();

  updateState() {
    if (mounted) {
      //grab or "reset" date time
      newDateTime = DateTime.now();

      //we don't want to add it or already did
      if(widget.addingDose.value == false){
        //close keyboard
        FocusScope.of(context).unfocus();
        //clear data
        newDoseController.clear();
      }
      else{
        FocusScope.of(context).requestFocus(focusNode);
      }
      
      //show changes
      setState(() {});
    }
  }

  saveDose(){
    //find next ID
    int largestID = 0;
    for(int i = 0; i < widget.dosesVN.value.length; i++){
      int thisID = widget.dosesVN.value[i].id;
      if(thisID > largestID){
        largestID = thisID;
      }
    }

    //create dose
    int newID = largestID + 1;
    String newValue = newDoseController.text;
    newValue = (newValue.length == 0) ? "0" : newValue;
    Dose theNewDose = Dose(
      newID,
      int.parse(newValue).toDouble(),
      DateTime.now(),
    );

    //create new list of doses
    List<Dose> newDoses = widget.dosesVN.value;
    newDoses.add(theNewDose);

    //notify everythign
    widget.dosesVN.value = newDoses;

    //close ourselves
    widget.addingDose.value = false;
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
    return SliverToBoxAdapter(
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: ThemeData.dark().primaryColorDark,
                  ),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(widget.pillSize / 3),
            ),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: widget.addingDose.value ? widget.pillSize : 0,
              color: ThemeData.dark().cardColor,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: (widget.pillSize - (16 * 2)) * (4 / 4),
                            height: widget.pillSize - (16 * 2),
                            decoration: BoxDecoration(
                              //between 500 and 800
                              color: Colors.grey[600],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                bottomLeft: Radius.circular(24),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Container(
                                  height: widget.pillSize - (16 * 2),
                                  color: Theme.of(context).accentColor,
                                ),
                                TextField(
                                  focusNode: focusNode,
                                  controller: newDoseController,
                                  //only difference when scroll to field
                                  scrollPadding: EdgeInsets.only(
                                    bottom: widget.pillSize,
                                  ),
                                  //style of text typed
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: widget.pillSize / 3,
                                  ),
                                  cursorColor:
                                      ThemeData.dark().scaffoldBackgroundColor,
                                  //eliminate bottom line border
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                      left: 14,
                                      bottom: (widget.pillSize / 3) / 2,
                                    ),
                                    suffix: Transform.translate(
                                      offset: Offset(-2, 4),
                                      child: Text(
                                        "u",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  //hide signs or decimals from keyboard if possible
                                  keyboardType: TextInputType.numberWithOptions(
                                    signed: false,
                                    decimal: false,
                                  ),
                                  //balance
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.center,
                                  //super guarantee only digits
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter.digitsOnly,
                                  ],
                                  //only 1 line at all times
                                  expands: false,
                                  minLines: 1,
                                  maxLines: 1,
                                  //on complete
                                  onEditingComplete: () => saveDose(),
                                  onSubmitted: (str) => saveDose(),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: (widget.pillSize - (16 * 2)) * (4 / 4),
                            height: widget.pillSize - (16 * 2),
                            decoration: BoxDecoration(
                              //between 500 and 800
                              color: Colors.grey[600],
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(24),
                                bottomRight: Radius.circular(24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ThemeData.dark().scaffoldBackgroundColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(2),
                        ),
                      ),
                      height: widget.pillSize,
                      width: 4,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
