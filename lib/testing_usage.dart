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
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(16))),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 8),
                      Text(
                        'AuthorName',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'Location Name, Time',
                    style: TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: Colors.blueGrey),
                    maxLines: 1,
                    softWrap: true,
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(height: 8),
                // Post title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'Post title',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    maxLines: 2,
                    softWrap: true,
                    textAlign: TextAlign.justify,
                  ),
                ),
                // Post content
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'content',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                    textAlign: TextAlign.justify,
                    maxLines: 4,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Likes, dislikes, share, bookmark
                Padding(
                  padding:
                      EdgeInsets.only(left: 12, right: 10, top: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.thumb_up_off_alt_outlined, size: 20),
                          SizedBox(width: 8),
                          Text('123',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14)),
                          SizedBox(width: 8),
                          Icon(Icons.thumb_down_alt_outlined, size: 20),
                          SizedBox(width: 8),
                          Text('2',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14)),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.share,
                            size: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Icon(
                              Icons.bookmark_add_outlined,
                              size: 20,
                            ),
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
