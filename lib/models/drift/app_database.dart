import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:test_app/models/drift/tables/messages_table.dart';
import 'package:test_app/models/drift/tables/segments_table.dart';
import 'package:test_app/models/helpers/messagesWithSegments.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Messages, Segments])
class AppDatabase extends _$AppDatabase {
  AppDatabase(String deviceId) : super(_openConnection(deviceId));

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection(String deviceId) {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'messages_$deviceId.sqlite'));
    return NativeDatabase(file);
  });
}
