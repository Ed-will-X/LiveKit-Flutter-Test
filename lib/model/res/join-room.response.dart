

class JoinRoomResponse {
  String? chatRoomId;
  String? livekitServerUrl;
  String? livekitAccessToken;

  JoinRoomResponse(
      {this.chatRoomId, this.livekitServerUrl, this.livekitAccessToken});

  JoinRoomResponse.fromJson(Map<String, dynamic> json) {
    chatRoomId = json['chatRoomId'];
    livekitServerUrl = json['livekit_serverUrl'];
    livekitAccessToken = json['livekit_accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chatRoomId'] = this.chatRoomId;
    data['livekit_serverUrl'] = this.livekitServerUrl;
    data['livekit_accessToken'] = this.livekitAccessToken;
    return data;
  }
}