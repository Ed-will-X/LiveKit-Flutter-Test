



import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../services/ui.service.dart';

class ButtonComponent extends StatelessWidget {
  void Function()? onPressed;
  String text;
  Color backgroundColor;
  Color textColor;
  double? elevation;
  IconData? icon;
  String? svg_path;
  double? height;
  Color? disabledColor;
  FontWeight? fontWeight;

  ButtonComponent({super.key, required this.text, required this.backgroundColor, required this.onPressed, required this.textColor, this.elevation, this.icon, this.svg_path, this.height, this.disabledColor, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    final isMobileScreen = UIService.isMobileScreen(context);
    double? mobileScreenHeightOverride = isMobileScreen ? null : 35;

    return Container(
      width: double.infinity,
      margin: kIsWeb ? EdgeInsets.symmetric(vertical: 5) : null,
      height: this.height != null ? this.height : mobileScreenHeightOverride,
      child: MaterialButton(
        onPressed: this.onPressed,
        color: backgroundColor,
        disabledColor: this.disabledColor ?? Colors.grey,
        elevation: elevation ?? 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0), // Set radius here
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(this.text, style: TextStyle(color: this.textColor, fontSize: 15, fontWeight: this.fontWeight ?? FontWeight.normal),),
            if(this.icon != null) ...[
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(icon, color: textColor,),
              )
            ],

            if(this.svg_path != null) ...[
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: SvgPicture.asset(svg_path!, width: 20, height: 20,),
              )
            ]
          ],
        ),
      ),
    );
  }
}
