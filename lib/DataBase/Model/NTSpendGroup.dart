
import '../sqlite_datastore.dart';
import 'NTMonth.dart';
import 'abstract/NTObject.dart';

class NTSpendGroup implements NTObject {
  // database 필드 ------------
  int id;
  String name;
  // --------------

  NTSpendGroup({
    required this.id,
    required this.name,
  });


  Future<List<NTMonth>> ntMonths() async {
    return await SqliteController().fetch(NTMonth.staticClassName(), where: 'groupId = ? ORDER BY date DESC', args: [id]);
  }






  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
  NTSpendGroup.fromMap(Map<dynamic, dynamic>? map)
      : id = map?['id'] ?? 0,
        name = map?['name'] ?? '';

  @override
  String className() {
    return 'NTGroup';
  }
  static String staticClassName() {
    return 'NTGroup';
  }
}

