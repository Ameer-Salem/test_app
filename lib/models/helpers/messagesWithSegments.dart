

import 'package:test_app/models/drift/app_database.dart';
import 'package:test_app/models/drift/tables/segments_table.dart';

class MessageWithSegments {
  final Message message;
  final List<Segment> segments;
  MessageWithSegments(this.message, this.segments);
}