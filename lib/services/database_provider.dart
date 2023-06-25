import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifterapp/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

final databaseProvider =
    Provider<Database>((ref) => throw Exception('Database not initialized'));

final databaseServiceProvider = Provider<DatabaseService>(
    (ref) => throw Exception('Database service not initialized'));
