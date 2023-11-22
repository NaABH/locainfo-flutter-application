import 'package:flutter/material.dart';

class MyPost extends StatelessWidget {
  final String author;
  final String title;
  final String content;

  const MyPost(
      {Key? key,
      required this.author,
      required this.title,
      required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Container(
        margin: const EdgeInsets.all(3),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Username
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.person),
                  const SizedBox(width: 8),
                  Text(
                    author,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 15),
                  ),
                ],
              ),
            ),
            // Post title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                maxLines: 2,
                softWrap: true,
                textAlign: TextAlign.justify,
              ),
            ),
            // Post content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                content,
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                textAlign: TextAlign.justify,
                maxLines: 4,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Likes, dislikes, share, bookmark
            const Padding(
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
    ]);
  }
}
