// // class NewHomePage extends StatefulWidget {
// //   const NewHomePage({super.key});
// //
// //   @override
// //   State<NewHomePage> createState() => _NewHomePageState();
// // }
// //
// // class _NewHomePageState extends State<NewHomePage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return SafeArea(
// //       child: Scaffold(
// //         appBar: PreferredSize(
// //           preferredSize: Size.fromHeight(100),
// //           child: MyHomeAppBar(),
// //         ),
// //         bottomNavigationBar: MyHomeBottomBar(),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class NewHomePage extends StatefulWidget {
//   @override
//   _NewHomePageState createState() => _NewHomePageState();
// }
//
// class _NewHomePageState extends State<NewHomePage> {
//   double mapHeight = 2 / 3;
//   double listHeight = 1 / 3;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           AnimatedContainer(
//             height: MediaQuery.of(context).size.height * mapHeight,
//             duration: Duration(milliseconds: 600),
//             child: Stack(
//               children: <Widget>[
//                 GoogleMap(
//                   initialCameraPosition: CameraPosition(
//                     target: LatLng(0, 0),
//                     zoom: 14.4746,
//                   ),
//                 ),
//                 Positioned(
//                   top: 16,
//                   left: 16,
//                   child: Text('Current Location'),
//                 ),
//                 Positioned(
//                   top: 16,
//                   right: 16,
//                   child: IconButton(
//                     icon: Icon(Icons.search),
//                     onPressed: () {
//                       // Handle search button press
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           NotificationListener<ScrollNotification>(
//             onNotification: (ScrollNotification scrollInfo) {
//               if (scrollInfo.metrics.pixels > 0) {
//                 setState(() {
//                   mapHeight = 0;
//                   listHeight = 1;
//                 });
//               } else {
//                 setState(() {
//                   mapHeight = 2 / 3;
//                   listHeight = 1 / 3;
//                 });
//               }
//               return true;
//             },
//             child: AnimatedContainer(
//               duration: Duration(milliseconds: 500),
//               margin: EdgeInsets.only(
//                   top: MediaQuery.of(context).size.height * mapHeight),
//               height: MediaQuery.of(context).size.height * listHeight,
//               child: ListView.builder(
//                 itemCount: 10,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text('Post ${index + 1}'),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class MyScrollableWidget extends StatefulWidget {
  @override
  _MyScrollableWidgetState createState() => _MyScrollableWidgetState();
}

class _MyScrollableWidgetState extends State<MyScrollableWidget> {
  ScrollController _scrollController = ScrollController();
  bool _endOfPage = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _endOfPage = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('End of page reached! Drag more to navigate.')),
        );
      } else if (_endOfPage &&
          _scrollController.position.pixels <
              _scrollController.position.maxScrollExtent) {
        _endOfPage = false;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SecondPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: 30,
        itemBuilder: (context, index) {
          return ListTile(title: Text('Item ${index + 1}'));
        },
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
      ),
      body: Center(
        child: Text('You have been redirected to the second page!'),
      ),
    );
  }
}
