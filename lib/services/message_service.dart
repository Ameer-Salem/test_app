import 'package:drift/drift.dart';
import 'package:test_app/models/app_database.dart';

class MessageService {
  final AppDatabase db;

  MessageService(this.db);

  Future<int> addMessage({
    required String type,
    required int senderId,
    required int receiverId,
    String? text,
    bool isSent = false,
  }) async {
    return db.insertMessage(
      MessagesCompanion(
        senderId: Value(senderId),
        receiverId: Value(receiverId),
        type: text == null ? Value.absent() : Value(type),
        textContent: Value(text),
        isSent: Value(isSent),
        timeStamp: Value(DateTime.now()),
      ),
    );
  }

  Future<int> addAttachment({
    required int messageId,
    required String path,
    required String type,
  }) async {
    return db.insertAttachment(
      AttachmentsCompanion(
        messageId: Value(messageId),
        fileType: Value(type),
        filePath: Value(path),
      ),
    );
  }

  Future<List<MessageWithAttachments>> getMessagesWithAttachments() => db.getMessagesWithAttachments();

  Stream<List<MessageWithAttachments>> watchMessagesWithAttachments() {
  final query = db.select(db.messages).join([
    leftOuterJoin(
      db.attachments,
      db.attachments.messageId.equalsExp(db.messages.id),
    ),
  ]);

  return query.watch().map((rows) {
    return rows.map((row) {
      final message = row.readTable(db.messages);
      final attachment = row.readTableOrNull(db.attachments);
      return MessageWithAttachments(
        message,
        attachment != null ? [attachment] : [],
      );
    }).toList();
  });
}

}
