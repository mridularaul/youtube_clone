import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/video.dart';
import '../screens/profile.dart';


class homePage extends StatefulWidget {
  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  String? username;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _getInitialProfile();
  }

  Future<void> _getInitialProfile() async {
    final userId = Supabase.instance.client.auth.currentUser!.id;
    final data = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();
    setState(() {
      username = data['username'];
      _imageUrl = data['image_url'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final videoStream = supabase.from('video').stream(primaryKey: ['id']);

    return Scaffold(
      appBar: AppBar(
        title: Text("YouTube"),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundImage: NetworkImage(_imageUrl ?? ''),
              radius: 15,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage(username: username, imageUrl: _imageUrl)),
              );
            },
          ),
        ],
      ),
      backgroundColor: Color(0xffF0F0F0),

      body: StreamBuilder(
        stream: videoStream,
        builder: (context, snapshot) {
          print('Snapshot Data: ${snapshot.data}');
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final videos = snapshot.data!;

          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return videoTile(context, video);
            },
          );
        },
      ),
    );
  }

  Widget videoTile(BuildContext context, video) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: GestureDetector(
          onTap: () {
            print(video);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoPlayerPage(
                  videoUrl: video['url'],
                  title: video['title'],
                  description: video['description'],
                  likes: video['likes'],
                  dislikes: video['dislikes'],
                  views: video['views'],
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(video['thumbnail_url'], height: 200, fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(video['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    Text("${video['views']} views"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
                child: Text(video['description']),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
