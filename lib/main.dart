import 'package:flutter/material.dart';
import 'package:video_call_app/pages/call.page.dart';
import 'package:video_call_app/pages/home.page.dart';

import 'constants/navigation.constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: NavigationRoutes.home,
        routes: {
        NavigationRoutes.home: (context)=> HomePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == NavigationRoutes.call_page) {
          final args = settings.arguments as CallPageArgs;
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => CallPage(args: args,),
            transitionDuration: Duration.zero, // Disable transition animation
            reverseTransitionDuration: Duration.zero, // Disable reverse transition animation
          );
        }
      }
    );
  }
}

