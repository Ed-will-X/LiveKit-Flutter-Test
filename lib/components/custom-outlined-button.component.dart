import 'package:flutter/material.dart';

import '../services/ui.service.dart';

enum CustomOutlinedButtonRenderMode {
  dynamic, // Shows only icon on mobile and icon+child on desktop
  full, // shows both icon and child always
}

class CustomOutlinedButton extends StatelessWidget {
  final Color textColor;
  final Color backgroundColor;
  final Color? outlineColor;
  final String text;
  final IconData icon;
  final VoidCallback onPress;
  final double? borderRadius;
  final BuildContext parentContext;
  final CustomOutlinedButtonRenderMode? renderMode;
  final EdgeInsets? margin;

  CustomOutlinedButton({super.key, required this.text, required this.textColor, required this.backgroundColor, required this.icon, this.outlineColor, this.borderRadius, required this.onPress, this.renderMode, required this.parentContext, this.margin});

  Widget? _child() {
    final isMobileScreen = UIService.isMobileScreen(parentContext);
    if(renderMode == CustomOutlinedButtonRenderMode.dynamic) {
      if(isMobileScreen) {
        return null;
      } else {
        return Text(this.text, style: TextStyle(color: this.textColor));
      }
    } else {
      return Text(this.text, style: TextStyle(color: this.textColor));;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: this.backgroundColor,
          borderRadius: BorderRadius.circular(10)
      ),
      margin: this.margin,
      child: OutlinedButton(
        onPressed: () {
          this.onPress();
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            width: this.outlineColor != null ? 1.0 : 0,
            color: this.outlineColor ?? Colors.transparent,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Custom border radius
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15), // Padding
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(this.icon, size: 25, color: this.textColor,),
            if(this._child() != null) ...[
              SizedBox(width: 5,),
              this._child() ?? Text("")
            ]
          ],
        ),
      ),
    );
  }
}
