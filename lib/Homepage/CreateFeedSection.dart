import 'package:flutter/material.dart';

class PostFeed extends StatelessWidget {
  const PostFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(5, (index) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),
                title: Text('User $index'),
                subtitle: Text('2 hrs ago'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("This is a sample post $index"),
              ),
              Image.asset('assets/post${index + 1}.jpg', fit: BoxFit.cover),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.thumb_up_alt_outlined),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.comment_outlined),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.share_outlined),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
