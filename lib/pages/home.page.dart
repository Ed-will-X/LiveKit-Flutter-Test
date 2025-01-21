


import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_call_app/components/button.component.dart';
import 'package:video_call_app/components/error-text.component.dart';
import 'package:video_call_app/components/input.component.dart';
import 'package:video_call_app/components/loading-indicator.component.dart';
import 'package:video_call_app/constants/ui.constants.dart';
import 'package:video_call_app/pages/call.page.dart';
import 'package:video_call_app/services/api.service.dart';
import 'package:video_call_app/services/ui.service.dart';

import '../constants/navigation.constants.dart';
import '../model/res/nest-error.model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _chatRoomIdController = TextEditingController();
  final _usernameController = TextEditingController();

  late final ApiService _apiService;

  NestError? _error = null;
  var _isLoading = false;

  bool shouldJoinWithVideoOff = true;

  @override
  void initState() {
    super.initState();

    _apiService = ApiService(context: context);
    _usernameController.addListener(_updateInput);
    _chatRoomIdController.addListener(_updateInput);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _usernameController.dispose();
    _chatRoomIdController.dispose();
  }

  void _updateInput() {
    // final isButtonEnabled = _textController.text.length > 0;
    //
    // if (isButtonEnabled != _isSendButtonEnabled) {
    //   setState(() {
    //     _isSendButtonEnabled = isButtonEnabled;
    //   });
    // }
  }

  void handleJoinRoomClick() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final res = await _apiService.joinRoom(roomId: _chatRoomIdController.text, userId: _usernameController.text);
    if(res.isSuccess) {
      Navigator.pushNamed(context, NavigationRoutes.call_page, arguments: CallPageArgs(joinRoomResponse: res.success, joinWithVideoOff: this.shouldJoinWithVideoOff));
      print("Success");

      setState(() {
        _isLoading = false;
      });
    } else {
      UIService.showErrorDialog(title: res.error?.error ?? "", body: res.error?.message ?? "", context: context);

      setState(() {
        _error = res.error;
        _isLoading = false;
      });
    }
  }

  void openInNewTab(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // Ensures the link opens externally
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  void openGithub() {
    this.openInNewTab("https://github.com/Ed-will-X/LiveKit-Flutter-Test");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIConstants.backgroundColor,
      body: Center(
        child: Stack(
          children: [
            Container(child: Image.asset("assets/images/auth_root_image.jpg", fit: BoxFit.cover, height: double.infinity, width: double.infinity,)),
            Container(color: Colors.black.withOpacity(0.6),),
            Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 300
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("LiveKit Call Demo", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),),
                      Icon(Icons.video_call, color: Colors.white, size: 100),
                      SizedBox(height: 100,),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text("By Eddie Williams", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),)
                      ),
                      SizedBox(height: 10,),
                      InputComponent(controller: _chatRoomIdController, title: "Enter Chat Room Id....", inputType: TextInputType.text),
                      InputComponent(controller: _usernameController, title: "Enter Username....", inputType: TextInputType.text),
                  
                      if(_error != null) ...[
                        ErrorText(message: _error?.message),
                      ],
                  
                      Row(
                        children: [
                          Checkbox(
                            value: shouldJoinWithVideoOff,
                            onChanged: (bool? value) {
                              setState(() {
                                shouldJoinWithVideoOff = value ?? false;
                              });
                            },
                            // Customizing the checkbox appearance
                            activeColor: Colors.white, // Checkmark color
                            checkColor: Colors.black, // Background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4), // Optional for rounded edges
                            ),
                          ),
                  
                          Text("Join with video off", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),)
                        ],
                      ),
                  
                      if(_isLoading) ...[
                        LoadingIndicator(size: 35, color: Colors.white,)
                      ] else ...[
                        ButtonComponent(text: "Join Room", backgroundColor: Colors.white, fontWeight: FontWeight.bold, elevation: 0, onPressed: this.handleJoinRoomClick, textColor: Colors.black),
                        SizedBox(height: 30,),
                        ButtonComponent(text: "Github Repo", icon: HugeIcons.strokeRoundedGithub, backgroundColor: Colors.purple, fontWeight: FontWeight.bold, elevation: 0, onPressed: this.openGithub, textColor: Colors.white),
                      ]
                    ],
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
