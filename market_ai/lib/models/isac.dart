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
      GldDataSchema,
      SlvDataSchema,
      IwmDataSchema,
      XlkDataSchema,
      AaplDataSchema
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
      //     // await isar.spyDatas.clear();
      //     // await isar.qqqDatas.clear();
      //     await isar.usoDatas.clear();
      //     // await isar.gldDatas.clear();
      //     await isar.slvDatas.clear();
      //     // await isar.iwmDatas.clear();
      //     await isar.xlkDatas.clear();
      //     // await isar.aaplDatas.clear();
      //   });
      //   print('clear all Isac data');
      // }

      // await clearAllData(_isar!);

      MainPresenter.to.schemasLen.value = schemas.length;
    }
    return _isar!;
  }

  Future<void> clearSpyData() async {
    await _isar!.writeTxn(() async {
      await _isar!.spyDatas.clear();
    });
  }

  Future<void> clearQqqData() async {
    await _isar!.writeTxn(() async {
      await _isar!.qqqDatas.clear();
    });
  }

  Future<void> clearUsoData() async {
    await _isar!.writeTxn(() async {
      await _isar!.usoDatas.clear();
    });
  }

  Future<void> clearGldData() async {
    await _isar!.writeTxn(() async {
      await _isar!.gldDatas.clear();
    });
  }

  Future<void> clearSlvData() async {
    await _isar!.writeTxn(() async {
      await _isar!.slvDatas.clear();
    });
  }

  Future<void> clearIwmData() async {
    await _isar!.writeTxn(() async {
      await _isar!.iwmDatas.clear();
    });
  }

  Future<void> clearXlkData() async {
    await _isar!.writeTxn(() async {
      await _isar!.xlkDatas.clear();
    });
  }

  Future<void> clearAaplData() async {
    await _isar!.writeTxn(() async {
      await _isar!.aaplDatas.clear();
    });
  }
}
