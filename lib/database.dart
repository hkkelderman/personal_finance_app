import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

// Table: Household
class Households extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

// Table: Member
class Members extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get household =>
      integer().customConstraint('REFERENCES households(id)')();
  TextColumn get name => text()();
}

// Table: Account
class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get member =>
      integer().customConstraint('REFERENCES members(id)')();
  TextColumn get name => text()();
  TextColumn get type => text().withLength(min: 1, max: 20)();

  @override
  List<String> get customConstraints => [
        'CHECK (type IN ("checking", "saving", "investment", "mortgage", "loan", "credit card"))'
      ];
}

// Table: Category
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

// Table: Transaction
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get account =>
      integer().customConstraint('REFERENCES accounts(id)')();
  DateTimeColumn get date => dateTime()();
  RealColumn get amount => real()();
  TextColumn get where => text().nullable()(); // Can be blank
  TextColumn get what => text().nullable()(); // Can be blank
  IntColumn get category =>
      integer().customConstraint('REFERENCES categories(id)')();
  TextColumn get type => text().withLength(min: 1, max: 20)();
  BoolColumn get venmo => boolean().withDefault(Constant(false))();

  @override
  List<String> get customConstraints =>
      ['CHECK (type IN ("revenue", "expense"))'];
}

// Database class
@DriftDatabase(
    tables: [Households, Members, Accounts, Transactions, Categories])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // CRUD operations for each table
  Future<int> insertHousehold(HouseholdsCompanion entry) =>
      into(households).insert(entry);
  Future<List<Household>> getAllHouseholds() => select(households).get();

  Future<int> insertMember(MembersCompanion entry) =>
      into(members).insert(entry);
  Future<List<Member>> getAllMembers() => select(members).get();

  Future<int> insertAccount(AccountsCompanion entry) =>
      into(accounts).insert(entry);
  Future<List<Account>> getAllAccounts() => select(accounts).get();

  Future<int> insertCategory(CategoriesCompanion entry) =>
      into(categories).insert(entry);
  Future<List<Category>> getAllCategories() => select(categories).get();

  Future<int> insertTransaction(TransactionsCompanion entry) =>
      into(transactions).insert(entry);
  Future<List<Transaction>> getAllTransactions() => select(transactions).get();
}

// Database connection function
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'finance_app.db');
    return NativeDatabase(File(path));
  });
}
