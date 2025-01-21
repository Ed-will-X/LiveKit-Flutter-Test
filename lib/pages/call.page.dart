

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:livekit_client/livekit_client.dart';

import '../components/custom-outlined-button.component.dart';
import '../components/livekit-video.component.dart';
import '../constants/ui.constants.dart';
import '../model/res/join-room.response.dart';
import '../services/api.service.dart';
import '../services/ui.service.dart';

enum CallState {
  Failed,
  Waiting,
  Joining,
  InCall,
  LeftCall,
}

class CallPageArgs {
  final JoinRoomResponse? joinRoomResponse;
  final bool joinWithVideoOff;

  CallPageArgs({ required this.joinRoomResponse, required this.joinWithVideoOff });
}

class CallPage extends StatefulWidget {
  CallPageArgs args;

  CallPage({super.key, required this.args});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  CallState? _callState = null;
  final textStyle = const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20);

  late Room room;
  late final EventsListener<RoomEvent> _listener;
  final List<RemoteParticipant> _remoteParticipants = [];

  bool isMicrophoneEnabled = false;
  bool isCameraEnabled = false;
  bool isScreenShareEnabled = false;

  late ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(context: context);

    this.handleJoinLivekitCall();
  }

  @override
  void dispose() async {
    await this.handleDisposal();
    super.dispose();
  }

  Future<void> handleDisposal() async {

    await _listener?.dispose();
    await room?.disconnect();
    await room?.dispose();
  }

  void handleJoinLivekitCall() async {
    setState(() {
      _callState = CallState.InCall;
    });

    try {
      final roomOptions = const RoomOptions(
        adaptiveStream: true,
        dynacast: true,
        // ... your room options
      );

      this.room = Room(roomOptions: roomOptions);

      await room.connect(widget.args.joinRoomResponse?.livekitServerUrl ?? "", widget.args.joinRoomResponse?.livekitAccessToken ?? "");

      final remoteParticipants = this.room.remoteParticipants.values.toList();
      this.addParticipants(remoteParticipants);

      if(widget.args.joinWithVideoOff == false) {
        try {
          await room.localParticipant?.setCameraEnabled(true);

          setState(() {
            isCameraEnabled = true;
          });
        } catch (error) {
          print('Could not publish video, error: $error');
        }
      }

      try {
        await room.localParticipant?.setMicrophoneEnabled(true);
        setState(() {
          isMicrophoneEnabled = true;
        });
      } catch (error) {
        print('Could not publish audio, error: $error');
      }

      // var localVideo = await LocalVideoTrack.createCameraTrack();
      // await room.localParticipant?.publishVideoTrack(localVideo);

      _listener = room.createListener();


      _listener.on<RoomDisconnectedEvent>((_) {
        // handle disconnect
        print("Disconnected from room");
      });


      // Subscribe to room events
      _listener.on<ParticipantConnectedEvent>((event) {
        print('Participant connected: ${event.participant.identity}');
        this.addParticipant(event.participant);
        setState(() {});
      });

      _listener.on<ParticipantDisconnectedEvent>((event) {
        print('Participant disconnected: ${event.participant.identity}');
        this.removeParticipant(event.participant);
        setState(() {});
      });

      _listener.on<TrackSubscribedEvent>((event) {
        print('Track subscribed: ${event.participant.identity}, track: ${event.track.sid}');
      });

      _listener.on<TrackUnsubscribedEvent>((event) {
        print('Track unsubscribed: ${event.participant.identity}, track: ${event.track.sid}');
      });

      _listener.on<RoomDisconnectedEvent>((event) {
        print('Disconnected from room: ${event.reason}');
      });

      _listener.on<ActiveSpeakersChangedEvent>((event) {
        print('Active speakers: ${event.speakers.map((e) => e.identity).join(', ')}');
      });


      print("After room.connect");

    } catch (e) {
      print('Error connecting to room: $e');
      UIService.showErrorDialog(title: "Could not Connect", body: (e as dynamic).message ?? "Something went wrong somewhere", context: context);
    }
  }

  void addParticipants(List<RemoteParticipant> participants) {
    for(final participant in participants) {
      this.addParticipant(participant);
    }
    setState(() {});
  }

  void addParticipant(RemoteParticipant participant) {
    // TODO: Add to participant list
    this._remoteParticipants.add(participant);
  }

  void removeParticipant(RemoteParticipant participantToRemove) {
    this._remoteParticipants.removeWhere((participant)=> participant.sid == participantToRemove.sid);
  }

  Widget handleMainContent() {
    if(_callState == CallState.Waiting) {
      return Text("Waiting", style: this.textStyle,);
    } else if(_callState == CallState.Failed) {
      return Text("Failed", style: this.textStyle,);
    } else if(_callState == CallState.Joining) {
      return Text("Failed", style: this.textStyle,);
    } else if(_callState == CallState.InCall) {
      return _inCallLayout();
    } else if(_callState == CallState.LeftCall) {
      return Text("Left Call", style: this.textStyle,);
    } else {
      return Text("Else callback");
    }
  }

  Widget _inCallLayout() {
    return Column(
      children: [
        Text("In Call", style: this.textStyle,),
        this.renderVideos(),

        _actionLayout()
      ],
    );
  }

  Widget renderVideos() {
    final List<Participant> allParticipants = [ ...this._remoteParticipants ];

    if(this.room.localParticipant != null) {
      allParticipants.add(this.room?.localParticipant! as Participant<TrackPublication<Track>>);
      final isMobile = UIService.isMobileScreen(context);

      if(!isMobile) {
        // return Expanded(
        //   child: GridView.builder(
        //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        //       maxCrossAxisExtent: 400, // Max width of each item
        //       mainAxisSpacing: 8, // Vertical spacing between items
        //       crossAxisSpacing: 8, // Horizontal spacing between items
        //       childAspectRatio: 1, // Ratio of width to height
        //     ),
        //     itemCount: allParticipants.length,
        //     itemBuilder: (BuildContext context, int index) {
        //       final participant = allParticipants.reversed.toList()[index];
        //       return VideoView(participant: participant,);
        //     },
        //   ),
        // );
        return Expanded(
          child: Row(
            children: allParticipants.reversed.map((participant) {
              return Expanded(child: VideoView(participant: participant,));
            }).toList()
          ),
        );
      } else {
        return Expanded(
          child: Column(
            children: allParticipants.reversed.map((participant) {
              return Expanded(child: VideoView(participant: participant,));
            }).toList()
          ),
        );
      }
    } else {
      return Text("Null current participant");
    }
  }

  void toggleVideo() async {
    try {
      await this.room.localParticipant?.setCameraEnabled(!this.isCameraEnabled);
      setState(() {
        this.isCameraEnabled = !this.isCameraEnabled;
      });
    } catch(error) {
      print('Could not change camera enabled to ${this.isCameraEnabled}, error: $error');
    }
  }

  // void toggleVideo() async {
  //   try {
  //     final track = this.room.localParticipant?.videoTrackPublications.first;
  //     print("Video track count: ${this.room.localParticipant?.videoTrackPublications.length}");
  //     print("Muted: ${track?.muted}");
  //     if(isCameraEnabled == true) {
  //       await track?.mute();
  //       setState(() { this.isCameraEnabled = false; });
  //     } else {
  //       await track?.unmute();
  //       setState(() { this.isCameraEnabled = true; });
  //     }
  //     // await this.room.localParticipant?.setCameraEnabled(!this.isCameraEnabled);
  //   } catch(error) {
  //     print('Could not change camera enabled to ${this.isCameraEnabled}, error: $error');
  //   }
  // }

  void toggleAudio() async {
    try {
      await this.room.localParticipant?.setMicrophoneEnabled(!this.isMicrophoneEnabled);
      setState(() {
        this.isMicrophoneEnabled = !this.isMicrophoneEnabled;
      });
    } catch(error) {
      print('Could not change audio enabled to ${this.isMicrophoneEnabled}, error: $error');
    }
  }

  void toggleScreenShare() async {
    try {
      if(this.isCameraEnabled == true) {
        this.toggleVideo();
      }
      await this.room.localParticipant?.setScreenShareEnabled(!this.isScreenShareEnabled);
      setState(() {
        this.isScreenShareEnabled = !this.isScreenShareEnabled;
      });
    } catch(error) {
      print('Could not change screen share enabled to ${this.isScreenShareEnabled}, error: $error');
    }
  }

  void handleLeave() {
    Navigator.of(context).pop();
  }

  Widget _actionLayout() {
    final isMobileScreen = UIService.isMobileScreen(context);

    return Container(
      // constraints: const BoxConstraints(
      //   maxWidth: 700
      // ),
      height: 80,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      // width: isMobileScreen ? 300 : 1000,
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          CustomOutlinedButton(
              text: "Microphone",
              parentContext: context,
              textColor: isMicrophoneEnabled ? Colors.black : Colors.white,
              backgroundColor: isMicrophoneEnabled ? Colors.white : Colors.transparent,
              icon: Icons.mic,
              outlineColor: Colors.white,
              renderMode: CustomOutlinedButtonRenderMode.dynamic,
              margin: EdgeInsets.symmetric(horizontal: 4),
              onPress: this.toggleAudio
          ),

            CustomOutlinedButton(
              text: "Camera",
              parentContext: context,
              textColor: isCameraEnabled ? Colors.black : Colors.white,
              backgroundColor: isCameraEnabled ? Colors.white : Colors.transparent,
              icon: Icons.camera_alt,
              outlineColor: Colors.white,
              renderMode: CustomOutlinedButtonRenderMode.dynamic,
              margin: EdgeInsets.symmetric(horizontal: 4),
              onPress: this.toggleVideo
            ),

          // CustomOutlinedButton(
          //   text: "Share Screen",
          //   parentContext: context,
          //   textColor: isScreenShareEnabled ? Colors.black : Colors.white,
          //   backgroundColor: isScreenShareEnabled ? Colors.white : Colors.transparent,
          //   icon: HugeIcons.strokeRoundedShare01,
          //   outlineColor: Colors.white,
          //   renderMode: CustomOutlinedButtonRenderMode.dynamic,
          //   margin: EdgeInsets.symmetric(horizontal: 4),
          //   onPress: this.toggleScreenShare
          // ),

          CustomOutlinedButton(
            text: "Leave",
            parentContext: context,
            textColor: Colors.red,
            backgroundColor: Colors.transparent,
            icon: HugeIcons.strokeRoundedPictureInPictureExit,
            outlineColor: Colors.red,
            renderMode: CustomOutlinedButtonRenderMode.dynamic,
            margin: EdgeInsets.symmetric(horizontal: 4),
            onPress: this.handleLeave
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIConstants.backgroundColor,
      body: Container(
        child: Center(
          child: handleMainContent()
        )
      ),
    );
  }
}
