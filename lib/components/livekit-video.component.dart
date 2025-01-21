


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:video_call_app/components/empty-profile-image.component.dart';


class VideoView extends StatefulWidget {
  final Participant participant;

  VideoView({
    required this.participant,
  });

  @override
  State<StatefulWidget> createState() {
    return _VideoViewState();
  }
}

class _VideoViewState extends State<VideoView> {
  TrackPublication? videoPub;

  @override
  void initState() {
    super.initState();
    widget.participant.addListener(this._onParticipantChanged);
    // trigger initial change
    _onParticipantChanged();
  }


  @override
  void dispose() {
    widget.participant.removeListener(this._onParticipantChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant VideoView oldWidget) {
    print("Did update widget ran-${widget.participant.identity}");


    oldWidget.participant.removeListener(_onParticipantChanged);
    widget.participant.addListener(_onParticipantChanged);
    _onParticipantChanged();
    super.didUpdateWidget(oldWidget);
  }

  void _onParticipantChanged() {
    print("On participant changed ran-${widget.participant.identity}");
    var subscribedVideos = widget.participant.videoTrackPublications.where((pub) {
      print("pub is screen share: ${pub.isScreenShare}");
      return pub.kind == TrackType.VIDEO && !pub.isScreenShare && pub.subscribed;
    });

    print("video tracks: ${subscribedVideos.length}");

    setState(() {
      if (subscribedVideos.length > 0) {
        var videoPub = subscribedVideos.first;
        // when muted, show placeholder
        if (!videoPub.muted) {
          this.videoPub = videoPub;
          return;
        }
      }
      this.videoPub = null;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (videoPub != null && videoPub?.track != null && videoPub?.track?.muted == false) {
      return Container(
        margin: EdgeInsets.all(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: VideoTrackRenderer(
            videoPub?.track as VideoTrack,
            fit: rtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          ),
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text("Audio Only", style: TextStyle(color: Colors.white),)
                Column(
                  children: [
                    EmptyProfileImageComponent(size: 60),
                    Text(widget.participant.identity ?? "", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),)
                  ],
                )
              ],
            )
        ),
      );
    }
  }
}