import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController middle = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  final FixedExtentScrollController scrollController =
      FixedExtentScrollController();
  int ind = 5;
  int i = 0;
  bool isEmpty = true;
  Widget _buildMagnifierScreen() {
    return IgnorePointer(
      child: Column(
        children: <Widget>[
          /*  Expanded(
            child: Container(
              color: foreground,
            ),
          ), */
          Container(
            height: 50,
            width: 60,
            decoration: const ShapeDecoration(
              shape: StadiumBorder(
                  side: BorderSide(
                color: Color(0xFFba5905),
              )),
              //  StadiumBorder(
              //   side: BorderSide(
              //     color: widget.customColor,
              //   ),
              // ),
              color: Colors.teal,
            ),
            // constraints: BoxConstraints.expand(height: widget.itemExtent),
          ),
          /* Expanded(
            child: Container(
              color: foreground,
            ),
          ), */
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            height: 375,
            width: double.infinity,
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 30,
                    controller: middle,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Center(
                            child: Text((index + 1).toString(),
                                style: const TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 30),
                        ],
                      );
                    },
                  ),
                ),
                Flexible(
                  child: ListWheelScrollView.useDelegate(
                      itemExtent: 50,
                      diameterRatio: 1.5,
                      magnification: 1.7,
                      useMagnifier: true,
                      controller:
                          FixedExtentScrollController(initialItem: 0),
                      childDelegate: ListWheelChildLoopingListDelegate(
                        children: List.generate(
                          30,
                          (index) => Center(
                            child: Text((index + 1).toString(),
                                style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      onSelectedItemChanged: (int index) {
                        print(i);
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
