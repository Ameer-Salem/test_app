import 'package:drift/drift.dart';
import 'package:test_app/models/drift/app_database.dart';
import 'package:test_app/models/helpers/messagesWithSegments.dart';

abstract class IDatabaseService {
  Future<void> openDatabase(String deviceId);
  Future<void> closeDatabase();
  Future<int> insertMessage(MessagesCompanion message);
  Future<int> insertSegment(SegmentsCompanion segment);
  Future<void> markSegmentAck(int segmentId);
  Future<void> markMessageAck(int messageId);
  Future<void> incrementSegmentRetry(Segment segment);
  Stream<List<MessageWithSegments>> watchMessages();
  AppDatabase? get database;
  // Add other database-related methods here
}

class DatabaseService implements IDatabaseService {
  AppDatabase? _db;

  @override
  Future<void> closeDatabase() async {
    await _db?.close();
    _db = null;
  }

  @override
  AppDatabase? get database => _db;

  @override
  Future<void> openDatabase(String deviceId) async {
    await _db?.close();

    _db = AppDatabase(deviceId);
  }

  @override
  Future<int> insertMessage(MessagesCompanion message) {
    return _db!.into(_db!.messages).insert(message);
  }

  @override
  Future<int> insertSegment(SegmentsCompanion segment) {
    return _db!.into(_db!.segments).insert(segment);
  }

  @override
  Stream<List<MessageWithSegments>> watchMessages() {
    final query = _db!.select(_db!.messages)
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]);

    return query.watch().asyncMap((messages) async {
      final results = <MessageWithSegments>[];
      final segments = await _db!.select(_db!.segments).get();
      final grouped = <int, List<Segment>>{};
      for (final s in segments) {
        grouped.putIfAbsent(s.uid, () => []).add(s);
      }
      for (final msg in messages) {
        results.add(MessageWithSegments(msg, grouped[msg.uid] ?? []));
      }
      return results;
    });
  }

  @override
  Future<void> incrementSegmentRetry(Segment segment) async {
    await (_db!.update(_db!.segments)..where((s) => s.id.equals(segment.id)))
        .write(SegmentsCompanion(retryCount: Value(segment.retryCount + 1)));
  }

  @override
  Future<void> markMessageAck(int messageId) async {
    await (_db!.update(_db!.messages)..where((s) => s.id.equals(messageId)))
        .write(MessagesCompanion(status: const Value('delivered')));
  }

  @override
  Future<void> markSegmentAck(int segmentId) async {
    await (_db!.update(_db!.segments)..where((s) => s.id.equals(segmentId)))
        .write(SegmentsCompanion(ackReceived: const Value(true)));
  }

  Future<Segment> getSegment(int uid, int segmentIndex) async {
    final seg = _db!.select(_db!.segments)
      ..where((s) => s.uid.equals(uid) & s.segmentIndex.equals(segmentIndex));
    return await seg.getSingle();
  }

  Future<bool> checkUID(int uid) async {
    final row = await (_db!.select(
      _db!.messages,
    )..where((t) => t.uid.equals(uid))).getSingleOrNull();
    return row != null;
  }
}
