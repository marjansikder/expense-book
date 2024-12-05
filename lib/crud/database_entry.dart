import 'const.dart';

class DatabaseEntry {
  final int id;
  final String remark;
  final int amount;
  final EntryType type;
  final String date;
  final String time;

  const DatabaseEntry({
    required this.date,
    required this.amount,
    required this.id,
    required this.remark,
    required this.type,
    required this.time,
  });

  DatabaseEntry.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        amount = map[amountColumn] as int,
        date = map[dateColumn] as String,
        remark = map[remarkColumn] as String,
        time = map[timeColumn] as String,
        type =
            map[typeColumn] == "cashIn" ? EntryType.cashIn : EntryType.cashOut;

  @override
  String toString() =>
      'ID = $id, type = ${type.name}, amount = $amount, time = $date, remark = $remark, rawTime = $time';

  @override
  bool operator ==(covariant DatabaseEntry other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

enum EntryType { cashIn, cashOut }
