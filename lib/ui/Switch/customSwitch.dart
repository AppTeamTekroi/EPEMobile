import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  bool toggleValue;
  String? title1;
  String? title2;
  CustomSwitch( {Key? key, required this.toggleValue}) : super(key: key);

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleButton,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: 24,
        width: 65,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 0.8, color: Colors.blue),
            color: widget.toggleValue ? Colors.blue : Colors.white),
        child: Stack(
          children: [
            Positioned(
              top: 2,
              left: 13,
              child: AnimatedOpacity(
                  opacity: widget.toggleValue ? 1.0 : 0,
                  duration: Duration(milliseconds: 300),
                  child: Text(
                    widget.title1==null?'Yes':widget.title1!,
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  )),
            ),
            Positioned(
              right: 13,
              top: 2,
              child: AnimatedOpacity(
                  opacity: widget.toggleValue ? 0.0 : 1,
                  duration: Duration(milliseconds: 300),
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.blue, fontSize: 13),
                  )),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
              top: 0,
              left: widget.toggleValue ? 42 : 2,
              right: widget.toggleValue ? 2 : 42,
              child: GestureDetector(
                onTap: toggleButton,
                child: widget.toggleValue
                    ? CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 11,
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 11,
                      ),
                // child: AnimatedSwitcher(
                //     duration: Duration(milliseconds: 1000),
                //     transitionBuilder:
                //         (Widget child, Animation<double> animation) {
                //       return RotationTransition(
                //         child: child,
                //         turns: animation,
                //       );
                //     },
                //     child: toggleValue
                //         ? CircleAvatar(
                //             backgroundColor: Colors.white,
                //             radius: 18,
                //           )
                //         : CircleAvatar(
                //             backgroundColor: Colors.blue,
                //             radius: 18,
                //           )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  toggleButton() {
    setState(() {
      widget.toggleValue = !widget.toggleValue;
    });
  }
}
