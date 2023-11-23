import 'package:flutter/material.dart';

class MyLikeButton extends StatefulWidget {
  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<MyLikeButton> {
  bool isLiked = false;
  int numberOfLikes = 123; // Initialize this with the actual number of likes

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      numberOfLikes = isLiked ? numberOfLikes + 1 : numberOfLikes - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          GestureDetector(
            onTap: _toggleLike,
            child: Icon(
              isLiked ? Icons.thumb_up : Icons.thumb_up_off_alt_outlined,
              color: isLiked ? Colors.blue : null, size: 20,
            ),
          ),
          const SizedBox(width: 8),
          Text('$numberOfLikes',
              style:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        ],
      ),
    );
  }
}
