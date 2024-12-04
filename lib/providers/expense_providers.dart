import 'package:expense_book/crud/database_entry.dart';
import 'package:expense_book/crud/notes_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// StreamProvider for allEntries
final allEntriesProvider = StreamProvider<List<DatabaseEntry>>((ref) {
  return EntryService().allEntries;
});

// StreamProvider for getBalance
final balanceProvider = StreamProvider<List<int>>((ref) {
  return CashBook().getBalance;
});
