import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class NewsDetailPage extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String location;

  NewsDetailPage({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 10),
        child: AppBar(
          backgroundColor: Color(0xFF2C75FF),
          elevation: 5,
          title: const Text(
            "News",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16), 
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
             SizedBox(height: 12),
                  Text(
                    'Location: $location',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                  ),
                 
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => _shareNews(context),
                child: Text('Share'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareNews(BuildContext context) async {
    try {
      await Share.share(
        'Check out this news: $title\n\nDescription: $description\n\nImage: $imageUrl',
        subject: 'Share News',
      );
    } catch (e) {
      print('Error sharing news: $e');
    }
  }
}
