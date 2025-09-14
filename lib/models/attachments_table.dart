import 'package:drift/drift.dart';

class Attachments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get messageId => integer().customConstraint('REFERENCES messages(id)')();
  TextColumn get fileType => text()();
  TextColumn get filePath => text()();
}