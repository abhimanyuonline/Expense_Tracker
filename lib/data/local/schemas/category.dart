import 'package:isar/isar.dart';

part 'category.g.dart';

@collection
class Category {
  Id id = Isar.autoIncrement;

  late String name;
  late int iconCode; // Store icon point
  late int colorValue; // Store hex color
}
