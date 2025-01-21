import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hugeicons/hugeicons.dart';

import '../services/api.service.dart';
import 'loading-indicator.component.dart';

class EmptyProfileImageComponent extends StatelessWidget {
  late double size;
  late double? radius;

  EmptyProfileImageComponent({super.key, required this.size, this.radius});

  Widget handleVisibility() {
    return SvgPicture.asset("assets/icons/person_circle.svg", width: double.infinity, height: double.infinity, color: Colors.white,);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius != null ? radius! : size/2)
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius != null ? radius! : size/2),
          child: handleVisibility(),
        )
    );
  }
}