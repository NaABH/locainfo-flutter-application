import 'package:flutter/material.dart';

class MyHomeBottomBar extends StatelessWidget {
  const MyHomeBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 1 / 3,
      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      ),
      child: ListView(
        children: [
          Padding(
              padding: EdgeInsets.only(),
              child: Column(
                children: [
                  Container(
                    color: Colors.black,
                    padding: EdgeInsets.zero,
                  )
                ],
              )),
        ],
      ),
    );
  }
}
