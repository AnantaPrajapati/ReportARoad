import 'package:flutter/material.dart';

class Faqs extends StatelessWidget {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: AppBar(
            backgroundColor: Color(0xFF2C75FF),
            elevation: 5,
            title: const Text(
              "Recent Report",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: ListView(
        children: [
          _buildFaqItem(
            question: ' What is the Pothole Reporting System?',
            answer:
                'A1: The Pothole Reporting System is an application that allows users to report potholes and other road issues directly to the local government. Users can upload images, provide descriptions, and pinpoint the location of the pothole on a map. The government can then review these reports, approve or disapprove them, and take necessary actions.',
          ),
          _buildFaqItem(
            question: 'How do I report a pothole using the app?',
            answer:
                'A2: To report a pothole, open the app and navigate to the "Report Pothole" section. Fill in the required fields including location, title, description, and upload an image of the pothole. Once all fields are completed, submit the report.',
          ),
          _buildFaqItem(
            question: 'How can I view the status of my reported pothole?',
            answer: 'You can view the status of your report in the "Recent Reports" section. Each report will have a status indicator showing whether it is pending, approved, or disapproved.',
          ),
          _buildFaqItem(
            question: 'How does the government respond to reported potholes?',
            answer: 'The government reviews each submitted report, adds comments if necessary, and changes the status of the report to approved or disapproved. Approved reports will be scheduled for repair, while disapproved reports will include a reason for disapproval.',
          ),
          _buildFaqItem(
            question: 'Can I delete a report I submitted?',
            answer: 'Yes, you can delete a report if it has not yet been reviewed by the government. Go to the "Recent Reports" section, select the report, and choose the delete option.',
          ),
          _buildFaqItem(
            question: 'How do I share a report with others?',
            answer: 'To share a report, navigate to the "Recent Reports" section, select the report you want to share, and choose the share option. You can share the report through various platforms like email, social media, or messaging apps.',
          ),
          _buildFaqItem(
            question: ' What kind of notifications will I receive from the app?',
            answer: 'You will receive notifications for various activities such as when you register, submit a report, when your report is approved or disapproved, and when there are updates or comments on your report.',
          ),

          _buildFaqItem(
            question: ' How can I view incident reports submitted by other users?',
            answer: 'You can view incident reports submitted by other users in the "Incident Reports" section. This section displays a list of all reported incidents with details and images.',
          ),
          _buildFaqItem(
            question: 'Can the government post news and updates on the app?',
            answer: ' Yes, the government can post news and updates related to road maintenance and other public information. These updates will be visible in the "News" section of the app.',
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text(question),
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(answer),
          ),
        ],
      ),
    );
  }
}
