import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  late final dynamic? message;
  late final Color? color;
  ErrorText({super.key, required this.message, this.color});

  TextStyle get textStyle => TextStyle(color: color ?? Colors.red);
  // final TextStyle textStyle = TextStyle(color: this.color ?? Colors.red);

  @override
  Widget build(BuildContext context) {
    if(message != null && message is List) {
      print("List");
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ...(message as List<dynamic>).map((item) {
            return Container(width: double.infinity, child: Text(item, textAlign: TextAlign.end, style: textStyle,));
          })
        ],
      );
    } else if(message != null && message is String) {
      print("Stirng");
      return Container(width: double.infinity, child: Text(message, textAlign: TextAlign.end, style: textStyle,));
    } else {
      print(message.runtimeType);
      return Container();
    }
  }
}