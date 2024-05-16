import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:reportaroad/main.dart';
import 'package:reportaroad/models/NewsWidget.dart';
import 'package:reportaroad/utils/videoPlayer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class News extends StatefulWidget {
   final String userId;
   final token;
  News({
    Key? key,
    required this.userId,
    required this.token,
  }) : super(key: key);


  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
 List<dynamic> _news = [];
 
  @override
  void initState() {
    super.initState();
    _getnews();
  }

  void shareReport(String news) async {
    try {
      await Share.share(
        news,
        subject: 'Share Report',
      );
    } catch (e) {
      print('Error sharing news: $e');
    }
  }

  void _getnews() async {
    try {
      var response = await http.get(
        Uri.parse('${serverBaseUrl}getNews'),
        headers: {
          "Content-type": "application/json",
          "Cache-Control": "no-cache"
        },
      );

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == true) {
      var newsList = jsonResponse['news'];

      setState(() {
        _news = newsList;
      });
    } else {
      print('Failed to fetch news: ${jsonResponse['error']}');
    }
  } catch (e) {
    print('Error fetching news: $e');
  }
}
  void deleteReport(id) async {
    try {
      print('Deleting news with ID: $id');
      var regBody = {
        "id": id,
      };
      var response = await http.post(
        Uri.parse('${serverBaseUrl}deleteReport'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        setState(() {
          _news.removeWhere((news) => news['_id'] == id);
        });
      }
    } catch (e) {
      print('Error deleting news: $e');
    }
  }

  @override
Widget build(BuildContext context) {
  print('_news: $_news');
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
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.refresh),
                  color: Colors.blue,
                  onPressed: () {
                    _getnews();
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _news.isEmpty
              ? Center(child: Text('No News available'))
              : Column(
                  children: _news.map((newsItem) {
                    return NewsWidget(
                      imageUrl: newsItem['image'],
                      title: newsItem['title'],
                      location: newsItem['location'],
                      description: newsItem['desc'],
                    );
                  }).toList(),
                ),
          ),
        ],
      ),
    ),
  );
}

   void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SizedBox(
             width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: imageUrl.endsWith('.mp4') || imageUrl.endsWith('.mov')
                ? VideoPlayerWidget(url: imageUrl)
                : Hero(
                    tag: 'imageHero',
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:reportaroad/main.dart';
// import 'package:reportaroad/models/NewsWidget.dart';
// import 'package:share_plus/share_plus.dart';

// class News extends StatefulWidget {
//    final String userId;
//    final token;
//   News({
//     Key? key,
//     required this.userId,
//     required this.token,
//   }) : super(key: key);


//   @override
//   State<News> createState() => _NewsState();
// }

// class _NewsState extends State<News> {
//     final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//  List<dynamic> _news = [];

//   @override
//   void initState() {
//     super.initState();
//     _getnews();
//   }

//   void shareReport(String news) async {
//     try {
//       await Share.share(
//         news,
//         subject: 'Share Report',
//       );
//     } catch (e) {
//       print('Error sharing news: $e');
//     }
//   }

//   void _getnews() async {
//     try {
//       var response = await http.get(
//         Uri.parse('${serverBaseUrl}getNews'),
//         headers: {
//           "Content-type": "application/json",
//           "Cache-Control": "no-cache"
//         },
//       );

//       var jsonResponse = jsonDecode(response.body);
//       if (jsonResponse['success'] == true) {
//       var newsList = jsonResponse['news'];

//       setState(() {
//         _news = newsList;
//       });
//     } else {
//       print('Failed to fetch news: ${jsonResponse['error']}');
//     }
//   } catch (e) {
//     print('Error fetching news: $e');
//   }
// }
//   void deleteReport(id) async {
//     try {
//       print('Deleting news with ID: $id');
//       var regBody = {
//         "id": id,
//       };
//       var response = await http.post(
//         Uri.parse('${serverBaseUrl}deleteReport'),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(regBody),
//       );
//       var jsonResponse = jsonDecode(response.body);
//       if (jsonResponse['status']) {
//         setState(() {
//           _news.removeWhere((news) => news['_id'] == id);
//         });
//       }
//     } catch (e) {
//       print('Error deleting news: $e');
//     }
//   }

//   @override
// Widget build(BuildContext context) {
//   print('_news: $_news');
//   return Scaffold(
//     appBar: PreferredSize(
//       preferredSize: Size.fromHeight(kToolbarHeight + 10),
//       child: AppBar(
//         backgroundColor: Color(0xFF2C75FF),
//         elevation: 5,
//         title: const Text(
//           "News",
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//       ),
//     ),
//     body: SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 40),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.refresh),
//                   color: Colors.blue,
//                   onPressed: () {
//                     _getnews();
//                   },
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: _news.isEmpty
//               ? Center(child: Text('No News available'))
//               : Column(
//                   children: _news.map((newsItem) {
//                     return NewsWidget(
//                       imageUrl: newsItem['image'],
//                       title: newsItem['title'],
//                       location: newsItem['location'],
//                       description: newsItem['desc'],
//                     );
//                   }).toList(),
//                 ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

//    void _showImageDialog(BuildContext context, String imageUrl) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           child: GestureDetector(
//             onTap: () {
//               Navigator.of(context).pop();
//             },
//             child: SizedBox(
//               width: MediaQuery.of(context).size.width * 0.24,
//               height: MediaQuery.of(context).size.height * 0.24,
//               child: Hero(
//                 tag: 'imageHero',
//                 child: Image.network(
//                   imageUrl,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
