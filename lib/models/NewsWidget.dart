import 'package:flutter/material.dart';
import 'package:reportaroad/models/NewsDetailPage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NewsWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String location;
  final String newsId;
    final Function(String) onDelete;

  NewsWidget({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.location,
    required this.onDelete,
    required this.newsId,
  });

   @override
  Widget build(BuildContext context) {
    return Slidable(
        key: Key(newsId),
     endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onDelete(newsId),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetailPage(
                imageUrl: imageUrl,
                title: title,
                location: location,
                description: description,
              ),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(vertical: 8),
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
                  height: 150,
                ),
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
              SizedBox(height: 8),
              Text(
                location,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}