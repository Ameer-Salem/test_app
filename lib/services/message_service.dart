import 'package:drift/drift.dart';
import 'package:test_app/models/app_database.dart';

class MessageService {
  AppDatabase db;

  MessageService(this.db);

  Future<int> addMessage({
    required int senderId,
    required int receiverId,
    required String type,
    String? content,
  }) async {
    return db.insertMessage(
      MessagesCompanion(
        senderId: Value(senderId),
        receiverId: Value(receiverId),
        type: Value(type),
        textContent: Value(content),
        timeStamp: Value(DateTime.now()),
      ),
    );
  }

  Future<int> addAttachment({
    required int msgId,
    required String type,
    required String path,
  }) async {
    return db.insertAttachment(
      AttachmentsCompanion(
        messageId: Value(msgId),
        fileType: Value(type),
        filePath: Value(path),
      ),
    );
  }

  Stream<List<MessageWithAttachments>> getMessagesWithAttachments() {
    final query = db.select(db.messages).join([
      leftOuterJoin(
        db.attachments,
        db.attachments.messageId.equalsExp(db.messages.id),
      ),
    ]);

    return query.watch().map((rows) => rows.map((row) {
      final msg = row.readTable(db.messages);
      final attach = row.readTableOrNull(db.attachments);
      return MessageWithAttachments(msg, attach != null ? [attach] : []);

    }).toList());
  }
}
