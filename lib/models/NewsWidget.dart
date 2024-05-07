import 'package:flutter/material.dart';
import 'package:reportaroad/models/NewsDetailPage.dart';


class NewsWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  NewsWidget({
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to a new page with the detailed contents of the news item
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailPage(
              imageUrl: imageUrl,
              title: title,
              description: description,
            ),
          ),
        );
      },
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          // SizedBox(height: 5),
          // Text(
          //   description,
          //   style: TextStyle(fontSize: 16),
          //   maxLines: 3,
          //   overflow: TextOverflow.ellipsis,
          // ),
        ],
      ),
    ),
    );
  }
}
