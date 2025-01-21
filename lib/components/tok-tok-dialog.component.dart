


import 'package:flutter/material.dart';

class TikTokDialog extends StatefulWidget {
  final String title;
  final String body;
  bool? shouldDismiss;
  final Function() onPrimaryBtnPress;
  final String primaryBtnLabel;

  TikTokDialog({ required this.title, required this.body, required this.onPrimaryBtnPress, this.shouldDismiss, required this.primaryBtnLabel });

  @override
  State<TikTokDialog> createState() => _TikTokDialogState();
}

class _TikTokDialogState extends State<TikTokDialog> {
  // Initial color of the container
  Color _buttonBackground = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent, // Transparent background
      child: AnimatedContainer(
        constraints: BoxConstraints(
          maxWidth: 450
        ),
        duration: Duration(milliseconds: 300), // Smooth transition
        curve: Curves.easeInOut, // Animation curve
        padding: EdgeInsets.only(top: 20.0),
        decoration: BoxDecoration(
          color: Colors.white, // Dialog content color
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(widget.body, style: TextStyle(color: Colors.black),)
            ),

            SizedBox(height: 20),
            Divider(height: 1,),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  if(widget.shouldDismiss == true || widget.shouldDismiss == null) {
                    Navigator.of(context).pop();
                  }
                  widget.onPrimaryBtnPress();
                },
                onTapDown: (_) {
                  // Change color when the container is tapped
                  setState(() {
                    _buttonBackground = Colors.grey.shade400;
                  });
                },
                onTapUp: (_) {
                  // Revert color when the tap is released
                  setState(() {
                    _buttonBackground = Colors.transparent;
                  });
                },
                onTapCancel: () {
                  // Revert color if the tap is canceled (e.g., touch moves away)
                  setState(() {
                    _buttonBackground = Colors.transparent;
                  });
                },
                child: Container(
                    decoration: BoxDecoration(
                      color: _buttonBackground, // Dialog content color
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
                    ),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    alignment: Alignment.center,
                    child: Text(widget.primaryBtnLabel, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}