import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double horizontalPadding;
  final double verticalPadding;
  final VoidCallback? onBackButtonPressed; 

  CustomAppBar({
    required this.title,
    required this.horizontalPadding,
    required this.verticalPadding,
    this.onBackButtonPressed, 
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF2C75FF),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                if (onBackButtonPressed != null) {
                  onBackButtonPressed!(); 
                } else {
                  Navigator.of(context).pop(); 
                }
              },
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back,
                    size: 35,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
