




import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  double size;
  double? strokeWidth;
  Color? color;

  LoadingIndicator({super.key, required this.size, this.color, this.strokeWidth});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(this.color ?? Colors.black),
          strokeWidth: this.strokeWidth ?? 1.5,
        )
      ),
    );
  }
}