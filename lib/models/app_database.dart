import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:test_app/models/attachments_table.dart';
import 'package:test_app/models/messages_table.dart';

part 'app_database.g.dart';


@DriftDatabase(tables: [Messages, Attachments])
class AppDatabase extends _$AppDatabase {

  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> insertMessage(MessagesCompanion message) =>
      into(messages).insert(message);
  Future<int> insertAttachment(AttachmentsCompanion attachment) =>
      into(attachments).insert(attachment);
  
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

class MessageWithAttachments {
  final Message message;
  final List<Attachment> attachments;

  MessageWithAttachments(this.message, this.attachments);
}
