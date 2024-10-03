class ChatData {
  final String? currentUserId;
  final String? currentUserName;
  final String? currentUserImageUrl;
  final String? currentUserNationalId;
  final String? peerId;
  final String? peerUserName;
  final String? peerImageUrl;
  final String? peerNationalId;
  final String? conversionId;
  final int? type;
  final int? shipmentId;

  ChatData({
    required this.currentUserId,
    required this.currentUserImageUrl,
    required this.currentUserName,
    required this.peerId,
    required this.peerUserName,
    required this.peerImageUrl,
    required this.currentUserNationalId,
    required this.peerNationalId,
    required this.shipmentId,
    this.conversionId,
    this.type,
  });

  factory ChatData.fromJson(Map<String, dynamic> map) => ChatData(
        currentUserId: map['current_user_id'],
        currentUserImageUrl: map['current_user_image'],
        currentUserName: map['current_user_name'],
        peerId: map['peer_user_id'],
        peerUserName: map['peer_user_name'],
        peerNationalId: map['peer_national_id'],
        currentUserNationalId: map['current_user_national_id'],
        shipmentId: map['shipment_id'],
        peerImageUrl: map['peer_user_image_url'],
        conversionId: map['conversion_id'],
        type: map['type'],
      );

  Map<String, dynamic> toJson() => {
        'current_user_id': currentUserId,
        'current_user_image': currentUserImageUrl,
        'current_user_name': currentUserName,
        'peer_user_id': peerId,
        'peer_user_name': peerUserName,
        'current_user_national_id': currentUserNationalId,
        'peer_national_id': peerNationalId,
        'shipment_id': shipmentId,
        'peer_user_image_url': peerImageUrl,
        'conversion_id': conversionId,
        'type': type,
      };

  @override
  String toString() =>
      'ChatData{currentUserId: $currentUserId, currentUserName: $currentUserName, currentUserImageUrl: $currentUserImageUrl, currentUserNationalId: $currentUserNationalId, peerId: $peerId, peerUserName: $peerUserName, peerImageUrl: $peerImageUrl, peerNationalId: $peerNationalId, conversionId: $conversionId, type: $type, shipmentId: $shipmentId}';
}
