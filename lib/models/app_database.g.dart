// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MessagesTable extends Messages with TableInfo<$MessagesTable, Message> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _senderIdMeta = const VerificationMeta(
    'senderId',
  );
  @override
  late final GeneratedColumn<int> senderId = GeneratedColumn<int>(
    'sender_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receiverIdMeta = const VerificationMeta(
    'receiverId',
  );
  @override
  late final GeneratedColumn<int> receiverId = GeneratedColumn<int>(
    'receiver_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textContentMeta = const VerificationMeta(
    'textContent',
  );
  @override
  late final GeneratedColumn<String> textContent = GeneratedColumn<String>(
    'text_content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeStampMeta = const VerificationMeta(
    'timeStamp',
  );
  @override
  late final GeneratedColumn<DateTime> timeStamp = GeneratedColumn<DateTime>(
    'time_stamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSentMeta = const VerificationMeta('isSent');
  @override
  late final GeneratedColumn<bool> isSent = GeneratedColumn<bool>(
    'is_sent',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_sent" IN (0, 1))',
    ),
    defaultValue: Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    senderId,
    receiverId,
    type,
    textContent,
    timeStamp,
    isSent,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<Message> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sender_id')) {
      context.handle(
        _senderIdMeta,
        senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_senderIdMeta);
    }
    if (data.containsKey('receiver_id')) {
      context.handle(
        _receiverIdMeta,
        receiverId.isAcceptableOrUnknown(data['receiver_id']!, _receiverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_receiverIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('text_content')) {
      context.handle(
        _textContentMeta,
        textContent.isAcceptableOrUnknown(
          data['text_content']!,
          _textContentMeta,
        ),
      );
    }
    if (data.containsKey('time_stamp')) {
      context.handle(
        _timeStampMeta,
        timeStamp.isAcceptableOrUnknown(data['time_stamp']!, _timeStampMeta),
      );
    } else if (isInserting) {
      context.missing(_timeStampMeta);
    }
    if (data.containsKey('is_sent')) {
      context.handle(
        _isSentMeta,
        isSent.isAcceptableOrUnknown(data['is_sent']!, _isSentMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Message map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Message(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      senderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sender_id'],
      )!,
      receiverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}receiver_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      textContent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_content'],
      ),
      timeStamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}time_stamp'],
      )!,
      isSent: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_sent'],
      )!,
    );
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(attachedDatabase, alias);
  }
}

class Message extends DataClass implements Insertable<Message> {
  final int id;
  final int senderId;
  final int receiverId;
  final String type;
  final String? textContent;
  final DateTime timeStamp;
  final bool isSent;
  const Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.type,
    this.textContent,
    required this.timeStamp,
    required this.isSent,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sender_id'] = Variable<int>(senderId);
    map['receiver_id'] = Variable<int>(receiverId);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || textContent != null) {
      map['text_content'] = Variable<String>(textContent);
    }
    map['time_stamp'] = Variable<DateTime>(timeStamp);
    map['is_sent'] = Variable<bool>(isSent);
    return map;
  }

  MessagesCompanion toCompanion(bool nullToAbsent) {
    return MessagesCompanion(
      id: Value(id),
      senderId: Value(senderId),
      receiverId: Value(receiverId),
      type: Value(type),
      textContent: textContent == null && nullToAbsent
          ? const Value.absent()
          : Value(textContent),
      timeStamp: Value(timeStamp),
      isSent: Value(isSent),
    );
  }

  factory Message.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Message(
      id: serializer.fromJson<int>(json['id']),
      senderId: serializer.fromJson<int>(json['senderId']),
      receiverId: serializer.fromJson<int>(json['receiverId']),
      type: serializer.fromJson<String>(json['type']),
      textContent: serializer.fromJson<String?>(json['textContent']),
      timeStamp: serializer.fromJson<DateTime>(json['timeStamp']),
      isSent: serializer.fromJson<bool>(json['isSent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'senderId': serializer.toJson<int>(senderId),
      'receiverId': serializer.toJson<int>(receiverId),
      'type': serializer.toJson<String>(type),
      'textContent': serializer.toJson<String?>(textContent),
      'timeStamp': serializer.toJson<DateTime>(timeStamp),
      'isSent': serializer.toJson<bool>(isSent),
    };
  }

  Message copyWith({
    int? id,
    int? senderId,
    int? receiverId,
    String? type,
    Value<String?> textContent = const Value.absent(),
    DateTime? timeStamp,
    bool? isSent,
  }) => Message(
    id: id ?? this.id,
    senderId: senderId ?? this.senderId,
    receiverId: receiverId ?? this.receiverId,
    type: type ?? this.type,
    textContent: textContent.present ? textContent.value : this.textContent,
    timeStamp: timeStamp ?? this.timeStamp,
    isSent: isSent ?? this.isSent,
  );
  Message copyWithCompanion(MessagesCompanion data) {
    return Message(
      id: data.id.present ? data.id.value : this.id,
      senderId: data.senderId.present ? data.senderId.value : this.senderId,
      receiverId: data.receiverId.present
          ? data.receiverId.value
          : this.receiverId,
      type: data.type.present ? data.type.value : this.type,
      textContent: data.textContent.present
          ? data.textContent.value
          : this.textContent,
      timeStamp: data.timeStamp.present ? data.timeStamp.value : this.timeStamp,
      isSent: data.isSent.present ? data.isSent.value : this.isSent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Message(')
          ..write('id: $id, ')
          ..write('senderId: $senderId, ')
          ..write('receiverId: $receiverId, ')
          ..write('type: $type, ')
          ..write('textContent: $textContent, ')
          ..write('timeStamp: $timeStamp, ')
          ..write('isSent: $isSent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    senderId,
    receiverId,
    type,
    textContent,
    timeStamp,
    isSent,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Message &&
          other.id == this.id &&
          other.senderId == this.senderId &&
          other.receiverId == this.receiverId &&
          other.type == this.type &&
          other.textContent == this.textContent &&
          other.timeStamp == this.timeStamp &&
          other.isSent == this.isSent);
}

class MessagesCompanion extends UpdateCompanion<Message> {
  final Value<int> id;
  final Value<int> senderId;
  final Value<int> receiverId;
  final Value<String> type;
  final Value<String?> textContent;
  final Value<DateTime> timeStamp;
  final Value<bool> isSent;
  const MessagesCompanion({
    this.id = const Value.absent(),
    this.senderId = const Value.absent(),
    this.receiverId = const Value.absent(),
    this.type = const Value.absent(),
    this.textContent = const Value.absent(),
    this.timeStamp = const Value.absent(),
    this.isSent = const Value.absent(),
  });
  MessagesCompanion.insert({
    this.id = const Value.absent(),
    required int senderId,
    required int receiverId,
    required String type,
    this.textContent = const Value.absent(),
    required DateTime timeStamp,
    this.isSent = const Value.absent(),
  }) : senderId = Value(senderId),
       receiverId = Value(receiverId),
       type = Value(type),
       timeStamp = Value(timeStamp);
  static Insertable<Message> custom({
    Expression<int>? id,
    Expression<int>? senderId,
    Expression<int>? receiverId,
    Expression<String>? type,
    Expression<String>? textContent,
    Expression<DateTime>? timeStamp,
    Expression<bool>? isSent,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (senderId != null) 'sender_id': senderId,
      if (receiverId != null) 'receiver_id': receiverId,
      if (type != null) 'type': type,
      if (textContent != null) 'text_content': textContent,
      if (timeStamp != null) 'time_stamp': timeStamp,
      if (isSent != null) 'is_sent': isSent,
    });
  }

  MessagesCompanion copyWith({
    Value<int>? id,
    Value<int>? senderId,
    Value<int>? receiverId,
    Value<String>? type,
    Value<String?>? textContent,
    Value<DateTime>? timeStamp,
    Value<bool>? isSent,
  }) {
    return MessagesCompanion(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      type: type ?? this.type,
      textContent: textContent ?? this.textContent,
      timeStamp: timeStamp ?? this.timeStamp,
      isSent: isSent ?? this.isSent,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<int>(senderId.value);
    }
    if (receiverId.present) {
      map['receiver_id'] = Variable<int>(receiverId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (textContent.present) {
      map['text_content'] = Variable<String>(textContent.value);
    }
    if (timeStamp.present) {
      map['time_stamp'] = Variable<DateTime>(timeStamp.value);
    }
    if (isSent.present) {
      map['is_sent'] = Variable<bool>(isSent.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('id: $id, ')
          ..write('senderId: $senderId, ')
          ..write('receiverId: $receiverId, ')
          ..write('type: $type, ')
          ..write('textContent: $textContent, ')
          ..write('timeStamp: $timeStamp, ')
          ..write('isSent: $isSent')
          ..write(')'))
        .toString();
  }
}

class $AttachmentsTable extends Attachments
    with TableInfo<$AttachmentsTable, Attachment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _messageIdMeta = const VerificationMeta(
    'messageId',
  );
  @override
  late final GeneratedColumn<int> messageId = GeneratedColumn<int>(
    'message_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'REFERENCES messages(id)',
  );
  static const VerificationMeta _fileTypeMeta = const VerificationMeta(
    'fileType',
  );
  @override
  late final GeneratedColumn<String> fileType = GeneratedColumn<String>(
    'file_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, messageId, fileType, filePath];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Attachment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('message_id')) {
      context.handle(
        _messageIdMeta,
        messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('file_type')) {
      context.handle(
        _fileTypeMeta,
        fileType.isAcceptableOrUnknown(data['file_type']!, _fileTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_fileTypeMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Attachment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Attachment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      messageId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}message_id'],
      )!,
      fileType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_type'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
    );
  }

  @override
  $AttachmentsTable createAlias(String alias) {
    return $AttachmentsTable(attachedDatabase, alias);
  }
}

class Attachment extends DataClass implements Insertable<Attachment> {
  final int id;
  final int messageId;
  final String fileType;
  final String filePath;
  const Attachment({
    required this.id,
    required this.messageId,
    required this.fileType,
    required this.filePath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['message_id'] = Variable<int>(messageId);
    map['file_type'] = Variable<String>(fileType);
    map['file_path'] = Variable<String>(filePath);
    return map;
  }

  AttachmentsCompanion toCompanion(bool nullToAbsent) {
    return AttachmentsCompanion(
      id: Value(id),
      messageId: Value(messageId),
      fileType: Value(fileType),
      filePath: Value(filePath),
    );
  }

  factory Attachment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Attachment(
      id: serializer.fromJson<int>(json['id']),
      messageId: serializer.fromJson<int>(json['messageId']),
      fileType: serializer.fromJson<String>(json['fileType']),
      filePath: serializer.fromJson<String>(json['filePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'messageId': serializer.toJson<int>(messageId),
      'fileType': serializer.toJson<String>(fileType),
      'filePath': serializer.toJson<String>(filePath),
    };
  }

  Attachment copyWith({
    int? id,
    int? messageId,
    String? fileType,
    String? filePath,
  }) => Attachment(
    id: id ?? this.id,
    messageId: messageId ?? this.messageId,
    fileType: fileType ?? this.fileType,
    filePath: filePath ?? this.filePath,
  );
  Attachment copyWithCompanion(AttachmentsCompanion data) {
    return Attachment(
      id: data.id.present ? data.id.value : this.id,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      fileType: data.fileType.present ? data.fileType.value : this.fileType,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Attachment(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('fileType: $fileType, ')
          ..write('filePath: $filePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, messageId, fileType, filePath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Attachment &&
          other.id == this.id &&
          other.messageId == this.messageId &&
          other.fileType == this.fileType &&
          other.filePath == this.filePath);
}

class AttachmentsCompanion extends UpdateCompanion<Attachment> {
  final Value<int> id;
  final Value<int> messageId;
  final Value<String> fileType;
  final Value<String> filePath;
  const AttachmentsCompanion({
    this.id = const Value.absent(),
    this.messageId = const Value.absent(),
    this.fileType = const Value.absent(),
    this.filePath = const Value.absent(),
  });
  AttachmentsCompanion.insert({
    this.id = const Value.absent(),
    required int messageId,
    required String fileType,
    required String filePath,
  }) : messageId = Value(messageId),
       fileType = Value(fileType),
       filePath = Value(filePath);
  static Insertable<Attachment> custom({
    Expression<int>? id,
    Expression<int>? messageId,
    Expression<String>? fileType,
    Expression<String>? filePath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (messageId != null) 'message_id': messageId,
      if (fileType != null) 'file_type': fileType,
      if (filePath != null) 'file_path': filePath,
    });
  }

  AttachmentsCompanion copyWith({
    Value<int>? id,
    Value<int>? messageId,
    Value<String>? fileType,
    Value<String>? filePath,
  }) {
    return AttachmentsCompanion(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      fileType: fileType ?? this.fileType,
      filePath: filePath ?? this.filePath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<int>(messageId.value);
    }
    if (fileType.present) {
      map['file_type'] = Variable<String>(fileType.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('fileType: $fileType, ')
          ..write('filePath: $filePath')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MessagesTable messages = $MessagesTable(this);
  late final $AttachmentsTable attachments = $AttachmentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [messages, attachments];
}

typedef $$MessagesTableCreateCompanionBuilder =
    MessagesCompanion Function({
      Value<int> id,
      required int senderId,
      required int receiverId,
      required String type,
      Value<String?> textContent,
      required DateTime timeStamp,
      Value<bool> isSent,
    });
typedef $$MessagesTableUpdateCompanionBuilder =
    MessagesCompanion Function({
      Value<int> id,
      Value<int> senderId,
      Value<int> receiverId,
      Value<String> type,
      Value<String?> textContent,
      Value<DateTime> timeStamp,
      Value<bool> isSent,
    });

class $$MessagesTableFilterComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get senderId => $composableBuilder(
    column: $table.senderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get receiverId => $composableBuilder(
    column: $table.receiverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timeStamp => $composableBuilder(
    column: $table.timeStamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSent => $composableBuilder(
    column: $table.isSent,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get senderId => $composableBuilder(
    column: $table.senderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get receiverId => $composableBuilder(
    column: $table.receiverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timeStamp => $composableBuilder(
    column: $table.timeStamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSent => $composableBuilder(
    column: $table.isSent,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get senderId =>
      $composableBuilder(column: $table.senderId, builder: (column) => column);

  GeneratedColumn<int> get receiverId => $composableBuilder(
    column: $table.receiverId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get timeStamp =>
      $composableBuilder(column: $table.timeStamp, builder: (column) => column);

  GeneratedColumn<bool> get isSent =>
      $composableBuilder(column: $table.isSent, builder: (column) => column);
}

class $$MessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MessagesTable,
          Message,
          $$MessagesTableFilterComposer,
          $$MessagesTableOrderingComposer,
          $$MessagesTableAnnotationComposer,
          $$MessagesTableCreateCompanionBuilder,
          $$MessagesTableUpdateCompanionBuilder,
          (Message, BaseReferences<_$AppDatabase, $MessagesTable, Message>),
          Message,
          PrefetchHooks Function()
        > {
  $$MessagesTableTableManager(_$AppDatabase db, $MessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> senderId = const Value.absent(),
                Value<int> receiverId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> textContent = const Value.absent(),
                Value<DateTime> timeStamp = const Value.absent(),
                Value<bool> isSent = const Value.absent(),
              }) => MessagesCompanion(
                id: id,
                senderId: senderId,
                receiverId: receiverId,
                type: type,
                textContent: textContent,
                timeStamp: timeStamp,
                isSent: isSent,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int senderId,
                required int receiverId,
                required String type,
                Value<String?> textContent = const Value.absent(),
                required DateTime timeStamp,
                Value<bool> isSent = const Value.absent(),
              }) => MessagesCompanion.insert(
                id: id,
                senderId: senderId,
                receiverId: receiverId,
                type: type,
                textContent: textContent,
                timeStamp: timeStamp,
                isSent: isSent,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MessagesTable,
      Message,
      $$MessagesTableFilterComposer,
      $$MessagesTableOrderingComposer,
      $$MessagesTableAnnotationComposer,
      $$MessagesTableCreateCompanionBuilder,
      $$MessagesTableUpdateCompanionBuilder,
      (Message, BaseReferences<_$AppDatabase, $MessagesTable, Message>),
      Message,
      PrefetchHooks Function()
    >;
typedef $$AttachmentsTableCreateCompanionBuilder =
    AttachmentsCompanion Function({
      Value<int> id,
      required int messageId,
      required String fileType,
      required String filePath,
    });
typedef $$AttachmentsTableUpdateCompanionBuilder =
    AttachmentsCompanion Function({
      Value<int> id,
      Value<int> messageId,
      Value<String> fileType,
      Value<String> filePath,
    });

class $$AttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileType => $composableBuilder(
    column: $table.fileType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileType => $composableBuilder(
    column: $table.fileType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get messageId =>
      $composableBuilder(column: $table.messageId, builder: (column) => column);

  GeneratedColumn<String> get fileType =>
      $composableBuilder(column: $table.fileType, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);
}

class $$AttachmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttachmentsTable,
          Attachment,
          $$AttachmentsTableFilterComposer,
          $$AttachmentsTableOrderingComposer,
          $$AttachmentsTableAnnotationComposer,
          $$AttachmentsTableCreateCompanionBuilder,
          $$AttachmentsTableUpdateCompanionBuilder,
          (
            Attachment,
            BaseReferences<_$AppDatabase, $AttachmentsTable, Attachment>,
          ),
          Attachment,
          PrefetchHooks Function()
        > {
  $$AttachmentsTableTableManager(_$AppDatabase db, $AttachmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttachmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> messageId = const Value.absent(),
                Value<String> fileType = const Value.absent(),
                Value<String> filePath = const Value.absent(),
              }) => AttachmentsCompanion(
                id: id,
                messageId: messageId,
                fileType: fileType,
                filePath: filePath,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int messageId,
                required String fileType,
                required String filePath,
              }) => AttachmentsCompanion.insert(
                id: id,
                messageId: messageId,
                fileType: fileType,
                filePath: filePath,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AttachmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttachmentsTable,
      Attachment,
      $$AttachmentsTableFilterComposer,
      $$AttachmentsTableOrderingComposer,
      $$AttachmentsTableAnnotationComposer,
      $$AttachmentsTableCreateCompanionBuilder,
      $$AttachmentsTableUpdateCompanionBuilder,
      (
        Attachment,
        BaseReferences<_$AppDatabase, $AttachmentsTable, Attachment>,
      ),
      Attachment,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db, _db.messages);
  $$AttachmentsTableTableManager get attachments =>
      $$AttachmentsTableTableManager(_db, _db.attachments);
}
