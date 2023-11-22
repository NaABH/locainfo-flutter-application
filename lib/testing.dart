import 'package:flutter/material.dart';

class Testing extends StatelessWidget {
  const Testing({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Wrap(children: [
          Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(12))),
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 8),
                      Text(
                        'Name',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Title',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. This is the content. ',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                    textAlign: TextAlign.justify,
                    maxLines: 4,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.thumb_up_off_alt_outlined),
                          SizedBox(width: 8),
                          Text('123',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          SizedBox(width: 8),
                          Icon(Icons.thumb_down_alt_outlined),
                          SizedBox(width: 8),
                          Text('2',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.share),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Icon(Icons.bookmark_add_outlined),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
