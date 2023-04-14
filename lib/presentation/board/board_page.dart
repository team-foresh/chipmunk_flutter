import 'package:chipmunk_flutter/core/widgets/chipmunk_scaffold.dart';
import 'package:chipmunk_flutter/data/service/board_service.dart';
import 'package:chipmunk_flutter/init.dart';
import 'package:flutter/material.dart';

class Post {
  final String image;
  final String title;
  final String description;

  Post({required this.image, required this.title, required this.description});
}

class BoardPage extends StatelessWidget {
  final List<Post> posts = [
    Post(
        image:
            'https://zijhkonihriwfrffefwm.supabase.co/storage/v1/object/public/board/image/2023412_16951_melow2@naver.com.txt.png',
        title: 'Post 1',
        description: 'This is the description of post 1'),
    Post(image: 'https://picsum.photos/200', title: 'Post 2', description: 'This is the description of post 2'),
    Post(image: 'https://picsum.photos/200', title: 'Post 3', description: 'This is the description of post 3'),
    Post(image: 'https://picsum.photos/200', title: 'Post 4', description: 'This is the description of post 4'),
  ];

  BoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChipmunkScaffold(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          children: posts.map<Widget>(_buildCard).toList(),
        ),
      ),
    );
  }

  Widget _buildCard(Post post) {
    return GestureDetector(
      onTap: () {
        BoardService repository = serviceLocator<BoardService>();
        // repository.getMyBoards();
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  post.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    post.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
