import 'package:isar/isar.dart';
import 'package:market_ai/presenters/presenters.dart';
import 'package:path_provider/path_provider.dart';

import 'collections.dart';

class IsarService {
  static final IsarService _instance = IsarService._internal();
  Isar? _isar;

  factory IsarService() {
    return _instance;
  }

  IsarService._internal();

  Future<Isar> getIsarInstance() async {
    List<CollectionSchema<dynamic>> schemas = [
      SpyDataSchema,
      QqqDataSchema,
      UsoDataSchema,
      GldDataSchema
    ];
    if (_isar == null) {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open(
        schemas,
        directory: dir.path,
      );
      // Clear all data in all collections
      // Future<void> clearAllData(Isar isar) async {
      //   await isar.writeTxn(() async {
      //     await isar.spyDatas.clear();
      //     await isar.qqqDatas.clear();
      //     await isar.usoDatas.clear();
      //     await isar.gldDatas.clear();
      //   });
      //   print('clear all Isac data');
      // }

      // await clearAllData(_isar!);

      MainPresenter.to.schemasLen.value = schemas.length;
    }
    return _isar!;
  }
}
