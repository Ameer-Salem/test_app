
import 'package:flutter/material.dart';
import 'package:test_app/models/app_database.dart';
import 'package:test_app/services/message_service.dart';

class DatabaseController extends ChangeNotifier {
  final AppDatabase _db;
  DatabaseController(this._db);

  MessageService get service => MessageService(_db);
}
