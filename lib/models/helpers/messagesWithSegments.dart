

import 'package:test_app/models/drift/app_database.dart';

class MessageWithSegments {
  final Message message;
  final List<Segment> segments;
  MessageWithSegments(this.message, this.segments);
}