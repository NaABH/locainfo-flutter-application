import 'package:flutter/material.dart';
import 'package:locainfo/components/my_back_button.dart';
import 'package:locainfo/components/mytag.dart';
import 'package:locainfo/constants/app_colors.dart';

class PostDetailPage extends StatelessWidget {
  const PostDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    var imageUrl =
        'https://images.unsplash.com/photo-1575936123452-b67c3203c357?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: MyBackButton(
            onPressed: () {},
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: ListView(padding: EdgeInsets.zero, children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  image: NetworkImage(imageUrl), fit: BoxFit.cover),
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: MyTag(
                        backgroundColor: Colors.grey.withAlpha(150),
                        children: const [
                          Text(
                            'Category',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'The Rise of Sustainable Living',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 26),
                ),
                const Text(
                  'Posted by Name, 5 hours ago',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 12),
                ),
                const Text(
                  'At Place Name',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 12),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'In a world increasingly conscious of its environmental impact, sustainable living practices have gained significant traction. From eco-friendly homes to zero-waste lifestyles, individuals are embracing choices that minimize their carbon footprint. This shift extends beyond personal habits to influence industries and policies. As we navigate the challenges of climate change, the rise of sustainable living emerges as a beacon of hope, inspiring a collective commitment to a greener, healthier planet.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {},
                  child: MyTag(
                    backgroundColor: AppColors.grey3,
                    children: const [
                      Icon(
                        Icons.directions,
                        size: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text('Bring me there'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ]),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10.0),
          height: 50,
          color: Colors.grey[200],
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.thumb_up),
              Icon(Icons.thumb_down),
              Icon(Icons.report),
              Icon(Icons.share),
              Icon(Icons.bookmark),
            ],
          ),
        ),
      ),
    );
  }
}
