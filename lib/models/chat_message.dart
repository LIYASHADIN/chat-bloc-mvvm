class ChatMessage {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final String messageType;
  final String? fileUrl;
  final String? fileName;
  final int? fileSize;
  final List<String> deletedBy;
  final String status;
  final DateTime? deliveredAt;
  final DateTime? seenAt;
  final List<String> seenBy;
  final DateTime sentAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.messageType,
    this.fileUrl,
    this.fileName,
    this.fileSize,
    required this.deletedBy,
    required this.status,
    this.deliveredAt,
    this.seenAt,
    required this.seenBy,
    required this.sentAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id'],
      chatId: json['chatId'],
      senderId: json['senderId'],
      content: json['content'] ?? '',
      messageType: json['messageType'] ?? 'text',
      fileUrl: json['fileUrl'],
      fileName: json['fileName'],
      fileSize: json['fileSize'],
      deletedBy: List<String>.from(json['deletedBy'] ?? []),
      status: json['status'] ?? 'sent',
      deliveredAt:
          json['deliveredAt'] != null ? DateTime.parse(json['deliveredAt']) : null,
      seenAt: json['seenAt'] != null ? DateTime.parse(json['seenAt']) : null,
      seenBy: List<String>.from(json['seenBy'] ?? []),
      sentAt: DateTime.parse(json['sentAt']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
