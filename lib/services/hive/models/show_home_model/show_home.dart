import 'package:hive_flutter/hive_flutter.dart';

part 'show_home.g.dart';

@HiveType(typeId: 4)
class ShowOnboard extends HiveObject {
  @HiveField(0)
  bool showOnboard;

  ShowOnboard({
    required this.showOnboard,
  });
}
