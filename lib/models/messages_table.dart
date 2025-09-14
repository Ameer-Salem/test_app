import 'package:drift/drift.dart';

class Messages extends Table {

  IntColumn get id => integer().autoIncrement()();
  IntColumn get senderId => integer()();
  IntColumn get receiverId => integer()();
  TextColumn get type => text()();
  TextColumn get textContent => text().nullable()();
  DateTimeColumn get timeStamp => dateTime()();
  BoolColumn get isSent => boolean().withDefault(Constant(true))();

}