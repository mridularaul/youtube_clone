import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  final String? username;
  late String? imageUrl;

  ProfilePage({this.username, this.imageUrl});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Avatar(
                imageUrl: widget.imageUrl,
                onUpload: (imageUrl) async {
                  setState(() {
                    widget.imageUrl = imageUrl;
                  });
                  await _updateProfile(imageUrl);
                },
              ),
              const SizedBox(height: 12),
              Text(widget.username ?? '',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateProfile(String imageUrl) async {
    final userId = Supabase.instance.client.auth.currentUser!.id;
    final response = await Supabase.instance.client
        .from('profiles')
        .update({'image_url': imageUrl})
        .eq('id', userId);
    setState(() {
      widget.imageUrl = imageUrl;
    });

    if (response.error != null) {
      // Handle error
      debugPrint(response.error!.message);
    }
  }
}

class Avatar extends StatelessWidget {
  final String? imageUrl;
  final void Function(String imageUrl) onUpload;

  const Avatar({
    required this.imageUrl,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: imageUrl != null
                ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
            )
                : Container(
              color: Colors.grey,
              child: const Center(
                child: Text('No Image'),
              ),
            ),
          ),
          // const SizedBox(height: 12),
          IconButton(
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image =
                await picker.pickImage(source: ImageSource.gallery);
                if (image == null) {
                  return;
                }
                final imageExtension =
                image.path.split('.').last.toLowerCase();
                final imageBytes = await image.readAsBytes();
                final userId =
                    Supabase.instance.client.auth.currentUser!.id;
                final imagePath =
                    '$userId/profile.${imageExtension}';
                await Supabase.instance.client.storage
                    .from('profiles')
                    .uploadBinary(
                  imagePath,
                  imageBytes,
                  fileOptions: FileOptions(
                    upsert: true,
                    contentType: 'image/$imageExtension',
                  ),
                );
                String imageUrl =
                Supabase.instance.client.storage
                    .from('profiles')
                    .getPublicUrl(imagePath);
                onUpload(imageUrl);
              },
              icon: Icon(Icons.add_a_photo_outlined)
          ),

        ],
      ),
    );
  }
}
